import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

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
  nMap createState() => nMap();
}

class nMap extends State<nMapPage> {
  latlonToNum(lat, lon, index) {
    var lat_rad = lat * (pi / 180);
    var n = pow(2, 16);
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

  determineColour(row, column) {
    if (column == 0 || column == 4 || row == 0 || row == 4) {
      return Colors.green;
    } else if (column == 2 && row == 2) {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return InteractiveViewer.builder(
            alignment: Alignment.center,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            builder: (BuildContext context, Quad viewport) {
              print("point0: ${viewport.point0}");
              print("point1: ${viewport.point1}");
              print("point2: ${viewport.point2}");
              print("point3: ${viewport.point3}");

              double xMin = viewport.point0.x;
              double xMax = viewport.point0.x;
              double yMin = viewport.point0.y;
              double yMax = viewport.point0.y;
              for (final Vector3 point in <Vector3>[
                viewport.point1,
                viewport.point2,
                viewport.point3,
              ]) {
                if (point.x < xMin) {
                  xMin = point.x;
                } else if (point.x > xMax) {
                  xMax = point.x;
                }

                if (point.y < yMin) {
                  yMin = point.y;
                } else if (point.y > yMax) {
                  yMax = point.y;
                }
              }

              final int firstRow = (yMin / 256).floor();
              final int lastRow = (yMax / 256).ceil();
              final int firstCol = (xMin / 256).floor();
              final int lastCol = (xMax / 256).ceil();

              print(firstRow);
              print(lastRow);
              print(firstCol);
              print(lastCol);

              return SizedBox(
                  width: 1,
                  height: 1,
                  child: Stack(clipBehavior: Clip.none, children: [
                    for (int column = firstCol; column < lastCol + 2; column++)
                      for (int row = firstRow; row < lastRow + 1; row++)
                        Positioned(
                            left: (256 * (column - 2)).toDouble() +
                                (((viewport.point2.x - viewport.point3.x) / 2) -
                                    128),
                            top: (256 * (row - 2)).toDouble() +
                                (((viewport.point3.y - viewport.point0.y) / 2) -
                                    128),
                            child: Container(
                                width: 256,
                                height: 256,
                                color: determineColour(row, column),
                                child: Text("row: $row, col: $column")))
                  ]));
            },
          );
        },
      ),
    );
  }
}
