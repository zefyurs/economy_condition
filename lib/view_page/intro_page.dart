import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final controller = LiquidController();
  final _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  final List bgImage = [
    Image.asset("assets/images/bg_1.jpeg"),
    Image.asset("assets/images/bg_2.jpeg"),
    Image.asset("assets/images/bg_3.jpeg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '신세경',
          style: GoogleFonts.blackHanSans(
              textStyle: const TextStyle(fontSize: 50, letterSpacing: 2.0, fontStyle: FontStyle.italic, height: 5.0)),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.black,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        children: [
          SpeedDialChild(
            labelBackgroundColor: Colors.white,
            labelStyle: const TextStyle(color: Colors.black),
            backgroundColor: Colors.white,
            child: const Icon(Icons.movie, color: Colors.black),
            label: '작품소개',
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )
        ],
      ),
      body: Stack(
        children: [
          // * Page view는 여러 위젯들을 스크롤을 통해 전환가능한 위젯이다.
          PageView(
            onPageChanged: (pageNo) {
              setState(() {
                currentPage = pageNo;
              });
            },
            pageSnapping: false,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            children: [
              stackImage(context, bgImage[0].image),
              stackImage(context, bgImage[1].image),
              stackImage(context, bgImage[2].image),
            ],
          ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    onDotClicked: (index) => _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
                    effect: const WormEffect(
                      spacing: 16,
                      dotColor: Colors.white54,
                      activeDotColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Stack liquidSwipe() {
    return Stack(
      children: [
        LiquidSwipe(
          liquidController: controller,
          enableSideReveal: true,
          onPageChangeCallback: (page) {
            setState(() {
              page = page;
            });
          },
          slideIconWidget: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
          pages: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/bg_1.jpeg"), fit: BoxFit.cover)),
            ),
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/bg_2.jpeg"), fit: BoxFit.cover)),
            ),
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/bg_3.jpeg"), fit: BoxFit.cover)),
            ),
          ],
          waveType: WaveType.liquidReveal,
          enableLoop: true,
          fullTransitionValue: 100,
          positionSlideIcon: 0.9,
          currentUpdateTypeCallback: (updateType) => updateType,
        ),
        Positioned(
            bottom: 0,
            left: 16,
            right: 32,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      child: Text('skip'),
                      onPressed: () {
                        controller.animateToPage(page: 2, duration: 400);
                      }),
                  AnimatedSmoothIndicator(
                    activeIndex: controller.currentPage.toInt(),
                    count: 3,
                    effect: const WormEffect(
                      spacing: 16,
                      dotColor: Colors.white54,
                      activeDotColor: Colors.white,
                    ),
                    onDotClicked: (index) {
                      controller.animateToPage(page: index);
                    },
                  ),
                  TextButton(
                      child: Text('next'),
                      onPressed: () {
                        final page = controller.currentPage + 1;

                        controller.animateToPage(page: page > 3 ? 0 : page, duration: 400);
                      })
                ],
              ),
            ))
      ],
    );
  }

  Stack stackImage(BuildContext context, ImageProvider img) {
    return Stack(
      children: [
        Image(
            image: img,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover),
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       // ElevatedButton(onPressed: () {}, child: Text("로그인")),
        //       Container(
        //         width: 200,
        //         height: 200,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(16),
        //           image: const DecorationImage(
        //               image: AssetImage("assets/images/bg_2.jpeg"), fit: BoxFit.cover, opacity: 0.9),
        //         ),
        // BlurryContainer(
        //   padding: EdgeInsets.all(20),
        //   width: 300,
        //   height: 200,
        //   elevation: 0,
        //   blur: 20,
        //   borderRadius: BorderRadius.all(Radius.circular(16)),
        //   child:
        //     // color: Colors.white.withOpacity(0.2),
        //   ),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Column(
        //       children: [
        //         Text(
        //           '배우 신세경',
        //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        //         )
        //       ],
        //     )
        //   ],
        // ),
        // ),
        // SizedBox(height: 50),
      ],
    );
  }
}
