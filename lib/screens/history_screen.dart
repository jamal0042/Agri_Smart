import 'package:flutter/material.dart';
import 'package:AgriSmart/services/storage_service.dart';
import 'package:AgriSmart/services/disease_service.dart';
import 'package:AgriSmart/models/scan_result.dart';
import 'package:AgriSmart/widgets/scan_result_card.dart';
import 'package:AgriSmart/screens/disease_detail_screen.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  List<ScanResult> _scanHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  Future<void> _loadScanHistory() async {
    final history = await StorageService.getScanHistory();
    setState(() {
      _scanHistory = history;
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer l\'historique'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer tout l\'historique des analyses ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearScanHistory();
      _loadScanHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Historique effacé avec succès'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Historique des analyses'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_scanHistory.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Effacer l\'historique',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scanHistory.isEmpty
              ? _buildEmptyState(theme)
              : _buildHistoryList(theme),
    );
  }

  Widget _buildHistoryList(ThemeData theme) {
    return Column(
      children: [
        _buildStats(theme),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _scanHistory.length,
            itemBuilder: (context, index) {
              final scan = _scanHistory[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    final disease =
                        DiseaseService.getDiseaseById(scan.diseaseId);
                    if (disease != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DiseaseDetailScreen(disease: disease),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: ScanResultCard(scanResult: scan),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Statistiques',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Total d\'analyses',
                  _scanHistory.length.toString(),
                  Icons.analytics_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Cette semaine',
                  _getThisWeekCount().toString(),
                  Icons.calendar_today_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Confiance moy.',
                  '${_getAverageConfidence().toStringAsFixed(0)}%',
                  Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 80,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune analyse enregistrée',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vos analyses de plantes apparaîtront ici après avoir utilisé la fonction de scanner.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Naviguer vers l'écran de scan (tab 1)
                final tabController = DefaultTabController.of(context);
                if (tabController != null) {
                  tabController.animateTo(1);
                }
              },
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Commencer une analyse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getThisWeekCount() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return _scanHistory
        .where((scan) => scan.timestamp.isAfter(startOfWeek))
        .length;
  }

  double _getAverageConfidence() {
    if (_scanHistory.isEmpty) return 0.0;
    final total = _scanHistory.fold<double>(
      0.0,
      (sum, scan) => sum + scan.confidence,
    );
    return (total / _scanHistory.length) * 100;
  }
}
