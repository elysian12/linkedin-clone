import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottombloc_event.dart';
part 'bottombloc_state.dart';

class BottomBloc extends Bloc<BottomBlocEvent, BottomBlocState> {
  BottomBloc() : super(BottomBlocInitial()) {
    on<BottomBlocEvent>((event, emit) {
      if (event is ChangePageEvent) {
        emit(BottomNavigationCurrentState(currentIndex: event.pageIndex));
      }
    });
  }
}
