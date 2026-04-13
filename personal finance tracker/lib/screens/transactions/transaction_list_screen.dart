import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/budget_provider.dart';
import '../../utils/helpers.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _selectedType = 'الكل';
  String? _selectedCategory;
  String _selectedPeriod = 'الكل';

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions) {
    List<Transaction> filtered = transactions;

    // Filter by type
    if (_selectedType != 'الكل') {
      filtered = filtered.where((t) => t.type == _selectedType).toList();
    }

    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }

    // Filter by period
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'أسبوع':
        final weekAgo = now.subtract(const Duration(days: 7));
        filtered = filtered.where((t) => t.date.isAfter(weekAgo)).toList();
        break;
      case 'شهر':
        final startOfMonth = DateTime(now.year, now.month, 1);
        filtered = filtered.where((t) => t.date.isAfter(startOfMonth.subtract(const Duration(days: 1)))).toList();
        break;
      case 'سنة':
        final startOfYear = DateTime(now.year, 1, 1);
        filtered = filtered.where((t) => t.date.isAfter(startOfYear.subtract(const Duration(days: 1)))).toList();
        break;
      case 'الكل':
        // No filter
        break;
    }

    return filtered;
  }

  Map<String, List<Transaction>> _groupByMonth(List<Transaction> txns) {
    final grouped = <String, List<Transaction>>{};

    for (final txn in txns) {
      DateTime keyDate = DateTime(txn.date.year, txn.date.month, 1);
      final key = keyDate.toIso8601String();
      grouped.putIfAbsent(key, () => []).add(txn);
    }

    // Sort keys descending
    final sortedKeys = grouped.keys.toList()..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    final sortedGrouped = <String, List<Transaction>>{};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المعاملات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Optional: open filter dialog, but for now, filters are in UI
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            selectedType: _selectedType,
            selectedPeriod: _selectedPeriod,
            onTypeChanged: (type) => setState(() => _selectedType = type),
            onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
          ),
          _CategoryFilterChips(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (category) => setState(() => _selectedCategory = category),
          ),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
                if (transactionProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredTransactions = _getFilteredTransactions(transactionProvider.transactions);
                if (filteredTransactions.isEmpty) {
                  return const Center(child: Text('لا توجد معاملات'));
                }

                final grouped = _groupByMonth(filteredTransactions);

                return ListView.builder(
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final month = grouped.keys.elementAt(index);
                    final txns = grouped[month]!;
                    txns.sort((a, b) => b.date.compareTo(a.date));
                    final displayMonth = DateFormat('MMMM yyyy', 'ar_EG').format(DateTime.parse(month));
                    final incomeTotal = txns.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
                    final expenseTotal = txns.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(displayMonth, style: Theme.of(context).textTheme.titleMedium),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'دخل: ${formatCurrency(incomeTotal)}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    'مصروف: ${formatCurrency(expenseTotal)}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...txns.map((t) {
                          final Category cat = context.read<CategoryProvider>().categories.firstWhere(
                            (c) => c.name == t.category,
                            orElse: () => Category(name: 'Unknown', icon: 'help', color: 0xFF9E9E9E, type: 'expense', isCustom: false),
                          );
                          return Dismissible(
                            key: ValueKey(t.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) async {
                              final transactionProvider = context.read<TransactionProvider>();
                              transactionProvider.budgetProvider = context.read<BudgetProvider>();
                              await transactionProvider.deleteTransaction(t.id!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم حذف المعاملة')),
                                );
                              }
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(
                                  iconFromString(cat.icon),
                                  color: Color(cat.color),
                                ),
                              ),
                              title: Text(t.description),
                              subtitle: Text(
                                '${DateFormat('d MMMM yyyy', 'ar_EG').format(t.date)} • ${cat.name} • ${t.paymentMethod}',
                              ),
                              trailing: Text(
                                formatCurrency(t.amount),
                                style: TextStyle(
                                  color: t.type == 'income' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selectedType;
  final String selectedPeriod;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onPeriodChanged;

  const _FilterBar({
    required this.selectedType,
    required this.selectedPeriod,
    required this.onTypeChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['الكل', 'income', 'expense'].map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(type == 'income' ? 'دخل' : type == 'expense' ? 'مصروف' : 'الكل'),
                  selected: selectedType == type,
                  onSelected: (selected) => onTypeChanged(type),
                ),
              );
            }).toList(),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['أسبوع', 'شهر', 'سنة', 'الكل'].map((period) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(period),
                  selected: selectedPeriod == period,
                  onSelected: (selected) => onPeriodChanged(period),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const _CategoryFilterChips({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: const Text('الكل'),
                  selected: selectedCategory == null,
                  onSelected: (selected) => onCategoryChanged(null),
                ),
              ),
              ...categoryProvider.categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(cat.name),
                    avatar: Icon(iconFromString(cat.icon)),
                    selected: selectedCategory == cat.name,
                    onSelected: (selected) => onCategoryChanged(selected ? cat.name : null),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
