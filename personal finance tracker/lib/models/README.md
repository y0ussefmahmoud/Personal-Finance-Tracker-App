# Models Layer

هذه الطبقة تحتوي على نماذج البيانات (Data Models) التي تمثل كيانات التطبيق.

## النماذج المتوفرة

### Transaction
تمثل معاملة مالية (دخل أو مصروف)
- **الحقول**: id, type, amount, category, description, date, paymentMethod, isRecurring, recurringType, moneyLocationId, createdAt
- **الوظائف**: toMap(), fromMap(), copyWith()

### Category
تمثل فئة للمعاملات (مثلاً: طعام، تسوق، راتب)
- **الحقول**: id, name, icon, color, type (income/expense/both), isCustom
- **الوظائف**: toMap(), fromMap(), copyWith()

### MoneyLocation
تمثل مكان المال (كاش، بنك، محفظة إلكترونية)
- **الحقول**: id, name, actualAmount, icon, color, createdAt, updatedAt
- **الوظائف**: toMap(), fromMap(), copyWith()
- **الملاحظات**: expectedAmount يتم حسابه ديناميكياً من المعاملات

### Budget
تمثل ميزانية شهرية لفئة معينة
- **الحقول**: id, category, amount, spent, startDate, endDate, status
- **الوظائف**: toMap(), fromMap(), copyWith()

### Installment
تمثل قسط أو دين
- **الحقول**: id, name, totalAmount, remainingAmount, monthlyPayment, dueDate, type (installment/debt), status
- **الوظائف**: toMap(), fromMap(), copyWith()

### Zakat
تمثل سجل زكاة
- **الحقول**: id, year, gold, cash, investments, totalAssets, totalZakat, paid, paymentDate
- **الوظائف**: toMap(), fromMap(), copyWith()

### Tip
تمثل نصيحة مالية
- **الحقول**: id, title, content, category (saving/investment/budgeting), isRead, date
- **الوظائف**: toMap(), fromMap(), copyWith()

## مثال الاستخدام

```dart
// إنشاء معاملة جديدة
final transaction = Transaction(
  type: 'expense',
  amount: 100.0,
  category: 'طعام',
  description: 'غداء',
  date: DateTime.now(),
  paymentMethod: 'نقدي',
  isRecurring: false,
  createdAt: DateTime.now(),
);

// تحويل إلى Map
final map = transaction.toMap();

// استعادة من Map
final restored = Transaction.fromMap(map);
```
