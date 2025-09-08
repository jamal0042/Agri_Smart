import 'package:flutter/material.dart';
import 'package:AgriSmart/models/disease.dart';

class DiseaseCard extends StatelessWidget {
  final Disease disease;
  final VoidCallback? onTap;

  const DiseaseCard({
    super.key,
    required this.disease,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: disease.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              disease.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.local_florist_rounded,
                                color: theme.colorScheme.onPrimaryContainer,
                                size: 32,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.local_florist_rounded,
                            color: theme.colorScheme.onPrimaryContainer,
                            size: 32,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disease.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            disease.plantType,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              _getSeverityIcon(),
                              size: 16,
                              color: _getSeverityColor(theme),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              disease.severity,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: _getSeverityColor(theme),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                disease.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.medical_services_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${disease.symptoms.length} symptômes',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.healing_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${disease.treatments.length} traitements',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  IconData _getSeverityIcon() {
    switch (disease.severity.toLowerCase()) {
      case 'élevée':
      case 'elevée':
      case 'high':
        return Icons.error_rounded;
      case 'modérée':
      case 'moderée':
      case 'moderate':
        return Icons.warning_rounded;
      case 'faible':
      case 'low':
        return Icons.info_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}