import 'package:complaints/common/utils/enum_utils.dart';

extension ComplaintSeverityExtension on ComplaintSeverity {
  static ComplaintSeverity fromJson(String value) {
    final normalized = value.trim().toLowerCase();

    return ComplaintSeverity.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => ComplaintSeverity.low,
    );
  }
}
