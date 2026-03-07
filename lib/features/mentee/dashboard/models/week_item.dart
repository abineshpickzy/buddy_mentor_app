class WeekItem {
  final int week;
  final String title;
  final String status; // complete, in_progress, pending

  WeekItem({required this.week, required this.title, required this.status});
}

final List<WeekItem> sampleWeeks = [
  WeekItem(week: 1, title: "Foundation of Engineering", status: "complete"),
  WeekItem(
    week: 2,
    title: "Problem Analysis & Identification",
    status: "complete",
  ),
  WeekItem(week: 3, title: "Data Collection Techniques", status: "in_progress"),
  WeekItem(week: 4, title: "Data Collection Techniques", status: "pending"),
  WeekItem(week: 5, title: "System Thinking Basics", status: "pending"),
];
