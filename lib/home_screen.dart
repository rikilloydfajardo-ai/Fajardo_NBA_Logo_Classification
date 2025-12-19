import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/nba_class.dart';
import 'classifier_screen.dart';
import 'team_details_screen.dart';
import 'services/collection_service.dart';
import 'scan_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionService _collectionService = CollectionService();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    await _collectionService.init();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    final unlockedCount = _collectionService.unlockedCount;
    final totalTeams = nbaClasses.length;
    final progress = totalTeams > 0 ? unlockedCount / totalTeams : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.sports_basketball,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Text(
              'NBA Lens',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScanHistoryScreen()),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(Icons.history, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              const Color(0xFF0B1121),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Collection',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            '$unlockedCount/$totalTeams',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white10,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan teams to unlock their profiles!',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.80,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: nbaClasses.length,
                  itemBuilder: (context, index) {
                    final team = nbaClasses[index];
                    final isUnlocked =
                        _collectionService.isTeamUnlocked(team.id);
                    return TeamCard(
                      team: team,
                      isUnlocked: isUnlocked,
                      onTap: () {
                        print("Team card tapped: ${team.name}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamDetailsScreen(team: team),
                          ),
                        ).then((_) => _refresh());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClassifierScreen()),
          );
          _refresh();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        label: Text(
          'Scan Logo',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final NBAClass team;
  final bool isUnlocked;
  final VoidCallback onTap;

  const TeamCard({
    super.key,
    required this.team,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnlocked
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Hero(
                    tag: 'team_${team.name}',
                    child: Image.asset(
                      team.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              team.name,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isUnlocked)
                            Icon(Icons.check_circle_outline, // Changed icon
                                size: 14,
                                color: Colors.grey.withOpacity(0.5)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to view details', // Always show this
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
