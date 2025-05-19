import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/screens/product_tab.dart';
import 'package:stock_management/screens/newproduct.dart';
import 'package:stock_management/screens/out_going.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Paracetamol',
      'supplier': 'PharmaCo',
      'quantity': 25,
      'pricePerUnit': 1.50,
      'sellPrice': 2.00,
      'expiry': '2025-06-01'
    },
    {
      'id': 2,
      'name': 'Ibuprofen',
      'supplier': 'HealthPlus',
      'quantity': 10,
      'pricePerUnit': 2.30,
      'sellPrice': 3.00,
      'expiry': '2024-12-31'
    },
  ];

  final List<Map<String, dynamic>> _outgoingHistory = [];

  void _updateStock(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String operation = 'add';
        final qtyController = TextEditingController();

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Update ${product['name']} Stock', style: Theme.of(context).textTheme.titleLarge),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Add'),
                            value: 'add',
                            groupValue: operation,
                            onChanged: (value) {
                              setModalState(() {
                                operation = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Remove'),
                            value: 'remove',
                            groupValue: operation,
                            onChanged: (value) {
                              setModalState(() {
                                operation = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: operation == 'add' ? 'Add Quantity' : 'Remove Quantity'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final qty = int.tryParse(qtyController.text) ?? 0;
                        if (qty <= 0) return;

                        if (operation == 'add') {
                          product['quantity'] += qty;
                        } else {
                          if (product['quantity'] < qty) return;
                          product['quantity'] -= qty;
                        }

                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text(operation == 'add' ? 'Add Stock' : 'Remove Stock'),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    final nameController = TextEditingController(text: product['name']);
    final supplierController = TextEditingController(text: product['supplier']);
    final priceController = TextEditingController(text: product['pricePerUnit'].toString());
    final sellPriceController = TextEditingController(text: product['sellPrice'].toString());
    final expiryController = TextEditingController(text: product['expiry']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Edit Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: supplierController, decoration: const InputDecoration(labelText: 'Supplier')),
                TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Buy Price')),
                TextField(controller: sellPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sell Price')),
                TextField(controller: expiryController, decoration: const InputDecoration(labelText: 'Expiry Date')),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    product['name'] = nameController.text;
                    product['supplier'] = supplierController.text;
                    product['pricePerUnit'] = double.tryParse(priceController.text) ?? 0.0;
                    product['sellPrice'] = double.tryParse(sellPriceController.text) ?? 0.0;
                    product['expiry'] = expiryController.text;

                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _completeSale(Map<String, dynamic> product, int quantity) {
    product['quantity'] -= quantity;

    _outgoingHistory.insert(0, {
      'productId': product['id'],
      'productName': product['name'],
      'quantity': quantity,
      'sellPrice': product['sellPrice'],
      'total': quantity * product['sellPrice'],
      'date': DateTime.now().toIso8601String(),
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
          title: Text(
            'Bikaneza',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab( text: 'Products Detail'),
              Tab( text: 'Add New Product'),
              Tab(text: 'Outgoing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductDetailsScreen(
              products: _products,
              onUpdateStock: _updateStock,
              onEditProduct: _editProduct,
            ),
            AddProductScreen(onAddProduct: (newProduct) {
              setState(() {
                _products.add(newProduct);
              });
            }),
            OutgoingScreen(
              products: _products,
              outgoingHistory: _outgoingHistory,
              onCompleteSale: _completeSale,
            ),
          ],
        ),
      ),
    );
  }
}