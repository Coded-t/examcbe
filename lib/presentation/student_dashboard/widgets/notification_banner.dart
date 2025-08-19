import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationBanner extends StatefulWidget {
  final Map<String, dynamic>? notification;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;

  const NotificationBanner({
    Key? key,
    this.notification,
    this.onDismiss,
    this.onTap,
  }) : super(key: key);

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.notification != null) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(NotificationBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notification != null && oldWidget.notification == null) {
      _animationController.forward();
    } else if (widget.notification == null && oldWidget.notification != null) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notification == null) {
      return const SizedBox.shrink();
    }

    final notification = widget.notification!;
    final type = notification['type'] as String;
    final title = notification['title'] as String;
    final message = notification['message'] as String;
    final isUrgent = notification['isUrgent'] as bool? ?? false;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(type),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getBorderColor(type),
                        width: isUrgent ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: _getIconBackgroundColor(type),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: _getIconName(type),
                            color: _getIconColor(type),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: _getTextColor(type),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isUrgent)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.5.w,
                                        vertical: 0.3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.error,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'URGENT',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9.sp,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                message,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: _getTextColor(type)
                                      .withValues(alpha: 0.8),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (notification['timestamp'] != null) ...[
                                SizedBox(height: 0.5.h),
                                Text(
                                  _formatTimestamp(
                                      notification['timestamp'] as DateTime),
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: _getTextColor(type)
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),
                        if (widget.onDismiss != null)
                          GestureDetector(
                            onTap: () {
                              _animationController.reverse().then((_) {
                                widget.onDismiss?.call();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color:
                                    _getTextColor(type).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color:
                                    _getTextColor(type).withValues(alpha: 0.6),
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
      case 'result':
        return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
      case 'deadline':
        return AppTheme.warningLight.withValues(alpha: 0.1);
      case 'error':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      case 'info':
      default:
        return AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3);
      case 'result':
        return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3);
      case 'deadline':
        return AppTheme.warningLight.withValues(alpha: 0.3);
      case 'error':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3);
      case 'info':
      default:
        return AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3);
    }
  }

  Color _getIconBackgroundColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2);
      case 'result':
        return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.2);
      case 'deadline':
        return AppTheme.warningLight.withValues(alpha: 0.2);
      case 'error':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2);
      case 'info':
      default:
        return AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.2);
    }
  }

  Color _getIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'result':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'deadline':
        return AppTheme.warningLight;
      case 'error':
        return AppTheme.lightTheme.colorScheme.error;
      case 'info':
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  Color _getTextColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'result':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'deadline':
        return AppTheme.warningLight;
      case 'error':
        return AppTheme.lightTheme.colorScheme.error;
      case 'info':
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getIconName(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return 'assignment';
      case 'result':
        return 'grade';
      case 'deadline':
        return 'schedule';
      case 'error':
        return 'error';
      case 'info':
      default:
        return 'info';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
