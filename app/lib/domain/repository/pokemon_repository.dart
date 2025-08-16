import 'package:pokemon_view/data/models/pokemon_item.dart';
import 'package:pokemon_view/domain/entity/result.dart';

abstract interface class PokemonRepository {
  Future<Result<List<PokemonItem>>> fetchPokemons({int limit = 20, int offset = 0});
}
