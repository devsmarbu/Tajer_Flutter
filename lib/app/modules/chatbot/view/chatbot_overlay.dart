import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/chatbot_controller.dart';

/// App-wide overlay that hosts the embedded Tajer chatbot. The chatbot renders
/// its own floating bubble/panel directly inside a transparent, full-screen
/// WebView. Only the rectangle the widget actually occupies is interactive —
/// every other touch falls through to the app underneath.
class ChatbotOverlay extends StatelessWidget {
  const ChatbotOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatbotController>()) return const SizedBox.shrink();
    final c = Get.find<ChatbotController>();

    return Obx(() {
      final controller = c.webController;
      if (controller == null) return const SizedBox.shrink();

      final mq = MediaQuery.of(context);
      final keyboard = mq.viewInsets.bottom;

      // When the chat is open, the whole WebView is interactive (so the message
      // input reliably gets taps/typing). When it's just the bubble, only the
      // measured bubble region is interactive and everything else falls through
      // to the app. Treat a tall measured region as "open" too, as a fallback.
      final rect = c.widgetRect.value;
      final treatOpen = c.isChatOpen.value ||
          (rect != null && rect.height > mq.size.height * 0.5);
      final Rect? hitRect = !c.isReady.value
          ? null
          : (treatOpen ? (Offset.zero & mq.size) : rect);
      // If open, the chatbot fills the screen.
      // If closed, we size the Positioned wrapper height to end exactly above the tab bar (e.g. subtracting 80 pixels).
      // This leaves the bottom tab bar area completely free of the WebView on the native layer.
      if (treatOpen) {
        final double topInset = mq.viewPadding.top;
        final double bottomInset = keyboard > 0 ? keyboard : mq.viewPadding.bottom;

        return Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
            child: WebViewWidget(controller: controller),
          ),
        );
      } else {
        return Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 80, // Ends exactly above the bottom tab bar (allowing bottomInset: 0)
          child: _ChatHitArea(
            hitRect: hitRect,
            child: WebViewWidget(controller: controller),
          ),
        );
      }
    });
  }
}

/// Forwards pointer events to its child only inside [hitRect]; outside it,
/// hit-testing fails so widgets below in the parent [Stack] (the app) receive
/// the touch instead.
class _ChatHitArea extends SingleChildRenderObjectWidget {
  const _ChatHitArea({required this.hitRect, required Widget child})
      : super(child: child);

  final Rect? hitRect;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderChatHitArea(hitRect);

  @override
  void updateRenderObject(BuildContext context, _RenderChatHitArea renderObject) {
    renderObject.hitRect = hitRect;
  }
}

class _RenderChatHitArea extends RenderProxyBox {
  _RenderChatHitArea(this._hitRect);

  Rect? _hitRect;

  set hitRect(Rect? value) {
    if (value != _hitRect) {
      _hitRect = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final rect = _hitRect;
    if (rect == null) return false; // nothing interactive
    if (!rect.contains(position)) return false; // fall through to the app
    return super.hitTest(result, position: position);
  }
}
