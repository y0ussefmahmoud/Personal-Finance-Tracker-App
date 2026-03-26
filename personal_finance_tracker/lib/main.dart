import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'utils/theme.dart';
import 'database/database_helper.dart';
import 'providers/settings_provider.dart';
import 'providers/category_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/zakat_provider.dart';
import 'providers/installment_provider.dart';
import 'providers/tips_provider.dart';
import 'screens/transactions/add_transaction_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/analytics/analytics_screen.dart';
import 'screens/zakat/zakat_screen.dart';
import 'screens/budgets/budgets_screen.dart';
import 'screens/tips/tips_screen.dart';
import 'screens/installments/installments_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/transactions/transaction_list_screen.dart';

void main() async {
  // Enable debug flags
  if (kDebugMode) {
    debugPrint('=== DEBUG MODE ENABLED ===');
    debugPrint('Initializing app with debug logging...');
  }
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      debugPrint('=== FLUTTER ERROR ===');
      debugPrint('Exception: ${details.exception}');
      debugPrint('Stack: ${details.stack}');
      debugPrint('Library: ${details.library}');
      debugPrint('Context: ${details.context}');
    }
  };
  
  try {
    // Initialize database factory for all platforms
    if (kIsWeb) {
      debugPrint('Initializing Web database...');
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      debugPrint('Initializing Mobile database...');
      // Mobile (Android/iOS) - use regular sqflite
    }
    
    debugPrint('Initializing database...');
    final db = DatabaseHelper();
    await db.database;
    debugPrint('Database initialized successfully!');
    
    debugPrint('Loading settings...');
    final settingsProvider = SettingsProvider();
    await settingsProvider.loadSettings();
    debugPrint('Settings loaded successfully');

    debugPrint('Initializing categories...');
    final categoryProvider = CategoryProvider();
    await categoryProvider.seedDefaultCategories();
    debugPrint('Categories initialized successfully');

    debugPrint('Seeding default tips...');
    await TipsProvider.seedDefaultTips();
    debugPrint('Default tips seeded successfully');

    debugPrint('Starting app...');
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: categoryProvider),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => ZakatProvider()),
        ChangeNotifierProvider(create: (_) => InstallmentProvider()),
        ChangeNotifierProvider(create: (_) => TipsProvider()),
      ],
      child: const MyApp(),
    ));
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('=== INITIALIZATION ERROR ===');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
    // Fallback app with error screen
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('=== BUILDING MYAPP ===');
      final stopwatch = Stopwatch()..start();
      
      return Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          stopwatch.stop();
          debugPrint('MyApp build took: ${stopwatch.elapsedMilliseconds}ms');
          
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp(
              title: 'Personal Finance Tracker',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('ar')],
              locale: const Locale('ar'),
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: settings.themeMode,
              routes: {
                '/': (context) => const DashboardScreen(),
                '/add_transaction': (context) => const AddTransactionScreen(),
                '/analytics': (context) => const AnalyticsScreen(),
                '/budgets': (context) => const BudgetsScreen(),
                '/zakat': (context) => const ZakatScreen(),
                '/tips': (context) => const TipsScreen(),
                '/installments': (context) => const InstallmentsScreen(),
                '/settings': (context) => const SettingsScreen(),
                '/categories': (context) => const CategoriesScreen(),
                '/transactions': (context) => const TransactionListScreen(),
              },
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      );
    } else {
      return Consumer<SettingsProvider>(
        builder: (context, settings, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            title: 'Personal Finance Tracker',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            locale: const Locale('ar'),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settings.themeMode,
            routes: {
              '/': (context) => const DashboardScreen(),
              '/add_transaction': (context) => const AddTransactionScreen(),
              '/analytics': (context) => const AnalyticsScreen(),
              '/budgets': (context) => const BudgetsScreen(),
              '/zakat': (context) => const ZakatScreen(),
              '/tips': (context) => const TipsScreen(),
              '/installments': (context) => const InstallmentsScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/categories': (context) => const CategoriesScreen(),
              '/transactions': (context) => const TransactionListScreen(),
            },
            debugShowCheckedModeBanner: false,
          ),
        ),
      );
    }
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[50],
        appBar: AppBar(
          title: const Text('خطأ في التطبيق'),
          backgroundColor: Colors.red[400],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'حدث خطأ أثناء تشغيل التطبيق',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Attempt to restart
                  main();
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
