import 'package:equatable/equatable.dart';

import '../enum/index.dart';

abstract class FlowState<T> extends Equatable {
  final String? message;
  final String? title;

  T? get type;

  const FlowState({this.message, this.title});
}

class InitialState extends FlowState<NormalRendererType> {
  const InitialState();

  @override
  List<Object?> get props => [identityHashCode(this)];

  @override
  NormalRendererType? get type => NormalRendererType.content;
}

class LoadingState extends FlowState<LoadingRendererType> {
  const LoadingState({required this.type, super.title, super.message});

  @override
  final LoadingRendererType type;

  @override
  List<Object?> get props => [type, super.title, super.message, identityHashCode(this)];
}

class LoadingMoreState extends FlowState<LoadingRendererType> {
  const LoadingMoreState({required this.type, super.title, super.message});

  @override
  final LoadingRendererType type;

  @override
  List<Object?> get props => [type, super.title, super.message, identityHashCode(this)];
}

class ErrorState extends FlowState<ErrorRendererType> {
  const ErrorState({required this.type, super.title, super.message});

  @override
  final ErrorRendererType type;

  @override
  List<Object?> get props => [type, super.title, super.message, identityHashCode(this)];
}

class ContentState<T> extends FlowState<NormalRendererType> {
  const ContentState({this.data, this.randomInt, this.isLastPage = false});

  final int? randomInt;

  final T? data;

  final bool isLastPage;

  @override
  NormalRendererType? get type => NormalRendererType.content;

  @override
  List<Object?> get props => [randomInt, data, isLastPage, identityHashCode(this)];
}

class EmptyState extends FlowState<EmptyRendererType> {
  const EmptyState({super.message, super.title});

  @override
  final EmptyRendererType type = EmptyRendererType.content;

  @override
  List<Object?> get props => [super.title, super.message, identityHashCode(this)];
}

class SuccessState extends FlowState<SuccessRendererType> {
  const SuccessState({required this.type, super.title, super.message, this.data});

  @override
  final SuccessRendererType type;

  final dynamic data;

  @override
  List<Object?> get props => [
        type,
        super.title,
        super.message,
        data,
        identityHashCode(this),
      ];
}
