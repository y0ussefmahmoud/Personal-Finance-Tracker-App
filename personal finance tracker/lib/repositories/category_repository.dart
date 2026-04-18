import '../models/category.dart';
import '../database/database_helper.dart';
import '../domain/repositories/category_repository_interface.dart';
import '../domain/entities/category_entity.dart';

/// Repository for managing category data
///
/// This class acts as an abstraction layer between the data source (DatabaseHelper)
/// and the business logic (CategoryProvider), following the Repository Pattern.
/// It implements the CategoryRepositoryInterface from the domain layer.
class CategoryRepository implements CategoryRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  CategoryRepository(this._databaseHelper);

  /// Get all categories from the database
  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await _databaseHelper.getCategories();
    return categories.map((c) => _toEntity(c)).toList();
  }

  /// Add a new category to the database
  @override
  Future<int> addCategory(CategoryEntity entity) async {
    final category = _toModel(entity);
    return await _databaseHelper.insertCategory(category);
  }

  /// Update an existing category
  @override
  Future<void> updateCategory(CategoryEntity entity) async {
    final category = _toModel(entity);
    await _databaseHelper.updateCategory(category);
  }

  /// Delete a category by ID
  @override
  Future<void> deleteCategory(int id) async {
    await _databaseHelper.deleteCategory(id);
  }

  /// Get categories by type (income/expense/both)
  @override
  Future<List<CategoryEntity>> getCategoriesByType(String type) async {
    final categories = await _databaseHelper.getCategories();
    return categories
        .where((c) => c.type == type || c.type == 'both')
        .map((c) => _toEntity(c))
        .toList();
  }

  /// Convert Category model to CategoryEntity
  CategoryEntity _toEntity(Category model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      color: model.color,
      icon: model.icon,
      type: model.type,
      isCustom: model.isCustom,
    );
  }

  /// Convert CategoryEntity to Category model
  Category _toModel(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      icon: entity.icon,
      type: entity.type,
      isCustom: entity.isCustom,
    );
  }

  /// Get all categories from the database (legacy method for backward compatibility)
  Future<List<Category>> getAllCategories() async {
    return await _databaseHelper.getCategories();
  }

  /// Get categories by type (legacy method for backward compatibility)
  Future<List<Category>> getCategoriesByTypeLegacy(String type) async {
    final categories = await _databaseHelper.getCategories();
    return categories.where((c) => c.type == type || c.type == 'both').toList();
  }

  /// Legacy method for backward compatibility - accepts Category model
  Future<int> addCategoryLegacy(Category category) async {
    return await _databaseHelper.insertCategory(category);
  }

  /// Legacy method for backward compatibility - accepts Category model
  Future<void> updateCategoryLegacy(Category category) async {
    await _databaseHelper.updateCategory(category);
  }
}
