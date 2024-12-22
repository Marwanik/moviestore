import 'package:moviestore/domain/entities/category.dart';
import 'package:moviestore/domain/repositories/categoryRepo.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}
