import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String>? onChanged;
  final Validator? validator;
  final TextEditingController? controller;
  final bool autoFocus;

  const AppPasswordField({
    super.key,
    this.label = 'Password',
    this.value,
    this.onChanged,
    this.validator,
    this.controller,
    this.autoFocus = false,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  void _toggle() => setState(() => _obscure = !_obscure);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      value: widget.value,
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autoFocus: widget.autoFocus,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: _toggle,
        tooltip: _obscure ? 'Show password' : 'Hide password',
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
