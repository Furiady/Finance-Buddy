import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/outline-button-component/view.dart';

class ImagePickerComponent extends StatefulWidget {
  final double width;
  final double height;
  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;

  const ImagePickerComponent({
    super.key,
    required this.width,
    required this.height,
    this.selectedImage,
    required this.onImageChanged,
  });

  @override
  State<ImagePickerComponent> createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();
  bool _showPickerOptions = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      widget.onImageChanged(File(image.path));
    }
    setState(() {
      _showPickerOptions = false;
    });
  }

  void _removeImage() {
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: widget.height * 0.5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: widget.selectedImage == null
                  ? (_showPickerOptions
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButtonComponent(
                    onPressed: () => _pickImage(ImageSource.camera),
                    text: "Open Camera",
                  ),
                  const SizedBox(height: 10),
                  ElevatedButtonComponent(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    text: "Open Gallery",
                  ),
                ],
              )
                  : IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                iconSize: 40,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _showPickerOptions = true; // Show picker options
                  });
                },
              ))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  widget.selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButtonComponent(
                onPressed: () => _pickImage(ImageSource.camera),
                text: 'Ambil Foto',
              ),
              OutlinedButtonComponent(
                onPressed: widget.selectedImage == null ? null : _removeImage,
                text: "Hapus",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
