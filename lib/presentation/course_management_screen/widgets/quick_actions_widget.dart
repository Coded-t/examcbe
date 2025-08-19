import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onBulkImport;
  final VoidCallback? onGenerateEnrollmentCodes;

  const QuickActionsWidget({
    Key? key,
    this.onBulkImport,
    this.onGenerateEnrollmentCodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  context,
                  'Bulk Import',
                  'upload_file',
                  'Import multiple courses from CSV',
                  onBulkImport,
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickAction(
                  context,
                  'Enrollment Codes',
                  'qr_code',
                  'Generate bulk enrollment codes',
                  onGenerateEnrollmentCodes,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    String iconName,
    String description,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
