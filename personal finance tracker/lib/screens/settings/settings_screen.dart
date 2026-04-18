import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../database/database_helper.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/installment_provider.dart';
import '../../providers/zakat_provider.dart';
import '../../providers/tips_provider.dart';

/// Settings Screen - Manages application settings and user preferences
///
/// This screen provides access to:
/// - Theme switching (light/dark/system mode)
/// - Currency settings
/// - Database reset functionality
/// - Application information and version details
class SettingsScreen extends StatelessWidget {
  /// Creates a settings screen
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            _buildPreferencesSection(context, settings),
            _buildAppInfoSection(context),
            _buildDangerZoneSection(context),
          ],
        ),
      ),
    );
  }

  /// Builds the preferences section with user settings
  Widget _buildPreferencesSection(BuildContext context, SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'التفضيلات'),
        const ListTile(
          title: Text('الوضع'),
          subtitle: Text('اختر وضع التطبيق'),
          leading: Icon(Icons.palette),
        ),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.light,
              label: Text('فاتح'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text('داكن'),
              icon: Icon(Icons.dark_mode),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              label: Text('نظام'),
              icon: Icon(Icons.brightness_auto),
            ),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (Set<ThemeMode> selected) {
            settings.setThemeMode(selected.first);
          },
        ),
        ListTile(
          title: const Text('العملة'),
          trailing: DropdownButton<String>(
            value: settings.currency,
            items: ['ج.م', 'USD', 'EUR', 'SAR']
                .map((currency) => DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    ))
                .toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                settings.setCurrency(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  /// Builds the application information section
  Widget _buildAppInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'معلومات التطبيق'),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('الإصدار'),
          subtitle: const Text('1.3.4'),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('حول'),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'Personal Finance Tracker',
            applicationVersion: '1.3.4',
            applicationIcon: const Icon(Icons.account_balance_wallet, size: 48),
          ),
        ),
      ],
    );
  }

  /// Builds the dangerous actions section (reset data)
  Widget _buildDangerZoneSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'الإجراءات الخطرة'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '⚠️ تحذير: هذه الإجراءات لا يمكن التراجع عنها',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.restore, color: Colors.red),
          title: const Text('إعادة تعيين البيانات'),
          subtitle: const Text('حذف جميع البيانات واستعادة التطبيق'),
          onTap: () => _showResetDataConfirmation(context),
        ),
      ],
    );
  }

  /// Shows confirmation dialog for data reset
  void _showResetDataConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد إعادة التعيين'),
        content: const Text(
          'هل أنت متأكد من إعادة تعيين البيانات؟ سيتم حذف جميع المعاملات والميزانيات والأقساط وزكاة والنصائح. هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _performDataReset(context),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  /// Performs the actual data reset operation
  Future<void> _performDataReset(BuildContext context) async {
    Navigator.of(context).pop(); // Close dialog
    
    try {
      // Reset database
      await DatabaseHelper().resetDatabase();
      
      // Refresh all providers data
      if (!context.mounted) return;
      await _refreshAllProviders(context);
      
      // Show success message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إعادة تعيين البيانات بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إعادة تعيين البيانات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Refreshes all provider data after reset
  Future<void> _refreshAllProviders(BuildContext context) async {
    await Future.wait([
      context.read<TransactionProvider>().fetchTransactions(),
      context.read<BudgetProvider>().fetchBudgets(),
      context.read<InstallmentProvider>().fetchInstallments(),
      context.read<ZakatProvider>().fetchZakatRecords(),
      context.read<TipsProvider>().getTips(),
    ]);
  }
}

/// Custom widget for section headers
class SectionHeader extends StatelessWidget {
  final String title;
  
  const SectionHeader({
    super.key,
    required this.title,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
