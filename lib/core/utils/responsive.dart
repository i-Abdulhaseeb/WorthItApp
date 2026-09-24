import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Centralized responsive utility and breakpoints configuration.
class Responsive {
  Responsive._();

  /// Standard max width for reading and interactive mobile interfaces on wider screens.
  static const double maxContentWidth = 640.0;

  /// Max width for dialogs and modal popups.
  static const double maxDialogWidth = 460.0;

  /// Breakpoint thresholds
  static const double compactBreakpoint = 360.0;
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;

  /// Returns true if the screen is a small/compact phone (e.g. iPhone SE, width < 360)
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  /// Returns true if the device screen width is in phone range (< 600)
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  /// Returns true if the device screen width is in tablet range (600 - 1023)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Returns true if the device screen width is in desktop/laptop range (>= 1024)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Returns true if the viewport is wider than standard phone (>= 600)
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileBreakpoint;

  /// Returns responsive horizontal padding based on screen width
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < compactBreakpoint) return 14.0;
    if (width < mobileBreakpoint) return 20.0;
    if (width < tabletBreakpoint) return 28.0;
    return 32.0;
  }

  /// Return value tailored to current device breakpoint
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? compact,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < compactBreakpoint && compact != null) {
      return compact;
    }
    if (width >= tabletBreakpoint && desktop != null) {
      return desktop;
    }
    if (width >= mobileBreakpoint && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}

/// A container that centers its child and constrains its maximum width
/// on wide viewports (such as laptops and desktops) while filling the width
/// naturally on mobile devices.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return Align(
      alignment: alignment,
      child: content,
    );
  }
}

/// A dialog container that automatically scales appropriately on mobile and laptops.
class ResponsiveDialogContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;

  const ResponsiveDialogContainer({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxDialogWidth,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 24),
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = math.min(screenWidth - 32, maxWidth);

    return Center(
      child: SizedBox(
        width: dialogWidth,
        child: Container(
          padding: padding,
          decoration: decoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
          child: child,
        ),
      ),
    );
  }
}
