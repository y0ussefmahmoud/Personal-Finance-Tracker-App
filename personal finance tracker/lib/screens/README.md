# Screens Layer

هذه الطبقة تحتوي على شاشات التطبيق (UI) التي تعرض البيانات للمستخدم وتسمح له بالتفاعل مع التطبيق.

## الشاشات المتوفرة

### home/
- **dashboard_screen.dart**: الشاشة الرئيسية تعرض ملخص المالية والإحصائيات
- **widgets/**: ويدجتس قابلة لإعادة الاستخدام للشاشة الرئيسية
  - balance_card.dart: بطاقة الرصيد
  - quick_stats_row.dart: صف الإحصائيات السريعة
  - expense_pie_chart.dart: مخطط دائري للمصروفات
  - recent_transactions_list.dart: قائمة المعاملات الأخيرة

### transactions/
- **transaction_list_screen.dart**: قائمة المعاملات مع البحث والتصفية
- **add_transaction_screen.dart**: شاشة إضافة/تعديل معاملة

### categories/
- **categories_screen.dart**: إدارة الفئات (إضافة، تعديل، حذف)

### budgets/
- **budgets_screen.dart**: إدارة الميزانيات الشهرية

### installments/
- **installments_screen.dart**: إدارة الأقساط والديون
- **widgets/**: ويدجتس خاصة بالأقساط
  - installment_card.dart: بطاقة القسط
  - debt_card.dart: بطاقة الدين
  - circular_progress_painter.dart: رسام التقدم الدائري
  - add_installment_sheet.dart: ورقة إضافة قسط

### zakat/
- **zakat_screen.dart**: حساب وإدارة الزكاة

### money_locations/
- **money_locations_screen.dart**: إدارة أماكن المال (كاش، بنك، محفظة إلكترونية)

### analytics/
- **analytics_screen.dart**: تحليلات وإحصائيات متقدمة

### tips/
- **tips_screen.dart**: عرض النصائح المالية

### settings/
- **settings_screen.dart**: إعدادات التطبيق (اللغة، العملة، الوضع الليلي)

## مثال الاستخدام

```dart
// الانتقال لشاشة
Navigator.pushNamed(context, '/transactions');

// استخدام Provider في الشاشة
class MyScreen extends StatelessWidget {
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
```
