import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/utils/helpers.dart';

class QuickStatsRow extends StatelessWidget {
  final double income;
  final double expense;
  final String currency;

  const QuickStatsRow({
    super.key,
    required this.income,
    required this.expense,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emeraldBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFECFDF5);
    final emeraldBorder = isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFD1FAE5);
    final emeraldColor = const Color(0xFF10B981);
    final roseBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF1F2);
    final roseBorder = isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFFFE4E6);
    final roseColor = const Color(0xFFF43F5E);

    return Row(
      children: [
        Expanded(
          child: Card(
            color: emeraldBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: emeraldBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: emeraldColor),
                      const SizedBox(width: 8),
                      Text('الدخل', style: TextStyle(color: emeraldColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(income, symbol: currency),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Visibility(
                    visible: false,
                    child: Text(
                      '+5.4%',
                      style: TextStyle(color: emeraldColor, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            color: roseBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: roseBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_down, color: roseColor),
                      const SizedBox(width: 8),
                      Text('المصاريف', style: TextStyle(color: roseColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(expense),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Visibility(
                    visible: false,
                    child: Text(
                      '-2.1%',
                      style: TextStyle(color: roseColor, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
