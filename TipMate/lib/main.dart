import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TipMate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
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
  double tipAmount = 0.0;
  double billAmount = 0.0;
  double tipPercentage = 0.15;

  void _updateTipAmount() {
    setState(() {
      tipAmount = billAmount * tipPercentage;
    });
  }

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          // no colour
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            CurrencyInputField(
              onChanged: (input) {
                // This callback is called when the user enters or modifies the text
                // Convert the input text to a double and update the bill amount
                setState(() {
                  billAmount = double.tryParse(input) ?? 0.0;
                  _updateTipAmount();
                });
              },
            ), // currency input widget
            TipAmount(tipAmount: tipAmount),
          ],

          // Center(
          //     // Center is a layout widget. It takes a single child and positions it
          //     // in the middle of the parent.
          //     child: CurrencyInputField()

          //     // Column(
          //     //   // Column is also a layout widget. It takes a list of children and
          //     //   // arranges them vertically. By default, it sizes itself to fit its
          //     //   // children horizontally, and tries to be as tall as its parent.
          //     //   //
          //     //   // Column has various properties to control how it sizes itself and
          //     //   // how it positions its children. Here we use mainAxisAlignment to
          //     //   // center the children vertically; the main axis here is the vertical
          //     //   // axis because Columns are vertical (the cross axis would be
          //     //   // horizontal).
          //     //   //
          //     //   // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          //     //   // action in the IDE, or press "p" in the console), to see the
          //     //   // wireframe for each widget.
          //     //   mainAxisAlignment: MainAxisAlignment.center,
          //     //   children: <Widget>[
          //     //     const Text(
          //     //       'You have pushed the button this many times:',
          //     //     ),
          //     //     Text(
          //     //       '$_counter',
          //     //       style: Theme.of(context).textTheme.headlineMedium,
          //     //     ),
          //     //   ],
          //     // ),
          //     ),
        ));
  }
}

// bill amount
class CurrencyInputField extends StatelessWidget {
  final Function(String) onChanged;

  CurrencyInputField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: onChanged, // Pass the onChanged callback to the TextField
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter amount (e.g., 20.15)',
        border: OutlineInputBorder(),
      ),
    );
  }
}

// tip amount
class TipAmount extends StatelessWidget {
  final double tipAmount;

  TipAmount({required this.tipAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Tip Amount: ${tipAmount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
