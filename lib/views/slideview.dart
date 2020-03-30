import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:covid19/functions/api_fetching.dart';
import 'package:covid19/functions/categorypagedata.dart';
import 'package:covid19/models/news.dart';
import 'package:covid19/views/helpview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideView extends StatefulWidget{
  @override
  _SlideViewState createState() => _SlideViewState();
}

class _SlideViewState extends State<SlideView> with  AutomaticKeepAliveClientMixin<SlideView>{
  List<Articles> articlesList;
  Future<List<Category>> fetchcategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcategory = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double screenPixelRatio = MediaQuery.of(context).devicePixelRatio;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
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
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: deviceHeight * 0.33,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    dotColor: Color(0xFF6991C7).withOpacity(0.8),
                    dotSize: 5.5,
                    dotSpacing: 16.0,
                    dotBgColor: Colors.transparent,
                    showIndicator: true,
                    overlayShadow: true,
                    autoplay: true,
                    autoplayDuration: Duration(milliseconds: 4000),
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 1200),
                    overlayShadowColors: Color(0xFF2D3347),
                    overlayShadowSize: 0.9,
                    images: [
                      CachedNetworkImageProvider(
                          "https://images.unsplash.com/photo-1584265549845-1284ac2db582?ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80"),
                      CachedNetworkImageProvider(
                          "https://images.unsplash.com/photo-1584467735815-f778f274e296?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=100"),
                      CachedNetworkImageProvider(
                          "https://images.unsplash.com/photo-1567122087721-47b09b61e1d1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=653&q=80"),
                      CachedNetworkImageProvider(
                        'https://images.unsplash.com/photo-1584541010075-1bf0cbe59b70?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'),
                        CachedNetworkImageProvider(
                        'https://images.unsplash.com/flagged/photo-1568005438925-b724a38a9550?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=752&q=80'),
                        ],

                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      child: Text(
                        "Highlights", style: TextStyle(color: Colors.white,
                          fontFamily: "Gotham-Bold",
                          fontSize: deviceWidth * 0.12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 5.0, right: 5.0, bottom: 10.0),

                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0
                                  )
                                ]
                            ),
                            height: 60.0,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: "Search For Latest News From All Over The World",
                                    labelStyle: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,
                                        fontSize: deviceWidth * 0.04,
                                        fontWeight: FontWeight.w500)),
                                    prefixIcon: Icon(Icons.search, size: 28.0,)
                                ),
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<List<Articles>>(
                      future: fetchNewsArticles(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          articlesList = snapshot.data;
                        }
                        else if(snapshot.hasError){
                          print(snapshot.error);
                        }
                        else if(!snapshot.hasData){
                          return Center(child: SpinKitChasingDots(color: Colors.white, size: 60.0, duration: Duration(seconds: 2),));
                        }

                        return Container(
                          height: deviceHeight * 0.6,
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverPadding(
                                padding: EdgeInsets.only(top: deviceHeight * 0.01, bottom: deviceHeight * 0.02),
                                sliver: SliverFixedExtentList(
                                    delegate: SliverChildBuilderDelegate(
                                            (context, index) =>
                                            createViewItem(
                                                articlesList[index], context),
                                        childCount: articlesList.length
                                    ),
                                    itemExtent: deviceHeight * 0.3),
                              ),

                            ],
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>true;
}