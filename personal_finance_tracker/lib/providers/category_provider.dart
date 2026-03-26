import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  bool isLoading = false;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    categories = await db.getCategories();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    final db = DatabaseHelper();
    await db.insertCategory(category);
    await fetchCategories();
  }

  Future<void> updateCategory(Category category) async {
    final db = DatabaseHelper();
    await db.updateCategory(category);
    await fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    final db = DatabaseHelper();
    await db.deleteCategory(id);
    await fetchCategories();
  }

  /// Reset categories seeding - useful for testing and updates
  Future<void> resetCategoriesSeeding() async {
    final db = DatabaseHelper();
    await db.setSetting('categories_seeded', 'false');
    debugPrint('Categories seeding reset - will reseed on next init');
  }

  /// Force reseed all categories
  Future<void> forceReseedCategories() async {
    final db = DatabaseHelper();
    // Delete all existing categories
    final categories = await db.getCategories();
    for (final cat in categories) {
      await db.deleteCategory(cat.id!);
    }
    // Reset seeding flag
    await db.setSetting('categories_seeded', 'false');
    // Reseed
    await seedDefaultCategories();
    debugPrint('Categories force reseeded!');
  }

  Future<void> seedDefaultCategories() async {
    final db = DatabaseHelper();
    final seeded = await db.getSetting('categories_seeded');
    
    debugPrint('=== CATEGORIES SEEDING ===');
    debugPrint('Seeded status: $seeded');
    
    // Always check if we need to add new categories
    final existingCategories = await db.getCategories();
    final existingNames = existingCategories.map((c) => c.name).toSet();
    
    debugPrint('Existing categories: ${existingNames.toList()}');
    
    if (seeded != 'true') {
      debugPrint('Seeding default categories...');
      final defaultCategories = [
        // Income Categories
        Category(name: 'راتب', icon: 'payments', color: 0xFF8BC34A, type: 'income', isCustom: false),
        Category(name: 'عمل حر', icon: 'laptop', color: 0xFF2196F3, type: 'income', isCustom: false),
        Category(name: 'هدايا', icon: 'card_giftcard', color: 0xFFE91E63, type: 'both', isCustom: false),
        Category(name: 'استثمار', icon: 'trending_up', color: 0xFF9C27B0, type: 'income', isCustom: false),
        
        // Expense Categories
        Category(name: 'طعام', icon: 'restaurant', color: 0xFF4CAF50, type: 'expense', isCustom: false),
        Category(name: 'تسوق', icon: 'shopping_bag', color: 0xFF2196F3, type: 'expense', isCustom: false),
        Category(name: 'صحة', icon: 'health_and_safety', color: 0xFFE91E63, type: 'expense', isCustom: false),
        Category(name: 'فواتير', icon: 'receipt_long', color: 0xFFFF9800, type: 'expense', isCustom: false),
        Category(name: 'مواصلات', icon: 'directions_car', color: 0xFF9C27B0, type: 'expense', isCustom: false),
        Category(name: 'ترفيه', icon: 'theater_comedy', color: 0xFFFF5722, type: 'expense', isCustom: false),
        Category(name: 'زكاة', icon: 'volunteer_activism', color: 0xFF009688, type: 'expense', isCustom: false),
        Category(name: 'تعليم', icon: 'school', color: 0xFF795548, type: 'expense', isCustom: false),
        Category(name: 'ملابس', icon: 'checkroom', color: 0xFF607D8B, type: 'expense', isCustom: false),
        Category(name: 'السيارة', icon: 'directions_car', color: 0xFF9C27B0, type: 'expense', isCustom: false),
      ];
      
      debugPrint('Inserting ${defaultCategories.length} categories...');
      for (final cat in defaultCategories) {
        await db.insertCategory(cat);
        debugPrint('Inserted category: ${cat.name} (${cat.type})');
      }
      
      await db.setSetting('categories_seeded', 'true');
      debugPrint('Categories seeding completed!');
      await fetchCategories();
    } else {
      debugPrint('Categories already seeded, checking for missing categories...');
      
      // Check for missing categories and add them
      final missingCategories = [
        if (!existingNames.contains('عمل حر')) 
          Category(name: 'عمل حر', icon: 'laptop', color: 0xFF2196F3, type: 'income', isCustom: false),
        if (!existingNames.contains('هدايا')) 
          Category(name: 'هدايا', icon: 'card_giftcard', color: 0xFFE91E63, type: 'both', isCustom: false),
        if (!existingNames.contains('استثمار')) 
          Category(name: 'استثمار', icon: 'trending_up', color: 0xFF9C27B0, type: 'income', isCustom: false),
        if (!existingNames.contains('السيارة')) 
          Category(name: 'السيارة', icon: 'directions_car', color: 0xFF9C27B0, type: 'expense', isCustom: false),
      ];
      
      if (missingCategories.isNotEmpty) {
        debugPrint('Adding ${missingCategories.length} missing categories...');
        for (final cat in missingCategories) {
          await db.insertCategory(cat);
          debugPrint('Added missing category: ${cat.name} (${cat.type})');
        }
        await fetchCategories();
      } else {
        debugPrint('All categories are already present!');
      }
    }
  }
}
