import 'dart:typed_data';
import 'package:covid19/functions/homepagedata.dart';
import 'package:covid19/models/testingcenter.dart';
import 'package:covid19/views/helpview.dart';
import 'package:covid19/views/mapview.dart';
import 'package:covid19/views/slideview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicorndial/unicorndial.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}
class _HomePageViewState extends State<HomePageView> {
  List<TestingCenter> testingCenter;
  List<Marker> markers = <Marker>[];
  int _btmnavpage = 0;
  PageController _btmpagecontroller;
  GlobalKey _bottomNavigationKey = GlobalKey();
  GlobalKey<ScaffoldState> _navigationDrawerKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _btmpagecontroller = new  PageController(
      initialPage: _btmnavpage,
      keepPage: true,
    );
  }

  Future<Uint8List> getTestingMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/test_center_icon.png");
    return byteData.buffer.asUint8List();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _btmpagecontroller.dispose();
    super.dispose();
  }

  void pageChanged(int index) {
    setState(() {
      _btmnavpage = index;
    });
  }
//  var testingDataList = [
//    new TestingCenter(13.637927, 79.403916, "Sri Padmavati Mahila Visvavidyalayam"),
//    new TestingCenter(16.979170, 82.237355, "Rangaraya Medical College, Kakinada, Andhra Pradesh"),
//    new TestingCenter(16.517424, 80.671330, "Sidhartha Medical College, Vijayawada, Andhra Pradesh"),
//    new TestingCenter(14.671209, 77.592873, "GMC, Anantapur, Andhra Pradesh"),
//    new TestingCenter(11.634633, 92.714699, "Regional Medical Research Centre, Port Blair, Andaman and Nicobar Assam"),
//    new TestingCenter(26.154188, 91.770085, "Gauhati Medical College, Guwahati, Assam"),
//    new TestingCenter(27.472671, 94.982767, "Regional Medical Research Center, Dibrugarh, Assam"),
//    new TestingCenter(24.775760, 92.794333, "Silchar Medical College, Silchar, Assam"),
//    new TestingCenter(26.742562, 94.195102, "Jorhat Medical College, Jorhat, Assam"),
//    new TestingCenter(25.599794, 85.197658, "Rajendra Memorial Research Institute of Medical Sciences, Patna, Bihar"),
//    new TestingCenter(30.764988, 76.774987, "Post Graduate Institute of Medical Education & Research, Chandigarh"),
//    new TestingCenter(21.256749, 81.579174, "All India Institute Medical Sciences, Raipur, Chhattisgarh"),
//    new TestingCenter(28.567269, 77.210069, "All India Institute Medical Sciences, Delhi"),
//    new TestingCenter(23.052418, 72.602859, "BJ Medical College, Ahmedabad, Gujarat"),
//    new TestingCenter(22.478328, 70.065885, "M.P.Shah Government Medical College, Jamnagar, Gujarat"),
//    new TestingCenter(28.880162, 76.605653, "Pt. B.D. Sharma Post Graduate Inst. of Med. Sciences, Rohtak, Haryana"),
//    new TestingCenter(29.152213, 76.808404, "BPS Govt Medical College, Sonipat, Haryana"),
//    new TestingCenter(31.106466, 77.182278, "Indira Gandhi Medical College, Shimla, Himachal Pradesh"),
//    new TestingCenter(32.099138, 76.298724, "Dr.Rajendra Prasad Govt. Med. College, Kangra, Tanda, Himachal Pradesh"),
//    new TestingCenter(34.136133, 74.800031, "Sher-e- Kashmir Institute of Medical Sciences, Srinagar, Jammu and Kashmir"),
//    new TestingCenter(32.736104, 74.853993, "Government Medical College, Jammu, Jammu and Kashmir"),
//    new TestingCenter(34.085953, 74.798833, "Government Medical College, Srinagar, Jammu and Kashmir"),
//    new TestingCenter(22.843625, 86.232431, "MGM Medical College, Jamshedpur, Jharkhand"),
//    new TestingCenter(12.959387, 77.574767, "Bangalore Medical College & Research Institute, Bangalore, Karnataka"),
//    new TestingCenter(12.937326, 77.590840, "National Institute of Virology Field Unit Bangalore, Karnataka"),
//    new TestingCenter(12.315037, 76.650444, "Mysore Medical College & Research Institute, Mysore, Karnataka"),
//    new TestingCenter(13.004822, 76.102689, "Hassan Inst. of Med. Sciences, Hassan, Karnataka"),
//    new TestingCenter(13.932541, 75.567002, "Shimoga Inst. of Med. Sciences, Shivamogga, Karnataka"),
//    new TestingCenter(9.418507, 76.343203, "National Institute of Virology Field Unit, Kerala"),
//    new TestingCenter(8.523382, 76.928283, "Govt. Medical College, Thriuvananthapuram, Kerala"),
//    new TestingCenter(11.272199, 75.837208, "Govt. Medical College, Kozhikhode, Kerala"),
//    new TestingCenter(10.614480, 76.196077, "Govt. Medical College, Thrissur, Kerala"),
//    new TestingCenter(23.206744, 77.460169, "All India Institute Medical Sciences, Bhopal, Madhya Pradesh"),
//    new TestingCenter(23.147215, 79.878590, "National Institute of Research in Tribal Health (NIRTH), Jabalpur, Madhya Pradesh"),
//    new TestingCenter(25.590897, 91.937304, "NEIGRI of Health and Medical Sciences, Shillong, Meghalaya"),
//    new TestingCenter(21.153409, 79.093960, "Indira Gandhi Government Medical College, Nagpur, Maharashtra "),
//    new TestingCenter(18.984021, 72.829846, "Kasturba Hospital for Infectious Diseases, Mumbai, Maharashtra"),
//    new TestingCenter(18.940960, 72.827439, "NIV Mumbai Unit, Maharashtra"),
//    new TestingCenter(24.810046, 93.961132, "J N Inst. of Med. Sciences Hospital, Imphal-East, Manipur"),
//    new TestingCenter(24.815893, 93.922811, "Regional Institute of Medical Sciences, Imphal, Manipur"),
//    new TestingCenter(20.316642, 85.819459, "Regional Medical Research Center, Bhubaneswar, Odisha"),
//    new TestingCenter(11.950284, 79.799667, "Jawaharlal Institute of Postgraduate Medical Education & Research, Puducherry"),
//    new TestingCenter(30.327977, 76.385143, "Government Medical College, Patiala, Punjab"),
//    new TestingCenter(31.653843, 74.8852211, "Government Medical College, Amritsar, Punjab"),
//    new TestingCenter(26.893923, 75.803090, "Sawai Man Singh, Jaipur, Rajasthan"),
//    new TestingCenter(26.269440, 73.007465, "Dr. S.N Medical College, Jodhpur, Rajasthan"),
//    new TestingCenter(24.585553, 76.161060, "Jhalawar Medical College, Jhalawar, Rajasthan"),
//    new TestingCenter(24.588207, 73.694980, "RNT Medical College, Udaipur, Rajasthan"),
//    new TestingCenter(28.006411, 73.330541, "SP Med. College, Bikaner, Rajasthan"),
//    new TestingCenter(13.012432, 80.217620, "King's Institute of Preventive Medicine & Research, Chennai, Tamil Nadu"),
//    new TestingCenter(10.006257, 77.553884, "Government Medical College, Theni, Tamil Nadu"),
//    new TestingCenter(8.711721, 77.750851, "Tirunelveli Medical College, Tirunelveli, Tamil Nadu"),
//    new TestingCenter(10.776450, 79.606031, "Govt. Medical college, Thiruvarur, Tamil Nadu"),
//    new TestingCenter(23.783370, 91.257060, "Government Medical College, Agartala, Tripura"),
//  ];
//  void searchNearbyTestingCenter() async {
//    Uint8List  storeImgData = await getTestingMarker();
//    setState(() {
//      markers.clear();
//      for (int i = 0; i < testingDataList.length; i++) {
//        markers.add(
//          Marker(
//            markerId: MarkerId('Testing Centers'),
//            icon: BitmapDescriptor.fromBytes(storeImgData),
//            position: LatLng(testingDataList[i].lat,
//                testingDataList[i].lon),
//            infoWindow: InfoWindow(
//                title: testingDataList[i].name),
//            draggable: false,
//            zIndex: 2,
//            flat: true,
//            anchor: Offset(0.5, 0.5),
//            onTap: () {},
//          ),
//        );
//      }
//    });
//  }
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double screenPixelRatio = MediaQuery.of(context).devicePixelRatio;
    double deviceHeight = MediaQuery.of(context).size.height;
    var childButtons = List<UnicornButton>();
    ///Unicorn Sub Buttons
