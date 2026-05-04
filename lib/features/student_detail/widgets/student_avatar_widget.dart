import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentAvatar extends ConsumerStatefulWidget {
  final String? fileName;
  final double radius;
  final String? initialImageUrl;
  final bool isEdit;

  const StudentAvatar({
    super.key,
    this.fileName,
    this.radius = 50,
    this.initialImageUrl,
    this.isEdit = false,
  });

  @override
  ConsumerState<StudentAvatar> createState() => _StudentAvatarState();
}

class _StudentAvatarState extends ConsumerState<StudentAvatar> {
  File? _image;
  bool _loading = false;

  final _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  /// 🔹 Show Camera / Gallery options
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

  /// 🔹 Pick + Upload
  Future<void> _pickAndUpload(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) return;

      setState(() {
        _loading = true;
        _image = File(pickedFile.path);
      });

      final user = supabase.auth.currentUser;
      if (user == null) return;

      final fileExt = pickedFile.path.split('.').last;

      final finalFileName = widget.fileName != null
          ? '${widget.fileName}.$fileExt'
          : 'avatar.$fileExt';

      final filePath = '${user.id}/$finalFileName';

      // ✅ Upload
      await supabase.storage
          .from('student_images')
          .upload(
            filePath,
            _image!,
            fileOptions: const FileOptions(upsert: true),
          );

      // ✅ Public URL
      final publicUrl = supabase.storage
          .from('student_images')
          .getPublicUrl(filePath);

      // ✅ Update DB
      await supabase
          .from('students')
          .update({'image_url': publicUrl})
          .eq('spu_id', widget.fileName.toString());

      // ✅ Refresh provider
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
    // ✅ Cache buster
    final imageUrl = widget.initialImageUrl != null
        ? "${widget.initialImageUrl}?t=${DateTime.now().millisecondsSinceEpoch}"
        : null;

    return GestureDetector(
      onTap: _loading || widget.isEdit == false ? null : _showImageSourcePicker,
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

          // 🔄 Loading
          if (_loading) const CircularProgressIndicator(),

          // ✏️ Edit icon
          if (widget.isEdit)
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
