// Run with: flutter test test/generate_exercise_images_test.dart
// Generates exercise illustration PNGs into assets/images/
// Style: Athletic silhouettes with blue/cyan palette on dark background

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double kSize = 400;
const Color kBg = Color(0xFF0D1117);
const Color kSurface = Color(0xFF161B22);
const Color kBodyMain = Color(0xFF1F8FEB); // main body blue
const Color kBodyLight = Color(0xFF58C4FF); // highlight cyan
const Color kBodyDark = Color(0xFF0D4F8B); // shadow blue
const Color kAccent = Color(0xFF3FB950); // accent green (muscle highlight)
const Color kShirt = Color(0xFF2196F3); // shirt blue
const Color kShorts = Color(0xFF0D3B66); // shorts dark blue
const Color kSkin = Color(0xFFD4B5A0); // skin tone
const Color kSkinShadow = Color(0xFFB8937A);
const Color kShoe = Color(0xFF1565C0); // shoe blue
const Color kGlow = Color(0x2058C4FF); // subtle glow
const Color kFloor = Color(0xFF58A6FF);

// ── helpers ──────────────────────────────────────────────────────────────────

Paint _fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;

Paint _stroke(Color c, double w) => Paint()
  ..color = c
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

Paint _glowFill(Color c) => Paint()
  ..color = c
  ..style = PaintingStyle.fill
  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

/// Draw a rounded limb segment between two points with given width
void drawLimb(Canvas c, Offset a, Offset b, double width, Color color) {
  final paint = _fill(color);
  final dir = (b - a);
  final len = dir.distance;
  if (len < 1) return;
  final perp = Offset(-dir.dy / len, dir.dx / len) * (width / 2);
  final path = Path()
    ..moveTo(a.dx + perp.dx, a.dy + perp.dy)
    ..lineTo(b.dx + perp.dx, b.dy + perp.dy)
    ..lineTo(b.dx - perp.dx, b.dy - perp.dy)
    ..lineTo(a.dx - perp.dx, a.dy - perp.dy)
    ..close();
  c.drawPath(path, paint);
  // rounded ends
  c.drawCircle(a, width / 2, paint);
  c.drawCircle(b, width / 2, paint);
}

/// Draw a filled ellipse (for torso/head)
void drawEllipse(Canvas c, Offset center, double rx, double ry, Color color,
    [double rotation = 0]) {
  c.save();
  c.translate(center.dx, center.dy);
  c.rotate(rotation);
  c.drawOval(Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2), _fill(color));
  c.restore();
}

/// Draw a head with hair
void drawHead(Canvas c, Offset center, double r, {double rotation = 0, bool facingRight = true}) {
  // Glow
  c.drawCircle(center, r * 1.3, _glowFill(kGlow));
  // Head
  c.drawCircle(center, r, _fill(kSkin));
  // Hair
  final hairPath = Path();
  if (facingRight) {
    hairPath.addArc(
      Rect.fromCircle(center: center, radius: r),
      -math.pi * 0.8,
      math.pi * 1.1,
    );
    hairPath.close();
  } else {
    hairPath.addArc(
      Rect.fromCircle(center: center, radius: r),
      -math.pi * 0.3,
      math.pi * 1.1,
    );
    hairPath.close();
  }
  c.drawCircle(center.translate(0, -r * 0.15), r * 0.95, _fill(kBodyDark));
  // Face area
  c.drawCircle(
    center.translate(facingRight ? r * 0.15 : -r * 0.15, r * 0.1),
    r * 0.65,
    _fill(kSkin),
  );
}

/// Draw a shoe
void drawShoe(Canvas c, Offset pos, double size, {bool facingRight = true}) {
  final dir = facingRight ? 1.0 : -1.0;
  final path = Path()
    ..moveTo(pos.dx - dir * size * 0.3, pos.dy - size * 0.4)
    ..lineTo(pos.dx + dir * size * 0.8, pos.dy - size * 0.3)
    ..quadraticBezierTo(pos.dx + dir * size * 1.0, pos.dy, pos.dx + dir * size * 0.7, pos.dy)
    ..lineTo(pos.dx - dir * size * 0.4, pos.dy)
    ..quadraticBezierTo(pos.dx - dir * size * 0.5, pos.dy - size * 0.2, pos.dx - dir * size * 0.3, pos.dy - size * 0.4)
    ..close();
  c.drawPath(path, _fill(kShoe));
  // sole
  c.drawPath(Path()
    ..moveTo(pos.dx - dir * size * 0.4, pos.dy)
    ..lineTo(pos.dx + dir * size * 0.7, pos.dy)
    ..lineTo(pos.dx + dir * size * 0.7, pos.dy + size * 0.08)
    ..lineTo(pos.dx - dir * size * 0.4, pos.dy + size * 0.08)
    ..close(), _fill(const Color(0xFF0D2137)));
}

