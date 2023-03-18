import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/scan_model.dart';
import 'dart:async';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {

  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;
  
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50
    );
    
    Set<Marker> markers = Set<Marker>();
    markers.add(Marker(
      markerId: const MarkerId('geo-location'),
      position: scan.getLatLng()
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_disabled), 
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              /// Con esto conseguimos que, al hacer clic sobre el icono
              /// el mapa vuelva a centrarse en la pantalla hasta el marker
              /// que está pintado
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: scan.getLatLng(),
                    zoom: 17,
                    tilt: 50
                  )
                )
              );
            }
          )
        ],
      ),
      body:GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.layers),
        onPressed: () {

          /// Según tipo de mapa que se esté visualizando
          /// cambio el estilo
          if (mapType == MapType.normal) {
            mapType = MapType.satellite;
          } else {
            mapType = MapType.normal;
          }
          setState(() {});
        }
      )
    );
  }
}
