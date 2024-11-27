import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

class VideoBookPlayerScreen extends StatefulWidget {
  final DownloadModel downloads;

  VideoBookPlayerScreen({required this.downloads, Key? key}) : super(key: key);

  @override
  State<VideoBookPlayerScreen> createState() => _VideoBookPlayerScreenState();
}

class _VideoBookPlayerScreenState extends State<VideoBookPlayerScreen> with WidgetsBindingObserver {
  ChewieController? chewieCont;

  bool fileExist = false;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    WidgetsBinding.instance.addObserver(this);
    chewieCont = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.downloads.file.validate()),
      aspectRatio: 16 / 9,
      autoPlay: true,
      allowFullScreen: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      progressIndicatorDelay: Duration.zero,
      showControls: true,
      showOptions: true,
      materialProgressColors: ChewieProgressColors(backgroundColor: Colors.black, bufferedColor: primaryColor.withOpacity(0.3), playedColor: primaryColor, handleColor: primaryColor),
      placeholder: Lottie.asset(json_book_loader, height: 100, width: 100).center(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      chewieCont!.pause();
    } else {
      chewieCont!.play();
    }
  }

  @override
  void dispose() {
    chewieCont!.pause();
    chewieCont!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBarWidget(widget.downloads.name.validate()),
      body: Chewie(controller: chewieCont!).center().visible(chewieCont != null),
    );
  }
}
