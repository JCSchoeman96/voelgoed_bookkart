import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SeekBarView extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBarView({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarViewState createState() => _SeekBarViewState();
}

class _SeekBarViewState extends State<SeekBarView> {
  double? dragValue;

  void onSliderEnd(value) {
    if (widget.onChangeEnd != null) widget.onChangeEnd!(Duration(milliseconds: value.round()));

    dragValue = null;
  }

  void onSliderChange(value) {
    dragValue = value;
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(Duration(milliseconds: value.round()));
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackHeight: 2.0).copyWith(activeTrackColor: context.primaryColor, inactiveTrackColor: Colors.grey[300]),
          child: Slider(min: 0.0, max: widget.duration.inMilliseconds.toDouble(), value: widget.position.inMilliseconds.toDouble(), onChanged: onSliderChange, onChangeEnd: onSliderEnd),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Text('${widget.position.toString().split('.').first} / ${widget.duration.toString().split('.').first}', style: primaryTextStyle(size: 14)),
        ),
      ],
    );
  }
}
