import 'package:carousel_slider/carousel_slider.dart';

CarouselOptions carouselOptions(double aspectRatio) => CarouselOptions(
  aspectRatio: aspectRatio,
  viewportFraction: 0.3,
  enableInfiniteScroll: true,
  autoPlay: true,
  autoPlayInterval: const Duration(milliseconds: 3000),
  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
  // enlargeCenterPage: true,
  // enlargeFactor: 0.5,
);
