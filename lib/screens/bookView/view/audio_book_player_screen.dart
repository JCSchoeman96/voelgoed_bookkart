import 'package:bookkart_flutter/screens/bookView/component/seek_bar_view.dart';
import 'package:bookkart_flutter/models/book_description/position_data_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class AudioBookPlayerScreen extends StatefulWidget {
  final String url;
  final String bookName;
  final String bookImage;

  AudioBookPlayerScreen({Key? key, required this.url, required this.bookImage, required this.bookName}) : super(key: key);

  @override
  State<AudioBookPlayerScreen> createState() => _AudioBookPlayerScreenState(url);
}

class _AudioBookPlayerScreenState extends State<AudioBookPlayerScreen> with WidgetsBindingObserver {
  String? url;
  late AudioPlayer audioPlayer;
  Duration totalDuration = Duration();
  ValueNotifier<ProgressBarState> progressNotifier = ValueNotifier<ProgressBarState>(ProgressBarState(current: Duration.zero, buffered: Duration.zero, total: Duration.zero));

  _AudioBookPlayerScreenState(this.url);

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.pause();
    audioPlayer.dispose();
    super.dispose();
  }

  void init() {
    WidgetsBinding.instance.addObserver(this);

    audioPlayer = AudioPlayer();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    totalDuration = await audioPlayer.setUrl(url.validate()) ?? Duration();
    await audioPlayer.setUrl(url.validate());

    audioPlayer.bufferedPositionStream.listen((event) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(current: oldState.current, buffered: event, total: oldState.total);
    });

    audioPlayer.positionStream.listen((event) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(current: event, buffered: oldState.buffered, total: oldState.total);
    });

    audioPlayer.play();

    setState(() {});
  }

  Widget showDuration() {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: progressNotifier,
      builder: (context, value, child) {
        return SeekBarView(
          duration: totalDuration,
          position: value.current,
          bufferedPosition: value.buffered,
          onChangeEnd: (newPosition) {
            audioPlayer.seek(newPosition);
            setState(() {});
          },
        );
      },
    );
  }

  Widget showAudioPlayer(ProcessingState? processingState, bool? playing) {
    if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
      return Container(margin: EdgeInsets.only(top: 20), child: CircularProgressIndicator());
    } else if (playing != true) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment(6.123234262925839e-17, 1),
            end: Alignment(-1, 6.123234262925839e-17),
            colors: [
              Color.fromRGBO(185, 205, 254, 1),
              Color.fromRGBO(182, 178, 255, 1),
            ],
          ),
        ),
        child: IconButton(
          key: Key(PLAY_BUTTON),
          onPressed: audioPlayer.play,
          iconSize: 42.0,
          icon: Icon(Icons.play_arrow),
          color: context.primaryColor,
        ).center(),
      );
    } else if (processingState != ProcessingState.completed) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment(6.123234262925839e-17, 1),
            end: Alignment(-1, 6.123234262925839e-17),
            colors: [
              Color.fromRGBO(185, 205, 254, 1),
              Color.fromRGBO(182, 178, 255, 1),
            ],
          ),
        ),
        child: IconButton(
          icon: Icon(Icons.pause),
          key: Key(PAUSE_BUTTON),
          onPressed: audioPlayer.pause,
          color: context.primaryColor,
          iconSize: 42.0,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 20),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment(6.123234262925839e-17, 1),
            end: Alignment(-1, 6.123234262925839e-17),
            colors: [
              Color.fromRGBO(185, 205, 254, 1),
              Color.fromRGBO(182, 178, 255, 1),
            ],
          ),
        ),
        child: IconButton(
          onPressed: () => audioPlayer.seek(Duration.zero),
          iconSize: 42.0,
          icon: Icon(Icons.replay),
          color: context.primaryColor,
        ),
      );
    }
  }

  Widget showBookImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 308,
          child: Stack(
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: LottieBuilder.asset('assets/json_image/json_app_loader_2.json'),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Text(
            widget.bookName.validate(),
            style: primaryTextStyle(size: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.bookName.validate()),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        height: context.height(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showBookImage(),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                return showAudioPlayer(processingState, playing);
              },
            ),
            showDuration(),
          ],
        ),
      ),
    );
  }
}
