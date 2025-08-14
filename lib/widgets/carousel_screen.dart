import 'dart:async';

import 'package:flutter/material.dart';

class CarouselScreen extends StatefulWidget {
  final List<String>?imglist;
  const CarouselScreen({Key? key,this.imglist}) : super(key: key);

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  int activePage = 0;
  late PageController _pageController;


  @override
  void initState() {
    super.initState();
    print(widget.imglist);
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: 0,
    );

    // Start automatic scrolling
    startAutoScroll();
  }

  @override
  void dispose() {
    // Dispose the page controller to avoid memory leaks
    _pageController.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    // Auto-scroll every 3 seconds
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        SizedBox(
          width: MediaQuery.of(context).size.width,
         height: 350,
          child: PageView.builder(
            itemCount: widget.imglist!.length,
            pageSnapping: true,
            controller: _pageController,
            onPageChanged: (page) {
              int currentPage = page % (widget.imglist!.length);
              setState(() => activePage = currentPage);
            },
            itemBuilder: (context, pagePosition) {
              int index = pagePosition % widget.imglist!.length;
              bool active = index == activePage;
              return slider(widget.imglist!, index, active);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageIndicator(widget.imglist!.length, activePage),
        ),

      ],
    );
  }
}

AnimatedContainer slider(images, pagePosition, active) {
  double margin = active ? 10 : 20;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    margin: EdgeInsets.all( margin),
    child: FadeInImage(
      placeholder: AssetImage('assets/img/house_placeholder.png'),
      image: NetworkImage('${images[pagePosition]}'),
      fit: BoxFit.cover,
    ),

  );
}

List<Widget> imageIndicator(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(

        color: currentIndex == index ? Colors.teal.shade400 : Colors.black26,
        shape: BoxShape.circle,

      ),
    );
  });
}