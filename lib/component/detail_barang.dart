
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/component/edit_barang.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/component/wishlist.dart';
import 'package:tubes_ppb/screen/payment.dart';
import 'package:tubes_ppb/screen/wishlist.dart';
import 'package:tubes_ppb/style/color.dart';

class DetailBarang extends StatelessWidget {
  final Product data;

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  DetailBarang({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Container(
                height: mediaQuery.size.height / 2.5,
                width: mediaQuery.size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey, Colors.grey],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        data.image,
                        height: mediaQuery.size.height / 2.8,
                        width: mediaQuery.size.width / 1.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Provider.of<Wishlist>(context, listen: false)
                                  .addToWishlist(data);
                              showWishlistNotification(context, data.name);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Rp ${data.price}",
                      style: TextStyle(
                        fontSize: 18,
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Stock: ${data.stock}",
                      style: TextStyle(
                        fontSize: 18,
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      data.desc,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (int.parse(data.stock) > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                data: data,
                                price: null,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: db.collection("userData").doc(uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error"));
                  }
                  var result = snapshot.data!.data();
                  if (result?['role'] == 'admin') {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => EditBarang(data: data),
                                ),
                              );
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 200,
                      child: FutureBuilder<QuerySnapshot>(
                        future: db.collection("product").get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          }

                          var products = snapshot.data!.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              var productData =
                                  products[index].data() as Map<String, dynamic>;
                              var product = Product(
                                id: productData['id'] ?? '',
                                name: productData['name'] ?? '',
                                desc: productData['desc'] ?? '',
                                image: productData['image'] ?? '',
                                price: productData['price'] ?? '',
                                stock: productData['stock'] ?? '',
                              );
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailBarang(data: product),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 16),
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                product.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Rp ${product.price}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showWishlistNotification(BuildContext context, String productName) {
    Flushbar(
      message: "$productName ditambahkan ke Wishlist",
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        Icons.check_circle,
        size: 28,
        color: Colors.green,
      ),
    )..show(context);
  }
}
