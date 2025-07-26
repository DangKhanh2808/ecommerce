import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? maxWidth;
  final double? minHeight;
  final BoxDecoration? decoration;
  final bool useSafeArea;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.minHeight,
    this.decoration,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    Widget content = Container(
      width: maxWidth ?? screenWidth,
      constraints: BoxConstraints(
        minHeight: minHeight ?? 0,
        maxWidth: maxWidth ?? screenWidth,
      ),
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: decoration,
      child: child,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenHeight - (useSafeArea ? 100 : 0),
        ),
        child: content,
      ),
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultPadding = screenWidth > 600 ? 24.0 : 16.0;
    
    Widget content = Padding(
      padding: padding ?? EdgeInsets.all(defaultPadding),
      child: child,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool useSafeArea;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.useSafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Card(
      elevation: elevation ?? theme.cardTheme.elevation,
      color: backgroundColor ?? theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? 
            (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius ?? 
            const BorderRadius.all(Radius.circular(12)),
      ),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
} 