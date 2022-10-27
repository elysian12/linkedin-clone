part of 'bottombloc_bloc.dart';

abstract class BottomBlocEvent extends Equatable {
  const BottomBlocEvent();

  @override
  List<Object> get props => [];
}

class ChangePageEvent extends BottomBlocEvent {
  final int pageIndex;

  const ChangePageEvent({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}
