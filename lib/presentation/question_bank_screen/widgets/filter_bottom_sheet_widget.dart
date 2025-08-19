import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> _questionTypes = [
    'Multiple Choice',
    'True/False',
    'Fill in the Blank'
  ];
  final List<String> _usageStatuses = [
    'All',
    'Used in Active Exams',
    'Not Used',
    'Frequently Used'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Questions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Difficulty filter
                  _buildFilterSection(
                    title: 'Difficulty Level',
                    icon: 'trending_up',
                    child: _buildChipGroup(
                      items: _difficulties,
                      selectedItems:
                          (_filters['difficulties'] as List<String>?) ?? [],
                      onSelectionChanged: (selected) {
                        setState(() {
                          _filters['difficulties'] = selected;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Question type filter
                  _buildFilterSection(
                    title: 'Question Type',
                    icon: 'quiz',
                    child: _buildChipGroup(
                      items: _questionTypes,
                      selectedItems:
                          (_filters['questionTypes'] as List<String>?) ?? [],
                      onSelectionChanged: (selected) {
                        setState(() {
                          _filters['questionTypes'] = selected;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Usage status filter
                  _buildFilterSection(
                    title: 'Usage Status',
                    icon: 'visibility',
                    child: _buildRadioGroup(
                      items: _usageStatuses,
                      selectedItem: _filters['usageStatus'] ?? 'All',
                      onSelectionChanged: (selected) {
                        setState(() {
                          _filters['usageStatus'] = selected;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required String icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        child,
      ],
    );
  }

  Widget _buildChipGroup({
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedItems);
            if (selected) {
              newSelection.add(item);
            } else {
              newSelection.remove(item);
            }
            onSelectionChanged(newSelection);
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.primaryColor,
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
          side: BorderSide(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRadioGroup({
    required List<String> items,
    required String selectedItem,
    required Function(String) onSelectionChanged,
  }) {
    return Column(
      children: items.map((item) {
        return RadioListTile<String>(
          title: Text(
            item,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          value: item,
          groupValue: selectedItem,
          onChanged: (value) {
            if (value != null) {
              onSelectionChanged(value);
            }
          },
          activeColor: AppTheme.lightTheme.primaryColor,
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }).toList(),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'difficulties': <String>[],
        'questionTypes': <String>[],
        'usageStatus': 'All',
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
