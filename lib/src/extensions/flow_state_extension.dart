import 'dart:ui';

import 'package:an_core_ui/an_core_ui.dart';
import 'package:flutter/material.dart';

import '../bloc/index.dart';
import '../bloc/request_builder.dart';
import '../enum/index.dart';
import '../index.dart';

extension FlowStateExtension on FlowState {
  Widget flowStateBuilder(
    BuildContext context, {
    required Widget screenContent,
    required Function retry,
    Widget? loadingView,
    Widget? errorView,
    Widget? emptyView,
    Widget? successView,
    double? maxContentHeight,
    String? errorImage,
    String? successImage,
    String? loadingImage,
    String? emptyImage,
    String? errorTitle,
    String? successTitle,
    String? loadingTitle,
    String? emptyTitle,
    String? errorMessage,
    String? successMessage,
    String? loadingMessage,
    String? emptyMessage,
    String? successActionTitle,
    bool? isSliver = false,
    bool? withScaffold = false,
    Function? successAction,
  }) {
    final instance = RequestBuilderInitializer.instance;
    switch (runtimeType) {
      case InitialState:
        Widget w = const Center();
        if (isSliver!) {
          w = SliverToBoxAdapter(
            child: w,
          );
        }
        return w;

      case ContentState:
        {
          return screenContent;
        }

      case LoadingState:
        {
          String? loadingTitle0 = loadingTitle ?? instance.loadingTitle;
          final loadingImage0 = loadingImage ?? instance.loadingImage;
          final loadingMessage0 = loadingMessage ?? instance.loadingMessage;
          loadingTitle0 ??= 'loading'.translate;

          if (type == LoadingRendererType.content) {
            Widget? content = loadingView;
            content ??= instance.loadingView;
            content ??= StateRenderer(
              loadingTitle: loadingTitle0,
              loadingImage: loadingImage0,
              loadingMessage: loadingMessage0,
              state: this,
              retryActionFunction: retry,
              maxContentHeight: maxContentHeight,
              isSliver: isSliver,
              withScaffold: withScaffold,
            );
            // full screen loading state
            return content;
          } else {
            // show content ui of the screen
            return screenContent;
          }
        }
      case ErrorState:
        {
          if (type == ErrorRendererType.content) {
            String? errorTitle0 = errorTitle ?? instance.errorTitle;
            final errorImage0 = errorImage ?? instance.errorImage;
            final errorMessage0 = errorMessage ?? instance.errorMessage;
            errorTitle0 ??= 'error'.translate;

            Widget? content = errorView;
            content ??= instance.errorView;
            content ??= StateRenderer(
              errorTitle: errorTitle0,
              errorImage: errorImage0,
              errorMessage: errorMessage0,
              successActionTitle: successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: retry,
              maxContentHeight: maxContentHeight,
              isSliver: isSliver,
              withScaffold: withScaffold,
            );
            // full screen error state
            return content;
          } else {
            return screenContent;
          }
        }
      case EmptyState:
        {
          String? emptyTitle0 = emptyTitle ?? instance.emptyTitle;
          final emptyImage0 = emptyImage ?? instance.emptyImage;
          final emptyMessage0 = emptyMessage ?? instance.emptyMessage;
          emptyTitle0 ??= 'noData'.translate;

          Widget? content = emptyView;
          content ??= instance.emptyView;
          content ??= StateRenderer(
            emptyTitle: emptyTitle0,
            emptyImage: emptyImage0,
            emptyMessage: emptyMessage0,
            state: this,
            retryActionFunction: () {},
            maxContentHeight: maxContentHeight,
            isSliver: isSliver,
            withScaffold: withScaffold,
          );
          return content;
        }
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          if (type == SuccessRendererType.content) {
            String? successTitle0 = successTitle ?? instance.successTitle;
            final successImage0 = successImage ?? instance.successImage;
            final successMessage0 = successMessage ?? instance.successMessage;
            successTitle0 ??= 'success'.translate;

            Widget? content = successView;
            content ??= instance.successView;
            content ??= StateRenderer(
              successTitle: successTitle0,
              successImage: successImage0,
              successMessage: successMessage0,
              successActionTitle: successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: retry,
              maxContentHeight: maxContentHeight,
              isSliver: isSliver,
              withScaffold: withScaffold,
            );
            // full screen success state
            return content;
          } else {
            return screenContent;
          }
        }
      default:
        {
          return screenContent;
        }
    }
  }

  void flowStateListener(
    BuildContext context, {
    Function? retry,
    Widget? popUpLoadingView,
    Widget? popUpErrorView,
    Widget? popUpSuccessView,
    double? maxContentHeight,
    String? errorImage,
    String? successImage,
    String? loadingImage,
    String? emptyImage,
    String? errorTitle,
    String? successTitle,
    String? loadingTitle,
    String? emptyTitle,
    String? errorMessage,
    String? successMessage,
    String? loadingMessage,
    String? emptyMessage,
    String? successActionTitle,
    Function? successAction,
  }) {
    dismissDialog(context);
    final instance = RequestBuilderInitializer.instance;
    switch (runtimeType) {
      case LoadingState:
        {
          if (type == LoadingRendererType.popup) {
            String? loadingTitle0 = loadingTitle ?? instance.loadingTitle;
            final loadingImage0 = loadingImage ?? instance.loadingImage;
            final loadingMessage0 = loadingMessage ?? instance.loadingMessage;
            loadingTitle0 ??= 'loading'.translate;

            Widget? content = popUpLoadingView;
            content ??= instance.popUpLoadingView;
            content ??= StateRenderer(
              loadingTitle: loadingTitle0,
              loadingImage: loadingImage0,
              loadingMessage: loadingMessage0,
              state: this,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight,
            );
            // show popup loading
            showPopup(context, content, dismiss: false);
          }
        }
        break;
      case ErrorState:
        {
          String? errorTitle0 = errorTitle ?? instance.errorTitle;
          final errorImage0 = errorImage ?? instance.errorImage;
          final errorMessage0 = errorMessage ?? instance.errorMessage;
          errorTitle0 ??= 'error'.translate;

          if (type == ErrorRendererType.popup) {
            Widget? content = popUpErrorView;
            content ??= instance.popUpErrorView;
            content ??= StateRenderer(
              errorTitle: errorTitle0,
              errorImage: errorImage0,
              errorMessage: errorMessage0,
              successActionTitle: successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight,
            );
            // show popup error
            showPopup(context, content);
          } else if (type == ErrorRendererType.toast) {
            if (RequestBuilderInitializer.instance.onErrorToast != null) {
              RequestBuilderInitializer.instance.onErrorToast!(
                title: errorTitle0,
                message: message ?? errorMessage0 ?? "",
              );
            } else {
              ToastHelper.showCustomToast(
                context: context,
                title: errorTitle0,
                message: message ?? errorMessage0 ?? "",
                color: instance.errorColor,
              );
            }
          }
        }
        break;
      case SuccessState:
        {
          String? successTitle0 = successTitle ?? instance.successTitle;
          final successImage0 = successImage ?? instance.successImage;
          final successMessage0 = successMessage ?? instance.successMessage;
          successTitle0 ??= 'success'.translate;

          // i should check if we are showing loading popup to remove it before showing success popup
          if (type == SuccessRendererType.popup) {
            Widget? content = popUpSuccessView;
            content ??= instance.popUpSuccessView;
            content ??= StateRenderer(
              successTitle: successTitle0,
              successImage: successImage0,
              successMessage: successMessage0,
              successActionTitle: successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight,
            );
            // show popup error
            showPopup(context, content);
          } else if (type == SuccessRendererType.toast) {
            if (RequestBuilderInitializer.instance.onSuccessToast != null) {
              RequestBuilderInitializer.instance.onSuccessToast!(
                title: successTitle0,
                message: message ?? successMessage0 ?? "",
              );
            } else {
              ToastHelper.showCustomToast(
                context: context,
                title: successTitle0,
                message: message ?? successMessage0 ?? "",
                color: instance.mainColor,
              );
            }
          }
        }
        break;
      case EmptyState:
      case ContentState:
        break;
    }
  }

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing) {
      _isCurrentDialogShowing = false;
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
    BuildContext context,
    Widget widget, {
    bool dismiss = true,
  }) async {
    final color = RequestBuilderInitializer.instance.popUpBackground;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isCurrentDialogShowing = true;
      await showDialog(
        barrierColor: color ?? Colors.black.withOpacity(0.5),
        barrierDismissible: dismiss,
        context: context,
        builder: (BuildContext context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: widget,
          ),
        ),
      );
      _isCurrentDialogShowing = false;
    });
  }
}

bool _isCurrentDialogShowing = false;
