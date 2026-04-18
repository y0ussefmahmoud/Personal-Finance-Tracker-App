import '../models/category.dart';
import '../database/database_helper.dart';

/// Repository for managing category data
///
/// This class acts as an abstraction layer between the data source (DatabaseHelper)
/// and the business logic (CategoryProvider), following the Repository Pattern.
class CategoryRepository {
  final DatabaseHelper _databaseHelper;

  CategoryRepository(this._databaseHelper);

  /// Get all categories from the database
  Future<List<Category>> getAllCategories() async {
    return await _databaseHelper.getCategories();
  }

  /// Get categories by type (income/expense/both)
  Future<List<Category>> getCategoriesByType(String type) async {
    final categories = await _databaseHelper.getCategories();
    return categories.where((c) => c.type == type || c.type == 'both').toList();
  }

  /// Add a new category to the database
  Future<int> addCategory(Category category) async {
    return await _databaseHelper.insertCategory(category);
  }

  /// Update an existing category
  Future<void> updateCategory(Category category) async {
    await _databaseHelper.updateCategory(category);
  }

  /// Delete a category by ID
  Future<void> deleteCategory(int id) async {
    await _databaseHelper.deleteCategory(id);
  }
}
