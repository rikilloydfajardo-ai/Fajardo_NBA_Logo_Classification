import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/tflite_service.dart';
import 'services/firestore_service.dart';
import 'services/collection_service.dart';
import 'analytics_screen.dart';

class ClassifierScreen extends StatefulWidget {
  const ClassifierScreen({super.key});

  @override
  State<ClassifierScreen> createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen> {
  final TFLiteService _tfliteService = TFLiteService();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  File? _image;
  String _label = '';
  double _confidence = 0.0;
  List<Map<String, dynamic>> _recognitions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    await _tfliteService.loadModel();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // maxWidth/maxHeight 2048 ensures high quality while fixing orientation
      // imageQuality: 100 ensures maximum JPEG quality
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isLoading = true;
          _label = '';
          _confidence = 0.0;
        });
        await _classifyImage(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _classifyImage(String path) async {
    final result = await _tfliteService.classifyImage(path);
    final String label = result['label'];
    final double confidence = result['confidence'];
    final int index = result['index'];
    final List<Map<String, dynamic>> recognitions =
        List<Map<String, dynamic>>.from(result['recognitions'] ?? []);

    setState(() {
      _label = label;
      _confidence = confidence;
      _recognitions = recognitions;
      _isLoading = false;
    });

    // Log to Firestore if confidence is decent
    if (_confidence > 0.5) {
      await _firestoreService.logClassification(
        label: _label,
        confidence: _confidence,
      );
    }

    // Unlock Logic
    if (_confidence > 0.60) {
      final collectionService = CollectionService();
      // Add to history
      await collectionService.addToHistory(_label, _confidence);

      // Unlock team
      final isNewUnlock = await collectionService.unlockTeam(index);

      if (isNewUnlock && mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.emoji_events, color: Color(0xFFFF4B1F)),
                SizedBox(width: 8),
                Text('TEAM UNLOCKED!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            content: Text('You have collected the $_label!',
                style: TextStyle(color: Colors.grey[300])),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('AWESOME',
                    style: TextStyle(
                        color: Color(0xFFFF4B1F), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Team Scanner',
            style: GoogleFonts.outfit(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_image != null)
                      Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 80,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Upload or Take Photo',
                            style: GoogleFonts.outfit(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    if (_isLoading)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF4B1F),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_label.isNotEmpty) ...[
                  Text(
                    'Match Analysis Complete',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: _confidence),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeOutQuart,
                          builder: (context, value, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.white10,
                                    color: value > 0.8
                                        ? const Color(0xFF10B981) // Green
                                        : value > 0.5
                                            ? const Color(0xFFFF4B1F) // Orange
                                            : const Color(0xFFEF4444), // Red
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(value * 100).toInt()}%',
                                      style: GoogleFonts.outfit(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IDENTIFIED TEAM',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: const Color(0xFFFF4B1F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _label.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.1,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'High confidence match',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // View Report Button
                  GestureDetector(
                    onTap: () {
                      if (_image != null && _recognitions.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalyticsScreen(
                              imageFile: _image!,
                              label: _label,
                              confidence: _confidence,
                              recognitions: _recognitions,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Center(
                        child: Text(
                          'VIEW FULL REPORT',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Camera',
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Gallery',
                        onTap: () => _pickImage(ImageSource.gallery),
                        isSecondary: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSecondary ? const Color(0xFF1E293B) : const Color(0xFFFF4B1F),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
