import 'package:time_series_generator_api/generated/time_series_generator.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _message = "intial";
  final List<double> _streamData = <double>[];
  // List<charts.Series<RawDataResponse, String>> series = [charts.Series(id="Values",
  // data = _streamData,
  // );
  late TimeSeriesGeneratorClient stub;

  Future<void> subscribeStream() async {
    final channel = ClientChannel('192.168.0.100',
        port: 8080,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

    stub = TimeSeriesGeneratorClient(channel,
        options: CallOptions(timeout: const Duration(seconds: 30)));

    try {
      var subscribeRequest = Empty();
      var response = stub.subscribeToTimeSeries(subscribeRequest);

      await for (var data in response) {
        setState(() {
          if (data.yValues.firstOrNull != null) {
            _streamData.add(data.yValues.firstOrNull!);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Status from Server :',
            ),
            Text(
              '$_message',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _streamData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 50,
                        margin: const EdgeInsets.all(2),
                        child: Text('[${_streamData[index]}] '));
                  }),
            ),
            TextButton(
                onPressed: subscribeStream, child: const Text('Subscribe'))
          ],
        ),
      ),
    );
  }
}
