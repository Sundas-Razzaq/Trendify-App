import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendify/features/shop/models/product.dart';
import 'package:trendify/utils/services/product_service.dart';

class SellerAddProduct extends StatefulWidget {
  final Product? product;
  const SellerAddProduct({super.key, this.product});

  @override
  State<SellerAddProduct> createState() => _SellerAddProductState();
}

class _SellerAddProductState extends State<SellerAddProduct> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _oldPriceController;
  late final TextEditingController _reviewsController;

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;
  String? _uploadedImageUrl;

  bool _isSubmitting = false;
  double _rating = 0.0;
  String? _selectedCategory;

  final List<Map<String, String>> _categories = [
    {'label': 'Men', 'value': 'men'},
    {'label': 'Women', 'value': 'women'},
    {'label': 'Kids', 'value': 'kids'},
    {'label': 'Beauty', 'value': 'beauty'},
    {'label': 'Fashion', 'value': 'fashion'},
    {'label': 'Home', 'value': 'home'},
    {'label': 'Accessories', 'value': 'accessories'},
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    _titleController = TextEditingController(text: p?.title ?? '');
    _subtitleController = TextEditingController(text: p?.subtitle ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toString() : '',
    );
    _oldPriceController = TextEditingController(
      text: p?.oldPrice?.toString() ?? '',
    );
    _reviewsController = TextEditingController(
      text: p?.reviews?.toString() ?? '',
    );

    _rating = p?.rating ?? 0.0;
    _uploadedImageUrl = p?.image;
    _selectedCategory = p?.category ?? _categories.first['value'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    _reviewsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _pickedImageBytes = file.bytes;
        _pickedImageName = file.name;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_pickedImageBytes == null) return _uploadedImageUrl;

    try {
      final ref = FirebaseStorage.instance.ref(
        'products/${DateTime.now().millisecondsSinceEpoch}_${_pickedImageName ?? 'image'}.jpg',
      );

      final task = ref.putData(
        _pickedImageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await task
          .whenComplete(() {})
          .timeout(
            const Duration(seconds: 25),
            onTimeout: () => throw Exception('Image upload timeout'),
          );

      final url = await snapshot.ref.getDownloadURL();
      _pickedImageBytes = null;
      return url;
    } catch (e) {
      debugPrint('Image upload failed: $e');
      return null; // ❗ DO NOT block product creation
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final imageUrl = await _uploadImage();

      final product = Product(
        id: widget.product?.id,
        sellerId:
            widget.product?.sellerId ?? FirebaseAuth.instance.currentUser?.uid,
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim().isEmpty
            ? null
            : _subtitleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        image: imageUrl ?? '',
        category: _selectedCategory!,
        price: double.parse(_priceController.text),
        oldPrice: _oldPriceController.text.isEmpty
            ? null
            : double.parse(_oldPriceController.text),
        rating: _rating,
        reviews: _reviewsController.text.isEmpty
            ? null
            : int.parse(_reviewsController.text),
      );

      if (product.id == null) {
        await _productService.addProduct(product);
      } else {
        await _productService.updateProduct(product);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully')),
      );

      // Safely attempt to pop the current route if possible. `maybePop`
      // will do nothing if there's no route to pop (prevents assertion).
      Navigator.maybePop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c['value'],
                        child: Text(c['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Choose Image'),
              ),
              const SizedBox(height: 12),
              if (_pickedImageBytes != null)
                Image.memory(_pickedImageBytes!, height: 160)
              else if (_uploadedImageUrl != null &&
                  _uploadedImageUrl!.isNotEmpty)
                Image.network(_uploadedImageUrl!, height: 160),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Invalid price'
                    : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(isEdit ? 'Update Product' : 'Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
