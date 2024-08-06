import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(AniProps.opacity, Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500))
      ..tween(AniProps.translateY, Tween(begin: -30.0, end: .0),
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

    return PlayAnimationBuilder(
        delay: Duration(milliseconds: (500 * delay).round()),
        duration: tween.duration,
        tween: tween,
        child: child,
        builder: (context, child, value) {
          // if (value == null) return const SizedBox();
          return Opacity(
            opacity: child.get(AniProps.opacity),
            child: Transform.translate(
                offset: Offset(0, child.get(AniProps.translateY)),
                child: value),
          );
        });
  }
}
