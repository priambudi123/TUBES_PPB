import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/screen/home.dart';
import 'package:tubes_ppb/style/color.dart';

class PaymentScreen extends StatelessWidget {
  final Product data;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final List<String> sizes = ["36", "37", "38", "39", "40", "41", "42", "43"];
  String selectedSize = "36"; // Default size
  String selectedPaymentMethod = "Credit Card"; // Default payment method
  String selectedDeliveryOption = "Regular Delivery"; // Default delivery option

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  PaymentScreen({Key? key, required this.data, required price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: gray,
      ),
      body: Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'https://i.ibb.co/vxbFHLs/ababil-removebg-preview.png',
                  height: 100,
                ),
                SizedBox(height: 16),
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Rp ${data.price}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),
                // Shoes Size
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.accessibility, size: 24),
                    Text(
                      'Shoes Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedSize,
                      onChanged: (value) {
                        selectedSize = value!;
                      },
                      items: sizes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Delivery Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.delivery_dining, size: 24),
                    Text(
                      'Delivery Option',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedDeliveryOption,
                      onChanged: (value) {
                        selectedDeliveryOption = value!;
                      },
                      items: [
                        "Regular Delivery",
                        "Express Delivery",
                        "In-Store Pickup"
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Payment Method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.payment, size: 24),
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedPaymentMethod,
                      onChanged: (value) {
                        selectedPaymentMethod = value!;
                      },
                      items: ["Credit Card", "Bank Transfer", "e-Wallet"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Payment Amount TextField
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.attach_money, size: 24),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _paymentController,
                        decoration: InputDecoration(
                          labelText: 'Payment Amount',
                          hintText: 'Enter payment amount',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: gray),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Shipping Address TextField
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 24),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Shipping Address',
                          hintText: 'Enter your shipping address',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: gray),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Proceed to Payment Button
                ElevatedButton(
                  onPressed: () {
                    if (isNumeric(_paymentController.text)) {
                      if (int.parse(_paymentController.text) >=
                          int.parse(data.price)) {
                        final int stokNow = int.parse(data.stock) - 1;
                        final db = FirebaseFirestore.instance;
                        db.collection("product").doc(data.id).set(
                          {"stock": "$stokNow"},
                          SetOptions(merge: true),
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Payment Successful'),
                              content: Text(
                                  'Thank you for your purchase. Your order has been placed successfully.\n\nSize: $selectedSize\nShipping Address: ${_addressController.text}\nDelivery Option: $selectedDeliveryOption\nPayment Method: $selectedPaymentMethod\nPayment Amount: ${_paymentController.text}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(),
                                      ),
                                    );
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: black,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Payment',
                        style: TextStyle(fontSize: 16, color: white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
