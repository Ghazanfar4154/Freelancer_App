import 'package:flutter/material.dart';
import 'dart:async';

class ImageSlider extends StatefulWidget {
  final List<String> imagePaths;
  ImageSlider({super.key, required this.imagePaths});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late List<Widget> pages;
  int activePage = 0;
  PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    pages = List.generate(
      widget.imagePaths.length,
          (index) => ImagePlaceHolder(
        imagePath: widget.imagePaths[index],
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (activePage < widget.imagePaths.length - 1) {
        activePage++;
      } else {
        activePage = 0;
      }
      _pageController.animateToPage(
        activePage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            onPageChanged: (value) {
              setState(() {
                activePage = value;
              });
            },
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                pages.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    backgroundColor: activePage == index
                        ? Colors.yellow
                        : Colors.grey,
                    radius: 4,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  final String imagePath;
  ImagePlaceHolder({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );
  }
}
