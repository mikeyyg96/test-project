import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_poppin_v3/screens/home/bloc/home_bloc.dart';
import 'package:whats_poppin_v3/shared/read_file/bloc/reader_bloc.dart';

import 'screens/home/home_screen.dart';
import 'shared/timer/bloc/timer_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whats Poppin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => HomeBloc(),
          ),
          BlocProvider<TimerBloc>(
            create: (BuildContext context) => TimerBloc(),
          ),
          BlocProvider<ReaderBloc>(
            create: (BuildContext context) => ReaderBloc(),
          )
        ],
        child: HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
