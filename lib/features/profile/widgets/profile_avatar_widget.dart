import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileAvatar extends StatefulWidget {
  final double radius;
  final String? initialImageUrl;

  const ProfileAvatar({super.key, this.radius = 50, this.initialImageUrl});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _image;
  String? _imageUrl;
  bool _loading = false;

  final _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _pickAndUpload() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _loading = true;
    });

    try {
      final user = supabase.auth.currentUser;
      final fileExt = pickedFile.path.split('.').last;
      final fileName = '${user!.id}.$fileExt';
      final filePath = 'avatars/$fileName';

      // Upload
      await supabase.storage
          .from('avatars')
          .upload(
            filePath,
            _image!,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get public URL
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

      setState(() {
        _imageUrl = publicUrl;
      });

      // OPTIONAL: save URL in your profiles table
      await supabase.from('profiles').upsert({
        'id': user.id,
        'avatar_url': publicUrl,
      });
    } catch (e) {
      debugPrint('Upload error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                : (_imageUrl != null
                      ? NetworkImage(_imageUrl!) as ImageProvider
                      : null),
            child: (_image == null && _imageUrl == null)
                ? Icon(Icons.person, size: widget.radius * 0.6)
                : null,
          ),

          if (_loading) CircularProgressIndicator(),

          // Edit icon overlay
          Positioned(
            bottom: 0,
            right: 4,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
