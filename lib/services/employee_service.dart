// employee_service.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickassitnew/models/employee_model.dart';

class EmployeeService {
  final CollectionReference _employeesCollection =
      FirebaseFirestore.instance.collection('employees');

  // Function to get all employees
  Stream<List<Employee>> getAllEmployees() {
    return _employeesCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) =>
                Employee.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      },
    );
  }

  // Function to add a new employee
  Future<void> addEmployee(Employee employee) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: employee.email.toString(),
            password: employee.password.toString());

    if (userCredential != null) {}

    await FirebaseFirestore.instance
        .collection('login')
        .doc(userCredential.user!.uid)
        .set({
      'usertype': "employee",
      'uid': userCredential.user!.uid,
      'email': userCredential.user!.email,
      'password': employee.password,
      'status': 1
    });
    return _employeesCollection.doc(userCredential.user!.uid).set(employee.toMap());
  }

  // Function to update an existing employee
  Future<void> updateEmployee(Employee employee) {
    return _employeesCollection.doc(employee.id).update(employee.toMap());
  }

  // Function to delete an employee
  Future<void> deleteEmployee(String employeeId) {
    return _employeesCollection.doc(employeeId).delete();
  }

  // Function to get employees by shopId
  Stream<List<Employee>> getEmployeesByShopId(String shopId) {
    return _employeesCollection
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) =>
                Employee.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      },
    );
  }
}
