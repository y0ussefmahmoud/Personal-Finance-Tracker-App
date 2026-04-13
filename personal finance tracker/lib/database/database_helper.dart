import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction.dart' as transaction;
import '../models/budget.dart';
import '../models/category.dart' as models;
import '../models/zakat.dart';
import '../models/installment.dart';
import '../models/tip.dart';

/// Database Helper - Manages SQLite database operations
/// 
/// This class provides:
/// - Singleton pattern for database access
/// - CRUD operations for all entities
/// - Database initialization and migration
/// - Settings management
/// - Data reset functionality
/// 
/// Tables:
/// - transactions: Financial transactions
/// - budgets: Budget limits and tracking
/// - categories: Transaction categories
/// - zakat: Zakat records
/// - installments: Installment and debt tracking
/// - tips: Financial tips
/// - user_settings: Application settings

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  // Database configuration
  static const String _databaseName = 'personal_finance.db';
  static const int _databaseVersion = 2;

  // Private constructor for singleton
  DatabaseHelper._internal();

  /// Factory constructor returns singleton instance
  factory DatabaseHelper() => _instance;

  /// Gets database instance, initializes if needed
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes database with all tables
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old tables and recreate
      await db.execute('DROP TABLE IF EXISTS transactions');
      await db.execute('DROP TABLE IF EXISTS categories');
      await db.execute('DROP TABLE IF EXISTS budgets');
      await db.execute('DROP TABLE IF EXISTS zakat');
      await db.execute('DROP TABLE IF EXISTS installments');
      await db.execute('DROP TABLE IF EXISTS tips');
      // Settings table remains unchanged
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        date INTEGER NOT NULL,
        paymentMethod TEXT NOT NULL,
        isRecurring INTEGER NOT NULL,
        recurringType TEXT,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon TEXT NOT NULL,
        type TEXT NOT NULL,
        isCustom INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        spent REAL NOT NULL,
        startDate INTEGER NOT NULL,
        endDate INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE zakat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goldValue REAL NOT NULL,
        silverValue REAL NOT NULL,
        cash REAL NOT NULL,
        investments REAL NOT NULL,
        totalZakat REAL NOT NULL,
        date INTEGER NOT NULL,
        paid INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE installments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        paidAmount REAL NOT NULL,
        remainingAmount REAL NOT NULL,
        dueDate INTEGER NOT NULL,
        nextPayment REAL NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        isRead INTEGER NOT NULL,
        date INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT NOT NULL
      )
    ''');
  }

  // Helper methods for CRUD operations
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> insert(String table, Map<String, dynamic> values, {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort}) async {
    final db = await database;
    return await db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
  }

  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Transaction CRUD
  Future<List<transaction.Transaction>> getTransactions() async => (await query('transactions')).map(transaction.Transaction.fromMap).toList();

  Future<int> insertTransaction(transaction.Transaction t) => insert('transactions', t.toMap());

  Future<void> updateTransaction(transaction.Transaction t) => update('transactions', t.toMap(), where: 'id=?', whereArgs: [t.id]);

  Future<void> deleteTransaction(int id) => delete('transactions', where: 'id=?', whereArgs: [id]);

  // Budget CRUD
  Future<List<Budget>> getBudgets() async => (await query('budgets')).map(Budget.fromMap).toList();

  Future<int> insertBudget(Budget b) => insert('budgets', b.toMap());

  Future<void> updateBudget(Budget b) => update('budgets', b.toMap(), where: 'id=?', whereArgs: [b.id]);

  Future<void> deleteBudget(int id) => delete('budgets', where: 'id=?', whereArgs: [id]);

  // Category CRUD
  Future<List<models.Category>> getCategories() async => (await query('categories')).map(models.Category.fromMap).toList();

  Future<int> insertCategory(models.Category c) => insert('categories', c.toMap());

  Future<void> updateCategory(models.Category c) => update('categories', c.toMap(), where: 'id=?', whereArgs: [c.id]);

  Future<void> deleteCategory(int id) => delete('categories', where: 'id=?', whereArgs: [id]);

  // Zakat CRUD
  Future<List<Zakat>> getZakatRecords() async => (await query('zakat')).map(Zakat.fromMap).toList();

  Future<int> insertZakat(Zakat z) => insert('zakat', z.toMap());

  Future<void> updateZakat(Zakat z) => update('zakat', z.toMap(), where: 'id=?', whereArgs: [z.id]);

  Future<void> deleteZakat(int id) => delete('zakat', where: 'id=?', whereArgs: [id]);

  // Installment CRUD
  Future<List<Installment>> getInstallments() async => (await query('installments')).map(Installment.fromMap).toList();

  Future<int> insertInstallment(Installment i) async {
    debugPrint('DatabaseHelper.insertInstallment called: ${i.name}');
    final result = await insert('installments', i.toMap());
    debugPrint('DatabaseHelper.insertInstallment completed, id: $result');
    return result;
  }

  Future<void> updateInstallment(Installment i) => update('installments', i.toMap(), where: 'id=?', whereArgs: [i.id]);

  Future<void> deleteInstallment(int id) => delete('installments', where: 'id=?', whereArgs: [id]);

  // Tip CRUD
  Future<List<Tip>> getTips() async => (await query('tips')).map(Tip.fromMap).toList();

  Future<int> insertTip(Tip t) => insert('tips', t.toMap());

  Future<void> updateTip(Tip t) => update('tips', t.toMap(), where: 'id=?', whereArgs: [t.id]);

  Future<void> deleteTip(int id) => delete('tips', where: 'id=?', whereArgs: [id]);

  // Settings
  Future<String?> getSetting(String key) async {
    final rows = await query('settings', where: 'key=?', whereArgs: [key]);
    return rows.isNotEmpty ? rows.first['value'] as String? : null;
  }

  Future<void> setSetting(String key, String value) async {
    await insert('settings', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('transactions');
    await db.delete('budgets');
    await db.delete('categories');
    await db.delete('zakat');
    await db.delete('installments');
    await db.delete('tips');
    await db.delete('settings');
    
    debugPrint('Database reset completed');
  }
}
