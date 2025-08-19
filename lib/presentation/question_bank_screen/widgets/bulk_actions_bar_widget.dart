import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onBulkDelete;
  final VoidCallback onBulkMove;
  final VoidCallback onBulkChangeDifficulty;
  final VoidCallback onCancel;

  const BulkActionsBarWidget({
    Key? key,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onBulkDelete,
    required this.onBulkMove,
    required this.onBulkChangeDifficulty,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Selection info and cancel
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                size: 24,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                '$selectedCount selected',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onSelectAll,
                child: Text(
                  'Select All',
                  style: TextStyle(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context: context,
                icon: 'delete',
                label: 'Delete',
                color: AppTheme.errorLight,
                onTap: onBulkDelete,
              ),
              _buildActionButton(
                context: context,
                icon: 'folder_open',
                label: 'Move',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onTap: onBulkMove,
              ),
              _buildActionButton(
                context: context,
                icon: 'trending_up',
                label: 'Difficulty',
                color: AppTheme.warningLight,
                onTap: onBulkChangeDifficulty,
              ),
              _buildActionButton(
                context: context,
                icon: 'deselect',
                label: 'Deselect',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                onTap: onDeselectAll,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: icon,
                size: 20,
                color: color,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
