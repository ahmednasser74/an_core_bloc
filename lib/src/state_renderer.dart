import 'package:an_core_ui/an_core_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'index.dart';

class StateRenderer extends StatelessWidget {
  final FlowState state;
  final Function? retryActionFunction;
  final double? maxContentHeight;
  final bool? isSliver;
  final bool? withScaffold;
  final String? errorImage, successImage, loadingImage, emptyImage;
  final String? errorTitle, successTitle, loadingTitle, emptyTitle;
  final String? errorMessage, successMessage, loadingMessage, emptyMessage;
  final String? successActionTitle;
  final Function? successAction;

  const StateRenderer({
    Key? key,
    required this.state,
    this.maxContentHeight,
    this.retryActionFunction,
    this.isSliver = false,
    this.withScaffold = false,
    this.loadingImage,
    this.emptyImage,
    this.errorImage,
    this.successImage,
    this.emptyTitle,
    this.errorTitle,
    this.loadingTitle,
    this.successTitle,
    this.emptyMessage,
    this.errorMessage,
    this.loadingMessage,
    this.successMessage,
    this.successActionTitle,
    this.successAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      constraints: BoxConstraints(maxHeight: 200.h),
      child: _getStateWidget(context),
    );
    if (isSliver!) {
      widget = SliverToBoxAdapter(
        child: widget,
      );
    }
    if (withScaffold!) {
      widget = Scaffold(body: widget);
    }
    return widget;
  }

  Widget? _getStateWidget(BuildContext context) {
    switch (state.runtimeType) {
      case LoadingState:
        switch (state.type) {
          case LoadingRendererType.popup:
            return _defaultPopUpLoadingWidget(context, loadingTitle, loadingImage, loadingMessage);
          case LoadingRendererType.content:
            return _defaultLoadingWidget(context, loadingTitle, loadingImage, loadingMessage);
        }
        break;
      case ErrorState:
        switch (state.type) {
          case ErrorRendererType.popup:
            return _getPopUpDialog(
              context,
              _defaultPopUpErrorWidget(context, errorTitle, errorImage, errorMessage, successActionTitle, successAction),
            );
          case ErrorRendererType.content:
            return _defaultErrorWidget(context, errorTitle, errorImage, errorMessage);
          case ErrorRendererType.none:
            return null;
        }
        break;
      case SuccessState:
        switch (state.type) {
          case SuccessRendererType.popup:
            return _getPopUpDialog(
              context,
              _defaultPopUpSuccessWidget(context, successTitle, successImage, successMessage, successActionTitle, successAction),
            );
          case SuccessRendererType.content:
            return _defaultSuccessWidget(context, successTitle, successImage, successMessage, successActionTitle, successAction);
        }
      case EmptyState:
        switch (state.type) {
          case EmptyRendererType.content:
            return _defaultEmptyView(context, emptyTitle, emptyImage, emptyMessage);
        }
      default:
        return Container();
    }
    return Container();
  }

  Widget _getPopUpDialog(BuildContext context, Widget widget) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
          ),
        ],
      ),
      child: widget,
    );
  }

  Widget _getDialogContent(List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName, {double? height, double? width}) {
    return AppContainer(
      height: height ?? 200.h,
      width: width ?? 200.w,
      alignment: Alignment.center,
      child: Lottie.asset(animationName, fit: BoxFit.fill),
    );
  }

  static Widget defaultLoading(String? image) {
    return SizedBox(
      height: 100.h,
      width: 140.h,
      child: Lottie.asset(image ?? JsonAssets.loading),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: RequestBuilderInitializer.instance.messageTextStyle,
        ),
      ),
    );
  }

  Widget _getTitle(String? message, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message ?? "",
          textAlign: TextAlign.center,
          style: RequestBuilderInitializer.instance.titleTextStyle ?? TextStyle(color: context.isDarkTheme ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context, Function()? onPress) {
    if (onPress == null) return Container();
    return Center(
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(buttonTitle),
      ),
    );
  }

  Widget _defaultPopUpLoadingWidget(BuildContext context, String? title, String? image, String? message) {
    return _getDialogContent([
      _getAnimatedImage(image ?? JsonAssets.loading, height: 100.h, width: 140.w),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
    ]);
  }

  Widget _defaultPopUpErrorWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
    String? actionTitle,
    Function? action,
  ) {
    return _getDialogContent([
      _getAnimatedImage(image ?? JsonAssets.error),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        actionTitle ?? 'ok'.translate,
        context,
        () {
          if (action != null) {
            action();
          } else {
            Navigator.pop(context);
          }
        },
      )
    ]);
  }

  Widget _defaultLoadingWidget(BuildContext context, String? title, String? image, String? message) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.loading, height: 100.h, width: 140.w),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
    ]);
  }

  Widget _defaultErrorWidget(BuildContext context, String? title, String? image, String? message) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.error),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        'retry'.translate,
        context,
        retryActionFunction == null ? null : () => retryActionFunction!(),
      )
    ]);
  }

  Widget _defaultSuccessWidget(BuildContext context, String? title, String? image, String? message, String? actionTitle, Function? action) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.success),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        actionTitle ?? 'ok'.translate,
        context,
        () {
          if (action != null) {
            action();
          } else {
            Navigator.pop(context);
          }
        },
      )
    ]);
  }

  Widget _defaultEmptyView(BuildContext context, String? title, String? image, String? message) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.empty),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
    ]);
  }

  Widget _defaultPopUpSuccessWidget(BuildContext context, String? title, String? image, String? message, String? actionTitle, Function? action) {
    return _getDialogContent([
      _getAnimatedImage(image ?? JsonAssets.success),
      _getTitle(state.title ?? title, context),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        actionTitle ?? 'ok'.translate,
        context,
        () {
          if (action != null) {
            action();
          } else {
            Navigator.pop(context);
          }
        },
      )
    ]);
  }
}
// class RenderViewParameters {
//   final String message;
//   final String subMessage;
//   final String errorBottomSheetButtonTitle;
//   final Function retryActionFunction;
//   final double? maxContentHeight;
//   final bool? isSliver;
//   final bool? withScaffold;

//   RenderViewParameters({
//     required this.message,
//     this.subMessage = "",
//     this.errorBottomSheetButtonTitle = "",
//     this.maxContentHeight,
//     required this.retryActionFunction,
//     this.isSliver = false,
//     this.withScaffold = false,
//   });
// }

