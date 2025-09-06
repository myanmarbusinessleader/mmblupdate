import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessLocationMap extends StatefulWidget {
  final GeoPoint initPosition;
  const BusinessLocationMap({super.key, required this.initPosition});

  @override
  State<BusinessLocationMap> createState() => _BusinessLocationMapState();
}

class _BusinessLocationMapState extends State<BusinessLocationMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final LatLng target = LatLng(
      widget.initPosition.latitude,
      widget.initPosition.longitude,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.9,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(target: target, zoom: 16),
        markers: {
          Marker(
            markerId: const MarkerId("business_location"),
            position: target,
            infoWindow: const InfoWindow(title: "Business Location"),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
