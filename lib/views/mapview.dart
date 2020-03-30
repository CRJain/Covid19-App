import 'dart:typed_data';
import 'package:covid19/functions/api_fetching.dart';
import 'package:covid19/models/maps.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:unicorndial/unicorndial.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> controller1;
  List<Results> hospitalMarkerData;
  List<Results> atmMarkerData;
  List<Results> storeMarkerData;
  List<Results> testCenterData;
  static LatLng _initialPosition;
  Marker marker;
  List<Marker> markers = <Marker>[];
  @override
  void initState() {
    super.initState();
    fetchHospitalResults().then((value) {
      setState(() {
        hospitalMarkerData = value;
      });
    });
    fetchATMResults().then((value) {
      setState(() {
        atmMarkerData = value;
      });
    });
    fetchStoreResults().then((value) {
      setState(() {
        storeMarkerData = value;
      });
    });
    getCurrentLocation();
  }
    ///Loading Assets
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }
  Future<Uint8List> getHospitalMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/hospital_icon.png");
    return byteData.buffer.asUint8List();
  }
  Future<Uint8List> getATMMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/atm_icon.png");
    return byteData.buffer.asUint8List();
  }
  Future<Uint8List> getStoreMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/store_icon.png");
    return byteData.buffer.asUint8List();
  }
  Future<Uint8List> getTestCenterMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/test_center_icon.png");
    return byteData.buffer.asUint8List();
  }
  ///Searching Nearby Hopsitals & Placing Marker
  void searchNearbyHospital() async {
    Uint8List  hopsitalImgData = await getHospitalMarker();
    setState(() {
      markers.clear();
      markers.add(marker);
      for (int i = 0; i < hospitalMarkerData.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(hospitalMarkerData[i].placeid),
            icon: BitmapDescriptor.fromBytes(hopsitalImgData),
            position: LatLng(hospitalMarkerData[i].geometry.location.lat,
                hospitalMarkerData[i].geometry.location.lng),
            infoWindow: InfoWindow(
                title: hospitalMarkerData[i].name),
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            onTap: () {},
          ),
        );
      }
    });
  }
  ///Searching Nearby ATM's & Placing Marker
  void searchNearbyATM() async {

    Uint8List  atmImgData = await getATMMarker();
    setState(() {
      markers.clear();
      markers.add(marker);
      for (int i = 0; i < atmMarkerData.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(atmMarkerData[i].placeid),
            icon: BitmapDescriptor.fromBytes(atmImgData),
            position: LatLng(atmMarkerData[i].geometry.location.lat,
                atmMarkerData[i].geometry.location.lng),
            infoWindow: InfoWindow(
                title: atmMarkerData[i].name),
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            onTap: () {},
          ),
        );
      }
    });
  }
  ///Searching Nearby Stores & Placing Marker
  void searchNearbyStore() async {
    Uint8List  storeImgData = await getStoreMarker();
    setState(() {
      markers.clear();
      markers.add(marker);
      for (int i = 0; i < storeMarkerData.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(storeMarkerData[i].placeid),
            icon: BitmapDescriptor.fromBytes(storeImgData),
            position: LatLng(storeMarkerData[i].geometry.location.lat,
                storeMarkerData[i].geometry.location.lng),
            infoWindow: InfoWindow(
                title: storeMarkerData[i].name),
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            onTap: () {},
          ),
        );
      }
    });
  }

  /// Current User Location Marker
  void currentLocationMarker(Position newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      CameraPosition(
        target: _initialPosition,
        zoom: 14.4746,
      );
    });
  }
  ///Fetching Current User Location
  void getCurrentLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Uint8List imageData = await getMarker();
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
      currentLocationMarker(position, imageData);

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
    ///Setting Map Style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    ///Unicorn Sub Buttons
    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "Hosptials",
      currentButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.local_hospital),
          onPressed: searchNearbyHospital
      ),
    ));
    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "ATM",
      currentButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        mini: true,
        child: Icon(Icons.attach_money),
        onPressed: searchNearbyATM
      ),
    ));
    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "Stores",
      currentButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        mini: true,
        child: Icon(Icons.shopping_basket),
        onPressed: searchNearbyStore
      ),
    ));
    return Scaffold(
        body: _initialPosition == null ? Center(child: CircularProgressIndicator()) : Container(
          child: Stack(children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.4746),
              markers: Set<Marker>.of(markers),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _setStyle(controller);
                  controller1.complete(controller);
                });
              },
            )
          ]),
        ),
        floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.place),
          childButtons: childButtons,
        )
    );
  }
}