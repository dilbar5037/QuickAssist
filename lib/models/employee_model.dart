// employee_model.dart

class Employee {
  String? id; // Firestore document ID
  String? name;
  String? shopId;
  String? location;
  String? address;
  String? email;
  String? password; // Note: It's advisable to use a secure authentication method in production
  String? jobType;
  String? adharNo;
  String? phone;
  String? accountInfo;


  Employee({
    this.id,
    this.name,
    this.shopId,
    this.location,
    this.address,
    this.email,
    this.password,
    this.jobType,
    this.adharNo,
    this.phone,
    this.accountInfo,

  });

  factory Employee.fromMap(Map<String, dynamic> data, String id) {
    return Employee(
      id: id,
      name: data['name'],
      shopId: data['shopId'],
      location: data['location'],
      address: data['address'],
      email: data['email'],
      password: data['password'],
      jobType: data['jobType'],
      adharNo: data['adharNo'],
      phone: data['phone'],
      accountInfo: data['accountInfo'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'shopId': shopId,
      'location': location,
      'address': address,
      'email': email,
      'password': password,
      'jobType': jobType,
      'adharNo': adharNo,
      'phone': phone,
      'accountInfo': accountInfo,

    };
  }
}
