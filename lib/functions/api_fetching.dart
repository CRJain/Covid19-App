import 'dart:convert';
import 'package:covid19/globals/api_constants.dart';
import 'package:covid19/models/maps.dart';
import 'package:covid19/models/news.dart';
import 'package:covid19/models/states.dart';
import 'package:covid19/models/testingcenter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Fetching States From JSON
Future<List<States>> fetchStates() async {
  Data data;
  try {
    var response = await http.get(OUR_API);
    var decoded = json.decode(response.body);
    data = new Data.fromJson(decoded);
  }catch(e)
  {
    print(e.toString());
  }
  return data.states;
}
///Fetching Hospital Results
Future<List<Results>> fetchHospitalResults() async {
  Address address;
  try {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String url = '$PLACES_API_URL${position.latitude},${position.longitude}&radius=3000&keyword=hospitals&key=$PLACES_API_KEY';
    var response = await http.get(url);
    var decoded =  json.decode(response.body);
    address = new Address.fromJson(decoded);
  }catch(e)
  {
    print(e);
  }
  return address.resultsList;
}
///Fetch News API
Future<List<Articles>> fetchNewsArticles() async {
  News news;
  try {
    var response = await http.get(NEWS_API_URL);
    var decoded =  json.decode(response.body);
    news = new News.fromJson(decoded);
  }catch(e)
  {
    print(e);
  }
  return news.articles;
}
///Fetching ATM Results
Future<List<Results>> fetchATMResults() async {
  Address address;
  try {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String url = '$PLACES_API_URL${position.latitude},${position.longitude}&radius=3000&keyword=atm&key=$PLACES_API_KEY';
    var response = await http.get(url);
    var decoded =  json.decode(response.body);
    address = new Address.fromJson(decoded);
  }catch(e)
  {
    print(e);
  }
  return address.resultsList;
}

///Fetching Store Results
Future<List<Results>> fetchStoreResults() async {
  Address address;
  try {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String url = '$PLACES_API_URL${position.latitude},${position.longitude}&radius=3000&keyword=general store&key=$PLACES_API_KEY';
    var response = await http.get(url);
    var decoded =  json.decode(response.body);
    address = new Address.fromJson(decoded);
  }catch(e)
  {
    print(e);
  }
  return address.resultsList;
}