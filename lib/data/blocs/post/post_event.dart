part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostEvent extends PostEvent {
  final Post post;
  const CreatePostEvent({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
