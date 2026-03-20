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
    context.read<TransactionProvider>().fetchTransactions();
    context.read<CategoryProvider>().fetchCategories();
    context.read<SettingsProvider>().loadSettings();
  }

  Future<void> _refreshData() async {
    await context.read<TransactionProvider>().fetchTransactions();
    await context.read<CategoryProvider>().fetchCategories();
    await context.read<BudgetProvider>().fetchBudgets();
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
                      onPressed: () {},
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
                              onManageTap: () {},
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