//    childButtons.add(UnicornButton(
//      hasLabel: true,
//      labelText: "Hosptials",
//      currentButton: FloatingActionButton(
//          backgroundColor: Colors.redAccent,
//          mini: true,
//          child: Icon(Icons.local_hospital),
//          onPressed: searchNearbyTestingCenter
//      ),
//    ));
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF2d3447),
      key: _navigationDrawerKey,
      drawer: new Drawer(
        elevation: 16.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListView(
            children: <Widget>[
              DrawerHeader(child: Text("Nothing Here", style: TextStyle(fontFamily: "Calibre-Semibold", fontSize: 40.0, color: Colors.white),)),

            ],
          ),
        ),
      ),
      appBar:  AppBar(
        elevation: 0.1,
        title: Text("COVID-19 STUDY", style: TextStyle(
            fontFamily: "Calibre-Semibold",fontSize: deviceWidth * 0.07, color: Colors.white, letterSpacing: 1.5
        ),),
        backgroundColor: Color(0xFF2d3447),
        centerTitle: true,
        leading: IconButton(icon: Icon(
          HomeIcons.menu,
          color: Colors.white,
          size: 30.0,),
//          onPressed: (){
//            _navigationDrawerKey.currentState.openDrawer();
//          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 30.0,),
            onPressed: (){},
          )
        ],
      ),

      body: PageView(
          controller: _btmpagecontroller,
          pageSnapping: true,
          dragStartBehavior: DragStartBehavior.down,
          scrollDirection: Axis.horizontal,
          physics: new NeverScrollableScrollPhysics(),
          children:<Widget>[
            HomeView(),
            SlideView(),
            MapView(),
            HelpPageView()

          ],
          onPageChanged: (index) { pageChanged(index);}
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _btmnavpage,
        key: _bottomNavigationKey,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInOut,
        backgroundColor: Colors.transparent,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard, size: 30.0,),
            title: Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.ondemand_video, size: 30.0,),
            title: Text('News'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.map, size: 30.0,),
            title: Text('Maps'),
            activeColor: Colors.greenAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.help, size: 30.0,),
            title: Text(
              'Help ?',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
        ],
        onItemSelected: (int index) {
          HapticFeedback.lightImpact();
          setState(() {
            _btmpagecontroller.jumpToPage(index);
          });
        },
      ),
    );
  }
}