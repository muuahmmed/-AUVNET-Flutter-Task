import 'package:flutter/material.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final screenSize = MediaQuery.of(context).size;

    // Sample delivery data
    final deliveries = [
      {
        'status': 'Preparing',
        'time': '10:30 AM',
        'restaurant': 'Pizza Palace',
        'items': '2 items',
        'image': 'assets/restaurants/pizza.png',
      },
      {
        'status': 'On the way',
        'time': 'Estimated 12:15 PM',
        'restaurant': 'Burger King',
        'items': '1 item',
        'image': 'assets/restaurants/burger.png',
      },
      {
        'status': 'Delivered',
        'time': 'Yesterday, 7:45 PM',
        'restaurant': 'Sushi Express',
        'items': '3 items',
        'image': 'assets/restaurants/sushi.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Deliveries'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Orders',
              style: TextStyle(
                fontSize: screenSize.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Expanded(
              child: ListView.separated(
                itemCount: deliveries.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: screenSize.height * 0.02),
                itemBuilder: (context, index) {
                  final delivery = deliveries[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.03),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              delivery['image'] as String,
                              width: screenSize.width * 0.2,
                              height: screenSize.width * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  delivery['restaurant'] as String,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.005),
                                Text(
                                  delivery['items'] as String,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.035,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: screenSize.width * 0.04,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: screenSize.width * 0.01),
                                    Text(
                                      delivery['time'] as String,
                                      style: TextStyle(
                                        fontSize: screenSize.width * 0.035,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.03,
                              vertical: screenSize.height * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(delivery['status'] as String),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              delivery['status'] as String,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.035,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return Colors.orange;
      case 'on the way':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}