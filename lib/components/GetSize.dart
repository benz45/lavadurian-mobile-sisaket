import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

typedef void OnWidgetSizeChange(Size size);

class GetSizeRenderObject extends RenderProxyBox {
  Size oldSize;
  final Function onChange;

  GetSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child.size;
    if (oldSize == newSize) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      oldSize = newSize;
      onChange(newSize);
    });
  }
}

class GetSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const GetSize({
    Key key,
    @required this.onChange,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GetSizeRenderObject(onChange);
  }
}
