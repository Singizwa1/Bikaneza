import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onUpdateStock;
  final Function(Map<String, dynamic>) onEditProduct;

  const ProductDetailsScreen({
    super.key,
    required this.products,
    required this.onUpdateStock,
    required this.onEditProduct,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((product) {
      return product['name']
          .toString()
          .toLowerCase()
          .contains(_search.toLowerCase());
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (value) {
              setState(() {
                _search = value;
              });
            },
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text("No products found", style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    final expiryDate = DateTime.parse(product['expiry']);
                    final isExpired = expiryDate.isBefore(DateTime.now());
                    final isNearExpiry =
                        expiryDate.difference(DateTime.now()).inDays < 30;
                    final profit = product['sellPrice'] - product['pricePerUnit'];
                    final profitMargin = (profit / product['pricePerUnit']) * 100;

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'update') {
                                  widget.onUpdateStock(product);
                                } else if (value == 'edit') {
                                  widget.onEditProduct(product);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Row(
                                    children: [
                                      Icon(Icons.update, size: 20),
                                      SizedBox(width: 8),
                                      Text('Update Stock'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20),
                                      SizedBox(width: 8),
                                      Text('Edit Details'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Supplier: ${product['supplier']}', style: const TextStyle(fontSize: 12)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: product['quantity'] > 20
                                        ? Colors.green.shade100
                                        : product['quantity'] > 5
                                            ? Colors.orange.shade100
                                            : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'In Stock: ${product['quantity']}',
                                    style: TextStyle(
                                      color: product['quantity'] > 20
                                          ? Colors.green.shade800
                                          : product['quantity'] > 5
                                              ? Colors.orange.shade800
                                              : Colors.red.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Buy: \$${product['pricePerUnit'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                Text('Sell: \$${product['sellPrice'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          _showProductDetailsDialog(context, product);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showProductDetailsDialog(BuildContext context, Map<String, dynamic> product) {
    final expiryDate = DateTime.parse(product['expiry']);
    final isExpired = expiryDate.isBefore(DateTime.now());
    final isNearExpiry = expiryDate.difference(DateTime.now()).inDays < 30;
    final profit = product['sellPrice'] - product['pricePerUnit'];
    final profitMargin = (profit / product['pricePerUnit']) * 100;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.business, color: Colors.deepOrangeAccent),
              title: const Text('Supplier'),
              subtitle: Text(product['supplier']),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.deepOrangeAccent),
              title: const Text('Quantity in Stock'),
              subtitle: Text('${product['quantity']}'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.money, color: Colors.deepOrangeAccent),
              title: const Text('Buy Price'),
              subtitle: Text('\$${product['pricePerUnit'].toStringAsFixed(2)}'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.sell, color: Colors.deepOrangeAccent),
              title: const Text('Sell Price'),
              subtitle: Text('\$${product['sellPrice'].toStringAsFixed(2)}'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.green),
              title: const Text('Profit Margin'),
              subtitle: Text('\$${profit.toStringAsFixed(2)} (${profitMargin.toStringAsFixed(1)}%)'),
              dense: true,
            ),
            ListTile(
              leading: Icon(
                Icons.event,
                color: isExpired
                    ? Colors.red
                    : isNearExpiry
                        ? Colors.orange
                        : Colors.deepOrangeAccent,
              ),
              title: const Text('Expiry Date'),
              subtitle: Text(product['expiry']),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onUpdateStock(product);
            },
            child: const Text('Update Stock'),
          ),
        ],
      ),
    );
  }
}