import 'package:flutter/material.dart';

/// A reusable Card widget that prevents UI overflow and overlapping content
/// by applying minimum constraints and IntrinsicHeight.
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final double? minHeight;
  final double? maxHeight;
  final double? minWidth;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double elevation;
  final ShapeBorder? shape;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.minHeight,
    this.maxHeight,
    this.minWidth,
    this.maxWidth,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.color,
    this.elevation = 0,
    this.shape,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Padding(
      padding: padding,
      child: child,
    );

    if (minHeight != null || maxHeight != null || minWidth != null || maxWidth != null) {
      cardContent = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0.0,
          maxHeight: maxHeight ?? double.infinity,
          minWidth: minWidth ?? 0.0,
          maxWidth: maxWidth ?? double.infinity,
        ),
        child: cardContent,
      );
    }

    final card = Card(
      elevation: elevation,
      color: color,
      margin: margin,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: cardContent,
            )
          : cardContent,
    );

    return card;
  }
}

