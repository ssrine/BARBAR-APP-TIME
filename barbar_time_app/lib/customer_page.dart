import 'package:flutter/material.dart';
import 'models/customer.dart';
import 'services/api_service.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late Future<List<Customer>> futureCustomers;

  @override
  void initState() {
    super.initState();
    futureCustomers = ApiService().listCustomers(); // Ensure this method exists in ApiService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: futureCustomers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No customers found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final customer = snapshot.data![index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.email),
                  onTap: () {
                    // Navigate to a detailed view of the customer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailPage(customer: customer),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Customer Detail Page
class CustomerDetailPage extends StatelessWidget {
  final Customer customer;

  CustomerDetailPage({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${customer.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Name: ${customer.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: ${customer.email}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
