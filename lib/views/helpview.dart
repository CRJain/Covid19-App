import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:covid19/functions/api_fetching.dart';
import 'package:covid19/functions/categorypagedata.dart';
import 'package:covid19/globals/api_constants.dart';
import 'package:covid19/models/news.dart';
import 'package:covid19/models/states.dart';
import 'package:covid19/utils/growth.dart';
import 'package:covid19/views/insightsview.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:charts_flutter/flutter.dart'  as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpPageView extends StatefulWidget{
  @override
  _HelpPageViewState createState() => _HelpPageViewState();
}

class _HelpPageViewState extends State<HelpPageView> with  AutomaticKeepAliveClientMixin<HelpPageView>{
  List dataJSON;

  Future<String> getOurAPI() async {
    var response = await http
        .get(Uri.encodeFull(OUR_API), headers: {"Accept": "application/json"});

    if (this.mounted) {
      this.setState(() {
        var extractdata = json.decode(response.body);
        dataJSON = extractdata["States"];
      });
    }
  }
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    getOurAPI();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> _launched;
    const String mohfwLink = 'https://www.mohfw.gov.in/coronvavirushelplinenumber.pdf';
    const String donateLink = 'https://www.pmindia.gov.in/en/';
    const String testCentersLink = 'https://icmr.nic.in/sites/default/files/upload_documents/COVID_19_Testing_Laboratories.pdf';
    const String whoLink = 'https://www.who.int/emergencies/diseases/novel-coronavirus-2019';
    const String trackerLink = 'https://coronavirus.thebaselab.com/';
    double deviceWidth = MediaQuery.of(context).size.width;
    double screenPixelRatio = MediaQuery.of(context).devicePixelRatio;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF2D3347),
                Color(0xFF1E3647)
              ],
              begin: Alignment.topLeft, end: FractionalOffset(0.1, 0.9)
          ),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
              child: Center(
                child: Text(
                  "Need Help ?", style: TextStyle(color: Colors.white,
                    fontFamily: "Gotham-Bold",
                    fontSize: deviceWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
                child: Text(
                  "Call: +91-11-23978046", style: TextStyle(color: Colors.white,
                    fontFamily: "Gotham-Bold",
                    fontSize: deviceWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3),
                ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "Helpful Links", style: TextStyle(color: Colors.white,
                    fontFamily: "Gotham-Bold",
                    fontSize: deviceWidth * 0.10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.04, left: deviceWidth * 0.04),
              child: Container(
                height: deviceHeight * 0.1,
                child: RaisedButton(
                  elevation: 10,
                  textColor: Colors.white,
                  color: Colors.blue ,
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(mohfwLink);
                  }),
                  child: const Text('MOHFW',style: TextStyle(color: Colors.white,
                      fontFamily: "Gotham-Bold",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.04, left: deviceWidth * 0.04,  top: deviceHeight * 0.05),
              child: Container(
                height: deviceHeight * 0.1,
                child: RaisedButton(
                  elevation: 10,
                  textColor: Colors.white,
                  color: Colors.red ,
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(testCentersLink);
                  }),
                  child: const Text('Test Centers',style: TextStyle(color: Colors.white,
                      fontFamily: "Gotham-Bold",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.04, left: deviceWidth * 0.04,  top: deviceHeight * 0.05),
              child: Container(
                height: deviceHeight * 0.1,
                child: RaisedButton(
                  elevation: 10,
                  textColor: Colors.white,
                  color: Colors.green ,
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(whoLink);
                  }),
                  child: const Text('WHO',style: TextStyle(color: Colors.white,
                      fontFamily: "Gotham-Bold",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.04, left: deviceWidth * 0.04,  top: deviceHeight * 0.05),
              child: Container(
                height: deviceHeight * 0.1,
                child: RaisedButton(
                  elevation: 10,
                  textColor: Colors.white,
                  color: Colors.cyan,
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(donateLink);
                  }),
                  child: const Text('DONATE',style: TextStyle(color: Colors.white,
                      fontFamily: "Gotham-Bold",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.04, left: deviceWidth * 0.04,  top: deviceHeight * 0.05),
              child: Container(
                height: deviceHeight * 0.1,
                child: RaisedButton(
                  elevation: 10,
                  textColor: Colors.white,
                  color: Colors.pink ,
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(trackerLink);
                  }),
                  child: const Text('Tracker', style: TextStyle(color: Colors.white,
                      fontFamily: "Gotham-Bold",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
Widget createViewItem(Articles articles, BuildContext context){
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  double deviceWidth = MediaQuery.of(context).size.width;
  double screenPixelRatio = MediaQuery.of(context).devicePixelRatio;
  double deviceHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
    child: InkWell(
      child: Container(
        height: 300.0,
        width: 400.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              image: new DecorationImage(
                  image: new CachedNetworkImageProvider(articles.urlToImage), fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFABABAB).withOpacity(0.3),
                  blurRadius: 1.0,
                  spreadRadius: 2.0,
                )
              ]

          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.black12.withOpacity(0.1)
            ),
            child: Center(
              child: Text(
                articles.title,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gotham-Bold",
                    fontSize: deviceWidth * 0.050
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
Widget LoadingSpinActivity() {
  return Container(
    height: 1000.0,
    color: Colors.black.withOpacity(0.8),
    child: Center(
      child: SpinKitChasingDots(
        color: Colors.white,
        size: 110.0,
        duration: Duration(seconds: 3),
      ),
    ),
  );
}
