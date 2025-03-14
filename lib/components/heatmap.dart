import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:mytimetable/data/dataset.dart';

class MyHeatMap extends StatefulWidget {
  const MyHeatMap({super.key});

  @override
  State<MyHeatMap> createState() => _MyHeatMapState();
}

class _MyHeatMapState extends State<MyHeatMap> {
  final DatasetDatabase _datasetDatabase = DatasetDatabase();
  Map<DateTime, int> _heatmapData = {};

  @override
  void initState() {
    super.initState();
    _loadDataset();
  }

  Future<void> _loadDataset() async {
    await _datasetDatabase.loadData();
    setState(() {
      _heatmapData = _datasetDatabase.dataset.map((date, value) => MapEntry(
        DateTime(date.year, date.month, date.day), min(value,10),
      ));
    });
  }

  Map<int, Color> _generateColorSet(BuildContext context) {
    final Map<int, Color> colorSet = {};
    final int maxDataValue = _heatmapData.values.fold(0, (max, current) => max > current ? max : current);

    if (maxDataValue == 0) {
      return {1: const Color.fromARGB(255, 2, 179, 0)}; // Default if no data
    }

    final baseColor = Colors.green; // Or any base color you prefer
    for (int i = 1; i <= 10; i++) {
      final opacity = i / 10.0;
      colorSet[i] = baseColor.withOpacity(opacity);
    }
    print("\n✅dynamically changed\n");

    return colorSet;
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      datasets: _heatmapData,
      startDate: DateTime(DateTime.now().year, 1, 1),
      endDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      defaultColor: Theme.of(context).colorScheme.surface,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      colorsets: _generateColorSet(context), // Dynamically generated colors
    );
  }
}