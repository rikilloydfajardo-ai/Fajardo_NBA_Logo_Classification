import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/nba_class.dart';
import 'services/nba_service.dart';

class TeamDetailsScreen extends StatelessWidget {
  final NBAClass team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1E293B),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'team_${team.name}',
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Image.asset(
                        team.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'EST. ${team.foundedYear}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info Grid
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          title: 'COACH',
                          value: team.coach,
                          icon: Icons.sports,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoCard(
                          title: 'ARENA',
                          value: team.arena,
                          icon: Icons.stadium,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // LIVE STATS WIDGET
                  _SectionHeader(title: '2025-26 Season'),
                  const SizedBox(height: 12),
                  _LiveStatsCard(teamId: team.id),

                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final slugs = [
                          'lakers',
                          'celtics',
                          'bulls',
                          'nets',
                          'warriors',
                          'mavericks',
                          'suns',
                          'heat',
                          'spurs',
                          'rockets'
                        ];
                        final slug = slugs[team.id];
                        final url = Uri.parse('https://www.nba.com/team/$slug');
                        if (!await launchUrl(url)) {
                          debugPrint('Could not launch \$url');
                        }
                      },
                      icon: const Icon(Icons.public, size: 18),
                      label: const Text('View Official NBA.com Stats'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  _SectionHeader(title: 'Overview'),
                  const SizedBox(height: 12),
                  Text(
                    team.description,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[300],
                    ),
                  ),

                  const SizedBox(height: 32),

                  _SectionHeader(title: 'Key Facts'),
                  const SizedBox(height: 16),
                  ...team.facts.map((fact) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                fact,
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 32),

                  _SectionHeader(title: 'Active Roster'),
                  const SizedBox(height: 12),
                  _TeamRosterList(teamId: team.id),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _LiveStatsCard extends StatefulWidget {
  final int teamId;
  const _LiveStatsCard({required this.teamId});

  @override
  State<_LiveStatsCard> createState() => _LiveStatsCardState();
}

class _LiveStatsCardState extends State<_LiveStatsCard> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final stats = await NBAService().getTeamStats(widget.teamId);
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: LinearProgressIndicator(minHeight: 2));
    }

    if (_stats == null || _stats!.isEmpty) {
      return const SizedBox.shrink(); // Hide if no data
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'RECORD',
            value: '${_stats!['wins']}-${_stats!['losses']}',
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          _StatItem(
            label: 'RANK',
            value: '#${_stats!['rank']} ${_stats!['conference']}',
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          _StatItem(
            label: 'DIV',
            value:
                _stats!['division'].toString().split(' ').first.toUpperCase(),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TeamRosterList extends StatefulWidget {
  final int teamId;
  const _TeamRosterList({required this.teamId});

  @override
  State<_TeamRosterList> createState() => _TeamRosterListState();
}

class _TeamRosterListState extends State<_TeamRosterList> {
  List<Map<String, String>> _players = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    final players = await NBAService().getPlayers(widget.teamId);
    if (mounted) {
      setState(() {
        _players = players;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: _players.map((player) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: Text(
                  player['pos'] ?? '',
                  style: GoogleFonts.outfit(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player['name'] ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Avg Points: ${player['ppg']}',
                      style: GoogleFonts.outfit(
                          color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
