import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:math';

List<List<int>> multipliers = [
  [-1, -1],
  [0, -1],
  [-1, 0],
  [0, 0],
  [-1, 1],
  [0, 1],
  [-1, 2],
  [0, 2]
];

double aspectRatio = window.physicalSize.aspectRatio;

List<List<int>> alreadyFetchedTiles = [
  [32462, 20792]
];

class nMapPage extends StatefulWidget {
  nMap createState() => nMap(
      nCentre: {"latitude": 54.7989, "longitude": -1.6744},
      nZoom: 16,
      nToken:
          "access_token=pk.eyJ1IjoidGhvbWFzc3NiIiwiYSI6ImNsZjJ0cDI0ODA1aHQzc28xZHlwMXg3Y3kifQ.rDBktMOUdTGOQwPqyN7qiA",
      nUsername: "thomasssb",
      nStyleID: "clf2v7d4l008501qotad1c1n8");
}

class nMap extends State<nMapPage> {
  final Map<String, num> nCentre;
  final int nZoom;
  final String nToken;
  final String nUsername;
  final String nStyleID;

  nMap(
      {required this.nCentre,
      required this.nZoom,
      required this.nToken,
      required this.nUsername,
      required this.nStyleID});

  fetchTiles(List<int> colrow) async {
    print(alreadyFetchedTiles.contains(colrow));
    if (!alreadyFetchedTiles.contains(colrow)) {
      print("21");
      alreadyFetchedTiles.add(colrow);
      var img = await http.get(Uri.https(
          'api.mapbox.com',
          '/styles/v1/thomasssb/clf2v7d4l008501qotad1c1n8/tiles/$nZoom/${colrow[0]}/${colrow[1]}',
          {
            'access_token':
                "pk.eyJ1IjoidGhvbWFzc3NiIiwiYSI6ImNsZjJ0cDI0ODA1aHQzc28xZHlwMXg3Y3kifQ.rDBktMOUdTGOQwPqyN7qiA"
          }));
      return img.bodyBytes;
    }
  }

  latlonToNum(lat, lon, index) {
    var lat_rad = lat * (pi / 180);
    var n = pow(2, nZoom);
    var xtile = ((lon + 180) / 360 * n).floor();
    var ytile =
        ((1 - (log(tan(lat_rad) + sqrt(pow((tan(lat_rad)), 2) + 1))) / pi) /
                2.0 *
                n)
            .floor();
    print("${xtile + multipliers[index][0]}, ${ytile + multipliers[index][1]}");
    return <int>[xtile + multipliers[index][0], ytile + multipliers[index][1]];
  }

  moveMap(info) {
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: moveMap,
        onVerticalDragUpdate: moveMap,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 8,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ((window.physicalSize.width *
                            window.physicalSize.aspectRatio) /
                        256)
                    .floor()),
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<dynamic>(
                  future: fetchTiles(latlonToNum(
                      nCentre['latitude'], nCentre['longitude'], index)),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(snapshot.data);
                    } else {
                      return Container(color: Colors.white70);
                    }
                  });
            }));
  }
}
