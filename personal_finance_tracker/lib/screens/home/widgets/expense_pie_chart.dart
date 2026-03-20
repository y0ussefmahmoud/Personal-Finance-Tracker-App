import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/category.dart' as Cat;

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> expenseByCategory;
  final List<Cat.Category> categories;

  const ExpensePieChart({
    super.key,
    required this.expenseByCategory,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final totalExpense = expenseByCategory.values.fold(0.0, (a, b) => a + b);
    if (totalExpense == 0) {
      return const SizedBox.shrink();
    }

    // Sort by value descending, take top 3 + others
    final sorted = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3 = sorted.take(3);
    final othersValue = sorted.skip(3).fold(0.0, (a, b) => a + b.value);
    final sections = <PieChartSectionData>[];

    for (final entry in top3) {
      final Cat.Category category = categories.firstWhere(
        (c) => (c as Cat.Category).name == entry.key,
        orElse: () => Cat.Category(name: entry.key, icon: 'category', color: Colors.grey.value, type: 'expense', isCustom: false),
      );
      sections.add(PieChartSectionData(
        value: entry.value,
        radius: 55,
        color: Color(category.color),
        title: '',
        titleStyle: TextStyle(fontSize: 0),
      ));
    }

    if (othersValue > 0) {
      sections.add(PieChartSectionData(
        value: othersValue,
        radius: 55,
        color: Colors.grey,
        title: '',
        titleStyle: TextStyle(fontSize: 0),
      ));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'توزيع المصاريف',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('الإجمالي', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.secondary)),
                          Text('100%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in top3)
                  _LegendItem(
                    category: categories.firstWhere(
                      (c) => (c as Cat.Category).name == entry.key,
                      orElse: () => Cat.Category(name: entry.key, icon: 'category', color: Colors.grey.value, type: 'expense', isCustom: true),
                    ),
                    label: entry.key,
                    value: entry.value,
                    total: totalExpense,
                  ),
                if (othersValue > 0)
                  _LegendItem(
                    category: Cat.Category(name: 'أخرى', icon: 'category', color: Colors.grey.value, type: 'expense', isCustom: false),
                    label: 'أخرى',
                    value: othersValue,
                    total: totalExpense,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Cat.Category category;
  final String label;
  final double value;
  final double total;

  const _LegendItem({
    required this.category,
    required this.label,
    required this.value,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: Color(category.color),
        ),
        const SizedBox(width: 4),
        Text(
          '$label (${(value/total*100).toStringAsFixed(1)}%)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
