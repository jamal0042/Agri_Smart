import 'package:flutter/material.dart';
import 'package:AgriSmart/models/disease.dart';
import 'package:AgriSmart/widgets/treatment_card.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailScreen({
    super.key,
    required this.disease,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDiseaseInfo(theme),
                const SizedBox(height: 24),
                _buildSymptoms(theme),
                const SizedBox(height: 24),
                _buildCauses(theme),
                const SizedBox(height: 24),
                _buildTreatments(theme),
                const SizedBox(height: 24),
                _buildExpertConsultation(theme),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) => SliverAppBar(
    expandedHeight: 200,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      title: Text(
        disease.name,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: disease.imageUrl.isNotEmpty
            ? Image.network(
                disease.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.local_florist_rounded,
                  size: 80,
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
              )
            : Icon(
                Icons.local_florist_rounded,
                size: 80,
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
              ),
      ),
    ),
  );

  Widget _buildDiseaseInfo(ThemeData theme) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type de plante',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    disease.plantType,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getSeverityColor(theme),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Gravité: ${disease.severity}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          disease.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
      ],
    ),
  );

  Widget _buildSymptoms(ThemeData theme) => _buildSection(
    theme,
    'Symptômes',
    Icons.warning_rounded,
    disease.symptoms,
    theme.colorScheme.errorContainer,
    theme.colorScheme.onErrorContainer,
  );

  Widget _buildCauses(ThemeData theme) => _buildSection(
    theme,
    'Causes',
    Icons.psychology_rounded,
    disease.causes,
    theme.colorScheme.tertiaryContainer,
    theme.colorScheme.onTertiaryContainer,
  );

  Widget _buildSection(
    ThemeData theme,
    String title,
    IconData icon,
    List<String> items,
    Color backgroundColor,
    Color foregroundColor,
  ) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: foregroundColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 8, right: 12),
                decoration: BoxDecoration(
                  color: foregroundColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: foregroundColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    ),
  );

  Widget _buildTreatments(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.healing_rounded,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Traitements recommandés',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ...disease.treatments.asMap().entries.map((entry) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TreatmentCard(
          treatment: entry.value,
          priority: entry.key + 1,
        ),
      )),
    ],
  );

  Widget _buildExpertConsultation(ThemeData theme) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.primaryContainer,
          theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.support_agent_rounded,
              color: theme.colorScheme.onPrimaryContainer,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Besoin d\'aide ?',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Consultez un expert agricole pour obtenir des conseils personnalisés pour votre situation.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_rounded),
            label: const Text('Consulter un expert'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Color _getSeverityColor(ThemeData theme) {
    switch (disease.severity.toLowerCase()) {
      case 'élevée':
      case 'elevée':
      case 'high':
        return theme.colorScheme.error;
      case 'modérée':
      case 'moderée':
      case 'moderate':
        return Colors.orange;
      case 'faible':
      case 'low':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.secondary;
    }
  }
}