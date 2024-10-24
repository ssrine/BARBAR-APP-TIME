class Salon {
  final int id;
  final String name;
  final String location; // Make sure this property is defined

  Salon({required this.id, required this.name, required this.location});

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'],
      name: json['name'],
      location: json['location'], // Ensure this matches your API response
    );
  }
}
