// Run with: flutter test test/generate_exercise_images_test.dart
// Generates missing exercise illustration PNGs into assets/images/

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double kSize = 400;
const Color kBg = Color(0xFF161B22);
const Color kLine = Color(0xFF58A6FF);
const Color kAccent = Color(0xFF3FB950);
const double kStroke = 8;
const double kHead = 28;

// ── helpers ──────────────────────────────────────────────────────────────────

Paint linePaint([Color c = kLine, double w = kStroke]) =>
    Paint()..color = c..strokeWidth = w..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;

Paint fillPaint([Color c = kLine]) =>
    Paint()..color = c..style = PaintingStyle.fill;

void drawHead(Canvas c, Offset center, [double r = kHead]) {
  c.drawCircle(center, r, linePaint());
}

Future<void> save(String name, void Function(Canvas, Size) draw) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, kSize, kSize));
  canvas.drawRect(Rect.fromLTWH(0, 0, kSize, kSize), fillPaint(kBg));
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
  // Person lying on back, knees bent, hips raised – viewed from side
  // Layout: head left → shoulders → hips UP → knees → feet on floor
  final p = linePaint();
  final pA = linePaint(kAccent);

  // floor
  c.drawLine(const Offset(40, 330), const Offset(360, 330), linePaint(kLine, 3));

  // head (lying on floor, left side)
  drawHead(c, const Offset(75, 305));

  // neck → shoulders (on floor)
  c.drawLine(const Offset(75, 277), const Offset(110, 280), p);

  // upper arms flat on floor
  c.drawLine(const Offset(110, 280), const Offset(80, 330), p);
  c.drawLine(const Offset(115, 282), const Offset(160, 330), p);

  // torso: shoulders to hips (hips raised – accent)
  c.drawLine(const Offset(110, 280), const Offset(200, 190), pA);

  // hip width
  c.drawLine(const Offset(195, 190), const Offset(215, 190), pA);

  // thighs: hips down to knees
  c.drawLine(const Offset(200, 190), const Offset(240, 280), p);
  c.drawLine(const Offset(215, 190), const Offset(255, 280), p);

  // shins: knees down to feet on floor
  c.drawLine(const Offset(240, 280), const Offset(235, 330), p);
  c.drawLine(const Offset(255, 280), const Offset(280, 330), p);
}

void drawPlank(Canvas c, Size s) {
  // Person in forearm plank
  final p = linePaint();

  // floor
  c.drawLine(const Offset(40, 310), const Offset(360, 310), linePaint(kLine, 3));

  // feet
  c.drawLine(const Offset(290, 310), const Offset(285, 280), p);
  c.drawLine(const Offset(320, 310), const Offset(315, 280), p);

  // legs to hips
  c.drawLine(const Offset(285, 280), const Offset(250, 265), p);
  c.drawLine(const Offset(315, 280), const Offset(280, 265), p);

  // body (straight line – accent)
  c.drawLine(const Offset(260, 268), const Offset(100, 280), linePaint(kAccent));

  // forearms on floor
  c.drawLine(const Offset(100, 280), const Offset(80, 310), p);
  c.drawLine(const Offset(110, 275), const Offset(130, 310), p);

  // neck + head
  c.drawLine(const Offset(95, 278), const Offset(70, 255), p);
  drawHead(c, const Offset(55, 232));
}

void drawWallSit(Canvas c, Size s) {
  // Person sitting against wall, 90° knee angle
  final p = linePaint();
  final pA = linePaint(kAccent);

  // wall (left)
  c.drawLine(const Offset(100, 60), const Offset(100, 360), linePaint(kLine, 3));
  // floor
  c.drawLine(const Offset(100, 340), const Offset(360, 340), linePaint(kLine, 3));

  // torso against wall (accent)
  c.drawLine(const Offset(100, 150), const Offset(100, 270), pA);

  // thighs horizontal
  c.drawLine(const Offset(100, 270), const Offset(250, 270), p);
  c.drawLine(const Offset(100, 260), const Offset(250, 260), p);

  // shins vertical
  c.drawLine(const Offset(250, 265), const Offset(250, 340), p);

  // arms resting on thighs
  c.drawLine(const Offset(100, 200), const Offset(180, 260), p);

  // head
  drawHead(c, const Offset(100, 118));
}

