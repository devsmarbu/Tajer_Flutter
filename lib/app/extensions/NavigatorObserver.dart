
import 'package:flutter/cupertino.dart';

class RouteObserverWidget extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint("🟢 Pushed route: ${route.settings.name}");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint("🔴 Popped route: ${route.settings.name}");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint("🔁 Replaced route: ${newRoute?.settings.name}");
  }
}