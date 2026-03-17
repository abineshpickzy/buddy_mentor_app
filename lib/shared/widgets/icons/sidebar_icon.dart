import 'package:flutter/material.dart';
import 'package:buddymentor/core/constants/app_colors.dart';

class SidebarIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final VoidCallback? onTap;
  final int sidebarFlex;
  final int contentFlex;
  final EdgeInsets padding;

  const SidebarIcon({
    super.key,
    this.width = 17,
    this.height = 15,
    this.borderColor = const Color.fromARGB(255, 110, 109, 109),
    this.borderWidth = 2,
    this.borderRadius = 2,
    this.onTap,
    this.sidebarFlex = 2,
    this.contentFlex = 4,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: padding,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                flex: sidebarFlex,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: borderColor, width: borderWidth),
                    ),
                  ),
                ),
              ),
              Expanded(flex: contentFlex, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}