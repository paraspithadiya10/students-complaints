import 'package:complaints/common/controllers/profile_controller.dart';
import 'package:complaints/common/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider = NotifierProvider<ProfileController, Profile>(
  ProfileController.new,
);
