# 🏦 Personal Finance Tracker

تطبيق متقدم لإدارة الشؤون المالية الشخصية مصمم لمساعدتك على تتبع دخلك، مصروفاتك، والميزانية بفعالية.

## 📱 **المميزات الرئيسية**

### 💰 **إدارة المعاملات المالية**
- ✅ إضافة وتعديل وحذف المعاملات المالية
- 📊 تصنيف المعاملات (دخل/مصروفات)
- 🏷️ فئات مخصصة للمصروفات والدخل
- 🔍 البحث والتصفية في المعاملات
- 🎯 أقسام جديدة: "عمل حر"، "استثمار"، "هدايا"، "السيارة"

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

### � **إدارة أماكن المال**
- 🏦 تقسيم المال بين أماكن مختلفة (كاش، بنك، محفظة إلكترونية)
- 📊 حساب الرصيد المتوقع من المعاملات (الدخل - المصروفات)
- ✏️ تعديل الرصيد الفعلي يدوياً
- ⚠️ عرض العجز/الفائض بين الرصيد المتوقع والفعلي
- 🔗 ربط المعاملات بأماكن المال

### � **حساب الزكاة**
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
- **جديد:** دعم أفضل للمنصات المختلفة (Windows, Web, Mobile)

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
│   ├── budget.dart
│   └── money_location.dart
├── providers/                # إدارة الحالة (State Management)
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── settings_provider.dart
│   └── money_location_provider.dart
├── screens/                  # الشاشات الرئيسية
│   ├── home/
│   ├── transactions/
│   ├── analytics/
│   ├── settings/
│   └── money_locations/
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

### **الإصدار الحالي: v1.3.0**

#### **تاريخ التحديثات:**
- **v1.3.0** - 🎉 ميزة جديدة: إدارة أماكن المال
  - ✅ إضافة ميزة تقسيم المال بين أماكن مختلفة (كاش، بنك، محفظة إلكترونية)
  - ✅ حساب الرصيد المتوقع تلقائياً من المعاملات (الدخل - المصروفات)
  - ✅ إمكانية تعديل الرصيد الفعلي يدوياً
  - ✅ عرض العجز/الفائض بين الرصيد المتوقع والفعلي
  - ✅ ربط المعاملات بأماكن المال
  - ✅ تحديث قاعدة البيانات (version 5)
- **v1.2.6** - 🎉 ميزات جديدة وتحسينات
  - ✅ إضافة ميزة تعديل المعاملات
  - ✅ إضافة تأكيد قبل حذف المعاملة
  - ✅ تحسين تجربة المستخدم في إدارة المعاملات
- **v1.2.5** - 🎉 تحسينات كبيرة في جودة الكود والصيانة
  - ✅ إكمال TODO في transaction_provider.dart (error handling)
  - ✅ تقسيم installments_screen.dart من 512 سطر إلى 172 سطر
  - ✅ إنشاء ملفات منفصلة للمكونات (4 ملفات جديدة)
  - ✅ إصلاح lint warnings (use_key_in_widget_constructors)
  - ✅ إزالة debug prints من installment_provider.dart و database_helper.dart
  - ✅ تحسين جودة الكود والتوثيق
  - ✅ تحسين قابلية الصيانة والتطوير
  - ✅ تحسين Clean Code principles
- **v1.2.4** - 🐛 إصلاحات مهمة وتحسينات
  - ✅ إصلاح مشكلة إضافة القسط/الدين (تحسين التحقق من المدخلات)
  - ✅ إزالة FloatingActionButton من شاشة الأقساط والاعتماد على IconButton فقط
  - ✅ إصلاح جميع setState during build errors في الشاشات
  - ✅ تحسين جودة الكود وإزالة debug prints
  - ✅ تحسين ربط BudgetProvider بـ TransactionProvider
  - ✅ تحسين تقييم جودة الكود والتوثيق
- **v1.2.3** - 🎉 تحسينات كبيرة وإصلاحات مهمة
  - ✅ إضافة نسب مئوية للتصنيفات (مصروفات ودخل)
  - ✅ إصلاح مشكلة setState during build في شاشة الميزانية
  - ✅ إصلاح مشكلة setState during build في شاشة الأقساط
  - ✅ إصلاح مشكلة إضافة القسط/الدين
  - ✅ تحسين ربط BudgetProvider بـ TransactionProvider
  - ✅ إصلاح مشكلة تهيئة قاعدة البيانات على Android
  - ✅ إصلاح جميع lint warnings (avoid_print, unnecessary_import, use_build_context_synchronously, library_private_types_in_public_api)
  - ✅ تحسين ترتيب المعاملات (الأحدث في الأعلى)
  - ✅ تحسين جودة الكود والتوثيق
- **v1.2.2** - 🐛 إصلاحات وتحسينات
  - ✅ إصلاح مشاكل الميزانية
  - ✅ تحسين ربط الـ providers
- **v1.2.1** - 🎉 إضافة أقسام جديدة وحل مشاكل الـ Overflow
  - ✅ إضافة قسم "عمل حر" للدخل
  - ✅ إضافة قسم "استثمار" للدخل
  - ✅ إضافة قسم "هدايا" (للدخل والمصروف)
  - ✅ إضافة قسم "السيارة" للمصروفات
  - ✅ إصلاح مشاكل RenderFlex Overflow في القوائم
  - ✅ تحسين واجهة التصنيفات مع Scroll
  - ✅ دعم أفضل للمنصات المختلفة
- **v1.2.0** - 🔄 تحسينات الأداء والتصنيفات
- **v1.1.7** - 🐛 إصلاح أخطاء وتحسينات عامة
- **v1.1.6** - 📱 تحسين واجهة المستخدم
- **v1.1.5** - 🎨 تحسينات التصميم
- **v1.1.4** - 📊 تحسينات التحليلات
- **v1.1.3** - 💳 تحسينات الأقساط
- **v1.1.2** - 🕌 تحسينات الزكاة
- **v1.1.1** - 🎯 تحسينات الميزانية
- **v1.1.0** - 📱 إصدار مستقر مع ميزات جديدة
- **v1.0.3** - 🐛 إصلاح الأخطاء الأولية
- **v1.0.2** - 🔧 إضافة نظام Debug متقدم
- **v1.0.1** - 🚀 إصدار أولي مستقر

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

### **إضافة أقسام جديدة (مثل v1.2.1):**
```dart
// إضافة قسم "عمل حر" للدخل
await CategoryProvider().addCategory(
  Category(
    name: 'عمل حر',
    icon: 'laptop',
    color: 0xFF2196F3,
    type: 'income',
    isCustom: false,
  ),
);

// إضافة قسم "هدايا" للدخل والمصروف
await CategoryProvider().addCategory(
  Category(
    name: 'هدايا',
    icon: 'card_giftcard',
    color: 0xFFE91E63,
    type: 'both', // يعمل للدخل والمصروف
    isCustom: false,
  ),
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
