import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/collection_service.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final history = CollectionService().history;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Scan History',
            style: GoogleFonts.outfit(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1E293B),
                    title: Text('Clear History?',
                        style: GoogleFonts.outfit(color: Colors.white)),
                    content: Text(
                        'This will permanently delete all your scan history.',
                        style: GoogleFonts.outfit(color: Colors.grey[400])),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('CANCEL',
                            style: GoogleFonts.outfit(color: Colors.grey[400])),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await CollectionService().clearHistory();
                          setState(() {});
                        },
                        child: Text('DELETE',
                            style: GoogleFonts.outfit(
                                color: const Color(0xFFFF4B1F))),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    'No scans yet',
                    style: GoogleFonts.outfit(
                        color: Colors.grey[500], fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = history[index];
                final confidence = (item['confidence'] as double? ?? 0.0) * 100;
                final timestamp = DateTime.tryParse(item['timestamp'] ?? '') ??
                    DateTime.now();

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.qr_code_2, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['teamName'] ?? 'Unknown',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${timestamp.year}-${timestamp.month}-${timestamp.day} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                              style: GoogleFonts.outfit(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: confidence > 80
                              ? const Color(0xFF10B981).withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${confidence.toInt()}%',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: confidence > 80
                                ? const Color(0xFF10B981)
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
