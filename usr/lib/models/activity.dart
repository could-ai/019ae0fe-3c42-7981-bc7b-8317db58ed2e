class Activity {
  final String id;
  final String title;
  final String description; // "Funciones" or details
  final DateTime date;
  final String category;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });
}
