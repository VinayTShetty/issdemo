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
                _showBottomSheet(context, installationData);
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

  void _showBottomSheet(BuildContext context, InstallationData installationData) {
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
                  'Floor ID= ' + installationData.floodID.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Text(
                  'Done= ' +
                      installationData.done.toString() +
                      '\n' +
                      'Pending= ' +
                      installationData.pending.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
