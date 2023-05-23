import 'package:flutter/material.dart';

enum MarkerType{
  convenience,mart, cafe,department, restaurant
}

class ExhibitionMarker extends StatefulWidget {
  const ExhibitionMarker({
    Key? key,
    required this.type,
    required this.onFinishRendering,
  }) : super(key: key);

  final void Function(GlobalKey globalKey, MarkerType type) onFinishRendering;
  final MarkerType type;

  @override
  State<ExhibitionMarker> createState() => _ExhibitionMarkerState();
}

class _ExhibitionMarkerState extends State<ExhibitionMarker> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      loadTheMarker();
    });
  }

  Future<void> loadTheMarker() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onFinishRendering(_globalKey, widget.type);
    });
  }

  Widget _renderAMarker() { //실제구현
    if (widget.type == MarkerType.convenience) {
      return Image.asset('assets/marker_images/GS25_bi_(2019).svc');
    }
    else if (widget.type == MarkerType.mart) {
      return Image.asset('');
    }
    else if (widget.type == MarkerType.cafe) {
      return Image.asset('');
    }
    else if (widget.type == MarkerType.department) {
      return Image.asset('');
    }
    return Image.asset('');
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: _renderAMarker(),
    );
  }
}

Future<BitmapDescriptor?> convertWidgetToPNG(GlobalKey globalKey) async {
  RenderObject? boundary = globalKey.currentContext?.findRenderObject();

  if (boundary != null && boundary is RenderRepaintBoundary) {
    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes != null) {
      return BitmapDescriptor.fromBytes(pngBytes);
    }
  }

  return null;
}