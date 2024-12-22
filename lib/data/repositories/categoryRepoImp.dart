import 'package:moviestore/data/data_sources/categoryRemoteData.dart';
import 'package:moviestore/data/models/categoriesModel.dart';
import 'package:moviestore/domain/entities/category.dart';
import 'package:moviestore/domain/repositories/categoryRepo.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    final List<CategoryModel> categoryModels = await remoteDataSource.getCategories();
    return categoryModels.map((model) => Category(id: model.id, title: model.title)).toList();
  }
}
