import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final dateToCheck = DateTime(date.year, date.month, date.day);

  if (dateToCheck == today) {
    return 'Today';
  } else if (dateToCheck == yesterday) {
    return 'Yesterday';
  } else {
    return DateFormat('MMMM d, yyyy').format(date);
  }
}
