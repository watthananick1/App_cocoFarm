import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GetPoints extends StatefulWidget {
  const GetPoints({Key? key}) : super(key: key);

  @override
  _GetPointsState createState() => _GetPointsState();
}

class _GetPointsState extends State<GetPoints> {
  late LocationData cureentPosition;
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialcameraposition = LatLng(16.246684095346502, 103.25197508465824);

  late Marker marker;
  List<Marker> markers = <Marker>[];

  String myLocation = "no";
  late BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
    markers.add(Marker(
      markerId: MarkerId('1'),
      position: initialcameraposition,
      infoWindow: InfoWindow(
        title: 'Hi'
      ),
    ));
  }

  @override
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print("oncreted ${initialcameraposition.latitude} : ${initialcameraposition
      .longitude}");
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: initialcameraposition, zoom: 15),
      ),
    );
  }
  Future<LocationData?> getCurrentLocation() async {
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  // Future _goToMe() async {
  //   final GoogleMapController controller = await mapController;
  //   cureentPosition = await location.getLocation();
  //   double? latitude = cureentPosition.latitude;
  //   double? longitude = cureentPosition.longitude;
  //   initialcameraposition = LatLng(latitude!, longitude!);
  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: initialcameraposition,
  //         zoom: 16,
  //       ),
  //     ),
  //   );
  //   setState(() {});
  // }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text("Getting Location Point"),
        //   actions: [
        //     Row(
        //       children: <Widget>[
        //         IconButton(
        //           icon: const Icon(Icons.save),
        //           onPressed: () {
        //             Navigator.pop(
        //                 context, initialcameraposition);
        //             print("Save ${initialcameraposition.longitude} : ${initialcameraposition.latitude}");
        //           },
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialcameraposition,
            zoom: 16
          ),
          markers: Set<Marker>.of(markers),
          mapType: MapType.normal,
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: getLoc,
        //     label: Text('Me'),
        //     icon: Icon(Icons.near_me),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: FloatingActionButton(
            onPressed: getLoc,
            child: Icon(Icons.accessibility_new),
          ),
        ),
      ),
    );
  }
  getLoc() async {
    myLocation = "Me";
    print("myLocation $myLocation");
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied) {
      _permissionGranted == await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    cureentPosition = await location.getLocation();
    double? latitude = cureentPosition.latitude;
    double? longitude = cureentPosition.longitude;

    location.onLocationChanged.listen((LocationData cureentLocation) {

      setState(() {
        print("Current Loc ${cureentPosition.latitude} : ${cureentPosition.longitude}");
        initialcameraposition = LatLng(latitude!, longitude!);
        mapController.moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));

        setMarkers();
      });
    });
  }

  void setMarkers() {
    createMarker(context);
    markers.add(
      Marker(
        markerId: MarkerId("Home"),
        position: initialcameraposition,
        icon: customIcon,
        infoWindow: InfoWindow(
          title: myLocation,
        ),
      ),
    );
    setState(() {});
  }

  createMarker(context) {
    if(myLocation == "yes"){
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64,64)), 'asset/place.png')
      .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }
}

