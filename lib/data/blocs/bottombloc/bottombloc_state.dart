part of 'bottombloc_bloc.dart';

abstract class BottomBlocState extends Equatable {
  const BottomBlocState();

  @override
  List<Object> get props => [];
}

class BottomBlocInitial extends BottomBlocState {}

class BottomNavigationCurrentState extends BottomBlocState {
  final int currentIndex;

  const BottomNavigationCurrentState({
    required this.currentIndex,
  });

  @override
  List<Object> get props => [currentIndex];
}
