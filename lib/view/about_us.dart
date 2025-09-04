// about_us_screen_light.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreenLight extends StatefulWidget {
  const AboutUsScreenLight({super.key});

  @override
  State<AboutUsScreenLight> createState() => _AboutUsScreenLightState();
}

class _AboutUsScreenLightState extends State<AboutUsScreenLight>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _float;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  // Customize these:
  final String businessName = "MYANMAR BUSINESS LEADER";
  final String phoneNumber = "09976947648";

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

  Future<void> _callNumber() async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open dialer')),
      );
    }
  }

  Future<void> _smsNumber() async {
    // You can prefill text with ?body=Hi
    final uri = Uri(scheme: 'sms', path: phoneNumber);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open messages app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = [
      Color(0xFFF9FAFB), // gray-50
      Color(0xFFF3F4F6), // gray-100
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87, size: 24),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _GlassCardLight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Cover + Profile (stacked)
                        SizedBox(
                          height: 230,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Cover Photo
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                                child: SizedBox(
                                  height: 220,
                                  width: double.infinity,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        'assets/cover.png',
                                        fit: BoxFit.cover,
                                      ),
                                      // Subtle gradient overlay for readability
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.05),
                                              Colors.black.withOpacity(0.25),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Floating Profile Avatar
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 150,
                                child: AnimatedBuilder(
                                  animation: _float,
                                  builder: (context, child) {
                                    final dy = math.sin(_float.value * 2 * math.pi) * 4;
                                    return Transform.translate(
                                      offset: Offset(0, dy),
                                      child: child,
                                    );
                                  },
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.12),
                                            blurRadius: 18,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: const CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 56,
                                          backgroundImage:
                                          AssetImage('assets/logo.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 70),

                        // Name (Gradient)
                        _GradientText(
                          businessName,
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade700,
                              Colors.amber.shade900
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Phone Number (tap to call)
                        InkWell(
                          onTap: _callNumber, // <-- fixed
                          borderRadius: BorderRadius.circular(5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.phone_rounded,
                                    color: Colors.black87),
                                const SizedBox(width: 8),
                                Text(
                                  phoneNumber,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Message Button (opens SMS)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _smsNumber,
                              icon: const Icon(Icons.message_outlined),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  'Message Us',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
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
              border: Border.all(width: 1, color: Colors.black12),
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
