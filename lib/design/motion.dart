import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Sistemde "hareketi azalt" açık mı? Açıksa kaydırma/yay hareketleri yerine anlık
/// ya da yalnızca saydamlık geçişleri kullanılır.
bool reduceMotion(BuildContext context) => MediaQuery.disableAnimationsOf(context);

/// Apple tarzı yay: sönüm oranı ve tepki süresi (saniye) ile tanımlanır.
/// 1.0 = aşım yok. Hareket momentum taşımıyorsa 1.0 kullanılır.
SpringDescription polatSpring({double damping = 1.0, double response = 0.3}) {
  // response = 2π / ω₀ ; kütle = 1 varsayımıyla sertlik = ω₀², sönüm = 2·ζ·ω₀.
  final omega = 2 * 3.141592653589793 / response;
  return SpringDescription(
    mass: 1,
    stiffness: omega * omega,
    damping: 2 * damping * omega,
  );
}

/// Basılınca yay ile küçülen, bırakılınca geri dönen sarmalayıcı.
///
/// - Geri bildirim dokunma ANINDA başlar (onTapDown), bırakmayı beklemez.
/// - Hareket her an kesilebilir: yeni hedef, o anki değerden ve hızdan başlar.
/// - Azaltılmış hareket açıkken ölçek değişmez (yalnızca dokunma işlevi çalışır).
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.97,
  });

  final Widget child;
  final VoidCallback onTap;
  final double pressedScale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController.unbounded(vsync: this, value: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _springTo(double target) {
    if (reduceMotion(context)) {
      _controller.value = 1;
      return;
    }
    // Dokunma geri bildirimi hızlı (tepki 0.25 sn); bırakınca hafif yay.
    final spring = polatSpring(damping: target == 1 ? 0.8 : 1.0, response: 0.25);
    _controller.animateWith(
      SpringSimulation(spring, _controller.value, target, _controller.velocity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _springTo(widget.pressedScale),
      onTapUp: (_) => _springTo(1),
      onTapCancel: () => _springTo(1),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(scale: _controller.value, child: child),
        child: widget.child,
      ),
    );
  }
}

/// İlk gösterimde hafifçe yukarıdan kayarak beliren öğe (sıralı gecikmeli).
/// Zamanlayıcı kullanmaz; gecikme tek bir denetleyici içinde aralık olarak kodlanır.
/// Azaltılmış hareket açıkken yalnızca saydamlık geçişi yapılır, kayma yoktur.
class EntranceFade extends StatefulWidget {
  const EntranceFade({super.key, required this.index, required this.child});

  /// Sıra numarası: büyüdükçe giriş gecikir.
  final int index;
  final Widget child;

  @override
  State<EntranceFade> createState() => _EntranceFadeState();
}

class _EntranceFadeState extends State<EntranceFade> with SingleTickerProviderStateMixin {
  static const int _stepMs = 40;
  static const int _baseMs = 360;

  late final int _totalMs = _baseMs + widget.index * _stepMs;
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: _totalMs));
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Interval(widget.index * _stepMs / _totalMs, 1, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotion(context);
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final t = _curve.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: reduce ? Offset.zero : Offset(0, (1 - t) * 14),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
