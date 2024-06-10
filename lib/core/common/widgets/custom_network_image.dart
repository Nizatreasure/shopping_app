import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final void Function()? onRetry;
  final double indicatorSize;
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.indicatorSize = 25,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) {
        return Container(
          color: ColorManager.transparent,
          alignment: AlignmentDirectional.center,
          child: SizedBox(
            height: indicatorSize.r,
            width: indicatorSize.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.r,
              color: ColorManager.primaryBlack600,
            ),
          ),
        );
      },
      errorListener: (value) {
        if (onRetry != null) {
          onRetry!();
        }
      },
      errorWidget: (context, url, error) {
        return const SizedBox();
      },
    );
  }
}
