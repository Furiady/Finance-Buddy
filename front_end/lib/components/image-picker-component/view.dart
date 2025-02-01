import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:front_end/components/elevated-button-component/view.dart';

class ImagePickerComponent extends StatefulWidget {
  final double width;
  final double height;
  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;
  final bool readOnly;
  final String? imageUrl;

  const ImagePickerComponent({
    super.key,
    required this.width,
    required this.height,
    this.selectedImage,
    required this.onImageChanged,
    this.readOnly = false,
    this.imageUrl,
  });

  @override
  State<ImagePickerComponent> createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();
  late String? imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      widget.onImageChanged(File(image.path));
    }
  }

  void _removeImage() {
    if (widget.imageUrl != null) {
      setState(() {
        imageUrl = widget.imageUrl;
      });
      widget.onImageChanged(null);
    } else {
      widget.onImageChanged(null);
    }
  }

  void _showImageSourcePicker() {
    if (imageUrl != null) {
      setState(() {
        imageUrl = null;
      });
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Pick from Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : widget.selectedImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline_rounded),
                                iconSize: 40,
                                color: widget.readOnly
                                    ? Colors.grey
                                    : Colors.green,
                                onPressed: widget.readOnly
                                    ? null
                                    : _showImageSourcePicker
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Upload your image",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            widget.selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
            ),
          ),
        ),
        if (widget.selectedImage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButtonComponent(
                    onPressed: _showImageSourcePicker,
                    text: 'Pick image',
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: ElevatedButtonComponent(
                    onPressed: _removeImage,
                    text: "Delete image",
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.red),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 5),
        if (widget.imageUrl != null)
          const Text(
            "Upload your receipt for easier transaction recording",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
