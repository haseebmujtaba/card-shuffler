

https://github.com/user-attachments/assets/d9493395-cc1f-44fa-afb5-b82a3bea4aab



# card_shuffler
*Submitted by: Group 6 
Members: Haseeb 22k-4307
         Murtaza 22k-4508
         Saad 22k-4345
         Shahmir 22k-4414
*

A pure Dart package for shuffling, dealing, and managing standard playing card decks.

---

## Features

- 🃏 Standard 52-card deck (`PlayingCard`, `Suit`, `Rank`)
- 🔀 Three shuffle algorithms: **Fisher-Yates**, **Riffle**, **Overhand**
- 🎴 Deal hands to multiple players (round-robin)
- ✂️ Cut the deck
- 🔄 Reset to original order
- 🎲 Deterministic shuffles via seeded `Random`

---

## UI Showcase

### Shuffle & Cut Tab
Displays all 52 cards in a grid. Tap **Shuffle**, **Cut**, or **Reset** and watch the deck change in real time.

```
┌─────────────────────────────────────────────┐
│  🃏 Card Shuffler Demo          [Shuffle & Cut] │
├─────────────────────────────────────────────┤
│  Standard 52-card deck. Tap Shuffle or Cut! │
│                                             │
│  [Shuffle]  [Cut]  [Reset]                  │
│                                             │
│  A♠  2♠  3♠  4♠  5♠  6♠  7♠               │
│  8♠  9♠  10♠ J♠  Q♠  K♠  A♥               │
│  2♥  3♥  4♥  5♥  6♥  7♥  8♥               │
│  ...                                        │
└─────────────────────────────────────────────┘
```

### Deal Hands Tab
Use sliders to set the number of players (2–8) and cards per hand (1–13), then tap **Deal Hands**.

```
┌─────────────────────────────────────────────┐
│  Players: 4  ━━━━●━━━━━━━━━━━               │
│  Cards each: 5  ━━━●━━━━━━━━━               │
│                [Deal Hands]                  │
│  32 cards remaining in deck                 │
│  ─────────────────────────                  │
│  Player 1:  K♠  7♥  A♦  3♣  J♠            │
│  Player 2:  5♦  2♥  10♣ 8♠  Q♥            │
│  Player 3:  9♣  4♦  6♠  K♥  2♣            │
│  Player 4:  A♠  J♦  3♥  7♣  10♦           │
└─────────────────────────────────────────────┘
```

### Algorithms Tab
Pick a shuffle algorithm, run it, and see the resulting order for the first 13 cards.

```
┌─────────────────────────────────────────────┐
│  Choose algorithm:                          │
│  ○ Fisher-Yates — uniform random            │
│  ● Riffle — splits & interleaves halves     │
│  ○ Overhand — cuts small top packets        │
│                 [Run Shuffle]               │
│  Result (first 13 cards):                  │
│  7♠  A♦  Q♥  3♣  10♠  5♦  K♥ ...         │
└─────────────────────────────────────────────┘
```

---

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  card_shuffler: ^0.0.1
```

Then import:

```dart
import 'package:card_shuffler/card_shuffler.dart';
```

---

## Usage

### Create a standard deck

```dart
final deck = CardDeck.standard();
print(deck.remaining); // 52
```

### Shuffle the deck

```dart
// Default: Fisher-Yates
deck.shuffle();

// Riffle shuffle
deck.shuffle(algorithm: ShuffleAlgorithm.riffle);

// Overhand shuffle
deck.shuffle(algorithm: ShuffleAlgorithm.overhand);

// Deterministic (for tests)
deck.shuffle(random: Random(42));
```

### Deal cards

```dart
// Deal 5 cards to one player
final hand = deck.deal(5);
print(hand); // [K♠, 7♥, A♦, 3♣, J♠]

// Deal one card at a time
final card = deck.dealOne(); // returns null if deck is empty
```

### Deal to multiple players

```dart
final result = HandDealer.deal(
  deck: deck,
  playerCount: 4,
  cardsPerHand: 5,
);

for (int i = 0; i < result.playerCount; i++) {
  print('Player ${i + 1}: ${result.hands[i]}');
}
print('Remaining: ${result.remainingCards.length}');
```

### Cut the deck

```dart
deck.cut();       // cuts at the middle
deck.cut(10);     // cuts at position 10
```

### Peek & reset

```dart
final top = deck.peek(); // see top card without removing it

deck.reset();     // return all cards, restore original order
```

### Custom deck

```dart
final custom = CardDeck.custom([
  PlayingCard(rank: Rank.ace, suit: Suit.spades),
  PlayingCard(rank: Rank.king, suit: Suit.hearts),
]);
```

### PlayingCard model

```dart
const card = PlayingCard(rank: Rank.ace, suit: Suit.spades);
print(card);            // A♠
print(card.rank.value); // 1
print(card.suit.symbol);// ♠
```

---

## API Reference

### `PlayingCard`
| Property | Type | Description |
|---|---|---|
| `rank` | `Rank` | Card rank (Ace–King) |
| `suit` | `Suit` | Card suit (♠ ♥ ♦ ♣) |
| `toString()` | `String` | e.g. `"A♠"` |

### `CardDeck`
| Method | Returns | Description |
|---|---|---|
| `CardDeck.standard()` | `CardDeck` | New ordered 52-card deck |
| `CardDeck.custom(cards)` | `CardDeck` | Deck from custom card list |
| `shuffle({algorithm, random})` | `void` | Shuffle in place |
| `deal(count)` | `List<PlayingCard>` | Remove & return top N cards |
| `dealOne()` | `PlayingCard?` | Remove & return top card |
| `cut([position])` | `void` | Cut at position (default: middle) |
| `peek()` | `PlayingCard?` | Top card without removing |
| `reset()` | `void` | Restore original 52-card order |
| `remaining` | `int` | Cards left in deck |
| `isEmpty` | `bool` | True if deck is empty |

### `ShuffleAlgorithm`
| Value | Description |
|---|---|
| `fisherYates` | Uniform random — every permutation equally likely |
| `riffle` | Splits deck and interleaves packets |
| `overhand` | Repeatedly cuts small packets from top |

### `HandDealer.deal()`
| Parameter | Type | Description |
|---|---|---|
| `deck` | `CardDeck` | The deck to deal from |
| `playerCount` | `int` | Number of players |
| `cardsPerHand` | `int` | Cards per player |

Returns a `DealResult` with `hands` (list of player hands) and `remainingCards`.

---

## Example App

The `example/` folder contains a full Flutter app demonstrating all APIs across three tabs:
- **Shuffle & Cut** — visual 52-card grid with shuffle/cut/reset buttons
- **Deal Hands** — configurable multi-player hand dealing
- **Algorithms** — side-by-side comparison of all three shuffle algorithms

Run the example:
```bash
cd example
flutter run
```

---

## Additional Information

- This is a **Dart-only** package (no plugins, no native code).
- All operations mutate the deck in place; use `reset()` to restore.
- For reproducible results in tests, pass a seeded `Random` to `shuffle()`.

---

*Submitted by: [Your Group Name] — Members: [Member 1], [Member 2], ...*  
*Topic: Card Shuffler*
