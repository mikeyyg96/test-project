part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  const TimerState({this.timeStamp});
  final String timeStamp;

  @override
  List<Object> get props => [timeStamp];
}

class TimerInitial extends TimerState {
  TimerInitial({String timeStamp}) : super(timeStamp: timeStamp);
}
