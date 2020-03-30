import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:covid19/models/states.dart';
import 'package:covid19/utils/growth.dart';
import 'package:covid19/views/insightsview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'api_fetching.dart';

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

List<String> images = [
  "assets/slide-1.jpg",
  "assets/slide-2.jpg",
  "assets/slide-3.jpg",
  "assets/slide-4.jpg",
];

List<String> title = [
  "Get Your Facts Right",
  "Must Have Habits",
  "Sanitize Regularly",
  "Maintain Social Distance",
];


class HomeIcons {
  static const IconData menu = IconData(0xe900, fontFamily: "Home-Icons");
  static const IconData option = IconData(0xe902, fontFamily: "Home-Icons");
}


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String city;
  Completer<GoogleMapController> controller1;
  Marker marker;
  LatLng _initialPosition;
  var currentPage = images.length - 1.0;
  var currentPage2 = images.length - 1.0;
  List<States> statesList;
  void getCurrentLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
      city = placemark[0].locality;
      Uint8List imageData = await getMarker();
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
      currentLocationMarker(position, imageData);

    }catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/city-marker.png");
    return byteData.buffer.asUint8List();
  }
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStates().then((value) {
      setState(() {
        statesList = value;
      });
    });
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double screenPixelRatio = MediaQuery.of(context).devicePixelRatio;
    double deviceHeight = MediaQuery.of(context).size.height;
    double scaleTextFactor = MediaQuery.of(context).textScaleFactor;
    print('$deviceWidth');
    print('$deviceHeight');
    print('$screenPixelRatio');
    print('$scaleTextFactor');
    PageController controller = PageController(initialPage: images.length  -1);
    PageController controller2 = PageController(initialPage: images.length  -1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    controller2.addListener(() {
      setState(() {
        currentPage2 = controller2.page;
      });
    });


    return statesList.isEmpty ? SpinKitChasingDots : Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xFF2D3347),
              Color(0xFF1E3647)
            ],
            begin: Alignment.topLeft, end: FractionalOffset(0.1, 0.8)
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Habits", style: GoogleFonts.openSansCondensed(textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.12,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold
                    )),
                    ),
                    IconButton(
                      icon: Icon(
                        HomeIcons.option,
                        size: 14.0,
                        color: Colors.white,
                      ),
                      onPressed: (){},
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFff6e6e),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                        child: Text(
                          "WHO",
                          style: TextStyle(color: Colors.white, fontFamily: "Calibre-Semibold"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                CardScrollWidget(currentPage),
                Positioned.fill(child: PageView.builder(
                  itemCount: images.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Container();
                  },))
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Statistics", style: GoogleFonts.openSansCondensed(textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.12,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold
                  )),
                  ),
              IconButton(
                icon: Icon(
                  HomeIcons.option,
                  size: 14.0,
                  color: Colors.white,
                ),
                onPressed: (){},
              )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
                        child: Text(
                          "India",
                          style: TextStyle(color: Colors.white, fontFamily: "Calibre-Semibold", fontStyle: FontStyle.normal, fontSize: deviceWidth * .035),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
                  Container(
                    child: GlobalSituationCard(
                      cardTitle: 'Total CASES',
                      caseTitle: 'Total',
                      currentData: statesList[27].confirmed,
                      newData: statesList[27].rise,
                      percentChange: calculateGrowthPercentage(
                          statesList[27].confirmed, statesList[27].rise
                          ),
                      icon: showGrowthIcon(2000,
                          100),
                      color: Colors.red,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: deviceHeight * 0.05),),
            Container(
              child: GlobalSituationCard(
                cardTitle: 'Active Cases',
                caseTitle: 'Active',
                currentData: statesList[27].active,
                cardColor: Colors.deepOrangeAccent,
                newData: statesList[27].active,
                icon: showGrowthIcon(2000,
                    100),
                color: Colors.deepOrangeAccent,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: deviceHeight * 0.05),),

                  Container(
                    child: GlobalSituationCard(
                      cardTitle: 'Recovered Cases',
                      caseTitle: 'Recovered',
                      currentData: statesList[27].recovered,
                      cardColor: Colors.blue,
                      newData: statesList[27].recovered,
                      icon: showGrowthIcon(2000,
                          100),
                      color: Colors.red,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: deviceHeight * 0.05),),
                  Container(
                    child: GlobalSituationCard(
                      cardTitle: 'Death Cases',
                      caseTitle: 'Deaths',
                      currentData: statesList[27].deceased,
                      cardColor: Colors.red,
                      newData: statesList[27].deceased,
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      ),
                      color: Colors.blue,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: deviceHeight * 0.05),),
//            Padding(
//              padding: EdgeInsets.only(left: 0.0,right: 20.0,top: 20.0),
//              child: Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                child:  Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      "Your City", style: GoogleFonts.openSansCondensed(textStyle: TextStyle(
//                        color: Colors.white,
//                        fontSize: deviceWidth * 0.13,
//                        letterSpacing: 1.0,
//                        fontWeight: FontWeight.bold
//                    )),
//                    ),
//                    IconButton(
//                      icon: Icon(
//                        HomeIcons.option,
//                        size: 14.0,
//                        color: Colors.white,
//                      ),
//                      onPressed: (){},
//                    )
//                  ],
//                ),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 20.0),
//              child: Row(
//                children: <Widget>[
//                  Container(
//                    decoration: BoxDecoration(
//                      color: Colors.deepOrange,
//                      borderRadius: BorderRadius.circular(20.0),
//                    ),
//                    child: Center(
//                      child: Padding(
//                        padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
//                        child: Text(
//                          "Stats",
//                          style: TextStyle(color: Colors.white, fontFamily: "Calibre-Semibold"),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: 15.0,
//                  ),
//                  Text("9+ Stories", style: TextStyle(color: Colors.blueAccent, fontFamily: "Calibre-Semibold"), )
//                ],
//              ),
//            ),
//            Container(
//              height: 500,
//              child: GoogleMap(
//                myLocationEnabled: true,
//                mapType: MapType.normal,
//                initialCameraPosition: CameraPosition(
//                    target: _initialPosition,
//                    zoom: 5.05),
//                markers: Set.of((marker != null) ? [marker] : []),
//                onMapCreated: (GoogleMapController controller) {
//                  setState(() {
//                    _setStyle(controller);
//                    controller1.complete(controller);
//                  });
//                },
//              )
//            )
          ],
        ),
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage);
  @override
  Widget build(BuildContext context) {
    return new AspectRatio(aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints){
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthofPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          List<Widget> cardList = new List();
          var primaryCardLeft = safeWidth - widthofPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;

          for(var i=0; i<images.length; i++){
            var delta = i -  currentPage;

            var isOnRight = delta > 0;
            var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 :1), 0.0);
            var carditem = Positioned.directional(
              top: padding + verticalInset * max(-delta,0.0),
              bottom: padding + verticalInset * max(-delta, 0.0),
              start: start,
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),

                child: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0
                    )
                  ]),
                  child: AspectRatio(
                    aspectRatio: cardAspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(images[i],fit: BoxFit.cover),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(title[i], style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 25.0)),),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                  ),
                ),
              ),
            );
            cardList.add(carditem);
          }
          return Stack(
            children: cardList,
          );
        },
      ),);
  }
}