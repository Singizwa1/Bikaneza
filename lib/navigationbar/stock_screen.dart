import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockScreen extends StatefulWidget {
  
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Paracetamol',
      'supplier': 'PharmaCo',
      'quantity': 25,
      'pricePerUnit': 1.50,
      'expiry': '2025-06-01'
    },
    {
      'name': 'Ibuprofen',
      'supplier': 'HealthPlus',
      'quantity': 10,
      'pricePerUnit': 2.30,
      'expiry': '2024-12-31'
    },
  ];

  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bikaneza',
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: Colors.deepOrangeAccent,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepOrangeAccent,
          labelColor: Colors.deepOrangeAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Product Details'),
            Tab(text: 'Add New Product'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildProductDetails(),
          buildAddProduct(),
        ],
      ),
    );
  }

  Widget buildProductDetails() {
    final filtered = _products.where((product) {
      return product['name'].toString().toLowerCase().contains(_search.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Product',
              hintText: 'Search by name',
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
              filled: true,
              
            ),
            onChanged: (value) {
              setState(() {
                _search = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final product = filtered[index];
              final expiryDate = DateTime.parse(product['expiry']);
              final isExpired = expiryDate.isBefore(DateTime.now());
              final isNearExpiry = expiryDate.difference(DateTime.now()).inDays < 30;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(product['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Supplier: ${product['supplier']}'),
                      Text('In Stock: ${product['quantity']}'),
                      Text('Price/Unit: \$${product['pricePerUnit']}'),
                      Text(
                        'Expires: ${product['expiry']}',
                        style: TextStyle(
                          color: isExpired
                              ? Colors.red
                              : isNearExpiry
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(product['name']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Supplier: ${product['supplier']}'),
                            Text('Quantity: ${product['quantity']}'),
                            Text('Price Per Unit: \$${product['pricePerUnit']}'),
                            Text(
                              'Expiry Date: ${product['expiry']}',
                              style: TextStyle(
                                color: isExpired
                                    ? Colors.red
                                    : isNearExpiry
                                        ? Colors.orange
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: const Text('Close'),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildAddProduct() {
    final nameController = TextEditingController();
    final supplierController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    final expiryController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: supplierController,
            decoration: const InputDecoration(labelText: 'Supplier Name'),
          ),
          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Price Per Unit (\$)'),
          ),
          TextField(
            controller: expiryController,
            decoration: const InputDecoration(
              labelText: 'Expiry Date (YYYY-MM-DD)',
            ),
          ),

          // TODO: Future barcode scanner integration
          // IconButton(
          //   icon: Icon(Icons.qr_code_scanner),
          //   onPressed: () async {
          //     final barcode = await scanBarcode(); // Implement later
          //     if (barcode != null) {...}
          //   },
          // ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final supplier = supplierController.text.trim();
              final qty = int.tryParse(qtyController.text.trim()) ?? 0;
              final price = double.tryParse(priceController.text.trim()) ?? 0.0;
              final expiry = expiryController.text.trim();

              if (name.isEmpty || supplier.isEmpty || qty <= 0 || price <= 0 || expiry.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields correctly')),
                );
                return;
              }

              setState(() {
                _products.add({
                  'name': name,
                  'supplier': supplier,
                  'quantity': qty,
                  'pricePerUnit': price,
                  'expiry': expiry,
                });
              });

              _tabController.animateTo(0); // Switch back to Product List
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}