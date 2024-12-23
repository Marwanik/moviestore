import 'package:dio/dio.dart';
import 'package:moviestore/data/models/moviesModel.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource(this.dio);

  Future<List<MovieModel>> getMovies() async {
    try {
      final response = await dio.get('https://darsoft.b-cdn.net/movies.json');
      if (response.statusCode == 200) {
        final List moviesJson = response.data['movies'];
        return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        throw Exception('DioError: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        throw Exception('DioError: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}