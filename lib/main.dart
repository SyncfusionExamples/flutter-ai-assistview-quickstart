import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AssistViewSample(),
  ));
}

class AssistViewSample extends StatefulWidget {
  const AssistViewSample({super.key});

  @override
  State<AssistViewSample> createState() => AssistViewSampleState();
}

class AssistViewSampleState extends State<AssistViewSample> {
  late List<AssistMessage> _messages;
  bool _lightTheme = true;

  final AssistMessageAuthor user = const AssistMessageAuthor(
    id: 'User ID',
    name: 'User name',
  );

  final AssistMessageAuthor ai = const AssistMessageAuthor(
    id: 'ID',
    name: 'AI',
  );

  void _generativeResponse(String data) async {
    final String response = await _fetchAIResponse(data);
    setState(() {
      _messages.add(AssistMessage.response(
        data: response,
        time: DateTime.now(),
        author: AssistMessageAuthor(id: ai.id, name: ai.name),
      ));
    });
  }

  Future<String> _fetchAIResponse(String data) async {
    await Future.delayed(const Duration(seconds: 2));
    // Integrate an API call to communicate with the AI for real-time responses.
    String response =
        'Please connect to your preferred AI server for real-time queries.';
    return response;
  }

  @override
  void initState() {
    _messages = <AssistMessage>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter AI AssistView'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SfAIAssistView(
          messages: _messages,
          composer: const AssistComposer(
            decoration: InputDecoration(
              hintText: 'Ask here',
            ),
          ),
          actionButton: AssistActionButton(
            onPressed: (String data) {
              setState(() {
                _messages.add(AssistMessage.request(
                  data: data,
                  time: DateTime.now(),
                  author: AssistMessageAuthor(
                    id: user.id,
                    name: user.name,
                  ),
                ));
                _generativeResponse(data);
              });
            },
          ),
          placeholderBuilder: _buildPlaceholder,
          requestBubbleSettings: const AssistBubbleSettings(
            showUserName: true,
            showTimestamp: true,
            showUserAvatar: true,
          ),
          responseBubbleSettings: const AssistBubbleSettings(
            showUserAvatar: true,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    _lightTheme = Theme.of(context).brightness == Brightness.light;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 80.0,
            child: Image.asset(
              _lightTheme
                  ? 'assets/ai_avatar_light.png'
                  : 'assets/ai_avatar_dark.png',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Ask AI Anything!',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              runSpacing: 10.0,
              children: _generateQuickAccessTiles(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateQuickAccessTiles() {
    final List<String> options = [
      'Travel Tips',
      'Recipe Ideas',
      'Fun Fact',
      'Life Hacks',
    ];

    return options.map((option) {
      return InkWell(
        onTapDown: (TapDownDetails details) {
          setState(() {
            _messages.add(AssistMessage.request(
              data: option,
              time: DateTime.now(),
              author: AssistMessageAuthor(
                id: user.id,
                name: user.name,
              ),
            ));
            _generativeResponse(option);
          });
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              option,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}
