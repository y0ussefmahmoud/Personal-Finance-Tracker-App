import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/budget.dart';
import '../../models/category.dart';
import '../../providers/budget_provider.dart';
import '../../providers/category_provider.dart';
import '../../utils/icon_helper.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/bottom_nav_bar.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BudgetProvider>().fetchBudgets();
        context.read<CategoryProvider>().fetchCategories();
      }
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddBudgetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddBudgetSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزانيات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBudgetSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'نشط'),
              Tab(text: 'مخطط'),
              Tab(text: 'منتهي'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BudgetTabView(status: 'active'),
                _BudgetTabView(status: 'planned'),
                _BudgetTabView(status: 'completed'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}

class _BudgetTabView extends StatelessWidget {
  final String status;

  const _BudgetTabView({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BudgetProvider, CategoryProvider>(
      builder: (context, budgetProvider, categoryProvider, child) {
        final filteredBudgets = budgetProvider.budgets.where((budget) => budget.status == status).toList();

        return Column(
          children: [
            _OverallSummaryCard(budgets: filteredBudgets),
            Expanded(
              child: budgetProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => budgetProvider.fetchBudgets(),
                      child: ListView.builder(
                        itemCount: filteredBudgets.length,
                        itemBuilder: (context, index) {
                          final budget = filteredBudgets[index];
                          final category = categoryProvider.categories.firstWhere(
                            (cat) => cat.name == budget.category,
                            orElse: () => Category(name: budget.category, icon: 'category', color: 0xFF9E9E9E, type: 'expense', isCustom: false),
                          );
                          return _BudgetCategoryCard(budget: budget, category: category);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _OverallSummaryCard extends StatelessWidget {
  final List<Budget> budgets;

  const _OverallSummaryCard({required this.budgets});

  @override
  Widget build(BuildContext context) {
    final totalAmount = budgets.fold<double>(0.0, (sum, budget) => sum + budget.amount);
    final totalSpent = budgets.fold<double>(0.0, (sum, budget) => sum + budget.spent);
    final ratio = totalAmount > 0 ? (totalSpent / totalAmount).clamp(0.0, 1.0) : 0.0;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إجمالي الميزانية: ${formatCurrency(totalAmount)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'إجمالي المُنفَق: ${formatCurrency(totalSpent)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2f7f33)),
            ),
            const SizedBox(height: 4.0),
            Text('${formatCurrency(totalSpent)} من ${formatCurrency(totalAmount)}'),
          ],
        ),
      ),
    );
  }
}

class _BudgetCategoryCard extends StatelessWidget {
  final Budget budget;
  final Category category;

  const _BudgetCategoryCard({required this.budget, required this.category});

  @override
  Widget build(BuildContext context) {
    final ratio = budget.amount > 0 ? (budget.spent / budget.amount) : 0.0;
    final clampedRatio = ratio.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getProgressColor() {
      if (ratio < 0.80) {
        return isDark ? const Color(0xFF00E676) : const Color(0xFF4CAF50);
      } else if (ratio < 1.00) {
        return isDark ? const Color(0xFFFFD600) : const Color(0xFFEAB308);
      } else {
        return isDark ? const Color(0xFFFF5252) : const Color(0xFFEF4444);
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              iconFromString(category.icon),
              color: Color(category.color),
              size: 32.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    budget.category,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'المبلغ المتبقي: ${formatCurrency(budget.amount - budget.spent)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  LinearProgressIndicator(
                    value: clampedRatio,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
                  ),
                  const SizedBox(height: 4.0),
                  Text('${formatCurrency(budget.spent)} / ${formatCurrency(budget.amount)}'),
                  if (ratio >= 1.00)
                    Text(
                      'تجاوزت الميزانية',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBudgetSheet extends StatefulWidget {
  @override
  State<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<_AddBudgetSheet> {
  String? _selectedCategory;
  final _amountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _addBudget() async {
    if (_selectedCategory == null || _amountController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال مبلغ صحيح')),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تاريخ النهاية يجب أن يكون بعد أو يساوي تاريخ البداية')),
      );
      return;
    }

    try {
      final navigator = Navigator.of(context);
      await context.read<BudgetProvider>().addBudget(Budget(
        category: _selectedCategory!,
        amount: amount,
        spent: 0.0,
        startDate: _startDate!,
        endDate: _endDate!,
        status: 'active',
      ));
      if (!context.mounted) return;
      navigator.pop();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة الميزانية بنجاح')),
      );
    } catch (e) {
      if (!context.mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الإضافة: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final expenseCategories = categoryProvider.categories.where((cat) => cat.type == 'expense' || cat.type == 'both').toList();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'التصنيف'),
                items: expenseCategories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.name,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'المبلغ', suffixText: 'ج.م'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'تاريخ البداية'),
                onTap: () => _selectDate(context, true),
                controller: TextEditingController(text: _startDate != null ? _startDate!.toString().split(' ')[0] : ''),
              ),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'تاريخ النهاية'),
                onTap: () => _selectDate(context, false),
                controller: TextEditingController(text: _endDate != null ? _endDate!.toString().split(' ')[0] : ''),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addBudget,
                child: const Text('إضافة الميزانية'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}
