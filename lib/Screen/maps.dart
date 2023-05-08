import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatelessWidget {
  final LatLng location;
  final String name;
  final String email;
  late GoogleMapController mapController;

  Maps({
    required this.location,
    required this.name,
    required this.email,
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
          target: location,
          zoom: 20,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('marker2'),
            position: location,
            infoWindow: InfoWindow(
              title: name,
              snippet: email,
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
