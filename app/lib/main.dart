import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_view/app/app.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}
