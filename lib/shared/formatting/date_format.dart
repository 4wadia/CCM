const List<String> _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatShortDate(DateTime? value) {
  if (value == null) return '—';
  return '${value.day} ${_months[value.month - 1]} ${value.year}';
}

String formatMonth(DateTime value) =>
    '${_months[value.month - 1]} ${value.year}';

String formatDateTime(DateTime? value) {
  if (value == null) return '—';
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour < 12 ? 'am' : 'pm';
  return '${formatShortDate(value)}, $hour:$minute $suffix';
}

String formatFileDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}$month$day';
}
