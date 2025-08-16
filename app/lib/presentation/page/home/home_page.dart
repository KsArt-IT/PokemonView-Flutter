import 'package:flutter/material.dart';
import 'package:pokemon_view/presentation/page/pokemons_like/pokemons_like_page.dart';
import 'package:pokemon_view/presentation/page/pokemons_list/pokemons_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokemons')),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: const PokemonsLikePage(), //
          ),
          Flexible(
            flex: 2,
            child: const PokemonsListPage(), //
          ),
        ],
      ),
    );
  }
}
