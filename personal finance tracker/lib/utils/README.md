# Utils Layer

هذه الطبقة تحتوي على دوال مساعدة وأدوات قابلة لإعادة الاستخدام في جميع أنحاء التطبيق.

## الملفات المتوفرة

### helpers.dart
دوال مساعدة للتنسيق والحسابات

#### الوظائف الرئيسية
- `formatCurrency(double amount, String currency)`: تنسيق المبلغ بالعملة
- `formatDate(DateTime date)`: تنسيق التاريخ
- `calculatePercentage(double value, double total)`: حساب النسبة المئوية
- دوال مساعدة أخرى للتنسيق والتحويل

### icon_helper.dart
دوال مساعدة للتعامل مع الأيقونات

#### الوظائف الرئيسية
- `iconFromString(String iconName)`: تحويل اسم الأيقونة إلى IconData
- `getIconForCategory(String category)`: الحصول على الأيقونة المناسبة للفئة

### theme.dart
تعريفات الثيمات (ألوان، خطوط، أنماط)

#### الثيمات المتوفرة
- `lightTheme`: الثيم النهاري
- `darkTheme`: الثيم الليلي

## مثال الاستخدام

```dart
// استخدام helpers
final formattedAmount = formatCurrency(1000.0, 'EGP');
final formattedDate = formatDate(DateTime.now());
final percentage = calculatePercentage(50, 100);

// استخدام icon_helper
final icon = iconFromString('restaurant');
final categoryIcon = getIconForCategory('طعام');

// استخدام theme
final theme = Theme.of(context);
final color = theme.primaryColor;
```
