import 'package:covid19/functions/api_fetching.dart';
import 'package:covid19/models/states.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart'  as charts;

class ChartsView extends StatefulWidget {
  @override
  _ChartsViewState createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  List dataJSON;

  @override
  void initState() {
    super.initState();
    fetchStates().then((value) {
      setState(() {
        dataJSON = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Charts View")),
      body: chartWidget(),
    );
  }

  Widget chartWidget() {
    List<States> tsdata = [];
    if (dataJSON != null) {
      for (Map m in dataJSON) {
        try {
          tsdata.add(new States(name: m['Name'], confirmed: m['Confirmed']));
        } catch (e) {
          print(e.toString());
        }
      }
    } else {
      // Dummy list to prevent dataJSON = NULL
      tsdata.add(new States(name: '', confirmed: 0, active: 0));
    }

    var series = [
      new charts.Series<States, String>(
        id: 'Price',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (States coinsPrice, _) => coinsPrice.name,
        measureFn: (States coinsPrice, _) => coinsPrice.confirmed,
        data: tsdata,
      ),
    ];

    var chart = new charts.PieChart(
      series,
      animate: true,
    );

    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(32.0),
            child: new SizedBox(
              height: 200.0,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }
}
