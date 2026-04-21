import 'package:card_shuffler_2/card_shuffler_2.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CardShufflerApp());

class CardShufflerApp extends StatelessWidget {
  const CardShufflerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Shuffler Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A472A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});
  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🃏 Card Shuffler Demo'),
        backgroundColor: const Color(0xFF1A472A),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Shuffle & Cut'),
            Tab(text: 'Deal Hands'),
            Tab(text: 'Algorithms'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ShuffleCutTab(),
          DealHandsTab(),
          AlgorithmsTab(),
        ],
      ),
    );
  }
}

// ── Tab 1: Shuffle & Cut ──────────────────────────────────────────────────────
class ShuffleCutTab extends StatefulWidget {
  const ShuffleCutTab({super.key});
  @override
  State<ShuffleCutTab> createState() => _ShuffleCutTabState();
}

class _ShuffleCutTabState extends State<ShuffleCutTab> {
  CardDeck _deck = CardDeck.standard();
  String _status = 'Standard 52-card deck. Tap Shuffle or Cut!';

  void _shuffle() => setState(() {
        _deck.shuffle();
        _status = 'Shuffled (Fisher-Yates). ${_deck.remaining} cards.';
      });

  void _cut() => setState(() {
        _deck.cut();
        _status = 'Deck cut at middle. ${_deck.remaining} cards.';
      });

  void _reset() => setState(() {
        _deck = CardDeck.standard();
        _status = 'Deck reset to original order. 52 cards.';
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Text(_status,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: [
          FilledButton.icon(
              onPressed: _shuffle,
              icon: const Icon(Icons.shuffle),
              label: const Text('Shuffle')),
          FilledButton.icon(
              onPressed: _cut,
              icon: const Icon(Icons.content_cut),
              label: const Text('Cut')),
          OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset')),
        ]),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 72,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.65,
            ),
            itemCount: _deck.remaining,
            itemBuilder: (ctx, i) => _CardTile(card: _deck.cards[i]),
          ),
        ),
      ]),
    );
  }
}

// ── Tab 2: Deal Hands ─────────────────────────────────────────────────────────
class DealHandsTab extends StatefulWidget {
  const DealHandsTab({super.key});
  @override
  State<DealHandsTab> createState() => _DealHandsTabState();
}

class _DealHandsTabState extends State<DealHandsTab> {
  int _players = 4;
  int _cardsEach = 5;
  DealResult? _result;
  String? _error;

  void _deal() {
    final deck = CardDeck.standard()..shuffle();
    try {
      setState(() {
        _result = HandDealer.deal(
            deck: deck, playerCount: _players, cardsPerHand: _cardsEach);
        _error = null;
      });
    } on StateError catch (e) {
      setState(() {
        _error = e.message;
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _SliderRow(
                  label: 'Players',
                  value: _players,
                  min: 2,
                  max: 8,
                  onChanged: (v) => setState(() => _players = v)),
              _SliderRow(
                  label: 'Cards each',
                  value: _cardsEach,
                  min: 1,
                  max: 13,
                  onChanged: (v) => setState(() => _cardsEach = v)),
              const SizedBox(height: 8),
              FilledButton.icon(
                  onPressed: _deal,
                  icon: const Icon(Icons.casino),
                  label: const Text('Deal Hands')),
            ]),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!,
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center),
        ],
        if (_result != null) ...[
          const SizedBox(height: 12),
          Text('${_result!.remainingCards.length} cards remaining in deck'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _result!.playerCount,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (ctx, i) => ListTile(
                title: Text('Player ${i + 1}'),
                subtitle: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children:
                      _result!.hands[i].map((c) => _CardChip(card: c)).toList(),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

// ── Tab 3: Algorithms ─────────────────────────────────────────────────────────
class AlgorithmsTab extends StatefulWidget {
  const AlgorithmsTab({super.key});
  @override
  State<AlgorithmsTab> createState() => _AlgorithmsTabState();
}

class _AlgorithmsTabState extends State<AlgorithmsTab> {
  ShuffleAlgorithm _selected = ShuffleAlgorithm.fisherYates;
  List<PlayingCard> _shuffled = CardDeck.standard().cards;

  void _runShuffle() {
    final deck = CardDeck.standard()..shuffle(algorithm: _selected);
    setState(() => _shuffled = deck.cards);
  }

  String _algoName(ShuffleAlgorithm a) => switch (a) {
        ShuffleAlgorithm.fisherYates => 'Fisher-Yates (Knuth)',
        ShuffleAlgorithm.riffle => 'Riffle Shuffle',
        ShuffleAlgorithm.overhand => 'Overhand Shuffle',
      };

  String _algoDesc(ShuffleAlgorithm a) => switch (a) {
        ShuffleAlgorithm.fisherYates =>
          'Uniform random — every permutation equally likely',
        ShuffleAlgorithm.riffle => 'Splits deck in half and interleaves',
        ShuffleAlgorithm.overhand => 'Cuts small packets from top to bottom',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose algorithm:',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          ...ShuffleAlgorithm.values
              .map((algo) => RadioListTile<ShuffleAlgorithm>(
                    value: algo,
                    groupValue: _selected,
                    title: Text(_algoName(algo)),
                    subtitle: Text(_algoDesc(algo)),
                    onChanged: (v) => setState(() => _selected = v!),
                  )),
          const SizedBox(height: 4),
          Center(
            child: FilledButton.icon(
                onPressed: _runShuffle,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Shuffle')),
          ),
          const SizedBox(height: 16),
          Text('Result (first 13 cards):',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children:
                _shuffled.take(13).map((c) => _CardChip(card: c)).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────
class _CardTile extends StatelessWidget {
  final PlayingCard card;
  const _CardTile({required this.card});

  Color get _color => (card.suit == Suit.hearts || card.suit == Suit.diamonds)
      ? Colors.red.shade300
      : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card.rank.symbol,
              style: TextStyle(
                  color: _color, fontSize: 13, fontWeight: FontWeight.bold)),
          Text(card.suit.symbol, style: TextStyle(color: _color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _CardChip extends StatelessWidget {
  final PlayingCard card;
  const _CardChip({required this.card});

  Color get _color => (card.suit == Suit.hearts || card.suit == Suit.diamonds)
      ? Colors.red.shade300
      : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(card.toString(),
          style: TextStyle(color: _color, fontWeight: FontWeight.bold)),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const _SliderRow(
      {required this.label,
      required this.value,
      required this.min,
      required this.max,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 100, child: Text('$label: $value')),
      Expanded(
        child: Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          label: '$value',
          onChanged: (v) => onChanged(v.round()),
        ),
      ),
    ]);
  }
}
