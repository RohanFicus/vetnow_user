import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? child; // Allow custom widgets (like complex loaders)
  final IconData? icon; // Optional leading icon
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final BorderSide? side; // For outlined-style buttons

  const AppButton({
    super.key,
    this.text,
    this.child,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.width,
    this.height = 54, // Modern standard height
    this.borderRadius = 14, // Slightly rounder for modern look
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    // A button is disabled if onPressed is null OR isLoading is true
    final bool isDisabled = onPressed == null || isLoading;

    // Determine the background color
    final Color effectiveBgColor = isDisabled
        ? (color?.withOpacity(0.5) ?? Colors.grey.shade300)
        : (color ?? Theme.of(context).primaryColor);

    // Determine the text/icon color
    final Color effectiveTextColor = isDisabled
        ? Colors.grey.shade600
        : (textColor ?? Colors.white);

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          foregroundColor: effectiveTextColor,
          elevation: isDisabled ? 0 : 2, // No shadow when loading/disabled
          shadowColor: effectiveBgColor.withOpacity(0.4),
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: isDisabled
            ? null
            : () {
          FocusScope.of(context).unfocus(); // Auto-close keyboard
          onPressed?.call();
        },
        child: _buildContent(effectiveTextColor),
      ),
    );
  }

  Widget _buildContent(Color contentColor) {
    if (isLoading) {
      // If a custom child was provided for loading (like our spinner), use it
      // otherwise use the default small spinner
      return child ??
          SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          );
    }

    // If we have a custom child widget, use that
    if (child != null) return child!;

    // Otherwise, build the standard Text (with optional icon)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text ?? "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}