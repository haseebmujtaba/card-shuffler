import 'dart:math';

/// Defines the algorithm used to shuffle a deck of cards.
enum ShuffleAlgorithm {
  /// Fisher-Yates (Knuth) shuffle — uniform random distribution.
  fisherYates,

  /// Riffle shuffle — simulates a real-world bridge/riffle shuffle.
  riffle,

  /// Overhand shuffle — simulates an overhand (cut-and-stack) shuffle.
  overhand,
}

/// Provides static shuffle methods for a list of items.
class CardShuffler {
  CardShuffler._();

  /// Shuffles [deck] in place using the given [algorithm].
  ///
  /// Optionally supply a [random] instance for deterministic testing.
  ///
  /// Example:
  /// ```dart
  /// final deck = CardDeck.standard();
  /// CardShuffler.shuffle(deck.cards, algorithm: ShuffleAlgorithm.fisherYates);
  /// ```
  static void shuffle<T>(
    List<T> deck, {
    ShuffleAlgorithm algorithm = ShuffleAlgorithm.fisherYates,
    Random? random,
  }) {
    final rng = random ?? Random();
    switch (algorithm) {
      case ShuffleAlgorithm.fisherYates:
        _fisherYates(deck, rng);
      case ShuffleAlgorithm.riffle:
        _riffle(deck, rng);
      case ShuffleAlgorithm.overhand:
        _overhand(deck, rng);
    }
  }

  /// Fisher-Yates (Knuth) shuffle — O(n), perfectly uniform.
  static void _fisherYates<T>(List<T> deck, Random rng) {
    for (int i = deck.length - 1; i > 0; i--) {
      final j = rng.nextInt(i + 1);
      final tmp = deck[i];
      deck[i] = deck[j];
      deck[j] = tmp;
    }
  }

  /// Riffle shuffle: split deck roughly in half, then interleave packets.
  static void _riffle<T>(List<T> deck, Random rng) {
    if (deck.length < 2) return;
    final mid = deck.length ~/ 2 + rng.nextInt(3) - 1;
    final left = deck.sublist(0, mid.clamp(1, deck.length - 1));
    final right = deck.sublist(mid.clamp(1, deck.length - 1));

    int l = 0, r = 0, i = 0;
    while (l < left.length && r < right.length) {
      if (rng.nextBool()) {
        deck[i++] = left[l++];
      } else {
        deck[i++] = right[r++];
      }
    }
    while (l < left.length) deck[i++] = left[l++];
    while (r < right.length) deck[i++] = right[r++];
  }

  /// Overhand shuffle: repeatedly cut small packets from top to bottom.
  static void _overhand<T>(List<T> deck, Random rng) {
    if (deck.length < 2) return;
    final result = <T>[];
    final remaining = List<T>.from(deck);

    while (remaining.isNotEmpty) {
      // Cut a small packet of 1–8 cards from the top
      final packetSize = (rng.nextInt(8) + 1).clamp(1, remaining.length);
      final packet = remaining.sublist(0, packetSize);
      remaining.removeRange(0, packetSize);
      result.insertAll(0, packet);
    }

    for (int i = 0; i < deck.length; i++) {
      deck[i] = result[i];
    }
  }
}
