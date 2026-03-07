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


// sample data for testing
final List<TimelineItem> items = [
    // Week 1-4: Completed items
    TimelineItem(
        week: 1,
        title: "Foundation of Engineering Design",
        subtitle: "Complete",
        status: "completed"),
    TimelineItem(
        week: 2,
        title: "Problem Identification & Scoping",
        subtitle: "Complete",
        status: "completed"),
    TimelineItem(
        week: 3,
        title: "Research & Benchmarking",
        subtitle: "Complete",
        status: "completed"),
    TimelineItem(
        week: 4,
        title: "Ideation & Concept Development",
        subtitle: "In Progress",
        status: "inprogress"),
    
    // Week 5-8: Locked future items
    TimelineItem(
        week: 5,
        title: "Feasibility Analysis",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 6,
        title: "Prototype Planning",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 7,
        title: "Rapid Prototyping",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 8,
        title: "Testing & Validation",
        subtitle: "",
        status: "locked"),
    
    // Week 9-12: More locked items
    TimelineItem(
        week: 9,
        title: "Design Iteration",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 10,
        title: "User Feedback Integration",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 11,
        title: "Technical Documentation",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 12,
        title: "Manufacturing Considerations",
        subtitle: "",
        status: "locked"),
    
    // Week 13-16: Final phase items
    TimelineItem(
        week: 13,
        title: "Cost Analysis & Optimization",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 14,
        title: "Final Design Review",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 15,
        title: "Presentation Preparation",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 16,
        title: "Final Project Submission",
        subtitle: "",
        status: "locked"),
    
    // Week 17-20: Bonus/Extended items
    TimelineItem(
        week: 17,
        title: "Portfolio Compilation",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 18,
        title: "Peer Review Session",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 19,
        title: "Industry Feedback",
        subtitle: "",
        status: "locked"),
    TimelineItem(
        week: 20,
        title: "Project Reflection & Retrospective",
        subtitle: "",
        status: "locked"),
];