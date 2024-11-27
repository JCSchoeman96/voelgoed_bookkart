import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/widgets/folding_cubes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class AppLoader extends StatefulWidget {
  final bool? loadingVisible;
  final bool isObserver;
  final double? size;

  const AppLoader({this.loadingVisible, this.size, Key? key, this.isObserver = false}) : super(key: key);

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool hasNet = true;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      didUpdate();
    }
  }

  Future<void> didUpdate() async {
    hasNet = await isNetworkAvailable();
  }

  @override
  Widget build(BuildContext context) {
    if (hasNet) {
      if (widget.isObserver) {
        return Observer(
          builder: (context) {
            return Center(
              child: SpinKitFoldingCube(
                size: widget.size ?? 50,
                color: context.primaryColor,
              ).visible(widget.loadingVisible != null ? (appStore.isLoading && widget.loadingVisible.validate()) : appStore.isLoading),
            );
          },
        );
      } else {
        return Center(child: SpinKitFoldingCube(color: context.primaryColor));
      }
    }
    return Offstage();
  }
}
