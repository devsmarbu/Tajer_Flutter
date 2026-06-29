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
      final double topInset = treatOpen ? mq.viewPadding.top : 0;
      final double bottomInset =
      keyboard > 0 ? keyboard : (treatOpen ? mq.viewPadding.bottom : 0);


      return Positioned.fill(
        child: _ChatHitArea(
          // Interactive area: full screen when chat is open, just the bubble
          // when closed, null before ready.
          hitRect: hitRect,
          child: Padding(
            // Shrink the WebView above the keyboard so the chat input stays
            // visible while typing.
            padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
            child: WebViewWidget(controller: controller),
          ),
        ),
      );
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
