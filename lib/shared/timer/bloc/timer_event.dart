part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}


class TimerFeedback extends TimerEvent {
  TimerFeedback({this.currentTime});
  final String currentTime;
}