/// Draw background glow shape
void drawBgGlow(Canvas c, Offset center, double radius) {
  c.drawCircle(center, radius, _glowFill(const Color(0x101F8FEB)));
  c.drawCircle(center, radius * 0.6, _glowFill(const Color(0x0858C4FF)));
}

/// Draw ground line with reflection
void drawGround(Canvas c, double y, {double left = 60, double right = 340}) {
  c.drawLine(Offset(left, y), Offset(right, y), _stroke(kFloor.withAlpha(80), 2));
  // Subtle reflection gradient
  final reflectionRect = Rect.fromLTRB(left, y, right, y + 20);
  c.drawRect(
    reflectionRect,
    Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, y),
        Offset(0, y + 20),
        [const Color(0x1058C4FF), const Color(0x00000000)],
      ),
  );
}

/// Draw a torso shape (trapezoid from shoulders to waist)
void drawTorso(Canvas c, Offset shoulderL, Offset shoulderR, Offset hipL, Offset hipR, Color color) {
  final path = Path()
    ..moveTo(shoulderL.dx, shoulderL.dy)
    ..lineTo(shoulderR.dx, shoulderR.dy)
    ..lineTo(hipR.dx, hipR.dy)
    ..lineTo(hipL.dx, hipL.dy)
    ..close();
  c.drawPath(path, _fill(color));
}

Future<void> save(String name, void Function(Canvas, Size) draw) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, kSize, kSize));
  // Background
  canvas.drawRect(Rect.fromLTWH(0, 0, kSize, kSize), _fill(kBg));
  draw(canvas, const Size(kSize, kSize));
  final picture = recorder.endRecording();
  final img = await picture.toImage(kSize.toInt(), kSize.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  final file = File('assets/images/$name.png');
  await file.writeAsBytes(bytes!.buffer.asUint8List());
  // ignore: avoid_print
  print('✓  assets/images/$name.png');
}

// ── exercise drawers ──────────────────────────────────────────────────────────

void drawGluteBridges(Canvas c, Size s) {
  drawBgGlow(c, const Offset(200, 220), 150);
  drawGround(c, 330);

  // Person lying on back, hips raised
  // Head on left, feet on right

  // Head (lying down)
  drawHead(c, const Offset(68, 295), 18, facingRight: false);

  // Neck
  drawLimb(c, const Offset(85, 290), const Offset(100, 285), 12, kSkin);

  // Upper back on ground
  drawLimb(c, const Offset(100, 285), const Offset(130, 290), 18, kShirt);

  // Arms flat on ground
  drawLimb(c, const Offset(110, 290), const Offset(85, 320), 9, kSkin);
  drawLimb(c, const Offset(115, 288), const Offset(145, 320), 9, kSkin);

  // Torso rising up (the bridge) - accent color to show the exercise
  drawLimb(c, const Offset(130, 290), const Offset(195, 215), 20, kShirt);

  // Hips (raised high - key feature)
  drawEllipse(c, const Offset(200, 215), 22, 14, kShorts);

  // Glow at hips to emphasize the bridge
  c.drawCircle(const Offset(200, 215), 30, _glowFill(const Color(0x2058C4FF)));

  // Thighs going down to knees
  drawLimb(c, const Offset(200, 220), const Offset(245, 280), 16, kShorts);

  // Shins from knees to feet on ground
  drawLimb(c, const Offset(245, 280), const Offset(260, 325), 13, kSkin);

  // Feet
  drawShoe(c, const Offset(260, 325), 16, facingRight: true);

  // Accent line showing the bridge curve
  final bridgePath = Path()
    ..moveTo(130, 282)
    ..quadraticBezierTo(175, 200, 210, 215);
  c.drawPath(bridgePath, _stroke(kBodyLight.withAlpha(120), 2));
}

