import Flutter
import Security
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Retains the channel for the lifetime of the app so the handler stays
  /// registered.
  private var securityChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "app.creditcardmanager/security",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "getOrCreateDatabaseKey":
        do {
          result(try DatabaseKeyStore.getOrCreateKey())
        } catch {
          // Never surface error details: they can expose Keychain state.
          result(FlutterError(
            code: "KEYSTORE_ERROR",
            message: "Secure key operation failed",
            details: nil
          ))
        }
      case "deleteDatabaseKey":
        do {
          try DatabaseKeyStore.deleteKey()
          result(nil)
        } catch {
          result(FlutterError(
            code: "KEYSTORE_ERROR",
            message: "Secure key operation failed",
            details: nil
          ))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    securityChannel = channel
  }
}

/// Stores the 256-bit database key as a non-synchronizing Keychain item.
///
/// `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` keeps the item off iCloud
/// Keychain and out of encrypted backups that could be restored elsewhere. Losing
/// the Keychain item makes the database unreadable by design; this code never
/// replaces an existing item it cannot read.
private enum DatabaseKeyStore {
  private static let service = "app.creditcardmanager.database-key"
  private static let account = "primary"
  private static let keyLength = 32

  private enum StoreError: Error {
    case keychain(OSStatus)
    case random(OSStatus)
    case invalidLength
  }

  static func getOrCreateKey() throws -> String {
    if let existing = try readKey() {
      return existing
    }

    var bytes = [UInt8](repeating: 0, count: keyLength)
    let randomStatus = bytes.withUnsafeMutableBytes { buffer -> OSStatus in
      guard let baseAddress = buffer.baseAddress else {
        return errSecParam
      }
      return SecRandomCopyBytes(kSecRandomDefault, keyLength, baseAddress)
    }
    guard randomStatus == errSecSuccess else {
      throw StoreError.random(randomStatus)
    }

    let data = Data(bytes)
    for index in bytes.indices {
      bytes[index] = 0
    }

    var addQuery = baseQuery()
    addQuery[kSecValueData as String] = data
    addQuery[kSecAttrAccessible as String] =
      kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    addQuery[kSecAttrSynchronizable as String] = false

    let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
    if addStatus == errSecDuplicateItem {
      // Another caller created the item concurrently; read the winner.
      if let existing = try readKey() {
        return existing
      }
    }
    guard addStatus == errSecSuccess else {
      throw StoreError.keychain(addStatus)
    }

    return data.base64EncodedString()
  }

  static func deleteKey() throws {
    let status = SecItemDelete(baseQuery() as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw StoreError.keychain(status)
    }
  }

  private static func readKey() throws -> String? {
    var query = baseQuery()
    query[kSecReturnData as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitOne

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    if status == errSecItemNotFound {
      return nil
    }
    guard status == errSecSuccess else {
      throw StoreError.keychain(status)
    }
    guard let data = item as? Data, data.count == keyLength else {
      throw StoreError.invalidLength
    }
    return data.base64EncodedString()
  }

  private static func baseQuery() -> [String: Any] {
    return [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecAttrSynchronizable as String: false,
    ]
  }
}
