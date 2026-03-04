// lib/widgets/dashboard/popular_products_list.dart

import 'package:flutter/material.dart';

class PopularProductsList extends StatelessWidget {
  final List<dynamic> products;

  const PopularProductsList({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No products data',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: products.map((product) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Product image placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF9B7BFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    product['name']?.substring(0, 1).toUpperCase() ?? 'P',
                    style: TextStyle(
                      color: Color(0xFF9B7BFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Stock: ${product['stock'] ?? 0}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Order count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF9B7BFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${product['order_count'] ?? 0} orders',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9B7BFF),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}