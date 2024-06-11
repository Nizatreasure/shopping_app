import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  ///Width of the shimmer.
  ///Used only when [numberOfShimmer] is 1
  final double? width;

  ///Height of the shimmer
  final double? height;

  ///Border radius for the shimmer
  final double? borderRadius;

  ///Margin of the shimmer
  final EdgeInsetsGeometry? margin;

  ///Widget to display when [loading] is false
  final Widget child;

  ///Used to toggle between showing the shimmer widget or the
  ///child widget
  final bool loading;

  ///Number of shimmers place horizontally
  final int numberOfShimmer;

  ///Number of pixels between the horizontal shimmers.
  ///Used if [numberOfShimmer] is 1
  final double shimmerSpacing;

  ///The axis to use for the multishimmer
  ///Defauls to [Axis.horizontal]
  final Axis axis;

  const ShimmerWidget({
    required this.child,
    required this.loading,
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.shimmerSpacing = 0,
    this.numberOfShimmer = 1,
    this.axis = Axis.horizontal,
  }) : assert(axis != Axis.vertical || height != null,
            'Height must be provided if axis is vertical');

  @override
  Widget build(BuildContext context) {
    //show the child when the page is not loading and
    //show shimmer when the page is loading
    return !loading
        ? child
        : Shimmer.fromColors(
            baseColor: const Color(0xffF2F2F2),
            highlightColor: const Color(0xffFFFFFF),
            child: Padding(
              padding: margin ?? EdgeInsets.zero,
              child: numberOfShimmer == 1
                  ? _buildShimmer()
                  : axis == Axis.horizontal
                      ? Row(
                          children: _multiShimmers(),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _multiShimmers(),
                        ),
            ),
          );
  }

  List<Widget> _multiShimmers() {
    return List.generate(
      numberOfShimmer,
      (index) => Flexible(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: axis == Axis.horizontal ? (shimmerSpacing / 2).r : 0,
            vertical: axis == Axis.vertical ? (shimmerSpacing / 2).r : 0,
          ),
          child: _buildShimmer(),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: width?.r ?? double.infinity,
      height: height?.r ?? 30.r,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius?.r ?? 10.r),
        color: Colors.white,
      ),
    );
  }
}
