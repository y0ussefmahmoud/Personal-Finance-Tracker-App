# 🏦 Personal Finance Tracker

تطبيق متقدم لإدارة الشؤون المالية الشخصية مصمم لمساعدتك على تتبع دخلك، مصروفاتك، والميزانية بفعالية.

## 📱 **المميزات الرئيسية**

### 💰 **إدارة المعاملات المالية**
- ✅ إضافة وتعديل وحذف المعاملات المالية
- 📊 تصنيف المعاملات (دخل/مصروفات)
- 🏷️ فئات مخصصة للمصروفات
- 🔍 البحث والتصفية في المعاملات

### 📈 **التحليلات والإحصائيات**
- 📊 رسوم بيانية تفاعلية للدخل والمصروفات
- 🥧 مخطط دائري لتوزيع المصروفات حسب الفئات
- 📅 إحصائيات شهرية وسنوية
- 💡 نصائح ذكية لإدارة الأموال

### 🎯 **إدارة الميزانية**
- 📋 إنشاء ميزانيات شهرية
- 🎯 تتبع التقدم في تحقيق الأهداف
- ⚠️ تنبيهات عند تجاوز الميزانية
- 📈 مقارنة الأداء الشهري

### 💳 **إدارة الأقساط**
- 📅 تتبع أقساط القروض والالتزامات
- ⏰ تنبيهات بمواعيد السداد
- 💰 حساب المتبقي من الأقساط
- 📊 إجمالي الأقساط الشهرية

### 🕌 **حساب الزكاة**
- 💰 حساب الزكاة المستحقة
- 🏆 إضافة زكاة للمعاملات
- 📊 تتبع مدفوعات الزكاة
- 🎯 أهداف الزكاة السنوية

### ⚙️ **الإعدادات والتخصيص**
- 🌓 الوضع الليلي والنهاري
- 🌍 دعم العربية والإنجليزية
- 💱 اختيار عملة مخصصة
- 🎨 تخصيص واجهة التطبيق

## 🚀 **التثبيت والتشغيل**

### **المتطلبات**
- Android 5.0 (API Level 21) أو أعلى
- iOS 11.0 أو أعلى
- Flutter SDK 3.11.1 أو أعلى

### **خطوات التثبيت**
1. **تنزيل التطبيق:**
   ```bash
   git clone https://github.com/your-repo/personal-finance-tracker.git
   cd personal-finance-tracker
   ```

2. **تثبيت الاعتماديات:**
   ```bash
   flutter pub get
   ```

3. **تشغيل التطبيق:**
   ```bash
   flutter run
   ```

4. **بناء APK للتوزيع:**
   ```bash
   flutter build apk --release
   ```

## 📂 **هيكل المشروع**

```
lib/
├── main.dart                 # نقطة بداية التطبيق
├── database/                 # قاعدة البيانات
│   └── database_helper.dart
├── models/                   # نماذج البيانات
│   ├── transaction.dart
│   ├── category.dart
│   └── budget.dart
├── providers/                # إدارة الحالة (State Management)
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   └── settings_provider.dart
├── screens/                  # الشاشات الرئيسية
│   ├── home/
│   ├── transactions/
│   ├── analytics/
│   └── settings/
├── widgets/                  # ويدجتس قابلة لإعادة الاستخدام
└── utils/                    # أدوات مساعدة
    ├── helpers.dart
    └── theme.dart
```

## 🛠️ **التقنيات المستخدمة**

- **Flutter 3.11.1** - إطار العمل الرئيسي
- **Provider** - إدارة الحالة
- **SQLite** - قاعدة البيانات المحلية
- **fl_chart** - الرسوم البيانية
- **shared_preferences** - تخزين الإعدادات

## 📊 **الإصدارات**

### **الإصدار الحالي: 1.0.3+1**

#### **تاريخ التحديثات:**
- **v1.0.3** - تحسين الأداء وإصلاح الأخطاء
- **v1.0.2** - إضافة نظام Debug متقدم
- **v1.0.1** - إصدار أولي مستقر

## 🔧 **التطوير**

### **إضافة فئة جديدة:**
```dart
// إضافة فئة مخصصة
await CategoryProvider().addCategory(
  Category(
    name: 'اسم الفئة',
    icon: 'shopping_bag',
    color: Colors.blue.value,
    type: 'expense',
    isCustom: true,
  ),
);
```

### **إضافة معاملة مالية:**
```dart
// إضافة معاملة جديدة
await TransactionProvider().addTransaction(
  Transaction(
    amount: 100.0,
    category: 'طعام',
    type: 'expense',
    description: 'غداء',
    date: DateTime.now(),
  ),
);
```

## 🎨 **تخصيص الواجهة**

### **تغيير الألوان:**
```dart
// في ملف utils/theme.dart
static final lightTheme = ThemeData(
  primarySwatch: Colors.blue, // غير اللون الرئيسي
  // ... باقي الإعدادات
);
```

### **إضافة أيقونات مخصصة:**
1. ضع الأيقونات في: `android/app/src/main/res/mipmap-*dpi/`
2. ضع أيقونات iOS في: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
3. أعد بناء التطبيق

## 📱 **لقطات الشاشة**

*(أضف هنا لقطات شاشة للتطبيق)*

## 🤝 **المساهمة**

نرحب بمساهماتك! لتحسين التطبيق:

1. Fork المشروع
2. أنشئ فرع جديد (`git checkout -b feature/AmazingFeature`)
3. أرسل التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. ادفع الفرع (`git push origin feature/AmazingFeature`)
5. افتح Pull Request

## 📄 **الرخصة**

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## 📞 **الدعم والاتصال**

- 📧 **البريد الإلكتروني:** support@personal-finance-tracker.com
- 🐛 **بلاغ الأخطاء:** [GitHub Issues](https://github.com/your-repo/personal-finance-tracker/issues)
- 📖 **الوثائق:** [Wiki](https://github.com/your-repo/personal-finance-tracker/wiki)

## 🌟 **التقييمات**

إذا أعجبك التطبيق، يرجى تقييمه على متجر التطبيقات:

- [Google Play Store](https://play.google.com/store/apps/details?id=com.example.personal_finance_tracker)
- [App Store](https://apps.apple.com/app/personal-finance-tracker/id123456789)

---

**شكراً لاستخدامك تطبيق Personal Finance Tracker! 💙**
