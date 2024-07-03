import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BaseMapController controller = MapController.withPosition(
    initPosition: GeoPoint(latitude: 30.111, longitude: 29.2726),
  );

  @override
  void initState() {
    controller.listenerMapSingleTapping.addListener(() async {
      print(controller.listenerMapSingleTapping.value!.latitude);
      print(controller.listenerMapSingleTapping.value!.longitude);

      await controller.osmBaseController.addMarker(
        GeoPoint(
            latitude: controller.listenerMapSingleTapping.value!.latitude,
            longitude: controller.listenerMapSingleTapping.value!.longitude),
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.pin_drop),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: OSMFlutter(
              controller: controller,

              // onGeoPointClicked: (p0) {
              //   print(p0.latitude);
              //   print(p0.longitude);
              // },
              mapIsLoading: const CircularProgressIndicator(),
              osmOption: const OSMOption(
                zoomOption: ZoomOption(
                  initZoom: 10,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.osmBaseController
                  .goToPosition(GeoPoint(latitude: 29.111, longitude: 28.2726));
            },
            child: const Text("Go To Location"),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.osmBaseController.addMarker(
                GeoPoint(latitude: 29.111, longitude: 28.2726),
                markerIcon: const MarkerIcon(
                  icon: Icon(Icons.pin_drop),
                ),
              );
              await controller.osmBaseController.addMarker(
                GeoPoint(latitude: 30.26, longitude: 29.345),
                markerIcon: const MarkerIcon(
                  icon: Icon(Icons.pin_drop),
                ),
              );
            },
            child: const Text("Add Marker"),
          ),
          ElevatedButton(
            onPressed: () async {
              var data = await controller.osmBaseController.drawRoad(
                GeoPoint(latitude: 29.111, longitude: 28.2726),
                GeoPoint(latitude: 30.26, longitude: 29.345),
                // roadType: RoadType.
                roadOption: MultiRoadOption(
                  roadColor: Colors.blue,
                  roadBorderWidth: 2,
                  roadWidth: 3,
                ),
              );

              print(data.distance);
              print(data.duration);
              print(data.instructions);
            },
            child: const Text("Draw Road"),
          ),
        ],
      ),
    );
  }
}
