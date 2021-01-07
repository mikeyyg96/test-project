part of 'reader_bloc.dart';

abstract class ReaderState extends Equatable {
  const ReaderState();
  
  @override
  List<Object> get props => [];
}

class ReaderInitial extends ReaderState {}
