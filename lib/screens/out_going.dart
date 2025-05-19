import 'package:flutter/material.dart';

class OutgoingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> outgoingHistory;
  final Function(Map<String, dynamic>, int) onCompleteSale;

  const OutgoingScreen({
    super.key,
    required this.products,
    required this.outgoingHistory,
    required this.onCompleteSale,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedProduct;
    final quantityController = TextEditingController();
    double total = 0.0;

    void calculateTotal() {
      if (selectedProduct != null) {
        final quantity = int.tryParse(quantityController.text) ?? 0;
        total = quantity * (selectedProduct!['sellPrice'] as double);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Out Going',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Select Product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.medication),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: product,
                        child: Text('${product['name']} (${product['quantity']} in stock)'),
                      );
                    }).toList(),
                    onChanged: (product) {
                      selectedProduct = product;
                      quantityController.text = '';
                      total = 0.0;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (selectedProduct != null)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Sell Price',
                                  prefixText: '\$ ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                controller: TextEditingController(
                                  text: selectedProduct!['sellPrice'].toStringAsFixed(2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: quantityController,
                                decoration: InputDecoration(
                                  labelText: 'Quantity',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  helperText: 'Max: ${selectedProduct!['quantity']}',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => calculateTotal(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Product:'),
                                  Text(selectedProduct!['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Unit Price:'),
                                  Text('\$${selectedProduct!['sellPrice'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Quantity:'),
                                  Text(
                                    quantityController.text.isEmpty ? '0' : quantityController.text,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    '\$${total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart_checkout),
                            label: const Text('Complete Sale'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final quantity = int.tryParse(quantityController.text) ?? 0;
                              if (quantity <= 0 || selectedProduct == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter a valid quantity')),
                                );
                                return;
                              }
                              if (quantity > selectedProduct!['quantity']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Not enough items in stock'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              onCompleteSale(selectedProduct!, quantity);
                              quantityController.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recent Outgoing Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: outgoingHistory.isEmpty
                ? Center(
                    child: Text(
                      'No outgoing items yet',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    itemCount: outgoingHistory.length,
                    itemBuilder: (context, index) {
                      final item = outgoingHistory[outgoingHistory.length - 1 - index]; // Reverse order
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(item['productName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Qty: ${item['quantity']} • Total: \$${item['total'].toStringAsFixed(2)}'),
                          trailing: Text(
                            DateTime.parse(item['date']).toString().substring(0, 16),
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}