// lib/features/compose/presentation/pages/compose_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/utils/bidi_detector.dart';
import '../../../../l10n/l10n.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  TextDirection _subjectDirection = TextDirection.ltr;
  TextDirection _bodyDirection = TextDirection.ltr;

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _onSubjectChanged(String text) {
    setState(() {
      _subjectDirection = directionOf(text);
    });
  }

  void _onBodyChanged(String text) {
    setState(() {
      _bodyDirection = directionOf(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.composeTitle),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: FilledButton.icon(
              icon: const Icon(Icons.send_rounded, size: 16),
              label: Text(l10n.send),
              style: FilledButton.styleFrom(
                minimumSize: Size(80.w, 36.h),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
              ),
              onPressed: () {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.send),
                    backgroundColor: colors.success,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              // To field
              TextField(
                controller: _toController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Text(
                      '${l10n.toField}:',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurfaceSubtle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: 'recipient@example.com',
                ),
              ),
              SizedBox(height: 10.h),
              // Subject field
              TextField(
                controller: _subjectController,
                textDirection: _subjectDirection,
                onChanged: _onSubjectChanged,
                decoration: InputDecoration(
                  hintText: l10n.subjectField,
                ),
              ),
              SizedBox(height: 10.h),
              // Body field
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: colors.outline),
                  ),
                  child: TextField(
                    controller: _bodyController,
                    textDirection: _bodyDirection,
                    onChanged: _onBodyChanged,
                    maxLines: null,
                    expands: true,
                    style: textTheme.bodyLarge?.copyWith(color: colors.onSurface),
                    decoration: InputDecoration(
                      hintText: l10n.bodyField,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Bottom Action Bar
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: l10n.scheduleSend,
                    icon: Icon(Icons.schedule_send_rounded, color: colors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.scheduleSend)),
                      );
                    },
                  ),
                  SizedBox(width: 8.w),
                  IconButton.outlined(
                    tooltip: 'Attach',
                    icon: Icon(Icons.attach_file_rounded, color: colors.onSurfaceMuted),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: Icon(Icons.delete_outline_rounded, color: colors.error, size: 18),
                    label: Text(
                      l10n.discard,
                      style: textTheme.labelMedium?.copyWith(color: colors.error),
                    ),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
