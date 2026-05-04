import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileAvatar extends ConsumerStatefulWidget {
  final double radius;
  final String? initialImageUrl;

  const ProfileAvatar({super.key, this.radius = 50, this.initialImageUrl});

  @override
  ConsumerState<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends ConsumerState<ProfileAvatar> {
  File? _image;
  bool _loading = false;

  final _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  Future<void> _pickAndUpload(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) return;

      final user = supabase.auth.currentUser;

      if (user == null) {
        debugPrint("❌ User not logged in");
        return;
      }

      setState(() {
        _image = File(pickedFile.path);
        _loading = true;
      });

      final fileExt = pickedFile.path.split('.').last;
      final fileName = '${user.id}.$fileExt';
      final filePath = 'avatars/$fileName';

      await supabase.storage
          .from('avatars')
          .upload(
            filePath,
            _image!,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

      await supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id)
          .select();

      ref.read(profileControllerProvider.notifier).getProfile(user.id);
    } catch (e) {
      debugPrint('❌ Upload error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Cache buster (VERY IMPORTANT)
    final imageUrl = widget.initialImageUrl != null
        ? "${widget.initialImageUrl}?t=${DateTime.now().millisecondsSinceEpoch}"
        : null;

    return GestureDetector(
      onTap: _loading ? null : _showImageSourcePicker,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : (imageUrl != null
                      ? CachedNetworkImageProvider(imageUrl)
                      : null),
            child: (_image == null && imageUrl == null)
                ? Icon(Icons.person, size: widget.radius * 0.6)
                : null,
          ),

          // 🔄 Loading indicator
          if (_loading) const CircularProgressIndicator(),

          // ✏️ Edit icon
          Positioned(
            bottom: 0,
            right: 4,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUpload(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUpload(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
