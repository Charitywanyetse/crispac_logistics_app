import 'package:flutter/material.dart';
import 'products_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 189, 161, 238),
        title: Text(
          'Crispac Tailoring',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome Text
              Text(
                'Welcome to Crispac Tailoring!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 152, 104, 199),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12),

              // Tagline
              Text(
                'We design and sew quality uniforms for Schools, Hospitals, Hotels & Construction Sites.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 25),

              // // Logo
              // Container(
              //   height: 50,
              //   child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              // ),

              // SizedBox(height: 20),

              // MISSION SECTION
              _sectionTitle("Our Mission"),
              _sectionBox(
                "To provide high-quality, durable and professionally tailored uniforms that represent identity, comfort and excellence.",
              ),

              SizedBox(height: 25),

              // VISION SECTION
              _sectionTitle("Our Vision"),
              _sectionBox(
                "To become the leading tailoring company in East Africa, delivering innovation, trust and unmatched craftsmanship.",
              ),

              SizedBox(height: 35),

              // WHY CHOOSE US
              _sectionTitle("Why Choose Us"),
              SizedBox(height: 15),
              _whyChooseUs(),

              SizedBox(height: 35),

              // SERVICES TITLE
              _sectionTitle("Our Services"),
              SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 0.9,
                children: [
                  _buildServiceCard(Icons.school, "School Uniforms"),
                  _buildServiceCard(Icons.local_hospital, "Hospital Gowns"),
                  _buildServiceCard(Icons.construction, "Construction Wear"),
                  _buildServiceCard(Icons.hotel, "Hotel Linen & Chef Wear"),
                  _buildServiceCard(Icons.people, "Corporate Uniforms"),
                  _buildServiceCard(Icons.design_services, "Custom Tailoring"),
                ],
              ),

              SizedBox(height: 35),

              // TESTIMONIALS
              _sectionTitle("What Our Clients Say"),
              SizedBox(height: 20),
              _testimonialCard(
                "Sarah N.  School Administrator",
                "Crispac Tailoring delivered our school uniforms with outstanding quality. The stitching, fitting, and fabric were all perfect. Highly reliable!",
              ),
              SizedBox(height: 15),
              _testimonialCard(
                "Julius K.  Project Supervisor",
                "Our construction team uniforms were delivered on time and looked very professional. Crispac Tailoring is truly committed to excellence.",
              ),
              SizedBox(height: 15),
              _testimonialCard(
                "Martha A.  Hotel Manager",
                "The chef coats and hotel linen were beautifully tailored and durable. Great customer service and value for money!",
              ),

              SizedBox(height: 40),

              // Action Buttons
              Row(
                children: [
                 Expanded(
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductsScreen()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 169, 137, 224),
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text("View Products", style: TextStyle(fontSize: 16)),
  ),
),
SizedBox(width: 15),
Expanded(
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 122, 209, 168),
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text("Request a Quote", style: TextStyle(fontSize: 16)),
  ),
),
                ],
              ),

              SizedBox(height: 40),

              // Footer
              Text(
                "© 2025 Crispac Tailoring",
                style: TextStyle(color: const Color.fromARGB(255, 15, 15, 15), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SECTION TITLE WIDGET
  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 152, 104, 199),

        ),
      ),
    );
  }

  // SECTION BOX WIDGET
  Widget _sectionBox(String text) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFF1E9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, height: 1.5),
        textAlign: TextAlign.left,
      ),
    );
  }

  // WHY CHOOSE US SECTION
  Widget _whyChooseUs() {
    return Column(
      children: [
        _chooseUsItem(Icons.check_circle, "High-Quality Tailoring"),
        SizedBox(height: 12),
        _chooseUsItem(Icons.speed, "Fast and Reliable Delivery"),
        SizedBox(height: 12),
        _chooseUsItem(Icons.attach_money, "Affordable and Transparent Pricing"),
        SizedBox(height: 12),
        _chooseUsItem(Icons.groups, "Professional and Skilled Team"),
      ],
    );
  }

  Widget _chooseUsItem(IconData icon, String text) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFF7E49DA).withOpacity(0.1),
          child: Icon(icon, color: Color(0xFF7E49DA)),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  // TESTIMONIAL CARD
  Widget _testimonialCard(String name, String review) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color(0xFFF8F3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF7E49DA).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review,
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 10),
          Text(
            "- $name",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7E49DA),
            ),
          ),
        ],
      ),
    );
  }

  // SERVICE CARD WIDGET
  Widget _buildServiceCard(IconData icon, String title) {
    return Card(
      elevation: 4,
      shadowColor: Colors.deepPurple.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF7E49DA).withOpacity(0.1),
              radius: 28,
              child: Icon(icon, size: 32, color: Color.fromARGB(255, 251, 250, 252)),
            ),
            SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
