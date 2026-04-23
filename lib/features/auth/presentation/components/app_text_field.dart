import 'package:flutter/material.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';

typedef Validator = String? Function(String? value);

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final bool enabled;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? value; // initial / external value (kept in sync)
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Validator? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool autoFocus;
  final bool isFocusedConfig;
  final bool readOnly;
  //final IconData? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.autoFocus = false,
    this.isFocusedConfig = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ?? TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep external value in sync without jumping cursor
    final newValue = widget.value ?? '';
    if (_controller.text != newValue) {
      final prevSelection = _controller.selection;
      _controller.text = newValue;
      // put cursor at end if previous was at end, otherwise preserve position if possible
      final offset = newValue.length;
      final selIndex = prevSelection.baseOffset <= newValue.length
          ? prevSelection
          : TextSelection.collapsed(offset: offset);
      _controller.selection = selIndex;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isFocusedConfig
        ? Theme.of(context).colorScheme.primary
        : context.appBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.appText,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            ///labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            fillColor:
                widget.enabled ? context.appSurface : context.appSurfaceVariant,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            //suffixIcon: widget.suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