void drawPlank(Canvas c, Size s) {
  drawBgGlow(c, const Offset(200, 240), 140);
  drawGround(c, 320);

  // Person in forearm plank, facing left
  // Head on left, feet on right, body straight and elevated

  // Feet (right side)
  drawShoe(c, const Offset(325, 315), 14, facingRight: false);

  // Lower legs
  drawLimb(c, const Offset(320, 312), const Offset(295, 280), 12, kSkin);

  // Upper legs
  drawLimb(c, const Offset(295, 280), const Offset(245, 260), 15, kShorts);

  // Torso (straight line - key feature of plank)
  drawLimb(c, const Offset(245, 260), const Offset(130, 255), 20, kShirt);

  // Glow line along the straight body to emphasize form
  c.drawLine(const Offset(130, 248), const Offset(280, 254), _stroke(kBodyLight.withAlpha(80), 2));

  // Forearms on ground
  drawLimb(c, const Offset(135, 258), const Offset(105, 310), 10, kSkin);
  drawLimb(c, const Offset(145, 260), const Offset(165, 310), 10, kSkin);

  // Hands flat
  drawEllipse(c, const Offset(103, 314), 8, 5, kSkin);
  drawEllipse(c, const Offset(167, 314), 8, 5, kSkin);

  // Neck
  drawLimb(c, const Offset(130, 252), const Offset(108, 235), 11, kSkin);

  // Head
  drawHead(c, const Offset(95, 222), 18, facingRight: false);
}

void drawWallSit(Canvas c, Size s) {
  drawBgGlow(c, const Offset(170, 220), 130);

  // Wall on left
  final wallPath = Path()
    ..moveTo(100, 50)
    ..lineTo(100, 340)
    ..lineTo(105, 340)
    ..lineTo(105, 50)
    ..close();
  c.drawPath(wallPath, _fill(const Color(0xFF1E2A3A)));
  c.drawLine(const Offset(100, 50), const Offset(100, 340), _stroke(kFloor.withAlpha(100), 2));

  drawGround(c, 340, left: 100);

  // Person sitting against wall, 90° at knees

  // Head against wall
  drawHead(c, const Offset(115, 130), 20, facingRight: true);

  // Neck
  drawLimb(c, const Offset(118, 148), const Offset(120, 165), 12, kSkin);

  // Upper body against wall
  drawTorso(
    c,
    const Offset(100, 165), const Offset(140, 165),
    const Offset(105, 260), const Offset(140, 260),
    kShirt,
  );

  // Glow on wall to show back contact
  c.drawRect(const Rect.fromLTRB(95, 160, 102, 265), _glowFill(const Color(0x2058C4FF)));

  // Thighs horizontal (90° angle highlight)
  drawLimb(c, const Offset(120, 265), const Offset(230, 262), 17, kShorts);

  // 90° angle indicator
  final anglePath = Path()
    ..moveTo(230, 245)
    ..lineTo(230, 262)
    ..lineTo(247, 262);
  c.drawPath(anglePath, _stroke(kBodyLight.withAlpha(150), 2));
  // "90°" text-like accent
  c.drawCircle(const Offset(240, 250), 3, _fill(kBodyLight.withAlpha(150)));

  // Shins vertical
  drawLimb(c, const Offset(230, 265), const Offset(232, 335), 14, kSkin);

  // Feet
  drawShoe(c, const Offset(235, 335), 16, facingRight: true);

  // Arms resting on thighs
  drawLimb(c, const Offset(125, 195), const Offset(155, 255), 9, kSkin);
  drawLimb(c, const Offset(135, 195), const Offset(170, 255), 9, kSkin);

  // Hands on thighs
  drawEllipse(c, const Offset(157, 255), 7, 5, kSkin);
  drawEllipse(c, const Offset(172, 255), 7, 5, kSkin);
}

