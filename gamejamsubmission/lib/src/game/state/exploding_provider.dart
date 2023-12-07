import 'package:flutter_riverpod/flutter_riverpod.dart';

var explodingFieldsProvider = StateProvider<List<int>>((ref) => []);

var isExploding =
    Provider<bool>((ref) => ref.read(explodingFieldsProvider).isNotEmpty);
