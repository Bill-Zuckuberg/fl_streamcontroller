import 'dart:async';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as english_words;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streamcontroller Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StreamControllerExample(title: 'Streamcontroller Demo'),
    );
  }
}

class StreamControllerExample extends StatefulWidget {
  const StreamControllerExample({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<StreamControllerExample> createState() =>
      _StreamControllerExampleState();
}

class _Data {
  final String messager;
  final DateTime timestamp;
  const _Data({required this.messager, required this.timestamp});
}

class _StreamControllerExampleState extends State<StreamControllerExample> {
  final _inputStreamController = StreamController<_Data>();
  final _outputStreamController = StreamController<Widget>();

  @override
  void initState() {
    super.initState();
    void _onData(_Data _data) {
      final widgetToRender = ListTile(
        title: Text(_data.messager),
        subtitle: Text(_data.timestamp.toString()),
      );
      _outputStreamController.sink.add(widgetToRender);
    }

    _inputStreamController.stream.listen(_onData);
  }

  @override
  void dispose() {
    _inputStreamController.close();
    _outputStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const Text('data'),
          Card(
            elevation: 4.0,
            child: StreamBuilder(
                stream: _outputStreamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('no data'),
                    );
                  }
                  final Widget widgetToRender = snapshot.data;
                  return widgetToRender;
                }),
          ),
          ElevatedButton.icon(
              onPressed: () => _inputStreamController.sink.add(_Data(
                  messager: english_words.WordPair.random().asPascalCase,
                  timestamp: DateTime.now())),
              icon: const Icon(Icons.send),
              label: const Text('Send random word to imput stream'))
        ],
      ),
    );
  }
}
