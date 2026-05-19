import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:etisalatdemotv/core/theme/app_theme.dart';

class FocusButton extends StatefulWidget {
  const FocusButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.autofocus = false,
    this.size = 48,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool autofocus;
  final double size;
  final String? semanticLabel;

  @override
  State<FocusButton> createState() => _FocusButtonState();
}

class _FocusButtonState extends State<FocusButton> {
  bool _isFocused = false;

  void _onFocusChange(bool focused) {
    if (!mounted) return;
    setState(() => _isFocused = focused);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.select ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      widget.onPressed();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: Focus(
        autofocus: widget.autofocus,
        onFocusChange: _onFocusChange,
        onKeyEvent: _onKey,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            scale: _isFocused ? 1.12 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isFocused
                    ? AppTheme.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused
                      ? AppTheme.focusGlow
                      : Colors.white10,
                  width: 2,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppTheme.focusGlow.withValues(alpha: 0.30),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                widget.icon,
                size: widget.size,
                color: _isFocused
                    ? AppTheme.primary
                    : AppTheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}