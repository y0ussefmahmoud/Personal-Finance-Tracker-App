/// Get Categories Use Case
library;

import '../entities/category_entity.dart';
import '../repositories/category_repository_interface.dart';

class GetCategoriesUseCase {
  final CategoryRepositoryInterface _categoryRepository;

  GetCategoriesUseCase(this._categoryRepository);

  Future<List<CategoryEntity>> call() async {
    return await _categoryRepository.getCategories();
  }
}
