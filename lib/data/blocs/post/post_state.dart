// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoadingState extends PostState {}

class CreatePostSucessState extends PostState {}

class PostErrorState extends PostState {
  final String error;
  const PostErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
