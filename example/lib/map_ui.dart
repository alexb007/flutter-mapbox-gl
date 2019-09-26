// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'page.dart';

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapUiPage extends Page {
  MapUiPage() : super(const Icon(Icons.map), 'User interface');

  @override
  Widget build(BuildContext context) {
    return const MapUiBody();
  }
}

class MapUiBody extends StatefulWidget {
  const MapUiBody();

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(40.733,-73.989,),
    zoom: 11.0,
  );

  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  String _styleString = MapboxStyles.MAPBOX_STREETS;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode =
      MyLocationTrackingMode.Tracking;
  var routeJson = """
  {
      "weight_name": "routability",
      "legs": [
        {
          "summary": "University Place, East 8th Street",
          "steps": [
            {
              "intersections": [
                {
                  "out": 0,
                  "bearings": [
                    299
                  ],
                  "entry": [
                    true
                  ],
                  "location": [
                    -73.988907,
                    40.733124
                  ]
                },
                {
                  "bearings": [
                    8,
                    119,
                    189,
                    299
                  ],
                  "location": [
                    -73.989868,
                    40.733528
                  ],
                  "entry": [
                    true,
                    false,
                    true,
                    true
                  ],
                  "in": 1,
                  "out": 3
                },
                {
                  "bearings": [
                    11,
                    119,
                    189,
                    299
                  ],
                  "location": [
                    -73.990944,
                    40.733978
                  ],
                  "entry": [
                    true,
                    false,
                    true,
                    true
                  ],
                  "in": 1,
                  "out": 3
                }
              ],
              "name": "East 13th Street",
              "distance": 323.9,
              "maneuver": {
                "bearing_after": 299,
                "type": "depart",
                "bearing_before": 0,
                "location": [
                  -73.988907,
                  40.733124
                ],
                "instruction": "Head northwest on East 13th Street"
              },
              "weight": 234,
              "geometry": "_urwFt}qbMqA~DyAtEmBfG",
              "duration": 234,
              "mode": "walking",
              "driving_side": "right"
            },
            {
              "intersections": [
                {
                  "bearings": [
                    32,
                    119,
                    213,
                    298
                  ],
                  "location": [
                    -73.992264,
                    40.734531
                  ],
                  "entry": [
                    true,
                    false,
                    true,
                    true
                  ],
                  "in": 1,
                  "out": 2
                },
                {
                  "bearings": [
                    33,
                    120,
                    213,
                    298
                  ],
                  "location": [
                    -73.99279,
                    40.733921
                  ],
                  "entry": [
                    false,
                    true,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 2
                },
                {
                  "bearings": [
                    33,
                    120,
                    213,
                    298
                  ],
                  "location": [
                    -73.993324,
                    40.733303
                  ],
                  "entry": [
                    false,
                    true,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 2
                },
                {
                  "bearings": [
                    33,
                    120,
                    213,
                    298
                  ],
                  "location": [
                    -73.993813,
                    40.732731
                  ],
                  "entry": [
                    false,
                    true,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 2
                },
                {
                  "bearings": [
                    33,
                    120,
                    214,
                    300
                  ],
                  "location": [
                    -73.994293,
                    40.732166
                  ],
                  "entry": [
                    false,
                    true,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 2
                }
              ],
              "name": "University Place",
              "distance": 389,
              "maneuver": {
                "type": "turn",
                "location": [
                  -73.992264,
                  40.734531
                ],
                "bearing_before": 299,
                "modifier": "left",
                "bearing_after": 213,
                "instruction": "Turn left onto University Place"
              },
              "weight": 277,
              "geometry": "y}rwFrrrbMxBhBzBjBpB~AnB~ApBbB",
              "duration": 277,
              "mode": "walking",
              "driving_side": "right"
            },
            {
              "intersections": [
                {
                  "bearings": [
                    34,
                    120,
                    213,
                    299
                  ],
                  "location": [
                    -73.994789,
                    40.731602
                  ],
                  "entry": [
                    false,
                    true,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 3
                },
                {
                  "bearings": [
                    30,
                    119,
                    300
                  ],
                  "location": [
                    -73.995598,
                    40.731937
                  ],
                  "entry": [
                    true,
                    false,
                    true
                  ],
                  "in": 1,
                  "out": 2
                },
                {
                  "bearings": [
                    30,
                    120,
                    299
                  ],
                  "location": [
                    -73.995667,
                    40.731968
                  ],
                  "entry": [
                    true,
                    false,
                    true
                  ],
                  "in": 1,
                  "out": 2
                },
                {
                  "bearings": [
                    30,
                    119,
                    208,
                    299
                  ],
                  "location": [
                    -73.996353,
                    40.732254
                  ],
                  "entry": [
                    true,
                    false,
                    true,
                    true
                  ],
                  "in": 1,
                  "out": 3
                },
                {
                  "bearings": [
                    119,
                    213,
                    299
                  ],
                  "location": [
                    -73.997986,
                    40.732944
                  ],
                  "entry": [
                    false,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 2
                }
              ],
              "name": "East 8th Street",
              "distance": 450,
              "maneuver": {
                "type": "turn",
                "location": [
                  -73.994789,
                  40.731602
                ],
                "bearing_before": 214,
                "modifier": "right",
                "bearing_after": 299,
                "instruction": "Turn right onto East 8th Street"
              },
              "weight": 317,
              "geometry": "okrwFlbsbMcA`DELw@fCiCfIwB~GAB",
              "duration": 317,
              "mode": "walking",
              "driving_side": "right"
            },
            {
              "intersections": [
                {
                  "bearings": [
                    28,
                    118,
                    208,
                    333
                  ],
                  "location": [
                    -73.999451,
                    40.733547
                  ],
                  "entry": [
                    true,
                    false,
                    true,
                    true
                  ],
                  "in": 1,
                  "out": 3
                },
                {
                  "bearings": [
                    30,
                    153,
                    208,
                    344
                  ],
                  "location": [
                    -73.999527,
                    40.733662
                  ],
                  "entry": [
                    true,
                    false,
                    true,
                    true
                  ],
                  "in": 1,
                  "out": 2
                },
                {
                  "bearings": [
                    28,
                    152,
                    209,
                    334
                  ],
                  "location": [
                    -73.999588,
                    40.733574
                  ],
                  "entry": [
                    false,
                    true,
                    true,
                    true
                  ],
                  "in": 0,
                  "out": 2
                }
              ],
              "name": "6th Avenue; Avenue of the Americas",
              "distance": 97.1,
              "maneuver": {
                "type": "turn",
                "location": [
                  -73.999451,
                  40.733547
                ],
                "bearing_before": 298,
                "modifier": "left",
                "bearing_after": 208,
                "instruction": "Turn left onto 6th Avenue; Avenue of the Americas"
              },
              "weight": 67,
              "geometry": "uwrwFp_tbMCDEBC@GBPJnAz@^V",
              "duration": 67,
              "mode": "walking",
              "driving_side": "right"
            },
            {
              "intersections": [
                {
                  "in": 0,
                  "bearings": [
                    29
                  ],
                  "entry": [
                    true
                  ],
                  "location": [
                    -74.000008,
                    40.733006
                  ]
                }
              ],
              "name": "6th Avenue; Avenue of the Americas",
              "distance": 0,
              "maneuver": {
                "bearing_after": 0,
                "type": "arrive",
                "bearing_before": 209,
                "location": [
                  -74.000008,
                  40.733006
                ],
                "instruction": "You have arrived at your destination"
              },
              "weight": 0,
              "geometry": "itrwF`ctbM??",
              "duration": 0,
              "mode": "walking",
              "driving_side": "right"
            }
          ],
          "distance": 1260,
          "duration": 898,
          "weight": 898
        }
      ],
      "geometry": "_urwFt}qbMyG|ShQxNeKb\\\\UN`C~A",
      "distance": 1260,
      "duration": 898,
      "weight": 898
    }""";
  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  Widget _myLocationTrackingModeCycler() {
    final MyLocationTrackingMode nextType = MyLocationTrackingMode.values[
        (_myLocationTrackingMode.index + 1) %
            MyLocationTrackingMode.values.length];
    return FlatButton(
      child: Text('change to $nextType'),
      onPressed: () {
        setState(() {
          _myLocationTrackingMode = nextType;
        });
      },
    );
  }

  Widget _compassToggler() {
    return FlatButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compasss'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  Widget _setNavigation() {
    return FlatButton(
      child: Text('Set navigation'),
      onPressed: () {
        mapController.setNavigation(routeJson);
      },
    );
  }

  Widget _startNavigation() {
    return FlatButton(
      child: Text('start Nav'),
      onPressed: () {
        mapController.startNavigation();
      },
    );
  }

  Widget _latLngBoundsToggler() {
    return FlatButton(
      child: Text(
        _cameraTargetBounds.bounds == null
            ? 'bound camera target'
            : 'release camera target',
      ),
      onPressed: () {
        setState(() {
          _cameraTargetBounds = _cameraTargetBounds.bounds == null
              ? CameraTargetBounds(sydneyBounds)
              : CameraTargetBounds.unbounded;
        });
      },
    );
  }

  Widget _zoomBoundsToggler() {
    return FlatButton(
      child: Text(_minMaxZoomPreference.minZoom == null
          ? 'bound zoom'
          : 'release zoom'),
      onPressed: () {
        setState(() {
          _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
              ? const MinMaxZoomPreference(12.0, 16.0)
              : MinMaxZoomPreference.unbounded;
        });
      },
    );
  }

  Widget _setStyleToSatellite() {
    return FlatButton(
      child: Text('change map style to Satellite'),
      onPressed: () {
        setState(() {
          _styleString = MapboxStyles.SATELLITE;
        });
      },
    );
  }

  Widget _rotateToggler() {
    return FlatButton(
      child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
      onPressed: () {
        setState(() {
          _rotateGesturesEnabled = !_rotateGesturesEnabled;
        });
      },
    );
  }

  Widget _scrollToggler() {
    return FlatButton(
      child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
      onPressed: () {
        setState(() {
          _scrollGesturesEnabled = !_scrollGesturesEnabled;
        });
      },
    );
  }

  Widget _tiltToggler() {
    return FlatButton(
      child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
      onPressed: () {
        setState(() {
          _tiltGesturesEnabled = !_tiltGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return FlatButton(
      child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return FlatButton(
      child: Text('${_myLocationEnabled ? 'disable' : 'enable'} my location'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: _kInitialPosition,
        trackCameraPosition: true,
        compassEnabled: _compassEnabled,
        cameraTargetBounds: _cameraTargetBounds,
        minMaxZoomPreference: _minMaxZoomPreference,
        styleString: _styleString,
        rotateGesturesEnabled: _rotateGesturesEnabled,
        scrollGesturesEnabled: _scrollGesturesEnabled,
        tiltGesturesEnabled: _tiltGesturesEnabled,
        zoomGesturesEnabled: _zoomGesturesEnabled,
        myLocationEnabled: _myLocationEnabled,
        myLocationTrackingMode: _myLocationTrackingMode,
        onMapClick: (point, latLng) async {
          print(
              "${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
          List features =
              await mapController.queryRenderedFeatures(point, [], null);
          if (features.length > 0) {
            print(features[0]);
          }
        },
        onCameraTrackingDismissed: () {
          this.setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        });

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: mapboxMap,
          ),
        ),
      ),
    ];

    if (mapController != null) {
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              _setNavigation(),
              _startNavigation(),
              Text('camera bearing: ${_position.bearing}'),
              Text(
                  'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                  '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text('camera tilt: ${_position.tilt}'),
              Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              _compassToggler(),
              _myLocationTrackingModeCycler(),
              _latLngBoundsToggler(),
              _setStyleToSatellite(),
              _zoomBoundsToggler(),
              _rotateToggler(),
              _scrollToggler(),
              _tiltToggler(),
              _zoomToggler(),
              _myLocationToggler(),
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();
    setState(() {});
  }
}
