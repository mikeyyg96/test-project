import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerInitial(timeStamp: DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerFeedback) {
      yield TimerInitial(timeStamp: _getTime(event.currentTime));
    }
  }

  String _getTime(String initialTime) {
  final DateTime now = DateTime.now();
  final String formattedDateTime = _formatDateTime(now);
    initialTime = formattedDateTime;
    return initialTime;
}

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm a').format(dateTime);
  }
}
