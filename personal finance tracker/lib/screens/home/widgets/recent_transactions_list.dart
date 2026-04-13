import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction.dart' as transaction;
import '../../../models/category.dart' as category;
import 'package:personal_finance_tracker/utils/helpers.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<transaction.Transaction> txns;
  final List<category.Category> categories;
  final VoidCallback onViewAll;
  final String currency;

  const RecentTransactionsList({
    super.key,
    required this.txns,
    required this.categories,
    required this.onViewAll,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final emerald = const Color(0xFF10B981);
    final rose = const Color(0xFFF43F5E);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'أحدث المعاملات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: txns.length,
          separatorBuilder: (ctx, i) => const Divider(),
          itemBuilder: (ctx, i) {
            final t = txns[i];
            final category.Category cat = categories.firstWhere((c) => c.name == t.category, orElse: () => category.Category(name: 'unknown', icon: 'help', color: 0xFF000000, type: 'expense', isCustom: false));
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(cat.color).withValues(alpha: 0.1),
                      child: Icon(
                        iconFromString(cat.icon),
                        color: Color(cat.color),
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.description,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${DateFormat.jm('ar_EG').format(t.date)} • ${cat.name}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      t.type == 'income' ? '+${formatCurrency(t.amount, symbol: currency)}' : '-${formatCurrency(t.amount, symbol: currency)}',
                      style: TextStyle(
                        color: t.type == 'income' ? emerald : rose,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
