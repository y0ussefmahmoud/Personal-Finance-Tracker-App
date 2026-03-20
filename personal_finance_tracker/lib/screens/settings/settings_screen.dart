import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../database/database_helper.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/installment_provider.dart';
import '../../providers/zakat_provider.dart';
import '../../providers/tips_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'التفضيلات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
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
            SwitchListTile(
              title: const Text('الوضع المظلم'),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (value) {
                settings.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'معلومات التطبيق',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ListTile(
              title: const Text('الإصدار'),
              subtitle: const Text('1.0.3'),
            ),
            ListTile(
              title: const Text('حول'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Personal Finance Tracker',
                applicationVersion: '1.0.3',
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('إعادة تعيين البيانات', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('تأكيد إعادة التعيين'),
                      content: const Text(
                        'هل أنت متأكد من إعادة تعيين البيانات؟ سيتم حذف جميع المعاملات والميزانيات والأقساط وزكاة والنصائح. هذا الإجراء لا يمكن التراجع عنه.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('إلغاء'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            try {
                              await DatabaseHelper().resetDatabase();
                              await context.read<TransactionProvider>().fetchTransactions();
                              await context.read<BudgetProvider>().fetchBudgets();
                              await context.read<InstallmentProvider>().fetchInstallments();
                              await context.read<ZakatProvider>().fetchZakatRecords();
                              await context.read<TipsProvider>().getTips();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم إعادة تعيين البيانات بنجاح')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('فشل في إعادة تعيين البيانات: $e')),
                              );
                            }
                          },
                          child: const Text('إعادة تعيين'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
