import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget businessMap({
  required BuildContext context,
  Widget? titleWidget,
  String? title,
  TextStyle? titleStyle,
  String? textConfirmPicker,
  String? textCancelPicker,
  EdgeInsets contentPadding = EdgeInsets.zero,
  double radius = 0.0,
  GeoPoint? initPosition,
  double stepZoom = 1,
  double initZoom = 2,
  double minZoomLevel = 2,
  double maxZoomLevel = 18,
  bool isDismissible = false,
  bool initCurrentUserPosition = true,
}) {
  assert(title == null || titleWidget == null);
  assert((initCurrentUserPosition && initPosition == null) ||
      !initCurrentUserPosition && initPosition != null);
  final MapController controller = MapController(
    initMapWithUserPosition: UserTrackingOption(enableTracking: true),
    initPosition: initPosition,
  );

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5,
    width: MediaQuery.of(context).size.width * 0.9,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.9,
      child: OSMFlutter(
        osmOption: OSMOption(
          isPicker: true,
          zoomOption: ZoomOption(
            stepZoom: stepZoom,
            initZoom: initZoom,
            minZoomLevel: minZoomLevel,
            maxZoomLevel: maxZoomLevel,
          ),
        ),
        controller: controller,
      ),
    ),
  );
}

class BusinessLocationMap extends StatefulWidget {
  final GeoPoint initPosition;
  const BusinessLocationMap({
    Key? key,
    required this.initPosition,
  }) : super(key: key);

  @override
  State<BusinessLocationMap> createState() => _BusinessLocationMapState();
}

class _BusinessLocationMapState extends State<BusinessLocationMap> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final MapController controller = widget.initPosition != null
        ? MapController(initPosition: widget.initPosition)
        : MapController(initMapWithUserPosition: UserTrackingOption(enableTracking: true));
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.9,
      child: isLoading
          ? Skeletonizer(
              enabled: true,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          : OSMFlutter(
              osmOption: OSMOption(
                showZoomController: true,
                isPicker: true,
                zoomOption: ZoomOption(
                  stepZoom: 1,
                  initZoom: 10,
                  minZoomLevel: 2,
                  maxZoomLevel: 18,
                ),
              ),
              controller: controller,
              onMapIsReady: (isReady) {
                if (isReady && isLoading) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
    );
  }
}
