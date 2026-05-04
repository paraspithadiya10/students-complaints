import 'package:complaints/common/models/profile_model.dart';
import 'package:complaints/common/models/response_model.dart';
import 'package:complaints/data/supabase/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileController extends Notifier<Profile> {
  @override
  Profile build() => Profile();

  final _profileService = ProfileService();

  Future<void> getProfile(String userId) async {
    setLoading(true);
    try {
      final response = await _profileService.getProfile(userId);

      if (response.type != ResponseType.success || response.data == null) {
        debugPrint('Failed to fetch Profile');
        return;
      }

      final profile = response.data as Profile;

      state = state.copyWith(
        id: profile.id,
        username: profile.username,
        email: profile.email,
        stream: profile.stream,
        mobileNo: profile.mobileNo,
        avatarUrl: profile.avatarUrl,
        createdAt: profile.createdAt,
      );
    } catch (e) {
      debugPrint('Failed to fetch Profile: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    state = state.copyWith();
  }
}
