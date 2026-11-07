import 'package:credit_card_manager/data/database/migrations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('applies every step in ascending order', () async {
    final applied = <int>[];

    await applyMigrationPlan(
      from: 1,
      to: 3,
      steps: {2: () async => applied.add(2), 3: () async => applied.add(3)},
    );

    expect(applied, [2, 3]);
  });

  test('does nothing when already at the target version', () async {
    var called = false;

    await applyMigrationPlan(
      from: 2,
      to: 2,
      steps: {2: () async => called = true},
    );

    expect(called, isFalse);
  });

  test('fails loudly on a missing step', () async {
    await expectLater(
      applyMigrationPlan(from: 1, to: 3, steps: {2: () async {}}),
      throwsA(
        isA<MissingMigrationException>().having(
          (error) => error.missingVersion,
          'missingVersion',
          3,
        ),
      ),
    );
  });

  test('rejects a downgrade range', () async {
    expect(
      () => applyMigrationPlan(from: 3, to: 2, steps: const {}),
      throwsArgumentError,
    );
  });

  test('run applies the supplied forward steps', () async {
    var applied = false;

    await DatabaseMigrations.run(
      from: 1,
      to: latestSchemaVersion,
      steps: {latestSchemaVersion: () async => applied = true},
    );

    expect(applied, isTrue);
  });

  test('run refuses a schema newer than this build', () async {
    await expectLater(
      DatabaseMigrations.run(
        from: latestSchemaVersion,
        to: latestSchemaVersion + 1,
        steps: const {},
      ),
      throwsA(
        isA<MissingMigrationException>().having(
          (error) => error.missingVersion,
          'missingVersion',
          latestSchemaVersion + 1,
        ),
      ),
    );
  });

  test('run refuses a downgrade', () async {
    await expectLater(
      DatabaseMigrations.run(from: 2, to: 1, steps: const {}),
      throwsA(isA<SchemaDowngradeException>()),
    );
  });
}
