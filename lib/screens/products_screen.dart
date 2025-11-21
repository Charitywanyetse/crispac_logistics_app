import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7E49DA),
        title: Text(
          "Our Products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.75,
          children: [
            productCard("School Uniform", "assets/School Uniform.png", 45000),
            productCard("Hospital Gown", "assets/Hospital Gown.png", 38000),
            productCard("Construction Wear", "assets/Construction wear.png", 60000),
            productCard("Chef Coat", "assets/Chef Coat.jpg", 55000),
            productCard("Corporate Suit", "assets/Corporate Suit.png", 120000),
            productCard("Custom Designs", "assets/Custom Designs.png", 80000),
          ],
        ),
      ),
    );
  }

  Widget productCard(String name, String image, int price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),

          // Product Image
          Container(
            height: 90,
            width: 90,
            child: Image.asset(image, fit: BoxFit.contain),
          ),

          SizedBox(height: 10),

          // Product Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF7E49DA),
            ),
          ),

          SizedBox(height: 5),

          // Price
          Text(
            "Ugx $price",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          Spacer(),

          // Add to Cart Button
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7E49DA),
                padding: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "View Details",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
