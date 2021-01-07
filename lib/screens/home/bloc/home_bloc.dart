import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  //HomeBloc() : super(HomeInitial(verticalPosition: -300, timeStamp: DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now())));
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is AnimatePost) {
      yield HomeInitial(verticalPosition: _getVerticalPosition(event.opened));
    }
  }

  double _getVerticalPosition(bool opened) {
    return opened ? 0 : -300;
  }

}