import 'package:pokemon_view/data/models/pokemon_item.dart';
import 'package:pokemon_view/data/provider/pokemon_repository_provider.dart';
import 'package:pokemon_view/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_list_notifier.g.dart';

@riverpod
class PokemonListNotifier extends _$PokemonListNotifier {
  late final PokemonRepository _pokemonRepository;

  static const _limit = 20;

  var _offset = 0;
  var _isLoadingMore = false;
  var _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  Future<List<PokemonItem>> build() async {
    _pokemonRepository = ref.watch(pokemonRepositoryProvider);
    return _loadPage(reset: true);
  }

  Future<void> refresh() async {
    while (_isLoadingMore) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    _isLoadingMore = true;
    state = await AsyncValue.guard(() async => await _loadPage(reset: true));
    _isLoadingMore = false;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    state = await AsyncValue.guard(() async => await _loadPage());
    _isLoadingMore = false;
  }

  Future<List<PokemonItem>> _loadPage({bool reset = false}) async {
    if (reset) {
      _offset = 0;
      _hasMore = true;
    }

    if (!_hasMore) return state.valueOrNull ?? [];

    final result = await _pokemonRepository.fetchPokemons(limit: _limit, offset: _offset);

    return result.map(
      onSuccess: (data, more) {
        _offset += _limit;
        _hasMore = more;

        final current = reset ? <PokemonItem>[] : (state.valueOrNull ?? []);
        return [...current, ...data];
      },
      onFailure: (error) => throw error,
    );
  }
}
