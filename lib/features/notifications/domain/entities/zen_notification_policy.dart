import 'package:equatable/equatable.dart';

class ZenNotificationPolicy extends Equatable {
  final bool quietHoursEnabled;
  final int quietHoursStartMinutes;
  final int quietHoursEndMinutes;

  const ZenNotificationPolicy({
    required this.quietHoursEnabled,
    required this.quietHoursStartMinutes,
    required this.quietHoursEndMinutes,
  });

  @override
  List<Object?> get props => [quietHoursEnabled, quietHoursStartMinutes, quietHoursEndMinutes];
}
