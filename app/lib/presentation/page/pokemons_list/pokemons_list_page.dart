import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_view/presentation/page/pokemons_list/provider/pokemon_list_notifier.dart';

class PokemonsListPage extends ConsumerStatefulWidget {
  const PokemonsListPage({super.key});

  @override
  ConsumerState<PokemonsListPage> createState() => _PokemonsListPageState();
}

class _PokemonsListPageState extends ConsumerState<PokemonsListPage> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // debounce на 300мс
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        ref.read(pokemonListNotifierProvider.notifier).loadMore();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonAsync = ref.watch(pokemonListNotifierProvider);
    final hasMore = ref.watch(pokemonListNotifierProvider.notifier.select((state) => state.hasMore));

    return pokemonAsync.when(
      data: (pokemons) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(pokemonListNotifierProvider.notifier).refresh();
          },   
          child: ListView.builder(
            controller: _scrollController,
            itemCount: pokemons.length + (hasMore ? 1 : 0), // +1 для индикатора загрузки
            itemBuilder: (context, index) {
              if (index == pokemons.length) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: hasMore
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink(),
                );
              }
              final pokemon = pokemons[index];
              return ListTile(
                title: Text(pokemon.name),
                subtitle: Text(pokemon.url),
                key: ValueKey(pokemon),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
