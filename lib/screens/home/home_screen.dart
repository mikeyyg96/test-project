import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whats_poppin_v3/screens/home/bloc/home_bloc.dart';
import 'package:whats_poppin_v3/shared/read_file/bloc/reader_bloc.dart';
import 'package:whats_poppin_v3/shared/timer/bloc/timer_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer _timer;
  String _initialTime;
  Future<String> _loadData;
  Position position;
  CameraPosition cameraPosition;
  BitmapDescriptor _pinIcon;
  String _mapStyle;
  Completer<GoogleMapController> _googleMapController = new Completer();
  bool _zoomFeatures = true;
  double _verticalPosition = -300;
  double _drawerPosition = 0;
  Set<Circle> _circles = new Set<Circle>();
  Set<Marker> _markers = new Set<Marker>();

  @override
  void initState() {
    rootBundle
        .loadString('assets/map/map_style.txt')
        .then((value) => _mapStyle = value);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5, size: Size(4, 4)),
            'assets/map/text.gif')
        .then((value) => _pinIcon = value);
    _loadData = loadData().then((value) {
      _initialTime = _formatDateTime(DateTime.now());
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        BlocProvider.of<TimerBloc>(context)
            .add(TimerFeedback(currentTime: _initialTime));
      });
      return value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _loadData,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Stack(
                children: [
                  Container(
                    child: GoogleMap(
                      initialCameraPosition: cameraPosition,
                      onMapCreated:
                          (GoogleMapController googleMapController) async {
                        _googleMapController.complete(googleMapController);
                        final GoogleMapController controller =
                            await _googleMapController.future;
                        controller.setMapStyle(_mapStyle);
                      },
                      onCameraMove: (CameraPosition details) async {
                        final GoogleMapController controller =
                            await _googleMapController.future;
                        _verticalPosition = -300;
                        if (details.zoom > 18) {
                          setState(
                            () {
                              _zoomFeatures = false;
                              controller.animateCamera(CameraUpdate.zoomTo(17));
                            },
                          );
                        } else if (details.zoom < 11) {
                          setState(
                            () {
                              _zoomFeatures = false;
                              controller.animateCamera(CameraUpdate.zoomTo(12));
                            },
                          );
                        } else {
                          setState(
                            () {
                              _zoomFeatures = true;
                            },
                          );
                        }
                      },
                      onTap: (details) {
                        setState(() {
                          _verticalPosition = -300;
                        });
                      },
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: _zoomFeatures ? true : false,
                      circles: _circles,
                      markers: _markers,
                    ),
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return AnimatedPositioned(
                        curve: Curves.easeInOut,
                        bottom: _verticalPosition,
                        left: 0,
                        right: 0,
                        duration: Duration(milliseconds: 400),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            height: MediaQuery.of(context).size.height / 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 20,
                                  offset: Offset.zero,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '- Near Wyoming Valley Mall -',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      Divider(),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: FutureBuilder<int>(
                                                    future: placeholder(),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot<int>
                                                                snapshot) {
                                                      switch (snapshot
                                                          .connectionState) {
                                                        case ConnectionState
                                                            .done:
                                                          return Container(
                                                            height:
                                                                double.infinity,
                                                            alignment: Alignment
                                                                .center,
                                                            child: BlocBuilder<
                                                                TimerBloc,
                                                                TimerState>(
                                                              builder: (context,
                                                                  state) {
                                                                return TextField(
                                                                  controller:
                                                                      new TextEditingController(
                                                                          text:
                                                                              'There is a sale at Aeropostale! Use code 71AE02 at checkout!'),
                                                                  focusNode:
                                                                      FocusNode(),
                                                                  autocorrect:
                                                                      true,
                                                                  enableInteractiveSelection:
                                                                      true,
                                                                  readOnly:
                                                                      true,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  maxLines:
                                                                      null,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.0),
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  autofocus:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                          break;
                                                        case ConnectionState
                                                            .waiting:
                                                          return (Container(
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ));
                                                          break;
                                                        default:
                                                          print('default');
                                                          return (Container(
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ));

                                                          break;
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(Icons.keyboard_arrow_up),
                                                  Icon(Icons
                                                      .keyboard_arrow_down),
                                                  Icon(Icons.comment)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Text(
                                                '78 votes',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  _verticalPosition = -300;
                                                });
                                              },
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Zone #93',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    left: 0,
                    bottom: _drawerPosition,
                    child: GestureDetector(
                      onPanEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dy < 100) {}
                      },
                      child: Hero(
                        tag: 'preferences',
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0))),
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 20,
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '- Near Wyoming Valley Mall - ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                        onPressed: () {
                                          if (_drawerPosition == 0 &&
                                              _verticalPosition == -300) {
                                            setState(
                                              () {
                                                _drawerPosition =
                                                    -(MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2 -
                                                        50);
                                              },
                                            );
                                          } else if (_drawerPosition ==
                                                  -(MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          2 -
                                                      50) &&
                                              _verticalPosition > 0) {
                                            setState(
                                              () {
                                                _verticalPosition = -300;
                                                _drawerPosition = 0;
                                              },
                                            );
                                          } else {
                                            setState(
                                              () {
                                                _drawerPosition = 0;
                                              },
                                            );
                                          }
                                        },
                                        textColor: Colors.orange[300],
                                        child: _drawerPosition < 0
                                            ? Text('Open')
                                            : Text('Close'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Container(
                                    child: playArea('edit',
                                        controller:
                                            new TextEditingController()),
                                  ),
                                ),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Container(
                                    color: Colors.green[300],
                                    child: ShakeAnimatedWidget(
                                      enabled: true,
                                      duration: Duration(milliseconds: 1000),
                                      shakeAngle: Rotation.deg(z: 20),
                                      curve: Curves.linear,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    child: ShakeAnimatedWidget(
                                      enabled: true,
                                      duration: Duration(milliseconds: 1000),
                                      shakeAngle: Rotation.deg(z: 20),
                                      curve: Curves.linear,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.image,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    child: ShakeAnimatedWidget(
                                      enabled: true,
                                      duration: Duration(milliseconds: 1000),
                                      shakeAngle: Rotation.deg(z: 20),
                                      curve: Curves.linear,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.music_note,
                                          color: Colors.orange[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    child: ShakeAnimatedWidget(
                                      enabled: true,
                                      duration: Duration(milliseconds: 1000),
                                      shakeAngle: Rotation.deg(z: 20),
                                      curve: Curves.linear,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.fiber_smart_record,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child:
                                            BlocConsumer<TimerBloc, TimerState>(
                                          listener: (context, state) {},
                                          builder: (context, state) {
                                            return Text(
                                              '${state.timeStamp}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('Tags:'),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            tags('music'),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            tags('sports'),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            tags('television'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<ReaderBloc>(context).add(ReadFile());
                                  
                                  // FirebaseFirestore.instance.collection('zones').add({

                                  // });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 8.0, 16.0, 16.0),
                                  child: Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Shimmer.fromColors(
                                      period:
                                          const Duration(milliseconds: 2500),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Submit Message Publicly',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(Icons.send),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      baseColor: Colors.green[300],
                                      highlightColor: Colors.grey[100],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 0.0, 16.0, 16.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Swipe up for configuration',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_up,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
              break;
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
            default:
              return Container(
                  child: Center(child: CircularProgressIndicator()));
              break;
          }
        },
      ),
    );
  }

  Widget tags(String title) {
    return Container(
      height: 30,
      width: 130,
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(60.0))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '$title',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playArea(String type, {TextEditingController controller}) {
    switch (type) {
      case 'edit':
        return TextField(
          controller: controller,
          maxLines: null,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 16.0),
          textAlignVertical: TextAlignVertical.top,
          autofocus: false,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'What\'s on your mind?',
              hintStyle: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey)),
        );
        break;
      case 'image':
        return Center(child: CircularProgressIndicator());
        break;
      case 'music':
        return Center(child: CircularProgressIndicator());
        break;
      case 'record':
        return Center(child: CircularProgressIndicator());
        break;
      default:
        return Center(child: CircularProgressIndicator());
        break;
    }
  }

  Future<int> placeholder() async {
    return await 0;
  }

  Future<String> loadData() async {
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (value) {
        cameraPosition = new CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            tilt: 15,
            zoom: 12);
        position = value;
      },
    );

    await Firebase.initializeApp();
    CollectionReference zoneCollection =
        FirebaseFirestore.instance.collection('zones');
    await zoneCollection.get().then(
      (value) {
        value.docs.forEach(
          (element) async {
            GeoPoint zoneCenter = element.data()['location'];
            _circles.add(
              Circle(
                circleId: CircleId(element.data()['id']),
                center: LatLng(zoneCenter.latitude, zoneCenter.longitude),
                radius: 8046.72,
                fillColor: Colors.redAccent.withOpacity(0.5),
                strokeWidth: 3,
                strokeColor: Colors.redAccent,
              ),
            );
            CollectionReference markerCollection =
                element.reference.collection('markers');
            await markerCollection.get().then(
              (value) {
                GeoPoint markerCenter = element.data()['location'];
                _markers.add(
                  Marker(
                      markerId: MarkerId(element.data()['id']),
                      position:
                          LatLng(markerCenter.latitude, markerCenter.longitude),
                      consumeTapEvents: true,
                      onTap: () {
                        // Move camera eventually and pull up post using BLOC events
                        if (_verticalPosition == -300 && _drawerPosition < 0) {
                          setState(() {
                            _verticalPosition =
                                (MediaQuery.of(context).size.height / 2) -
                                    (MediaQuery.of(context).size.height / 4) /
                                        2;
                          });
                        } else if (_verticalPosition == -300 &&
                            _drawerPosition == 0) {
                          setState(() {
                            _drawerPosition = _drawerPosition =
                                -(MediaQuery.of(context).size.height / 2 - 50);
                            _verticalPosition =
                                (MediaQuery.of(context).size.height / 2) -
                                    (MediaQuery.of(context).size.height / 4) /
                                        2;
                          });
                        } else {
                          setState(() {
                            _verticalPosition = -300;
                          });
                        }
                      },
                      icon: _pinIcon),
                );
              },
            );
          },
        );
      },
    );
    return 'ok';
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
