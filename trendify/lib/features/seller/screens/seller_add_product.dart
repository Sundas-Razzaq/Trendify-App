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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorScheme.surfaceVariant.withOpacity(
                                  0.3,
                                ),
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              child: _pickedImageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        _pickedImageBytes!,
                                        fit: BoxFit.cover,
                                        height: 160,
                                      ),
                                    )
                                  : _uploadedImageUrl != null &&
                                        _uploadedImageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _uploadedImageUrl!,
                                        fit: BoxFit.cover,
                                        height: 160,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          size: 48,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'No image selected',
                                          style: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: const Text('Upload Image'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Product Details Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title Field
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Product Title *',
                          hintText: 'Enter product title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.title),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Title required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Category Field
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.category),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        items: _categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c['value'],
                                child: Text(c['label']!),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v),
                        borderRadius: BorderRadius.circular(10),
                        elevation: 4,
                      ),

                      const SizedBox(height: 16),

                      // Subtitle Field
                      TextFormField(
                        controller: _subtitleController,
                        decoration: InputDecoration(
                          labelText: 'Subtitle',
                          hintText: 'Enter product subtitle (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.subtitles),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter product description (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.description),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Price Fields Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: 'Price *',
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.attach_money),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(0.3),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (v) =>
                                  v == null || double.tryParse(v) == null
                                  ? 'Invalid price'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _oldPriceController,
                              decoration: InputDecoration(
                                labelText: 'Old Price',
                                hintText: '0.00 (optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.price_change),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(0.3),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Rating & Reviews Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rating: ${_rating.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Slider(
                                  value: _rating,
                                  min: 0,
                                  max: 5,
                                  divisions: 10,
                                  label: _rating.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setState(() {
                                      _rating = value;
                                    });
                                  },
                                  activeColor: colorScheme.primary,
                                  inactiveColor: colorScheme.onSurface
                                      .withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _reviewsController,
                              decoration: InputDecoration(
                                labelText: 'Reviews',
                                hintText: '0 (optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.reviews),
                                filled: true,
                                fillColor: colorScheme.surfaceVariant
                                    .withOpacity(0.3),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          isEdit ? 'Update Product' : 'Add Product',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Help Text
              Center(
                child: Text(
                  'Fields marked with * are required',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
