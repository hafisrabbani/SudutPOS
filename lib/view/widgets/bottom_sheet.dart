import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Key? key;
  final Widget? child;
  final bool isDismissible;
  final bool enableDrag;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  const CustomBottomSheet({
    this.key,
    this.child,
    this.isDismissible = true,
    this.enableDrag = true,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isDismissible) {
          _showBottomSheet(context);
        }
      },
      child: child,
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: true,
      isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: 0.9,
      useRootNavigator: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20).copyWith(bottom: 20),
            child: child!,
          ),
        );
      },
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }
}
