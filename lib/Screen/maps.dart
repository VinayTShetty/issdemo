import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iss/Screen/Data.dart';
import 'package:iss/Screen/InstallationData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Maps extends StatelessWidget {
  final Data mydemoData;
  final InstallationData installationData;
  late GoogleMapController mapController;

  Maps({
    required this.mydemoData,
    required this.installationData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Page'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.satellite,
            initialCameraPosition: CameraPosition(
              target: LatLng(mydemoData.userLocation.lat, mydemoData.userLocation.long),
              zoom: 20,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('marker2'),
                position: LatLng(mydemoData.userLocation.lat, mydemoData.userLocation.long),
                infoWindow: InfoWindow(
                  title: mydemoData.buildingName,
                  snippet: mydemoData.floorName,
                ),
              ),
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _showBottomSheet(context, installationData,mydemoData);
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.showMarkerInfoWindow(const MarkerId('marker2'));
  }


  void _showBottomSheet(BuildContext context, InstallationData installationData,Data mydemoData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text(
                  'Building ID=  ' + mydemoData.buildingID.toString()+"\n"
                      'Floor Name= '+mydemoData.floorName.toString()+"\n"
                      'Floor Level= '+mydemoData.floorLevel.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Text(
                  'Done Installation = ' +
                      installationData.done.toString() +
                      '\n' +
                      'Pending Installation ' +
                      installationData.pending.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showConfirmationDialog(context);
                    },
                    child:
                    Text('Make Installation'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> makePostRequest() async {
    final url = Uri.parse('https://exercicefsa.azurewebsites.net/api/Installation/42');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, dynamic>{
      'newConfrimedInstallations': 1,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('POST request successful');
        print(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to Install'),
          content: Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        // The user confirmed, do something here
        makePostRequest();
      } else {
        // The user canceled or dismissed the dialog
      }
    });
  }


}
