import 'package:flutter/material.dart';

class TreatmentCard extends StatelessWidget {
  final String treatment;
  final int priority;

  const TreatmentCard({
    super.key,
    required this.treatment,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPriorityColor(theme).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getPriorityColor(theme),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                priority.toString(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              treatment,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
          Icon(
            Icons.check_circle_outline_rounded,
            color: _getPriorityColor(theme),
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(ThemeData theme) {
    switch (priority) {
      case 1:
        return theme.colorScheme.primary;
      case 2:
        return theme.colorScheme.secondary;
      case 3:
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.primary;
    }
  }
}