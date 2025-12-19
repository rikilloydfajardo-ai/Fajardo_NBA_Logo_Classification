import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/nba_class.dart'; // Import to access team logos

class AnalyticsScreen extends StatelessWidget {
  final File imageFile;
  final String label;
  final double confidence;
  final List<Map<String, dynamic>> recognitions;

  const AnalyticsScreen({
    super.key,
    required this.imageFile,
    required this.label,
    required this.confidence,
    required this.recognitions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Analytics Report',
            style: GoogleFonts.outfit(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Image & Main Result (Glassmorphism Card)
            _buildTopSection(),
            const SizedBox(height: 32),

            // Analytics Section: Pie Chart (Donut)
            Text('Confidence Distribution',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDonutChartSection(),
            const SizedBox(height: 32),

            // Item List (All Classes)
            Text('Full Team Analysis',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildClassesList(),
            const SizedBox(height: 32),

            // Rate/Quality Section
            _buildQualitySection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF4B1F), width: 2),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFFFF4B1F).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(imageFile,
                  width: 90, height: 90, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IDENTIFIED',
                  style: GoogleFonts.outfit(
                      color: const Color(0xFFFF4B1F),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  label.isNotEmpty ? label : 'Unknown',
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.1),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.5))),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(1)}% Match',
                    style: GoogleFonts.outfit(
                        color: const Color(0xFF10B981),
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartSection() {
    // Only take top 5 for the chart specifically to avoid clutter,
    // but the list will show ALL.
    final chartData = recognitions.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 140,
            width: 140,
            child: CustomPaint(
              painter: DonutChartPainter(chartData),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(confidence * 100).toInt()}%',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Sure',
                      style:
                          GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                ],
              )),
            ),
          ),
          // Legend
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: chartData.map((rec) {
              int idx = chartData.indexOf(rec);
              final colors = [
                const Color(0xFF10B981),
                const Color(0xFFFF4B1F),
                Colors.blueAccent,
                Colors.amber,
                Colors.purpleAccent
              ];
              Color c = colors[idx % colors.length];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration:
                          BoxDecoration(color: c, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text((rec['label'] as String).split(' ').last,
                      style: GoogleFonts.outfit(
                          color: Colors.white70, fontSize: 12))
                ]),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildClassesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recognitions.length,
      itemBuilder: (context, index) {
        final rec = recognitions[index];
        final double val = (rec['confidence'] as double);
        final String name = rec['label'] as String;
        final int teamIdx = rec['index'] as int;

        // Try to get logo from nbaClasses if available
        String? logoAsset;
        try {
          // We assume nbaClasses is available and has an entry for this index
          // Need to handle potential index mismatch safely
          final nbaClass = nbaClasses.firstWhere((c) => c.id == teamIdx,
              orElse: () => nbaClasses[0]);
          // Only use it if IDs truly match, otherwise fallback
          if (nbaClass.id == teamIdx) {
            logoAsset = nbaClass.imagePath;
          }
        } catch (_) {}

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10)),
          child: Row(
            children: [
              // Team Logo Mini
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade800)),
                child: logoAsset != null
                    ? ClipOval(child: Image.asset(logoAsset, fit: BoxFit.cover))
                    : const Icon(Icons.sports_basketball,
                        size: 20, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: val,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(val > 0.8
                            ? const Color(0xFF10B981)
                            : val > 0.3
                                ? const Color(0xFFFF4B1F)
                                : Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('${(val * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.outfit(
                      color: val > 0.8 ? const Color(0xFF10B981) : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQualitySection() {
    // Fake Authentication Score driven by confidence
    int score = (confidence * 5).round();
    if (score < 1) score = 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF2C3E50), Color(0xFF0F172A)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Authenticity Score",
                  style:
                      GoogleFonts.outfit(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                  score >= 4
                      ? "EXCELLENT"
                      : score >= 3
                          ? "GOOD"
                          : "UNCERTAIN",
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: List.generate(
                5,
                (index) => Icon(index < score ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFD700), size: 30)),
          )
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> recognitions;

  DonutChartPainter(this.recognitions);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = 12.0;

    double startAngle = -pi / 2;

    // We normalize top 5 to fill the circle relative to each other for visual effect
    // Or we keep it absolute. Absolute is better for truth, but relative looks better if confidence is low.
    // Let's use absolute but fill remainder with grey.

    double totalConf = recognitions.fold(
        0.0, (sum, item) => sum + (item['confidence'] as double));
    double remainder = 1.0 - totalConf;
    if (remainder < 0) remainder = 0;

    final colors = [
      const Color(0xFF10B981), // Top 1 Green
      const Color(0xFFFF4B1F), // Top 2 Orange
      Colors.blueAccent,
      Colors.amber,
      Colors.purpleAccent,
    ];

    int i = 0;
    for (var rec in recognitions) {
      final double sweepAngle = 2 * pi * (rec['confidence'] as double);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = colors[i % colors.length];

      // Draw arc
      // To make nice rounded caps working well close together is tricky, but let's try
      canvas.drawArc(
          rect.deflate(strokeWidth / 2), startAngle, sweepAngle, false, paint);

      startAngle += sweepAngle;
      i++;
    }

    // Draw remainder background ring if needed
    if (remainder > 0.05) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = Colors.white10;
      // background ring under
      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
