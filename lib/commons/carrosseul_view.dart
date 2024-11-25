import 'dart:async'; // Para o Timer usado no autoPlay
import 'package:flutter/material.dart'; // Para widgets e UI do Flutter

class CarouselView extends StatefulWidget {
  final List<Widget> children;
  final double itemExtent;
  final bool itemSnapping;
  final EdgeInsetsGeometry padding;
  final bool autoPlay;
  final Duration autoPlayInterval;

  CarouselView({
    required this.children,
    this.itemExtent = 300.0,
    this.itemSnapping = false,
    this.padding = EdgeInsets.zero,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  _CarouselViewState createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  late PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: widget.itemSnapping ? 0.8 : 1.0, // Controla o "snapping"
    );
    if (widget.autoPlay) {
      _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
        int nextPage =
            (_controller.page!.toInt() + 1) % widget.children.length;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        height: widget.itemExtent,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.children.length,
          itemBuilder: (context, index) {
            return widget.children[index];
          },
        ),
      ),
    );
  }
}
