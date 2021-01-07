import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc() : super(ReaderInitial());

  @override
  Stream<ReaderState> mapEventToState(
    ReaderEvent event,
  ) async* {
    if (event is ReadFile) {
      List<String> entries = new List<String>();
      await rootBundle.loadString('assets/map/counties.txt').then((value) {
        for (String i in LineSplitter().convert(value)) {
          entries.add(value);
        }
      });
      print(entries.length);
    }
  }
}


Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile() async {
  final path = await _localPath();
  return File('$path/test.txt');
}

Future<String> _readCSV() async {
  final file = await _localFile();
  String contents = await file.readAsString();
  return contents;
}