import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GymImage extends StatelessWidget {
  const GymImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.opacity = 1,
    this.color,
  });

  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double opacity;
  final Color? color;

  bool get _isNetwork =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (_isNetwork) {
      image = CachedNetworkImage(
        imageUrl: source,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) => Container(
          color: const Color(0xFF2A2A2A),
          width: width,
          height: height,
        ),
        errorWidget: (_, __, ___) => Container(
          color: const Color(0xFF2A2A2A),
          width: width,
          height: height,
          child: const Icon(Icons.image_not_supported, color: Colors.white24),
        ),
      );
    } else {
      image = Image.asset(
        source,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFF2A2A2A),
          width: width,
          height: height,
        ),
      );
    }

    if (opacity < 1 || color != null) {
      image = ColorFiltered(
        colorFilter: ColorFilter.mode(
          color ?? Colors.white,
          color != null ? BlendMode.modulate : BlendMode.dst,
        ),
        child: Opacity(opacity: opacity, child: image),
      );
    }
    return image;
  }
}
