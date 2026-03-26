import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_stats_row.dart';
import 'widgets/expense_pie_chart.dart';
import 'widgets/recent_transactions_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TransactionProvider>().fetchTransactions();
        context.read<CategoryProvider>().fetchCategories();
        context.read<SettingsProvider>().loadSettings();
      }
    });
  }

  Future<void> _refreshData() async {
    await context.read<TransactionProvider>().fetchTransactions();
    await context.read<CategoryProvider>().fetchCategories();
    await context.read<BudgetProvider>().fetchBudgets();
  }

  /// Shows the main menu with navigation options
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'القائمة الرئيسية',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.add_circle),
                title: const Text('إضافة معاملة'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add_transaction');
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('جميع المعاملات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/transactions');
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('التحليلات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/analytics');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('الميزانيات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/budgets');
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('التصنيفات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categories');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('الزكاة'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/zakat');
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('الأقساط'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/installments');
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('نصائح مالية'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/tips');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('الإعدادات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows financial management options
  void _showManageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة الأموال',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.green),
                title: const Text('إضافة معاملة'),
                subtitle: const Text('سجل دخل أو مصروف جديد'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add_transaction');
                },
              ),
              ListTile(
                leading: const Icon(Icons.list, color: Colors.blue),
                title: const Text('عرض المعاملات'),
                subtitle: const Text('شاهد جميع معاملاتك'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/transactions');
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics, color: Colors.purple),
                title: const Text('التحليلات'),
                subtitle: const Text('عرض تقارير وإحصائيات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/analytics');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.orange),
                title: const Text('إدارة الميزانيات'),
                subtitle: const Text('حدد ميزانياتك الشهرية'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/budgets');
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: Colors.red),
                title: const Text('إدارة التصنيفات'),
                subtitle: const Text('أنشئ أو عدل تصنيفات المعاملات'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categories');
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.teal),
                title: const Text('إدارة الأقساط'),
                subtitle: const Text('تتبع الأقساط والديون'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/installments');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance, color: Colors.indigo),
                title: const Text('حساب الزكاة'),
                subtitle: const Text('احسب زكاتك'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/zakat');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).cardColor,
                elevation: 0,
                flexibleSpace: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => _showMenu(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'لوحة التحكم الرئيسية',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Consumer2<TransactionProvider, SettingsProvider>(
                        builder: (ctx, tp, sp, child) => Column(
                          children: [
                            BalanceCard(
                              totalBalance: tp.totalBalance,
                              currencySymbol: sp.currencySymbol,
                              onManageTap: () => _showManageOptions(context),
                            ),
                            if (tp.isLoading) const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Consumer2<TransactionProvider, SettingsProvider>(
                        builder: (ctx, tp, sp, child) => QuickStatsRow(
                          income: tp.currentMonthIncome,
                          expense: tp.currentMonthExpense,
                          currency: sp.currencySymbol,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Consumer2<TransactionProvider, CategoryProvider>(
                        builder: (ctx, tp, cp, child) => ExpensePieChart(
                          expenseByCategory: tp.expenseByCategory,
                          categories: cp.categories,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Consumer3<TransactionProvider, CategoryProvider, SettingsProvider>(
                        builder: (ctx, tp, cp, sp, child) => RecentTransactionsList(
                          txns: tp.transactions.take(5).toList(),
                          categories: cp.categories,
                          onViewAll: () => Navigator.pushNamed(ctx, '/transactions'),
                          currency: sp.currencySymbol,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
          Positioned(
            bottom: 80,
            left: 24,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => Navigator.pushNamed(context, '/add_transaction'),
              child: const Icon(Icons.add, size: 30),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
