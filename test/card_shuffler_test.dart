import 'dart:math';

import 'package:card_shuffler_2/card_shuffler_2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayingCard', () {
    test('toString returns rank symbol + suit symbol', () {
      const card = PlayingCard(rank: Rank.ace, suit: Suit.spades);
      expect(card.toString(), 'A♠');
    });

    test('equality works correctly', () {
      const a = PlayingCard(rank: Rank.king, suit: Suit.hearts);
      const b = PlayingCard(rank: Rank.king, suit: Suit.hearts);
      const c = PlayingCard(rank: Rank.queen, suit: Suit.hearts);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  group('CardDeck', () {
    test('standard deck has 52 cards', () {
      final deck = CardDeck.standard();
      expect(deck.remaining, 52);
    });

    test('deal removes cards from deck', () {
      final deck = CardDeck.standard();
      final hand = deck.deal(5);
      expect(hand.length, 5);
      expect(deck.remaining, 47);
    });

    test('dealOne returns null on empty deck', () {
      final deck = CardDeck.custom([]);
      expect(deck.dealOne(), isNull);
    });

    test('deal throws when insufficient cards', () {
      final deck = CardDeck.standard();
      expect(() => deck.deal(53), throwsStateError);
    });

    test('reset restores 52 cards in original order', () {
      final deck = CardDeck.standard();
      final originalFirst = deck.cards.first;
      deck.shuffle();
      deck.deal(10);
      deck.reset();
      expect(deck.remaining, 52);
      expect(deck.cards.first, equals(originalFirst));
    });

    test('cut moves bottom half to top', () {
      final deck = CardDeck.standard();
      final originalCards = List.from(deck.cards);
      deck.cut(26);
      expect(deck.cards.first, equals(originalCards[26]));
    });

    test('peek returns top card without removing it', () {
      final deck = CardDeck.standard();
      final top = deck.peek();
      expect(deck.remaining, 52);
      expect(top, isNotNull);
    });
  });

  group('CardShuffler algorithms', () {
    test('Fisher-Yates: deck length unchanged after shuffle', () {
      final deck = CardDeck.standard();
      final before = deck.remaining;
      deck.shuffle(algorithm: ShuffleAlgorithm.fisherYates);
      expect(deck.remaining, before);
    });

    test('Riffle: deck length unchanged after shuffle', () {
      final deck = CardDeck.standard();
      deck.shuffle(algorithm: ShuffleAlgorithm.riffle);
      expect(deck.remaining, 52);
    });

    test('Overhand: deck length unchanged after shuffle', () {
      final deck = CardDeck.standard();
      deck.shuffle(algorithm: ShuffleAlgorithm.overhand);
      expect(deck.remaining, 52);
    });

    test('Fisher-Yates with seeded random is deterministic', () {
      final deck1 = CardDeck.standard();
      final deck2 = CardDeck.standard();
      deck1.shuffle(random: Random(42));
      deck2.shuffle(random: Random(42));
      expect(deck1.cards, equals(deck2.cards));
    });
  });

  group('HandDealer', () {
    test('deals correct number of hands and cards', () {
      final deck = CardDeck.standard();
      deck.shuffle();
      final result = HandDealer.deal(
        deck: deck,
        playerCount: 4,
        cardsPerHand: 5,
      );
      expect(result.playerCount, 4);
      expect(result.hands.every((h) => h.length == 5), isTrue);
      expect(result.remainingCards.length, 32);
    });

    test('throws when deck has insufficient cards', () {
      final deck = CardDeck.standard();
      expect(
        () => HandDealer.deal(deck: deck, playerCount: 10, cardsPerHand: 10),
        throwsStateError,
      );
    });

    test('cards are dealt round-robin', () {
      // With a known deck order, player 1 gets card 0, player 2 gets card 1, etc.
      final deck = CardDeck.standard();
      final originalCards = List.from(deck.cards);
      final result = HandDealer.deal(
        deck: deck,
        playerCount: 2,
        cardsPerHand: 3,
      );
      // Round-robin: p1=[0,2,4], p2=[1,3,5]
      expect(result.hands[0][0], equals(originalCards[0]));
      expect(result.hands[1][0], equals(originalCards[1]));
      expect(result.hands[0][1], equals(originalCards[2]));
    });
  });
}
