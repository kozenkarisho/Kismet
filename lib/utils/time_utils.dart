/// Converts a timestamp in milliseconds since epoch to a human-readable
/// relative time string (e.g. "2 days ago", "just now").
String timeAgo(int? timestampMs) {
  if (timestampMs == null) return '';

  final now = DateTime.now();
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return '$m min${m == 1 ? '' : 's'} ago';
  }
  if (diff.inHours < 24) {
    final h = diff.inHours;
    return '$h hour${h == 1 ? '' : 's'} ago';
  }
  if (diff.inDays < 30) {
    final d = diff.inDays;
    return '$d day${d == 1 ? '' : 's'} ago';
  }
  if (diff.inDays < 365) {
    final months = (diff.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  }

  final years = (diff.inDays / 365).floor();
  return '$years year${years == 1 ? '' : 's'} ago';
}
