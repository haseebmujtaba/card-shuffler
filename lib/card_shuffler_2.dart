/// A Dart package for shuffling, dealing, and managing playing card decks.
///
/// ## Features
/// - Standard 52-card deck or custom decks
/// - Three shuffle algorithms: Fisher-Yates, Riffle, Overhand
/// - Deal cards to multiple players
/// - Cut the deck
/// - Reset to original order
///
/// ## Quick Start
/// ```dart
/// import 'package:card_shuffler/card_shuffler.dart';
///
/// void main() {
///   final deck = CardDeck.standard();
///   deck.shuffle(); // Fisher-Yates by default
///   final hand = deck.deal(5);
///   print(hand); // e.g. [A♠, 7♥, 3♦, K♣, 10♠]
/// }
/// ```
library card_shuffler;

export 'src/playing_card.dart';
export 'src/card_shuffler_2.dart';
export 'src/card_deck.dart';
export 'src/hand_dealer.dart';
