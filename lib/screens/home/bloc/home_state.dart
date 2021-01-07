part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState({this.verticalPosition});
  final double verticalPosition;

  @override
  List<Object> get props => [verticalPosition];
}

class HomeInitial extends HomeState {
  HomeInitial({double verticalPosition})
   : super(verticalPosition: verticalPosition);
}