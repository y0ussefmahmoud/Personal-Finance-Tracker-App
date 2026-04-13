import 'package:flutter/material.dart';
import '../../../models/installment.dart';
import '../../../utils/currency_formatter.dart';
import 'circular_progress_painter.dart';

class InstallmentCard extends StatelessWidget {
  final Installment installment;
  final VoidCallback onPay;

  const InstallmentCard({super.key, required this.installment, required this.onPay});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = installment.totalAmount > 0 ? installment.paidAmount / installment.totalAmount : 0.0;
    final fgColor = installment.status == 'closed'
        ? (isDark ? Color(0xFF00E676) : Color(0xFF4CAF50))
        : (isDark ? Color(0xFF3B82F6) : Color(0xFF1565C0));
    final bgColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.3);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: CircularProgressPainter(
                      progress: progress,
                      foregroundColor: fgColor,
                      backgroundColor: bgColor,
                    ),
                    size: Size(64, 64),
                  ),
                  Text('${(progress * 100).round()}%'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(installment.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(formatCurrency(installment.remainingAmount)),
                    Text('${installment.dueDate.day}/${installment.dueDate.month}/${installment.dueDate.year}'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: installment.status == 'closed' ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    installment.status == 'closed' ? 'مكتمل' : 'نشط',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (installment.status == 'active')
                  TextButton(
                    onPressed: onPay,
                    child: Text('دفع القسط'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
