import 'package:reactive_forms/reactive_forms.dart';

class DurationValueAccessor extends ControlValueAccessor<Duration, String> {
  @override
  Duration? viewToModelValue(String? input) {
    if (input == null || input.isEmpty) return null;

    final parts = input.split(':');
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return Duration(hours: hours, minutes: minutes);
  }

  @override
  String? modelToViewValue(Duration? duration) {
    if (duration == null) return '';
    final hh = duration.inHours.remainder(60).toString().padLeft(2, '0');
    final mm = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
