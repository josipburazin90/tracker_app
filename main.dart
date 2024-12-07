import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF292929),
      ),
      home: const MyHomePage(title: 'Josip'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: const [
          DetailPage(headline: 'Danas'),
          DetailPage(headline: 'Jucer'),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.headline});

  final String headline;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 48, 0.0, 32.0),
      child: Column(
        children: [
          Text(widget.headline,
              style: TextStyle(fontSize: 48.0, color: Colors.white)),
          const TrackingElement(
              color: Color(0xFF8BEF11),
              iconData: Icons.directions_run,
              unit: 'm',
              max: 5000),
          const TrackingElement(
              color: Color.fromARGB(255, 8, 95, 146),
              iconData: Icons.water_drop_outlined,
              unit: 'ml',
              max: 3000),
          const TrackingElement(
              color: Color.fromARGB(255, 170, 11, 157),
              iconData: Icons.fastfood,
              unit: 'kcal',
              max: 1680),
        ],
      ),
    );
  }
}

class TrackingElement extends StatefulWidget {
  const TrackingElement(
      {Key? key,
      required this.color,
      required this.iconData,
      required this.unit,
      required this.max})
      : super(key: key);

  final Color color;
  final IconData iconData;
  final String unit;
  final double max;

  @override
  _TrackingElementState createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _counter = 0;
  double _progress = 0;
  var now = DateTime.now();
  String _storageKey = '';

  void _incrementCounter() async {
    setState(() {
      _counter += 200;
      _progress = _counter / widget.max;
    });
    (await _prefs).setInt(_storageKey, _counter);
  }

  @override
  void initState() {
    super.initState();

    _storageKey = '${now.day}.${now.month}.${now.year} _${widget.unit}';

    _prefs.then((prefs) {
      _counter = prefs.getInt(_storageKey) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _incrementCounter,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(32.0, 64.0, 32.0, 24.0),
            child: Row(
              children: <Widget>[
                Icon(
                  widget.iconData,
                  color: Colors.white,
                  size: 50,
                ),
                Text(
                  '$_counter / ${widget.max.toInt()} ${widget.unit}',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: _progress,
            color: widget.color,
            backgroundColor: const Color(0X40ffffff),
            minHeight: 12.0,
          ),
        ],
      ),
    );
  }
}
