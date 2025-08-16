import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_view/data/provider/network_manager.dart';
import 'package:pokemon_view/data/repository/pokemon_repository_impl.dart';
import 'package:pokemon_view/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_repository_provider.g.dart';

@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  return PokemonRepositoryImpl(dio: ref.read(networkManagerProvider));
}