void drawSprint(Canvas c, Size s) {
  drawBgGlow(c, const Offset(200, 190), 150);
  drawGround(c, 350);

  // Dynamic sprinting / high knees figure, facing right
  // Forward lean, one knee high, explosive motion

  // Head (forward lean)
  drawHead(c, const Offset(225, 82), 20, facingRight: true);

  // Neck
  drawLimb(c, const Offset(220, 100), const Offset(210, 125), 13, kSkin);

  // Torso (forward lean)
  drawTorso(
    c,
    const Offset(192, 125), const Offset(230, 120),
    const Offset(195, 225), const Offset(222, 228),
    kShirt,
  );

  // HIGH KNEE (front leg) - key feature
  // Thigh going up
  drawLimb(c, const Offset(210, 228), const Offset(248, 168), 16, kShorts);
  // Shin hanging down
  drawLimb(c, const Offset(248, 168), const Offset(255, 228), 13, kSkin);
  // Foot
  drawShoe(c, const Offset(255, 228), 14, facingRight: true);

  // Glow on high knee to emphasize
  c.drawCircle(const Offset(248, 168), 20, _glowFill(const Color(0x2058C4FF)));

  // Rear leg (extended back)
  drawLimb(c, const Offset(205, 228), const Offset(178, 290), 15, kShorts);
  drawLimb(c, const Offset(178, 290), const Offset(160, 345), 12, kSkin);
  drawShoe(c, const Offset(155, 345), 14, facingRight: false);

  // Front arm (pumping forward)
  drawLimb(c, const Offset(218, 140), const Offset(255, 180), 9, kSkin);
  // Fist
  drawEllipse(c, const Offset(258, 182), 6, 5, kSkin);

  // Rear arm (pumping back)
  drawLimb(c, const Offset(205, 140), const Offset(175, 178), 9, kSkin);
  drawEllipse(c, const Offset(172, 180), 6, 5, kSkin);

  // Speed lines
  for (var i = 0; i < 3; i++) {
    final y = 140.0 + i * 40;
    c.drawLine(
      Offset(80 + i * 10.0, y),
      Offset(130 + i * 5.0, y),
      _stroke(kBodyLight.withAlpha(40 + i * 20), 2),
    );
  }
}

void drawPullUps(Canvas c, Size s) {
  drawBgGlow(c, const Offset(200, 180), 140);

  // Bar
  final barRect = const Rect.fromLTRB(70, 75, 330, 88);
  c.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(6)), _fill(const Color(0xFF2D3748)));
  c.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(6)), _stroke(kFloor.withAlpha(100), 1.5));

  // Bar supports
  c.drawRect(const Rect.fromLTRB(95, 40, 108, 78), _fill(const Color(0xFF2D3748)));
  c.drawRect(const Rect.fromLTRB(292, 40, 305, 78), _fill(const Color(0xFF2D3748)));

  // Person hanging, chin above bar (pull-up top position)

  // Hands gripping bar
  drawEllipse(c, const Offset(145, 82), 10, 8, kSkin);
  drawEllipse(c, const Offset(255, 82), 10, 8, kSkin);

  // Forearms
  drawLimb(c, const Offset(145, 85), const Offset(160, 125), 10, kSkin);
  drawLimb(c, const Offset(255, 85), const Offset(240, 125), 10, kSkin);

  // Upper arms (bent)
  drawLimb(c, const Offset(160, 125), const Offset(178, 155), 11, kSkin);
  drawLimb(c, const Offset(240, 125), const Offset(222, 155), 11, kSkin);

  // Head (chin above bar)
  drawHead(c, const Offset(200, 115), 20, facingRight: true);

  // Shoulders
  drawLimb(c, const Offset(175, 150), const Offset(225, 150), 14, kShirt);

  // Torso
  drawTorso(
    c,
    const Offset(175, 150), const Offset(225, 150),
    const Offset(185, 270), const Offset(215, 270),
    kShirt,
  );

  // Glow on upper body to show exertion
  c.drawCircle(const Offset(200, 180), 35, _glowFill(const Color(0x1558C4FF)));

  // Legs hanging slightly crossed
  drawLimb(c, const Offset(193, 270), const Offset(185, 340), 13, kShorts);
  drawLimb(c, const Offset(207, 270), const Offset(215, 340), 13, kShorts);

  // Lower legs
  drawLimb(c, const Offset(185, 340), const Offset(190, 375), 11, kSkin);
  drawLimb(c, const Offset(215, 340), const Offset(210, 375), 11, kSkin);

  // Shoes
  drawShoe(c, const Offset(190, 375), 12, facingRight: true);
  drawShoe(c, const Offset(210, 375), 12, facingRight: false);
}

