import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TipMate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  final List<String> types = ['Restaurant', 'Hotel', 'Taxi'];
  final List<String> countries = ['Canada', 'USA', 'China'];
  String selectedType = 'Restaurant';
  String selectedCountry = 'Canada';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title),
      ),
      body: Column(
          children: [
            CurrencyInputField(),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (String? newType) {
                if (newType != null) {
                  setState(() {
                    selectedType = newType;
                  });
                }
              },
              items: types.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newCountry) {
                if (newCountry != null) {
                  setState(() {
                    selectedCountry = newCountry;
                  });
                }
              },
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            )
          ]
          // Column(
          //   // Column is also a layout widget. It takes a list of children and
          //   // arranges them vertically. By default, it sizes itself to fit its
          //   // children horizontally, and tries to be as tall as its parent.
          //   //
          //   // Column has various properties to control how it sizes itself and
          //   // how it positions its children. Here we use mainAxisAlignment to
          //   // center the children vertically; the main axis here is the vertical
          //   // axis because Columns are vertical (the cross axis would be
          //   // horizontal).
          //   //
          //   // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          //   // action in the IDE, or press "p" in the console), to see the
          //   // wireframe for each widget.
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     const Text(
          //       'You have pushed the button this many times:',
          //     ),
          //     Text(
          //       '$_counter',
          //       style: Theme.of(context).textTheme.headlineMedium,
          //     ),
          //   ],
          // ),
          ),
    );
  }
}

// bill amount
class CurrencyInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter amount',
        border: OutlineInputBorder(),
      ),
    );
  }
}