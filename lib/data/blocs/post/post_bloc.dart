import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin_clone/data/models/post_model.dart';
import 'package:linkedin_clone/data/services/post_services.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final postService = PostServices();
  PostBloc() : super(PostInitial()) {
    on<PostEvent>((event, emit) {
      if (event is CreatePostEvent) {
        emit(PostLoadingState());
        postService.createPost(event.post);
        emit(CreatePostSucessState());
      }
    });
  }
}
