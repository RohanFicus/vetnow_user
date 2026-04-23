import 'package:flutter/material.dart';

typedef Validator = String? Function(String? value);

class AppPhoneField extends StatefulWidget {
  final String countryCode;
  final String hint;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;
  final String? value;
  final ValueChanged<String>? onChanged;
  final Validator? validator;
  final VoidCallback? onCountryTap;
  final bool autoFocus;

  const AppPhoneField({
    super.key,
    this.countryCode = '+91',
    this.hint = 'Enter your phone number',
    this.errorText,
    this.enabled = true,
    this.controller,
    this.value,
    this.onChanged,
    this.validator,
    this.onCountryTap,
    this.autoFocus = false,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
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
  void didUpdateWidget(covariant AppPhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = widget.value ?? '';
    if (_controller.text != newValue) {
      final prevSelection = _controller.selection;
      _controller.text = newValue;

      final offset = newValue.length;
      _controller.selection = prevSelection.baseOffset <= offset
          ? prevSelection
          : TextSelection.collapsed(offset: offset);
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: field.hasError ? Colors.red : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  /// Country selector
                  GestureDetector(
                    onTap: widget.onCountryTap,
                    child: Row(
                      children: [
                        const Text('🇮🇳', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          widget.countryCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),

                  /// Divider
                  const SizedBox(width: 4),
                  Container(height: 24, width: 1, color: Colors.white24),

                  /// Phone input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: widget.enabled,
                      autofocus: widget.autoFocus,
                      keyboardType: TextInputType.phone,

                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        fillColor: const Color(0xFF1E1E2A),
                        errorText: null,
                        // suffixIcon: widget.errorText != null
                        //     ? Tooltip(
                        //         message: widget.errorText!,
                        //         child: Icon(
                        //           Icons.error_outline,
                        //           color: Colors.red,
                        //           size: 20,
                        //         ),
                        //       )
                        //     : null,
                      ),
                      onChanged: (val) {
                        field.didChange(val);
                        widget.onChanged?.call(val);
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// Error text
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}
