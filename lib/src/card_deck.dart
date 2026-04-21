import 'dart:math';

import 'card_shuffler_2.dart';
import 'playing_card.dart';

/// A deck of [PlayingCard]s with shuffle, deal, cut, and reset capabilities.
///
/// Example:
/// ```dart
/// final deck = CardDeck.standard();
/// deck.shuffle();
/// final hand = deck.deal(5);
/// print(hand); // [K♠, 7♥, A♦, 3♣, J♠]
/// ```
class CardDeck {
  final List<PlayingCard> _cards;
  final List<PlayingCard> _originalOrder;

  CardDeck._(List<PlayingCard> cards)
      : _cards = cards,
        _originalOrder = List.unmodifiable(cards);

  /// Creates a standard 52-card deck ordered by suit then rank.
  factory CardDeck.standard() {
    final cards = <PlayingCard>[];
    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        cards.add(PlayingCard(rank: rank, suit: suit));
      }
    }
    return CardDeck._(cards);
  }

  /// Creates a deck from a custom list of [PlayingCard]s.
  factory CardDeck.custom(List<PlayingCard> cards) {
    return CardDeck._(List<PlayingCard>.from(cards));
  }

  /// The cards currently in the deck (top = index 0).
  List<PlayingCard> get cards => List.unmodifiable(_cards);

  /// How many cards remain in the deck.
  int get remaining => _cards.length;

  /// Whether the deck is empty.
  bool get isEmpty => _cards.isEmpty;

  /// Shuffles the deck using the specified [algorithm].
  ///
  /// Optionally supply a [random] instance for deterministic results.
  void shuffle({
    ShuffleAlgorithm algorithm = ShuffleAlgorithm.fisherYates,
    Random? random,
  }) {
    CardShuffler.shuffle(_cards, algorithm: algorithm, random: random);
  }

  /// Deals [count] cards from the top of the deck.
  ///
  /// Throws [StateError] if there are fewer than [count] cards remaining.
  List<PlayingCard> deal(int count) {
    if (count > _cards.length) {
      throw StateError(
          'Cannot deal $count cards: only $_cards.length remaining.');
    }
    final hand = _cards.sublist(0, count);
    _cards.removeRange(0, count);
    return hand;
  }

  /// Deals one card from the top. Returns `null` if the deck is empty.
  PlayingCard? dealOne() {
    if (_cards.isEmpty) return null;
    return _cards.removeAt(0);
  }

  /// Cuts the deck at [position] (default: middle).
  ///
  /// The bottom portion is moved to the top.
  void cut([int? position]) {
    final pos = (position ?? _cards.length ~/ 2).clamp(0, _cards.length);
    final top = _cards.sublist(0, pos);
    final bottom = _cards.sublist(pos);
    _cards
      ..clear()
      ..addAll(bottom)
      ..addAll(top);
  }

  /// Returns all dealt cards back to the deck and resets to the original order.
  void reset() {
    _cards
      ..clear()
      ..addAll(_originalOrder);
  }

  /// Peeks at the top card without removing it. Returns `null` if empty.
  PlayingCard? peek() => _cards.isEmpty ? null : _cards.first;

  @override
  String toString() => 'CardDeck(remaining: $remaining)';
}
