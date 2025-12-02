import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ActivityService _service = ActivityService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _service.addListener(_update);
  }

  @override
  void dispose() {
    _service.removeListener(_update);
    _tabController.dispose();
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Actividades'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Semanal'),
            Tab(text: 'Mensual'),
            Tab(text: 'Semestral'),
            Tab(text: 'Anual'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryList(_service.getWeeklyActivities(), 'Esta Semana'),
          _buildSummaryList(_service.getMonthlyActivities(), 'Este Mes'),
          _buildSummaryList(_service.getSemesterActivities(), 'Últimos 6 Meses'),
          _buildSummaryList(_service.getAnnualActivities(), 'Este Año'),
        ],
      ),
    );
  }

  Widget _buildSummaryList(List<Activity> activities, String period) {
    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assessment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No hay actividades para $period', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // Group by category for better summary
    Map<String, int> categoryCount = {};
    for (var a in activities) {
      categoryCount[a.category] = (categoryCount[a.category] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen: $period', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Total de actividades: ${activities.length}', style: Theme.of(context).textTheme.bodyLarge),
                const Divider(),
                ...categoryCount.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key),
                      Text('${e.value} actividades', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Detalle de Actividades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...activities.map((activity) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(activity.category[0]),
            ),
            title: Text(activity.title),
            subtitle: Text('${DateFormat('dd/MM/yyyy').format(activity.date)}\n${activity.description}'),
            isThreeLine: true,
          ),
        )),
      ],
    );
  }
}
