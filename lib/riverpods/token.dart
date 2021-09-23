import 'package:hikee/models/token.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tokenProvider = StateNotifierProvider<TokenNotifier, Token?>((ref) {
  return TokenNotifier();
});

class TokenNotifier extends StateNotifier<Token?> {
  TokenNotifier() : super(null);
  
}
