import 'package:dio/dio.dart';
import 'package:pokemon_view/data/models/pokemon_item.dart';
import 'package:pokemon_view/data/models/pokemon_list_response.dart';
import 'package:pokemon_view/domain/entity/result.dart';
import 'package:pokemon_view/domain/repository/pokemon_repository.dart';

final class PokemonRepositoryImpl implements PokemonRepository {
  final Dio _dio;

  const PokemonRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Result<List<PokemonItem>>> fetchPokemons({int limit = 20, int offset = 0}) async {
    try {
      // https://pokeapi.co/api/v2/ability/?limit=20&offset=40
      final response = await _dio.get(
        '/ability',
        queryParameters: {
          'offset': offset,
          'limit': limit,
          //
        },
      );

      if (response.statusCode != 200) {
        return Result.failure(Exception('Failed to load Pokemons'));
      }
      final data = PokemonListResponse.fromJson(response.data);
      return Result.success(data.results, data.next?.isNotEmpty == true);
    } on DioException catch (e) {
      return Result.failure(Exception(e.response?.data['message'] ?? 'Failed to load Pokemons'));
    } catch (e) {
      return Result.failure(Exception(e));
    }
  }
}
