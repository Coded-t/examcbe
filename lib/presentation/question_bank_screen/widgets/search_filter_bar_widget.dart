import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;
  final ValueChanged<String>? onSearchChanged;

  const SearchFilterBarWidget({
    Key? key,
    required this.searchController,
    required this.onFilterTap,
    this.hasActiveFilters = false,
    this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search questions...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged?.call('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            size: 20,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Filter button
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              color: hasActiveFilters
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: hasActiveFilters
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: InkWell(
                    onTap: onFilterTap,
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'filter_list',
                          size: 24,
                          color: hasActiveFilters
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),

                // Active filter indicator
                if (hasActiveFilters)
                  Positioned(
                    top: 0.5.h,
                    right: 0.5.h,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
