import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Category {
  int id;
  String name;
  String image;
  int parent;
  int totalProduct;
  Category.fromJson(Map<String, dynamic> json) {
//    if (json["slug"] == 'uncategorized') {
//      return ;
//    }
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
    totalProduct = json['count'];

    final image = json['image'];
    if (image!=null) {
      this.image = image['src'];

    }
  }
}

Future<List<Category>> getCategories() async {
  String url = "https://milleniumsound.co.in/wp-json/wc/v3/products/categories?consumer_key=ck_916bf850a879b31dd3ceff01300a03a8d5c559b0&consumer_secret=cs_fb4f70b9e784551a093c94a7c954a997924c2380";
  var response = await http.get(url);
  return compute(parseProduct, response.body);
}

List<Category> parseProduct(String responseBody) {
  var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Category>((json) => Category.fromJson(json)).toList();
}
