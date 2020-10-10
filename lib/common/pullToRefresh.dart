import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget buildPullToRefresh(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  if (pulledExtent < 15) {
    return Container();
  }
  switch (refreshState) {
    case RefreshIndicatorMode.inactive:
    case RefreshIndicatorMode.done:
    case RefreshIndicatorMode.armed:
    case RefreshIndicatorMode.refresh:
      return Container();
      break;
    case RefreshIndicatorMode.drag:
      return Center(
          child: Transform.rotate(
        angle: pulledExtent / 10,
        child: Container(
          width: 45,
          height: 45,
          child: Icon(
            EvaIcons.refresh,
            size: 20,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF282828),
          ),
        ),
      ));
      break;
  }

  return Container();
}
