/// System categories seeded once when the database is created.
///
/// IDs are stable strings so future imports and rules can reference them without
/// a lookup by display name.
typedef SeedCategory = ({String id, String name});

const List<SeedCategory> systemCategories = <SeedCategory>[
  (id: 'cat_groceries', name: 'Groceries'),
  (id: 'cat_dining', name: 'Dining'),
  (id: 'cat_fuel', name: 'Fuel'),
  (id: 'cat_travel', name: 'Travel'),
  (id: 'cat_utilities', name: 'Utilities'),
  (id: 'cat_entertainment', name: 'Entertainment'),
  (id: 'cat_shopping', name: 'Shopping'),
  (id: 'cat_health', name: 'Health'),
  (id: 'cat_education', name: 'Education'),
  (id: 'cat_fees_interest', name: 'Fees & interest'),
  (id: 'cat_cash_advance', name: 'Cash advance'),
  (id: 'cat_other', name: 'Other'),
];
