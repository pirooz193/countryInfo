import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const ImageLoadingService({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if ((width != null || height != null) && fit != null) {
      image = CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(child: SizedBox(
          width: 20,
        height: 20,
          child: CircularProgressIndicator(
            color: Colors.grey.shade600,
          ),
        )),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: fit,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.fitWidth,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    } else {
      return image;
    }
  }
}
