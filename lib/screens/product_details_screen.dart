import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String name;
  final String image;
  final int price;

  ProductDetailsScreen({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  String? selectedType;

  List<String> getProductTypes(String productName) {
    if (productName == "School Uniform") {
      return [
        "Primary School Uniform",
        "Secondary School Uniform",
        "Sports Uniform",
      ];
    } else if (productName == "Hospital Gown") {
      return [
        "Surgical Gown",
        "Patient Gown",
        "Maternity Gown",
      ];
    } else if (productName == "Construction Wear") {
      return [
        "Reflector Jacket",
        "Safety Helmet Set",
        "Full Safety Suit",
      ];
    } else if (productName == "Chef Coat") {
      return [
        "Short Sleeve Chef Coat",
        "Long Sleeve Chef Coat",
        "Executive Chef Coat",
      ];
    } else if (productName == "Corporate Suit") {
      return [
        "Men Suit",
        "Women Suit",
        "Custom Tailored Suit",
      ];
    } else {
      return [
        "Standard Design",
        "Premium Design",
        "Custom Design",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {

    final types = getProductTypes(widget.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Image.asset(widget.image, height: 200),
            ),

            const SizedBox(height: 20),

            Text(
              widget.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Ugx ${widget.price}",
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedType,
              items: types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (selectedType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a type")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "${widget.name} ($selectedType) added to cart"),
                    ),
                  );
                },
                child: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}