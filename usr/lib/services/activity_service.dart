import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityService extends ChangeNotifier {
  static final ActivityService _instance = ActivityService._internal();
  factory ActivityService() => _instance;

  ActivityService._internal() {
    // Mock data for demonstration
    _activities.addAll([
      Activity(
        id: '1',
        title: 'Revisión de correos',
        description: 'Responder correos urgentes de clientes',
        date: DateTime.now(),
        category: 'Administrativo',
      ),
      Activity(
        id: '2',
        title: 'Reunión de equipo',
        description: 'Planificación semanal de sprint',
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Reunión',
      ),
      Activity(
        id: '3',
        title: 'Informe Mensual',
        description: 'Generar métricas de ventas',
        date: DateTime.now().subtract(const Duration(days: 15)),
        category: 'Reportes',
      ),
    ]);
  }

  final List<Activity> _activities = [];

  List<Activity> get activities => List.unmodifiable(_activities);

  void addActivity(Activity activity) {
    _activities.insert(0, activity); // Add to top
    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // Filter methods for summaries
  List<Activity> getDailyActivities(DateTime date) {
    return _activities.where((a) => 
      a.date.year == date.year && 
      a.date.month == date.month && 
      a.date.day == date.day
    ).toList();
  }

  List<Activity> getWeeklyActivities() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return _activities.where((a) => 
      a.date.isAfter(startOfWeek.subtract(const Duration(days: 1)))
    ).toList();
  }

  List<Activity> getMonthlyActivities() {
    final now = DateTime.now();
    return _activities.where((a) => 
      a.date.month == now.month && a.date.year == now.year
    ).toList();
  }
  
  List<Activity> getSemesterActivities() {
    final now = DateTime.now();
    // Simple logic: last 6 months
    final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    return _activities.where((a) => 
      a.date.isAfter(sixMonthsAgo)
    ).toList();
  }

  List<Activity> getAnnualActivities() {
    final now = DateTime.now();
    return _activities.where((a) => 
      a.date.year == now.year
    ).toList();
  }
}
