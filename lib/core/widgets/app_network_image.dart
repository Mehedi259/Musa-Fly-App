import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import 'shimmer_loader.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? fallbackAsset;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    final validUrl = ApiConstants.formatImageUrl(imageUrl);

    Widget imageWidget;
    if (validUrl.isEmpty) {
      imageWidget = _buildFallback();
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: validUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ShimmerBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: borderRadius,
        ),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.primarySubtle,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.primary.withAlpha(128),
          size: 28,
        ),
      ),
    );
  }
}
