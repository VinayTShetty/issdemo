import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iss/Screen/Data.dart';

class Maps extends StatelessWidget {
  final Data mydemoData;
  late GoogleMapController mapController;

  Maps({
    required this.mydemoData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Page'),
      ),
      body: GoogleMap(
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
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.showMarkerInfoWindow(const MarkerId('marker2'));
  }
}
