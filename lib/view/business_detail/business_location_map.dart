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
  double _currentZoom = 16;
  late LatLng _markerPosition;

  @override
  void initState() {
    super.initState();
    _markerPosition = LatLng(
      widget.initPosition.latitude,
      widget.initPosition.longitude,
    );
  }

  Future<void> _zoomIn() async {
    final controller = await _controller.future;
    setState(() {
      _currentZoom += 1;
    });
    controller.animateCamera(CameraUpdate.zoomTo(_currentZoom));
  }

  Future<void> _zoomOut() async {
    final controller = await _controller.future;
    setState(() {
      _currentZoom -= 1;
    });
    controller.animateCamera(CameraUpdate.zoomTo(_currentZoom));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(target: _markerPosition, zoom: _currentZoom),
            markers: {
              Marker(
                markerId: const MarkerId("business_location"),
                position: _markerPosition,
                infoWindow: const InfoWindow(title: "Business Location"),
                draggable: true,
                onDragEnd: (LatLng newPosition) {
                  setState(() {
                    _markerPosition = newPosition;
                  });
                },
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoom_in",
                  mini: true,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "zoom_out",
                  mini: true,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
