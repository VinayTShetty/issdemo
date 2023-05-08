import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:iss/Screen/maps.dart';

import 'Screen/Data.dart';

void main() => runApp(MyApp());

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
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode Scanner')),
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
                        Text('Scan QR Code',
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
    Response response = await get(url);
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');


    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Access the data from the response
      final buildingName = jsonResponse['buildingName'];
      final floorLevel = jsonResponse['floorLevel'];
      final imageURL = jsonResponse['floorplan']['imageURL'];

      // Or convert the response to a custom class
      final data = Data.fromJson(jsonResponse);
      print("-Response Code Here "+data.buildingID.toString());
      LatLng location =  LatLng(12.918427462285367, 77.50269032423634);
      Navigator.push(
        scaffoldContext,
        MaterialPageRoute(builder: (context) => Maps(location: location,name:"",email:"")),
      );
    } else {
      throw Exception('Failed to load data');
    }
  }
}

