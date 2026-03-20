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

  Future<void> seedDefaultCategories() async {
    final db = DatabaseHelper();
    final seeded = await db.getSetting('categories_seeded');
    if (seeded != 'true') {
      final defaultCategories = [
        Category(name: 'طعام', icon: 'restaurant', color: 0xFF4CAF50, type: 'both', isCustom: false),
        Category(name: 'تسوق', icon: 'shopping_bag', color: 0xFF2196F3, type: 'expense', isCustom: false),
        Category(name: 'صحة', icon: 'health_and_safety', color: 0xFFE91E63, type: 'expense', isCustom: false),
        Category(name: 'فواتير', icon: 'receipt_long', color: 0xFFFF9800, type: 'expense', isCustom: false),
        Category(name: 'مواصلات', icon: 'directions_car', color: 0xFF9C27B0, type: 'expense', isCustom: false),
        Category(name: 'ترفيه', icon: 'theater_comedy', color: 0xFFFF5722, type: 'expense', isCustom: false),
        Category(name: 'زكاة', icon: 'volunteer_activism', color: 0xFF009688, type: 'expense', isCustom: false),
        Category(name: 'راتب', icon: 'payments', color: 0xFF8BC34A, type: 'income', isCustom: false),
      ];
      for (final cat in defaultCategories) {
        await db.insertCategory(cat);
      }
      await db.setSetting('categories_seeded', 'true');
      await fetchCategories();
    }
  }
}
