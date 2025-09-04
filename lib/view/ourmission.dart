// about_us_screen_light.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class OurMission extends StatefulWidget {
  const OurMission({super.key});

  @override
  State<OurMission> createState() => _OurMissionState();
}

class _OurMissionState extends State<OurMission>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _float;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _entrance.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = [
      Color(0xFFF9FAFB), // gray-50
      Color(0xFFF3F4F6), // gray-100
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor:Color(0xFFF9FAFB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87, size: 24),


      ),
      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: bg,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _GlassCardLight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 24),
                        // Floating image
                        AnimatedBuilder(
                          animation: _float,
                          builder: (context, child) {
                            final dy = math.sin(_float.value * 2 * math.pi) * 6;
                            return Transform.translate(
                              offset: Offset(0, dy),
                              child: child,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/logo.png', // your image
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Gradient title
                         _GradientText(
                          'OUR MISSION',
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade700,
                              Colors.amber.shade900
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Description
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            '''လုပ်ငန်းရှင်အချင်းချင်း အချိန်တိုအတွင်းမှာ လွယ်ကူစွာ ရှာဖွေနိုင်ရန် Network ချိတ်ဆက်ပေးသော စာအုပ်နှင့် Phone Application ဖြစ်ပြီး မြန်မာနိုင်ငံအတွင်းမှ လုပ်ငန်းရှင်အချင်းချင်း ဘာပဲလိုလို လွယ်ကူစွာ ရှာ‌ဖွေဆက်သွယ်နိုင်ရန် ချိတ်ဆက်‌ပေးနေသော နေရာတစ်ခုဖြစ်လာရန် ကြိုးစားလုပ်ဆောင်သွားမည်''',
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16,
                              height: 2,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
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

// --- Helpers ---

class _GlassCardLight extends StatelessWidget {
  final Widget child;
  const _GlassCardLight({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.75),
              border: Border.all(
                width: 1,
                color: Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const _GradientText(
      this.text, {
        required this.gradient,
        required this.style,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
