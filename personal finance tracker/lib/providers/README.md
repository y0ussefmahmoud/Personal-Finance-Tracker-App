# Providers Layer

هذه الطبقة تحتوي على Providers التي تدير حالة التطبيق باستخدام نمط Provider.

## لماذا Provider؟

- **إدارة الحالة**: إدارة حالة التطبيق بسهولة
- **إعادة البناء**: إعادة بناء الواجهة تلقائياً عند تغيير الحالة
- **فصل المسؤوليات**: فصل منطق الأعمال عن الواجهة

## الـ Providers المتوفرة

### TransactionProvider
إدارة المعاملات المالية
- **الوظائف**: fetchTransactions, addTransaction, updateTransaction, deleteTransaction
- **الحسابات**: totalBalance, totalIncome, totalExpense, expenseByCategory

### CategoryProvider
إدارة الفئات
- **الوظائف**: fetchCategories, addCategory, updateCategory, deleteCategory
- **الوظائف الإضافية**: seedDefaultCategories, resetCategoriesSeeding, forceReseedCategories

### MoneyLocationProvider
إدارة أماكن المال
- **الوظائف**: fetchMoneyLocations, addMoneyLocation, updateMoneyLocation, deleteMoneyLocation
- **الحسابات**: calculateExpectedAmount, totalExpectedAmount, totalActualAmount, totalDeficit

### BudgetProvider
إدارة الميزانيات
- **الوظائف**: fetchBudgets, addBudget, updateBudget, deleteBudget
- **الوظائف الإضافية**: updateSpentForCategory

### InstallmentProvider
إدارة الأقساط والديون
- **الوظائف**: fetchInstallments, addInstallment, updateInstallment, deleteInstallment
- **الحسابات**: totalDebt, totalInstallments, nextMonthPayments

### ZakatProvider
إدارة الزكاة
- **الوظائف**: fetchZakatRecords, addZakatRecord, updateZakatRecord, deleteZakatRecord
- **الحسابات**: totalPaidZakat, totalUnpaidZakat

### TipsProvider
إدارة النصائح المالية
- **الوظائف**: fetchTips, addTip, updateTip, deleteTip, markAsRead
- **الوظائف الإضافية**: seedDefaultTips (static)
- **الفلاتر**: unreadTips, savingTips, investmentTips, budgetingTips

### SettingsProvider
إدارة إعدادات التطبيق
- **الإعدادات**: اللغة، العملة، الوضع الليلي/النهاري

## مثال الاستخدام

```dart
// في Widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.transactions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(provider.transactions[index].category),
            );
          },
        );
      },
    );
  }
}

// إضافة معاملة
final provider = context.read<TransactionProvider>();
await provider.addTransaction(transaction);
```
