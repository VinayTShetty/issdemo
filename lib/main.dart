import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:iss/Screen/InstallationData.dart';
import 'package:iss/Screen/maps.dart';
import 'Screen/Data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(MyApp());
// var supportedLocales = [
//   const Locale('en', ''), // English
//   const Locale('es', ''), // Spanish
//   const Locale('fr', ''), // French
// ];
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';
  late BuildContext mycontext;

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    //  fetchAlbum(barcodeScanRes);
      makeGetRequest(barcodeScanRes,mycontext);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
//barcode scanner flutter ant
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: const Text('ISS App')),

            body: Builder(builder: (BuildContext context) {
              mycontext=context;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ElevatedButton(
                        //     onPressed: () => scanBarcodeNormal(),
                        //     child: const Text('Barcode scan')),
                        GestureDetector(
                          onTap: () {
                            // add your logic here for when the image is clicked
                            scanBarcodeNormal();
                          },
                          child: Image.asset(
                            'assets/screensaverimage.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Text(AppLocalizations.of(context)!.scanqrcode,
                            style: const TextStyle(fontSize: 30,color: Color(
                                0xFF090404)),
                        )
                      ]));
            })));
  }

  Future<http.Response> fetchAlbum(String uniqueId) {
    return http.get(Uri.parse('https://exercicefsa.azurewebsites.net/api/QR/'+uniqueId));
  }

  Future<void> makeGetRequest(String qrcode,BuildContext scaffoldContext) async {
    final url = Uri.parse('https://exercicefsa.azurewebsites.net/api/QR/'+qrcode);
    final installationDetails = Uri.parse('https://exercicefsa.azurewebsites.net/api/Installation/42');

    Response response = await get(url);
    Response installationResponse = await get(installationDetails);
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Response QR Code ${response.body}');

    if (installationResponse.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final installData = InstallationData.fromJson(jsonResponse);
    }else {
      throw Exception('Failed to load data');
    }
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Access the data from the response
      final buildingName = jsonResponse['buildingName'];
      final floorLevel = jsonResponse['floorLevel'];
      final imageURL = jsonResponse['floorplan']['imageURL'];

      // Or convert the response to a custom class
      final data = Data.fromJson(jsonResponse);
     print("ISS API Response Body QR Scan GET = "+response.body.toString());
     print("ISS API Response Body Floor ID GET = "+installationResponse.body.toString());
      InstallationData installData = InstallationData.fromJson(jsonDecode(installationResponse.body));
      print('Response Installation  ${installationResponse.body}');
      LatLng location =  LatLng(12.918427462285367, 77.50269032423634);
      Navigator.push(
        scaffoldContext,
        MaterialPageRoute(builder: (context) => Maps(mydemoData:data,installationData:installData)),
      );
    } else {
      throw Exception('Failed to load data');
    }
  }
}

