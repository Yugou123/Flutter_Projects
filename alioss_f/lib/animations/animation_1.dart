
import 'package:flutter/cupertino.dart';

class MyAnimatedWidget extends AnimatedWidget{
  final Widget child;
  MyAnimatedWidget(this.child,{Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child:  Transform(
        alignment: Alignment.center,
        transform: Transform.rotate(angle: animation.value,alignment: Alignment.center,).transform,
        child: child,
      ),
    );
  }

}