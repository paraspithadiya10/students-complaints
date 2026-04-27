import 'package:complaints/common/models/response_model.dart';
import 'package:complaints/common/models/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  Future<ResponseModel> getProfile(String userId) async {
    try {
      final response = await supabase.rpc(
        'get_user_profile',
        params: {'p_id': userId},
      );

      debugPrint('Raw response: $response');

      if (response == null) {
        return ResponseModel(data: null, type: ResponseType.error);
      }

      final list = response as List<dynamic>;
      debugPrint('mobile_no value: ${list.first['mobile_no']}');
      debugPrint('mobile_no type: ${list.first['mobile_no'].runtimeType}');

      if (list.isEmpty) {
        return ResponseModel(data: null, type: ResponseType.error);
      }

      final profile = Profile.fromJson(list.first);

      return ResponseModel(data: profile, type: ResponseType.success);
    } catch (e) {
      debugPrint('Service error: ${e.toString()}');
      return ResponseModel(data: null, type: ResponseType.exception);
    }
  }
}