void drawLongRun(Canvas c, Size s) {
  drawBgGlow(c, const Offset(200, 200), 150);
  drawGround(c, 355);

  // Relaxed jogging figure, mid-stride, facing right

  // Head
  drawHead(c, const Offset(215, 80), 20, facingRight: true);

  // Neck
  drawLimb(c, const Offset(212, 98), const Offset(208, 120), 12, kSkin);

  // Torso (mostly upright, slight lean)
  drawTorso(
    c,
    const Offset(190, 120), const Offset(228, 118),
    const Offset(192, 238), const Offset(222, 240),
    kShirt,
  );

  // Front leg (stride forward)
  drawLimb(c, const Offset(212, 240), const Offset(242, 295), 15, kShorts);
  drawLimb(c, const Offset(242, 295), const Offset(258, 350), 12, kSkin);
  drawShoe(c, const Offset(260, 350), 15, facingRight: true);

  // Rear leg (pushing off)
  drawLimb(c, const Offset(200, 240), const Offset(178, 300), 15, kShorts);
  drawLimb(c, const Offset(178, 300), const Offset(162, 350), 12, kSkin);
  drawShoe(c, const Offset(158, 350), 15, facingRight: false);

  // Arms (relaxed jogging form)
  // Front arm
  drawLimb(c, const Offset(200, 135), const Offset(180, 185), 9, kSkin);
  drawLimb(c, const Offset(180, 185), const Offset(185, 210), 8, kSkin);
  drawEllipse(c, const Offset(186, 213), 6, 5, kSkin);

  // Rear arm
  drawLimb(c, const Offset(220, 135), const Offset(245, 180), 9, kSkin);
  drawLimb(c, const Offset(245, 180), const Offset(238, 205), 8, kSkin);
  drawEllipse(c, const Offset(237, 208), 6, 5, kSkin);

  // Motion lines behind
  for (var i = 0; i < 4; i++) {
    final y = 150.0 + i * 35;
    c.drawLine(
      Offset(70 + i * 8.0, y),
      Offset(110 + i * 5.0, y),
      _stroke(kBodyLight.withAlpha(30 + i * 15), 1.5),
    );
  }
}

void drawStretching(Canvas c, Size s) {
  drawBgGlow(c, const Offset(200, 230), 140);
  drawGround(c, 320);

  // Seated forward fold – person sitting, legs extended, reaching for toes

  // Legs extended to the right along the ground
  // Left leg
  drawLimb(c, const Offset(130, 295), const Offset(240, 295), 14, kShorts);
  drawLimb(c, const Offset(240, 295), const Offset(310, 300), 12, kSkin);
  // Right leg (slightly overlapping)
  drawLimb(c, const Offset(130, 305), const Offset(240, 305), 14, kShorts);
  drawLimb(c, const Offset(240, 305), const Offset(310, 308), 12, kSkin);

  // Feet
  drawShoe(c, const Offset(315, 300), 14, facingRight: true);
  drawShoe(c, const Offset(315, 310), 14, facingRight: true);

  // Hips (seated)
  drawEllipse(c, const Offset(130, 290), 18, 20, kShorts);

  // Torso bending forward over legs
  drawTorso(
    c,
    const Offset(115, 240), const Offset(155, 238),
    const Offset(118, 285), const Offset(148, 288),
    kShirt,
  );

  // Upper body folding forward (the stretch)
  drawLimb(c, const Offset(135, 240), const Offset(200, 235), 16, kShirt);

  // Glow along the stretch line
  final stretchPath = Path()
    ..moveTo(135, 232)
    ..quadraticBezierTo(180, 222, 240, 232);
  c.drawPath(stretchPath, _stroke(kBodyLight.withAlpha(80), 2));

  // Neck and head (reaching forward and down)
  drawLimb(c, const Offset(200, 235), const Offset(230, 240), 12, kSkin);
  drawHead(c, const Offset(245, 238), 17, facingRight: true);

  // Arms reaching toward feet
  drawLimb(c, const Offset(170, 245), const Offset(250, 268), 8, kSkin);
  drawLimb(c, const Offset(175, 250), const Offset(255, 275), 8, kSkin);

  // Hands near feet
  drawEllipse(c, const Offset(253, 270), 7, 5, kSkin);
  drawEllipse(c, const Offset(258, 277), 7, 5, kSkin);
}

// ── main ─────────────────────────────────────────────────────────────────────

void main() {
  test('generate exercise images', () async {
    await save('glute_bridges', drawGluteBridges);
    await save('plank', drawPlank);
    await save('wall_sit', drawWallSit);
    await save('sprint', drawSprint);
    await save('pull_ups', drawPullUps);
    await save('long_run', drawLongRun);
    await save('stretching', drawStretching);
  });
}
