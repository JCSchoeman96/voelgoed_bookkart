import 'dart:math' as math show sin, pi;

import 'package:flutter/widgets.dart';

enum SpinKitWaveType { start, end, center }

class Wave extends StatefulWidget {
  const Wave({
    Key? key,
    this.color,
    this.type = SpinKitWaveType.start,
    this.size = 50.0,
    this.itemBuilder,
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null), 'You should specify either a itemBuilder or a color'),
        assert(itemCount >= 2, 'itemCount Cant be less then 2 '),
        super(key: key);

  final Color? color;
  final int itemCount;
  final double size;
  final SpinKitWaveType type;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  WaveState createState() => WaveState();
}

class WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> bars = getAnimationDelay(widget.itemCount);
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 1.25, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bars.length, (i) {
            return ScaleYWidget(
              scaleY: DelayTween(begin: .4, end: 1.0, delay: bars[i]).animate(controller),
              child: SizedBox.fromSize(size: Size(widget.size / widget.itemCount, widget.size), child: itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  List<double> getAnimationDelay(int itemCount) {
    switch (widget.type) {
      case SpinKitWaveType.start:
        return startAnimationDelay(itemCount);
      case SpinKitWaveType.end:
        return endAnimationDelay(itemCount);
      case SpinKitWaveType.center:
      default:
        return centerAnimationDelay(itemCount);
    }
  }

  List<double> startAnimationDelay(int count) {
    return [
      ...List<double>.generate(count ~/ 2, (index) => -1.0 - (index * 0.1) - 0.1).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 + (index * 0.1) + (count.isOdd ? 0.1 : 0.0),
      ),
    ];
  }

  List<double> endAnimationDelay(int count) {
    return [
      ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.1) + 0.1).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(
        count ~/ 2,
        (index) => -1.0 - (index * 0.1) - (count.isOdd ? 0.1 : 0.0),
      ),
    ];
  }

  List<double> centerAnimationDelay(int count) {
    return [
      ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.2) + 0.2).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.2) + 0.2),
    ];
  }

  Widget itemBuilder(int index) {
    return widget.itemBuilder != null ? widget.itemBuilder!(context, index) : DecoratedBox(decoration: BoxDecoration(color: widget.color));
  }
}

class ScaleYWidget extends AnimatedWidget {
  const ScaleYWidget({
    Key? key,
    required Animation<double> scaleY,
    required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key, listenable: scaleY);

  final Widget child;
  final Alignment alignment;

  Animation<double> get scale {
    return listenable as Animation<double>;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(transform: Matrix4.identity()..scale(1.0, scale.value, 1.0), alignment: alignment, child: child);
  }
}

class DelayTween extends Tween<double> {
  DelayTween({
    double? begin,
    double? end,
    required this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) {
    return lerp(animation.value);
  }
}
