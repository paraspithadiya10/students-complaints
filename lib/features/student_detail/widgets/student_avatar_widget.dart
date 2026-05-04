import 'dart:io';
import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentAvatar extends ConsumerStatefulWidget {
  final String? fileName;
  final double radius;
  final String? initialImageUrl;

  const StudentAvatar({
    super.key,
    this.fileName,
    this.radius = 50,
    this.initialImageUrl,
  });

  @override
  ConsumerState<StudentAvatar> createState() => _StudentAvatarState();
}

class _StudentAvatarState extends ConsumerState<StudentAvatar> {
  File? _image;
  bool _loading = false;

  final _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  Future<void> _pickAndUpload() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        _loading = true;
        _image = File(pickedFile.path); // ✅ FIX
      });

      final user = supabase.auth.currentUser;
      if (user == null) return;

      final fileExt = pickedFile.path.split('.').last;

      final finalFileName = widget.fileName != null
          ? '${widget.fileName}.$fileExt'
          : 'avatar.$fileExt';

      final filePath = '${user.id}/$finalFileName';

      // Upload
      await supabase.storage
          .from('student_images')
          .upload(
            filePath,
            _image!, // now safe ✅
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = supabase.storage
          .from('student_images')
          .getPublicUrl(filePath);

      await supabase
          .from('students')
          .update({'image_url': publicUrl})
          .eq('spu_id', widget.fileName.toString());

      ref.read(profileControllerProvider.notifier).getProfile(user.id);
    } catch (e) {
      debugPrint('Upload error: $e');
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
    // Cache buster (VERY IMPORTANT)
    final imageUrl = widget.initialImageUrl != null
        ? "${widget.initialImageUrl}?t=${DateTime.now().millisecondsSinceEpoch}"
        : null;

    return GestureDetector(
      onTap: _loading ? null : _pickAndUpload,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : (imageUrl != null ? NetworkImage(imageUrl) : null),
            child: (_image == null && imageUrl == null)
                ? Icon(Icons.person, size: widget.radius * 0.6)
                : null,
          ),

          // Loading indicator
          if (_loading) const CircularProgressIndicator(),

          // ️ Edit icon
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
}