void drawSprint(Canvas c, Size s) {
  // Sprint / High Knees – dynamic forward lean, knee at chest height
  final p = linePaint();
  final pA = linePaint(kAccent);

  // floor
  c.drawLine(const Offset(40, 350), const Offset(360, 350), linePaint(kLine, 3));

  // head (slight forward lean)
  drawHead(c, const Offset(225, 80));

  // torso (forward lean)
  c.drawLine(const Offset(225, 108), const Offset(205, 220), p);

  // HIGH KNEE (front) – accent, knee at hip height
  c.drawLine(const Offset(205, 220), const Offset(245, 155), pA); // thigh up
  c.drawLine(const Offset(245, 155), const Offset(260, 220), pA); // shin down

  // rear leg (extended back and down)
  c.drawLine(const Offset(205, 220), const Offset(175, 290), p);
  c.drawLine(const Offset(175, 290), const Offset(155, 350), p);

  // front arm (pumping forward – accent)
  c.drawLine(const Offset(215, 145), const Offset(255, 195), pA);
  // rear arm (pumping back)
  c.drawLine(const Offset(215, 145), const Offset(170, 180), p);
}

void drawPullUps(Canvas c, Size s) {
  // Person hanging from bar, chin above bar
  final p = linePaint();
  final pA = linePaint(kAccent);

  // bar
  c.drawLine(const Offset(60, 90), const Offset(340, 90), linePaint(kLine, 6));
  // bar supports
  c.drawLine(const Offset(100, 50), const Offset(100, 90), linePaint(kLine, 4));
  c.drawLine(const Offset(300, 50), const Offset(300, 90), linePaint(kLine, 4));

  // hands on bar
  c.drawCircle(const Offset(150, 90), 8, fillPaint(kAccent));
  c.drawCircle(const Offset(250, 90), 8, fillPaint(kAccent));

  // arms (bent, pulling up – accent)
  c.drawLine(const Offset(150, 90), const Offset(165, 145), pA);
  c.drawLine(const Offset(250, 90), const Offset(235, 145), pA);

  // head (above bar level / chin up)
  drawHead(c, const Offset(200, 118));

  // shoulders
  c.drawLine(const Offset(165, 145), const Offset(235, 145), p);

  // torso
  c.drawLine(const Offset(200, 145), const Offset(200, 260), p);

  // legs hanging
  c.drawLine(const Offset(200, 260), const Offset(185, 340), p);
  c.drawLine(const Offset(200, 260), const Offset(215, 340), p);
}

void drawLongRun(Canvas c, Size s) {
  // Relaxed jogging figure
  final p = linePaint();
  final pA = linePaint(kAccent);

  // floor
  c.drawLine(const Offset(40, 360), const Offset(360, 360), linePaint(kLine, 3));

  // head
  drawHead(c, const Offset(210, 90));

  // torso (upright)
  c.drawLine(const Offset(210, 118), const Offset(205, 235), p);

  // rear leg
  c.drawLine(const Offset(205, 235), const Offset(175, 300), p);
  c.drawLine(const Offset(175, 300), const Offset(155, 360), p);

  // front leg (accent – stride forward)
  c.drawLine(const Offset(205, 235), const Offset(235, 295), pA);
  c.drawLine(const Offset(235, 295), const Offset(255, 360), pA);

  // arms relaxed
  c.drawLine(const Offset(207, 160), const Offset(175, 215), p);
  c.drawLine(const Offset(207, 160), const Offset(245, 200), p);
}

void drawStretching(Canvas c, Size s) {
  // Seated forward bend: sitting upright figure folds torso over straight legs
  // Hips on left, legs extend right, torso bends forward to the right
  final p = linePaint();
  final pA = linePaint(kAccent);

  // floor
  c.drawLine(const Offset(40, 300), const Offset(360, 300), linePaint(kLine, 3));

  // hips at left-center
  const hx = 120.0;
  const hy = 295.0;

  // legs extended to the right along the floor
  c.drawLine(const Offset(hx, hy), const Offset(340, 297), p);

  // torso bending sharply forward (accent) – from hips up then curving toward feet
  c.drawLine(const Offset(hx, hy), const Offset(hx, hy - 120), p);   // upright back
  c.drawLine(const Offset(hx, hy - 120), const Offset(310, hy - 40), pA); // torso fold forward

  // head at tip of folded torso
  drawHead(c, const Offset(318, hy - 65));

  // arms along the legs, hands reaching toes (accent)
  c.drawLine(const Offset(hx + 10, hy - 90), const Offset(335, hy - 10), pA);
}

// ── main ─────────────────────────────────────────────────────────────────────

void main() {
  test('generate missing exercise images', () async {
    await save('glute_bridges', drawGluteBridges);
    await save('plank', drawPlank);
    await save('wall_sit', drawWallSit);
    await save('sprint', drawSprint);
    await save('pull_ups', drawPullUps);
    await save('long_run', drawLongRun);
    await save('stretching', drawStretching);
  });
}
