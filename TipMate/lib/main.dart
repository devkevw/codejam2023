import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'tips.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    print(// prints to console, for debugging
        "Location services are disabled. Some features may not work properly.");
  }

  // Check and request location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print(// prints to console, for debugging
          "Location permissions are denied. Some features may not work properly.");
    }
  }

  // Get the current location
  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    // Perform reverse geocoding to get the address information
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the country from the placemark
    geo_country = placemarks.isNotEmpty ? placemarks[0].country ?? '' : '';
    print(geo_country); //prints to console, for debugging
  }

  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'TipMate'),
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
  final List<String> countries = tipMap.keys.toList()..sort();
  String selectedCountry = 'China';
  double tipAmount = 0.0;
  double billAmount = 0.0;
  double tipPercentage = 0.0;
  double totalAmount = 0.0;

  _MyHomePageState() {
    // Check if geo_location is in tipMap.keys
    if (tipMap.keys.contains(geo_country)) {
      selectedCountry = geo_country;
      tipPercentage = tipMap[geo_country]!;
    }
  }

  //for updating tip amount
  void _updateTipAmount() {
    setState(() {
      tipAmount = billAmount * tipPercentage;
    });
  }

  // for updating total bill amount
  void _updateTotalAmount() {
    setState(() {
      totalAmount = billAmount + tipAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping elsewhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30)),
          ),
          body: Column(children: [
            Container(
                margin:
                    EdgeInsets.only(top: 80, bottom: 0, left: 20, right: 20),
                child: Text(
                    'Welcome to TipMate!\n\nEnter your bill and the country you are dining in.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18))),
            Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 10, left: 60, right: 60),
                child: CurrencyInputField(
                  onChanged: (input) {
                    setState(() {
                      billAmount = double.tryParse(input) ??
                          0.0; // counver user input to double
                      _updateTipAmount();
                      _updateTotalAmount();
                    });
                  },
                )),
            Container(
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 60, right: 60),
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
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ));
                  }).toList(),
                )),
            Container(
                margin:
                    EdgeInsets.only(top: 120, bottom: 0, left: 60, right: 60),
                child: TipAmount(tipAmount: tipAmount)),
            Container(
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 60, right: 60),
                child: TotalAmount(totalAmount: totalAmount)),
            TipInfo(percentage: tipPercentage, country: selectedCountry)
          ])),
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
          labelStyle: TextStyle(fontSize: 18.0),
          hintText: '0.00',
          border: UnderlineInputBorder(),
          contentPadding: EdgeInsets.only(bottom: 0),
        ),
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400));
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
      style: TextStyle(fontSize: 24.0),
    );
  }
}

// total amount
class TotalAmount extends StatelessWidget {
  final double totalAmount;

  TotalAmount({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Text('Total: ${totalAmount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold));
  }
}

// tip information
class TipInfo extends StatelessWidget {
  final double percentage;
  final String country;

  TipInfo({required this.percentage, required this.country});

  @override
  Widget build(BuildContext context) {
    int tipPercentage = (percentage * 100).toInt();

    String tipText;
    if (percentage == 0) {
      tipText =
          'The recommended tipping rate in $country is $tipPercentage%. The service charge is already included in the price.';
    } else {
      tipText = 'The recommended tipping rate in $country is $tipPercentage%.';
    }
    return Container(
      margin: EdgeInsets.only(top: 18, bottom: 60, left: 20, right: 20),
      child: Text(
        tipText,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
