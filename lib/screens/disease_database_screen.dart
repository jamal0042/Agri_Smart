import 'package:flutter/material.dart';
import 'package:AgriSmart/services/disease_service.dart';
import 'package:AgriSmart/models/disease.dart';
import 'package:AgriSmart/widgets/disease_card.dart';
import 'package:AgriSmart/screens/disease_detail_screen.dart';

class DiseaseDatabaseScreen extends StatefulWidget {
  const DiseaseDatabaseScreen({super.key});

  @override
  State<DiseaseDatabaseScreen> createState() => _DiseaseDatabaseScreenState();
}

class _DiseaseDatabaseScreenState extends State<DiseaseDatabaseScreen> {
  List<Disease> _diseases = [];
  List<Disease> _filteredDiseases = [];
  String _searchQuery = '';
  String _selectedFilter = 'Toutes';

  final List<String> _plantTypes = [
    'Toutes',
    'Tomate',
    'Multiple',
    'Céréales',
    'Fruits et légumes',
  ];

  @override
  void initState() {
    super.initState();
    _loadDiseases();
  }

  void _loadDiseases() {
    _diseases = DiseaseService.getAllDiseases();
    _filteredDiseases = _diseases;
    setState(() {});
  }

  void _filterDiseases() {
    _filteredDiseases = _diseases.where((disease) {
      final matchesSearch = _searchQuery.isEmpty ||
          disease.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          disease.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _selectedFilter == 'Toutes' ||
          disease.plantType == _selectedFilter ||
          (disease.plantType == 'Multiple' && _selectedFilter != 'Toutes');

      return matchesSearch && matchesFilter;
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Base de données'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(theme),
          Expanded(
            child: _filteredDiseases.isEmpty
                ? _buildEmptyState(theme)
                : _buildDiseaseList(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(ThemeData theme) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        TextField(
          onChanged: (value) {
            _searchQuery = value;
            _filterDiseases();
          },
          decoration: InputDecoration(
            hintText: 'Rechercher une maladie...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _plantTypes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final plantType = _plantTypes[index];
              final isSelected = plantType == _selectedFilter;
              
              return FilterChip(
                label: Text(plantType),
                selected: isSelected,
                onSelected: (selected) {
                  _selectedFilter = plantType;
                  _filterDiseases();
                },
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              );
            },
          ),
        ),
      ],
    ),
  );

  Widget _buildDiseaseList(ThemeData theme) => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: _filteredDiseases.length,
    itemBuilder: (context, index) {
      final disease = _filteredDiseases[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DiseaseCard(
          disease: disease,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiseaseDetailScreen(disease: disease),
            ),
          ),
        ),
      );
    },
  );

  Widget _buildEmptyState(ThemeData theme) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune maladie trouvée',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de modifier vos critères de recherche',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    ),
  );
}