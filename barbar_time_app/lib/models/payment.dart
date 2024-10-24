class Payment {
  final int id;
  final int customerId; // Define this property
  final double amount;

  Payment({required this.id, required this.customerId, required this.amount});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      customerId: json['customer_id'], // Ensure this matches your API response
      amount: json['amount'],
    );
  }
}
