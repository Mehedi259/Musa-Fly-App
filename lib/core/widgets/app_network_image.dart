import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import 'shimmer_loader.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    String primaryUrl = ApiConstants.formatImageUrl(imageUrl);
    String backupUrl = ApiConstants.formatImageUrl(fallbackUrl);

    // If primary is empty, try backup
    final effectiveUrl = primaryUrl.isNotEmpty ? primaryUrl : backupUrl;

    Widget imageWidget;
    if (effectiveUrl.isEmpty) {
      imageWidget = _buildPlaceholder();
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: effectiveUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ShimmerBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: borderRadius,
        ),
        errorWidget: (context, url, error) {
          // If primary failed and we have a secondary backup URL, try it
          if (backupUrl.isNotEmpty && url != backupUrl) {
            return CachedNetworkImage(
              imageUrl: backupUrl,
              width: width,
              height: height,
              fit: fit,
              errorWidget: (context, url, error) => _buildPlaceholder(),
            );
          }
          return _buildPlaceholder();
        },
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

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(40),
            AppColors.primary.withAlpha(70),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.photo_size_select_actual_outlined,
          color: AppColors.primary.withAlpha(120),
          size: 32,
        ),
      ),
    );
  }
}
