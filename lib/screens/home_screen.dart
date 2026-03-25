import 'package:flutter/material.dart';
import 'create_order_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 247, 246, 248);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  HEADER (Gradient)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                     "Hello Charity, and welcome to the Crispac logistic family! "
                      "We’re thrilled to help you bring your vision to life with precision tailoring."
                       "Whether it's for school, the workplace, or specialized construction gear, we promise quality finishing.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 8, 8),
                      ),
                    ),
                    // SizedBox(height: 5),
                    // Text(
                      
                    //   style: TextStyle(color: Colors.white70),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [

                    //  Mission & Vision Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Our Mission",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "To be Uganda’s most trusted tailoring partner by delivering meticulously crafted garments and personalized service, ensuring every client feels confident, comfortable, and flawlessly fitted.",
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Our Vision",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "To transform lives in Uganda through the art of sewing, building a community of empowered tailors and well-dressed individuals."
,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    //  Create Order Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateOrderScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "Create Order",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //  Stats
                    Row(
                      children: [
                        Expanded(child: _buildStatsCard("Pending", "5")),
                        const SizedBox(width: 10),
                        Expanded(child: _buildStatsCard("Delivered", "10")),
                      ],
                    ),

                    const SizedBox(height: 25),

                    //  Recent Orders
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Recent Orders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildRecentOrder("Order1 construction uniform", "Pending"),
                    _buildRecentOrder("Order2 hotel wear", "Delivered"),
                    _buildRecentOrder("Order3 school uniform", "Shipped"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Modern Stats Card
  Widget _buildStatsCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //  Modern Order Tile
  Widget _buildRecentOrder(String orderId, String status) {
    Color statusColor;

    switch (status.toLowerCase()) {
      case "pending":
        statusColor = Colors.orange;
        break;
      case "delivered":
        statusColor = Colors.green;
        break;
      case "shipped":
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: ListTile(
        title: Text(orderId),
        subtitle: Text(
          status,
          style: TextStyle(color: statusColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}