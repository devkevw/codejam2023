import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tips.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

// // Check if location services are enabled
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     print("Location services are disabled. Please enable services.");
//     return;
//   }

//   // Check and request location permissions
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Handle the case where the user denied location permission
//       print("Location permissions are denied. Exiting the app.");
//       return;
//     }
//   }

//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TipMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'TipMate'
      ),
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
  final List<String> countries = tipMap.keys.toList();
  String selectedCountry = 'Canada';
  double tipAmount = 0.0;
  double billAmount = 0.0;
  double tipPercentage = 0.15;
  double totalAmount = 0.0;
  
  void _updateTipAmount() {
    setState(() {
      tipAmount = billAmount * tipPercentage;
    });
  }

    void _updateTotalAmount() {
    setState(() {
      totalAmount = billAmount + tipAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.amber,
          title: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w900)
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'Welcome to TipMate!\nEnter your bill and the country you are dining in.',
                textAlign: TextAlign.center)
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20, 
                horizontal: 60),
            child: CurrencyInputField(
              onChanged: (input) {
                // This callback is called when the user enters or modifies the text
                // Convert the input text to a double and update the bill amount
                setState(() {
                  billAmount = double.tryParse(input) ?? 0.0;
                  _updateTipAmount();
                  _updateTotalAmount();
                });
              },
              )
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newCountry) {
                if (newCountry != null) {
                  setState(() {
                    selectedCountry = newCountry;
                    tipPercentage = tipMap[newCountry]!;
                    _updateTipAmount();
                    _updateTotalAmount();
                  });
                }
              },
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      country,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                );
              }).toList(),
            )),
            Container(
              margin: EdgeInsets.all(5),
              child: TipAmount(tipAmount: tipAmount)
              ),
            Container(
              margin: EdgeInsets.all(5),
              child: TotalAmount(totalAmount: totalAmount)
            )
        ]
       )
      );
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
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: '0.00',
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.only(bottom: 0),
      ),
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400
      )
    );
  }
}

// tip amount
class TipAmount extends StatelessWidget {
  final double tipAmount;

  TipAmount({required this.tipAmount});

  @override
  Widget build(BuildContext context) {
    return Text(
        'Tip: ${tipAmount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 20.0
          ),
      );
  }
}

class TotalAmount extends StatelessWidget {
  final double totalAmount;

  TotalAmount({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return
      Text(
        'Total: ${totalAmount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        )
      );
  }
}