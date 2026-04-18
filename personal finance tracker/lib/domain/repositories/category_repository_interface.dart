/// Category Repository Interface
/// 
/// This interface defines the contract for category data operations.
library;

import '../entities/category_entity.dart';

abstract class CategoryRepositoryInterface {
  Future<List<CategoryEntity>> getCategories();
  Future<int> addCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(int id);
  Future<List<CategoryEntity>> getCategoriesByType(String type);
}
