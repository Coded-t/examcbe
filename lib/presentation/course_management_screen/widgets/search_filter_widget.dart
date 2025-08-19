import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;
  final String selectedFilter;

  const SearchFilterWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Data Structures',
    'Database',
    'Machine Learning',
    'CS201',
  ];

  final Map<String, String> _filterOptions = {
    'all': 'All Courses',
    'active': 'Active',
    'draft': 'Draft',
    'archived': 'Archived',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(height: 3.h),
            Text(
              'Filter Courses',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ..._filterOptions.entries.map((entry) => ListTile(
                  leading: Radio<String>(
                    value: entry.key,
                    groupValue: widget.selectedFilter,
                    onChanged: (value) {
                      if (value != null) {
                        widget.onFilterChanged(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  title: Text(
                    entry.value,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    widget.onFilterChanged(entry.key);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSearchSuggestions() {
    if (_recentSearches.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(height: 3.h),
            Text(
              'Recent Searches',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ..._recentSearches.map((search) => ListTile(
                  leading: CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  title: Text(
                    search,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _searchController.text = search;
                    widget.onSearchChanged(search);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                onTap: _showSearchSuggestions,
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: widget.selectedFilter != 'all'
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.selectedFilter != 'all'
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            child: IconButton(
              onPressed: _showFilterBottomSheet,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: widget.selectedFilter != 'all'
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              tooltip: 'Filter courses',
            ),
          ),
        ],
      ),
    );
  }
}
