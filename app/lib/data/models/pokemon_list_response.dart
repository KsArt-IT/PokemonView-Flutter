import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_view/data/models/pokemon_item.dart';

part 'pokemon_list_response.freezed.dart';
part 'pokemon_list_response.g.dart';

@freezed
class PokemonListResponse with _$PokemonListResponse {
  const factory PokemonListResponse({
    required int count,
    required String? previous,
    required String? next,
    required List<PokemonItem> results,
  }) = _PokemonListResponse;

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);
}
