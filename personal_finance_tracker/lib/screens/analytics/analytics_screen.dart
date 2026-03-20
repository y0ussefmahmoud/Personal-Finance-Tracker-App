import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../models/category.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/icon_helper.dart';
import '../../widgets/bottom_nav_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedFilter = 'شهر';

  @override
  void initState() {
    super.initState();
    final tp = context.read<TransactionProvider>();
    if (tp.transactions.isEmpty) {
      tp.fetchTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات المالية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Optional: Implement additional filter options
            },
          ),
        ],
      ),
      body: Consumer2<TransactionProvider, CategoryProvider>(
        builder: (ctx, tp, cp, _) {
          if (tp.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final data = _selectedFilter == 'أسبوع'
              ? tp.getWeeklyData()
              : _selectedFilter == 'سنة'
                  ? tp.getYearlyData()
                  : tp.getMonthlyData(6);
          final expByCat = tp.expenseByCategoryFiltered(_selectedFilter);

          if (data.isEmpty) {
            return const Center(child: Text('لا توجد بيانات للفترة المحددة'));
          }

          return RefreshIndicator(
            onRefresh: tp.fetchTransactions,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TimeFilterSegment(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _MonthlyBarChartCard(data: data, isDark: isDark),
                  const SizedBox(height: 16),
                  _SavingsLineChartCard(data: data, isDark: isDark),
                  const SizedBox(height: 16),
                  _CategoryBreakdownCard(
                    expenseByCategory: expByCat,
                    categories: cp.categories,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

class _TimeFilterSegment extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _TimeFilterSegment({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['سنة', 'شهر', 'أسبوع'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return Expanded(
              child: TextButton(
                onPressed: () => onFilterChanged(filter),
                style: TextButton.styleFrom(
                  backgroundColor: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  foregroundColor: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MonthlyBarChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool isDark;

  const _MonthlyBarChartCard({
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final incomeColor = isDark ? const Color(0xFF22C55E) : const Color(0xFF2f7f33);
    final expenseColor = isDark ? const Color(0xFF3B82F6).withOpacity(0.4) : const Color(0xFF2f7f33).withOpacity(0.3);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الدخل مقابل المصاريف',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _buildLegendItem('دخل', incomeColor),
                    const SizedBox(width: 16),
                    _buildLegendItem('مصاريف', expenseColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  barGroups: data.map((item) {
                    final index = data.indexOf(item);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item['income'],
                          color: incomeColor,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: item['expense'],
                          color: expenseColor,
                          width: 12,
                        ),
                      ],
                      barsSpace: 4,
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('');
                          return Text('${(value / 1000).toStringAsFixed(0)}ك');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= data.length) return const Text('');
                          final label = data[index]['label'] as String;
                          return Text(label.length > 3 ? label.substring(0, 3) : label);
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _SavingsLineChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool isDark;

  const _SavingsLineChartCard({
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF2d5a8e);

    // Calculate cumulative savings
    double cumulative = 0;
    final cumulativeData = data.map((item) {
      cumulative += item['savings'];
      return {'label': item['label'], 'cumulative': cumulative};
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نمو المدخرات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: cumulativeData.map((item) {
                        final index = cumulativeData.indexOf(item);
                        return FlSpot(index.toDouble(), item['cumulative']);
                      }).toList(),
                      isCurved: true,
                      color: lineColor,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            lineColor.withOpacity(0.3),
                            lineColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${(value / 1000).toStringAsFixed(0)}ك');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= cumulativeData.length) return const Text('');
                          final label = cumulativeData[index]['label'] as String;
                          return Text(label.length > 3 ? label.substring(0, 3) : label);
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  final Map<String, double> expenseByCategory;
  final List<Category> categories;

  const _CategoryBreakdownCard({
    required this.expenseByCategory,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final total = expenseByCategory.values.fold(0.0, (sum, amount) => sum + amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'توزيع المصاريف حسب التصنيف',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenseByCategory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = expenseByCategory.entries.elementAt(index);
                final category = categories.firstWhere(
                  (c) => c.name == entry.key,
                  orElse: () => Category(name: entry.key, color: Colors.grey.value, icon: 'help', type: 'expense', isCustom: false),
                );
                final percentage = total > 0 ? (entry.value / total * 100).toStringAsFixed(1) : '0.0';

                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(category.color),
                      child: Icon(
                        iconFromString(category.icon),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: total > 0 ? entry.value / total : 0,
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                            color: Color(category.color),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('$percentage%'),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/categories');
                },
                child: const Text('عرض كافة التصنيفات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

