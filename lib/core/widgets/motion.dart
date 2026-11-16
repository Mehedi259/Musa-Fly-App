import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_design.dart';

/// Fades and lifts its child into place. Used to stagger list reveals:
/// pass the item's index and the delay is worked out for you.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int index;
  final double offsetY;
  final Duration duration;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offsetY = 18,
    this.duration = AppMotion.slow,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _a = CurvedAnimation(parent: _c, curve: AppMotion.emphasized);
  Timer? _start;

  @override
  void initState() {
    super.initState();
    final delay = AppMotion.stagger(widget.index);
    if (delay == Duration.zero) {
      _c.forward();
    } else {
      // Held so dispose can cancel it: an uncancelled Future.delayed leaves a
      // pending timer behind when the widget goes away mid-stagger.
      _start = Timer(delay, _c.forward);
    }
  }

  @override
  void dispose() {
    _start?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(
          offset: Offset(0, widget.offsetY * (1 - _a.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Wraps a tappable surface so it scales down slightly while held —
/// the single cheapest trick for making taps feel physical.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool haptic;
  final BorderRadius? borderRadius;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.haptic = true,
    this.borderRadius,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: () {
        if (widget.haptic) HapticFeedback.lightImpact();
        widget.onTap!();
      },
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.ease,
        child: widget.child,
      ),
    );
  }
}

/// Page route with a shared-axis style transition — the outgoing page
/// slides and fades back while the new one comes forward.
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  PremiumPageRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          pageBuilder: (_, _, _) => page,
          transitionsBuilder: (context, animation, secondary, child) {
            final curved = CurvedAnimation(parent: animation, curve: AppMotion.emphasized);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.035),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// Convenience: `context.pushPremium(SomeScreen())`.
extension PremiumNav on BuildContext {
  Future<T?> pushPremium<T>(Widget page) =>
      Navigator.of(this).push<T>(PremiumPageRoute<T>(page: page));
}
