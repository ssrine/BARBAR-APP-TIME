import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../services/api_service.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final ApiService apiService = ApiService();
  late Future<List<Payment>> _payments;

  @override
  void initState() {
    super.initState();
    _payments = apiService.listPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: FutureBuilder<List<Payment>>(
        future: _payments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payments found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Payment payment = snapshot.data![index];
                return ListTile(
                  title: Text('Payment of \$${payment.amount}'),
                  subtitle: Text('Customer ID: ${payment.customerId}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePaymentDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreatePaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController customerIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: customerIdController,
                decoration: InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                final customerId = int.tryParse(customerIdController.text);

                if (amount != null && customerId != null) {
                  final payment = await apiService.createPayment(customerId, amount);
                  if (payment != null) {
                    setState(() {
                      _payments = apiService.listPayments(); // Refresh the payment list
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create payment.')));
                  }
                }
              },
              child: Text('Create'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
