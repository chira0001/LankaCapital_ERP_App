import 'dart:async';
import 'package:flutter/material.dart';

class AppTopSnackBar {
  const AppTopSnackBar._();

  static OverlayEntry? _currentEntry;

  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool showClose = true,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline_rounded,
      color: Colors.red,
      duration: duration,
      showClose: showClose,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool showClose = true,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      color: Colors.green,
      duration: duration,
      showClose: showClose,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
    required Duration duration,
    required bool showClose,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);

    _currentEntry?.remove();
    _currentEntry = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopSnackBarWidget(
        message: message,
        icon: icon,
        color: color,
        duration: duration,
        showClose: showClose,
        onDismissed: () {
          entry.remove();
          if (_currentEntry == entry) _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _TopSnackBarWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Duration duration;
  final bool showClose;
  final VoidCallback onDismissed;

  const _TopSnackBarWidget({
    required this.message,
    required this.icon,
    required this.color,
    required this.duration,
    required this.showClose,
    required this.onDismissed,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withAlpha((0.95 * 255).round()), // 95%
                        widget.color.withAlpha((0.80 * 255).round()), // 80%
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withAlpha((0.18 * 255).round()),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.18 * 255).round()),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(widget.icon, color: Colors.white),
                      ),
                      const SizedBox(width: 12),

                      // This fixes overflow/unbounded flex issues
                      Expanded(
                        child: Text(
                          widget.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ),

                      if (widget.showClose) ...[
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: _dismiss,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          splashRadius: 15,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          tooltip: 'Close',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
