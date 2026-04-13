import 'package:flutter/material.dart';
import '../../../models/installment.dart';
import '../../../utils/currency_formatter.dart';

class DebtCard extends StatefulWidget {
  final Installment debt;

  const DebtCard({super.key, required this.debt});

  @override
  State<DebtCard> createState() => _DebtCardState();
}

class _DebtCardState extends State<DebtCard> {
  bool _reminderOn = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountColor = isDark ? Color(0xFFFF5252) : Color(0xFFEF4444);
    final initial = widget.debt.name.isNotEmpty ? widget.debt.name[0].toUpperCase() : '?';
    final avatarColor = Theme.of(context).primaryColor.withValues(alpha: 0.1);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: avatarColor,
              child: Text(initial),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.debt.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      formatCurrency(widget.debt.remainingAmount),
                      style: TextStyle(color: amountColor),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.debt.status == 'closed' ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.debt.status == 'closed' ? 'مكتمل' : 'نشط',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Text('تذكير'),
                    Switch(
                      value: _reminderOn,
                      onChanged: (value) => setState(() => _reminderOn = value),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
