// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:student_service/data/BannerEntity.dart';
// import 'package:student_service/widgets/image.dart';

// class BannerSlider extends StatefulWidget {
//   final List<BannerEntity> banners;
//   const BannerSlider({
//     Key? key,
//     required this.banners,
//   }) : super(key: key);

//   @override
//   _BannerSliderState createState() => _BannerSliderState();
// }

// class _BannerSliderState extends State<BannerSlider> {
//   final PageController _controller = PageController();
//   int _currentPageIndex = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
//       if (_currentPageIndex < widget.banners.length - 1) {
//         _currentPageIndex++;
//       } else {
//         _currentPageIndex = 0;
//       }
//       _controller.animateToPage(_currentPageIndex,
//           duration: Duration(milliseconds: 500), curve: Curves.ease);
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 2,
//       child: Stack(
//         children: [
//           PageView.builder(
//             controller: _controller,
//             itemCount: widget.banners.length,
//             physics: BouncingScrollPhysics(),
//             itemBuilder: (context, index) => _Slide(
//               banner: widget.banners[index],
//             ),
//             onPageChanged: (int pageIndex) {
//               setState(() {
//                 _currentPageIndex = pageIndex;
//               });
//             },
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 8,
//             child: Center(
//               child: SmoothPageIndicator(
//                 controller: _controller,
//                 count: widget.banners.length,
//                 axisDirection: Axis.horizontal,
//                 effect: WormEffect(
//                   spacing: 4.0,
//                   radius: 4.0,
//                   dotWidth: 20.0,
//                   dotHeight: 6.0,
//                   paintStyle: PaintingStyle.fill,
//                   strokeWidth: 1.5,
//                   dotColor: Colors.grey.shade500,
//                   activeDotColor: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Slide extends StatelessWidget {
//   final BannerEntity banner;

//   const _Slide({
//     Key? key,
//     required this.banner,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, right: 12),
//       child: ImageLoadingService(
//         borderRadius: BorderRadius.circular(12),
//         imageUrl: banner.imageUrl,
//       ),
//     );
//   }
// }
