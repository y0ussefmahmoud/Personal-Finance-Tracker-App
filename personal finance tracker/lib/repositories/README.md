# Repositories Layer

هذه الطبقة تحتوي على Repository Pattern الذي يعمل كطبقة تجريد بين مصدر البيانات (DatabaseHelper) ومنطق الأعمال (Providers).

## لماذا Repository Pattern؟

- **فصل المسؤوليات**: فصل منطق قاعدة البيانات عن منطق الأعمال
- **قابلية الاختبار**: يمكن اختبار Repositories بسهولة
- **إمكانية إعادة الاستخدام**: يمكن إعادة استخدام Repositories في أماكن مختلفة
- **سهولة التبديل**: يمكن تبديل مصدر البيانات بسهولة (مثلاً من SQLite إلى API)

## الملفات المتوفرة

### TransactionRepository
إدارة عمليات المعاملات المالية (CRUD)

### CategoryRepository
إدارة عمليات الفئات (CRUD)

### MoneyLocationRepository
إدارة عمليات أماكن المال (CRUD)

### BudgetRepository
إدارة عمليات الميزانية (CRUD)

### InstallmentRepository
إدارة عمليات الأقساط والديون (CRUD)

### ZakatRepository
إدارة عمليات الزكاة (CRUD)

### TipRepository
إدارة عمليات النصائح (CRUD)

## مثال الاستخدام

```dart
// في Provider
class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _transactionRepository;

  TransactionProvider() : _transactionRepository = TransactionRepository(DatabaseHelper());

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionRepository.addTransaction(transaction);
    await fetchTransactions();
  }
}
```
