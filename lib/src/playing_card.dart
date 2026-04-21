/// Represents a suit of a playing card.
enum Suit {
  hearts('♥', 'Hearts'),
  diamonds('♦', 'Diamonds'),
  clubs('♣', 'Clubs'),
  spades('♠', 'Spades');

  const Suit(this.symbol, this.name);

  /// The unicode symbol for this suit.
  final String symbol;

  /// The display name for this suit.
  final String name;
}

/// Represents the rank (face value) of a playing card.
enum Rank {
  ace('A', 1),
  two('2', 2),
  three('3', 3),
  four('4', 4),
  five('5', 5),
  six('6', 6),
  seven('7', 7),
  eight('8', 8),
  nine('9', 9),
  ten('10', 10),
  jack('J', 11),
  queen('Q', 12),
  king('K', 13);

  const Rank(this.symbol, this.value);

  /// The display symbol of the rank.
  final String symbol;

  /// The numeric value of the rank (Ace = 1, Jack = 11, Queen = 12, King = 13).
  final int value;
}

/// Represents a single playing card with a [rank] and [suit].
///
/// Example:
/// ```dart
/// final card = PlayingCard(rank: Rank.ace, suit: Suit.spades);
/// print(card); // A♠
/// ```
class PlayingCard {
  /// The rank (face value) of this card.
  final Rank rank;

  /// The suit of this card.
  final Suit suit;

  /// Creates a [PlayingCard] with the given [rank] and [suit].
  const PlayingCard({required this.rank, required this.suit});

  /// Returns the short display string, e.g. "A♠", "10♥".
  @override
  String toString() => '${rank.symbol}${suit.symbol}';

  /// Returns true if this card has the same rank and suit as [other].
  @override
  bool operator ==(Object other) =>
      other is PlayingCard && other.rank == rank && other.suit == suit;

  @override
  int get hashCode => Object.hash(rank, suit);
}
