import 'package:dio/dio.dart';
import 'package:moviestore/data/models/categoriesModel.dart';

class CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSource(this.dio);

  Future<List<categoryModel>> getCategories() async {
    try {
      final response = await dio.get('https://darsoft.b-cdn.net/movies_categories.json');
      if (response.statusCode == 200) {
        final List categoriesJson = response.data['categories'];
        return categoriesJson.map((json) => categoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        // Server responded but with an error code
        throw Exception('DioError: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        // Something happened in setting up or sending the request
        throw Exception('DioError: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
