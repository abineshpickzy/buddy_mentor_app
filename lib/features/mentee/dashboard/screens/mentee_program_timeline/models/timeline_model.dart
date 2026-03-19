class TimelineItem {
  final int week;
  final String title;
  final String subtitle;
  final String status; // completed | inprogress | locked

  TimelineItem({
    required this.week,
    required this.title,
    required this.subtitle,
    required this.status,
  });
}

