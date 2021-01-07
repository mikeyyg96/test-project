part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class AnimatePost extends HomeEvent {
  AnimatePost({this.opened});
  final bool opened;
}
