import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProduct;

  const AddProductScreen({super.key, required this.onAddProduct});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late TextEditingController nameController;
  late TextEditingController supplierController;
  late TextEditingController qtyController;
  late TextEditingController priceController;
  late TextEditingController sellPriceController;
  late TextEditingController expiryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    supplierController = TextEditingController();
    qtyController = TextEditingController();
    priceController = TextEditingController();
    sellPriceController = TextEditingController();
    expiryController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    supplierController.dispose();
    qtyController.dispose();
    priceController.dispose();
    sellPriceController.dispose();
    expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'Add New Product',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.medication),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: supplierController,
                decoration: InputDecoration(
                  labelText: 'Supplier Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Buy Price (\$)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.payments),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: sellPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Sell Price (\$)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.sell),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 365)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    expiryController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  final name = nameController.text.trim();
                  final supplier = supplierController.text.trim();
                  final qty = int.tryParse(qtyController.text.trim()) ?? 0;
                  final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                  final sellPrice = double.tryParse(sellPriceController.text.trim()) ?? 0.0;
                  final expiry = expiryController.text.trim();

                  if (name.isEmpty ||
                      supplier.isEmpty ||
                      qty <= 0 ||
                      price <= 0 ||
                      sellPrice <= 0 ||
                      expiry.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields correctly')),
                    );
                    return;
                  }
                  if (sellPrice <= price) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sell price must be higher than buy price')),
                    );
                    return;
                  }

                  widget.onAddProduct({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'name': name,
                    'supplier': supplier,
                    'quantity': qty,
                    'pricePerUnit': price,
                    'sellPrice': sellPrice,
                    'expiry': expiry,
                  });

                  // Clear form
                  nameController.clear();
                  supplierController.clear();
                  qtyController.clear();
                  priceController.clear();
                  sellPriceController.clear();
                  expiryController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name added to inventory'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Add Product', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}