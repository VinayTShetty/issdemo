import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iss/Screen/Data.dart';
import 'package:iss/Screen/InstallationData.dart';

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
                target: LatLng(mydemoData.userLocation.lat,mydemoData.userLocation.long),
                zoom: 20,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('marker2'),
                  position: LatLng(mydemoData.userLocation.lat,mydemoData.userLocation.long),
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
                  // Do something when the button is pressed
                  _showMyDialog(context,installationData);
                },
                child: Icon(Icons.my_location),
              ),
            )
          ]
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.showMarkerInfoWindow(const MarkerId('marker2'));
  }
  void _showMyDialog(BuildContext context,InstallationData installationData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Floor ID= "+installationData.floodID.toString()),
          content: Text("Done= "+installationData.done.toString()+"\n"+"Pending= "+installationData.pending.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
