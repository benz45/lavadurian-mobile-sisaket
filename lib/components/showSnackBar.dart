import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void showSnackBar(context, String text) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      action: SnackBarAction(label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

void showFlashBar(
  context, {
  String title,
  String message,
  bool success = false,
  bool error = false,
  bool warning = false,
  int duration = 2000,
}) {
  Widget _flashBar = new FlashBar(
    title: title != null
        ? Text(
            '$title',
            style: Theme.of(context).textTheme.headline6,
          )
        : null,
    content: message != null
        ? Text(
            '$message',
            style: Theme.of(context).textTheme.subtitle1,
          )
        : null,
    icon: Icon(
      success
          ? Icons.check
          : warning
              ? Icons.warning_amber_rounded
              : error
                  ? Icons.error_outline
                  : Icons.info,
      color: success
          ? Colors.green[300]
          : warning
              ? Colors.yellow[700]
              : error
                  ? Colors.red[300]
                  : Colors.grey[300],
    ),
    shouldIconPulse: false,
    /* leftBarIndicatorColor: success
        ? Colors.green[300]
        : warning
            ? Colors.yellow[700]
            : error
                ? Colors.red[300]
                : Colors.grey[300], */
  );

  showFlash(
    context: context,
    duration: Duration(milliseconds: duration),
    builder: (context, controller) {
      return Flash.bar(
          controller: controller,
          backgroundGradient: LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          position: FlashPosition.bottom,
          // enableDrag: true,
          horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
          margin: const EdgeInsets.all(8),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.fastOutSlowIn,
          child: _flashBar);
    },
  );
}
