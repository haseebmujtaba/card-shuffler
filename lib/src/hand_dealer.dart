import 'card_deck.dart';
import 'playing_card.dart';

/// The result of dealing hands from a [CardDeck].
class DealResult {
  /// Each player's hand as a list of cards.
  final List<List<PlayingCard>> hands;

  /// Cards left in the deck after dealing.
  final List<PlayingCard> remainingCards;

  const DealResult({required this.hands, required this.remainingCards});

  /// Number of players who received a hand.
  int get playerCount => hands.length;

  @override
  String toString() {
    final sb = StringBuffer('DealResult(\n');
    for (int i = 0; i < hands.length; i++) {
      sb.writeln('  Player ${i + 1}: ${hands[i].join(', ')}');
    }
    sb.writeln('  Remaining: ${remainingCards.length} cards');
    sb.write(')');
    return sb.toString();
  }
}

/// Utility for dealing multiple hands from a [CardDeck].
class HandDealer {
  HandDealer._();

  /// Deals [cardsPerHand] cards to [playerCount] players from [deck].
  ///
  /// Cards are dealt one at a time in round-robin fashion (like real dealing).
  ///
  /// Throws [StateError] if the deck doesn't have enough cards.
  static DealResult deal({
    required CardDeck deck,
    required int playerCount,
    required int cardsPerHand,
  }) {
    final needed = playerCount * cardsPerHand;
    if (deck.remaining < needed) {
      throw StateError(
          'Need $needed cards but only ${deck.remaining} remain in deck.');
    }

    final hands = List.generate(playerCount, (_) => <PlayingCard>[]);

    for (int round = 0; round < cardsPerHand; round++) {
      for (int player = 0; player < playerCount; player++) {
        hands[player].add(deck.dealOne()!);
      }
    }

    return DealResult(
      hands: hands,
      remainingCards: List.from(deck.cards),
    );
  }
}
