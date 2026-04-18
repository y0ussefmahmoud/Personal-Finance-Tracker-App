# Database Layer

هذه الطبقة تحتوي على DatabaseHelper الذي يدير جميع عمليات قاعدة البيانات SQLite.

## DatabaseHelper

Singleton class يدير جميع عمليات قاعدة البيانات.

### الوظائف الرئيسية

- **التهيئة**: إنشاء قاعدة البيانات والجداول
- **Migrations**: إدارة تحديثات هيكل قاعدة البيانات
- **CRUD Operations**: عمليات الإضافة، القراءة، التعديل، الحذف لجميع النماذج
- **Settings**: تخزين إعدادات التطبيق

### الجداول

- **transactions**: المعاملات المالية
- **categories**: الفئات
- **budgets**: الميزانيات
- **installments**: الأقساط والديون
- **zakat**: سجلات الزكاة
- **tips**: النصائح المالية
- **money_locations**: أماكن المال
- **settings**: إعدادات التطبيق

### Database Version

الإصدار الحالي: 5

تاريخ التحديثات:
- **v1**: إنشاء الجداول الأساسية
- **v2**: إضافة جدول الأقساط
- **v3**: إضافة جدول الزكاة
- **v4**: إضافة money_location_id لجدول transactions
- **v5**: إزالة expectedAmount من جدول money_locations

## مثال الاستخدام

```dart
// الحصول على قاعدة البيانات
final db = DatabaseHelper();
final database = await db.database;

// إضافة معاملة
await db.insertTransaction(transaction);

// الحصول على جميع المعاملات
final transactions = await db.getTransactions();

// تحديث معاملة
await db.updateTransaction(transaction);

// حذف معاملة
await db.deleteTransaction(id);
```
