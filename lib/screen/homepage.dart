import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/component/detail_barang.dart';
import 'package:tubes_ppb/screen/wishlist.dart';
import 'package:tubes_ppb/style/color.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  // data instance
  final TextEditingController _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<String> getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (error) {
      print('Error getting image URL: $error');
      return "https://firebasestorage.googleapis.com/v0/b/tubes-mobile2.appspot.com/o/profile_image%2Fno-photo-available.png?alt=media&token=9a7d9cd6-62af-45ef-bd8c-1f49fc502f03";
    }
  }

  @override
  Widget build(BuildContext context) {
    // media query
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[200]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Best product",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Perfect choice",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.heart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WishlistScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: white,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      child: Container(
                        height: mediaQuery.size.height,
                        width: mediaQuery.size.width,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "New Arrivals",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 150,
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
                                  child: Text("Error"),
                                );
                              }
                              var data = snapshot.data!.docs;

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length > 5 ? 5 : data.length, // Batasi hanya 5 produk
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => DetailBarang(
                                          data: Product(
                                            id: data[index].id,
                                            image: data[index]['image'],
                                            name: data[index]['name'],
                                            price: data[index]['price'],
                                            stock: data[index]['stock'],
                                            desc: data[index]['desc'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      width: 150,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        elevation: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 100, // Tetapkan tinggi gambar
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(15.0),
                                                ),
                                                child: Image.network(
                                                  data[index]['image'].toString(),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    print('Error loading image: $error');
                                                    return Icon(Icons.error);
                                                  },
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                (loadingProgress.expectedTotalBytes ?? 1)
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                data[index]['name'].toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "Recommended Products",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: db.collection("product").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error"),
                                );
                              }
                              var _data = snapshot.data!.docs;
                              var filteredData = _data.where((product) {
                                var price = int.tryParse(product['price'] ?? "0") ??
                                    0;
                                return price > 1000000;
                              }).toList();

                              return ListView.builder(
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => DetailBarang(
                                          data: Product(
                                            id: filteredData[index].id,
                                            image:
                                                filteredData[index]['image'],
                                            name: filteredData[index]['name'],
                                            price:
                                                filteredData[index]['price'],
                                            stock:
                                                filteredData[index]['stock'],
                                            desc: filteredData[index]['desc'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.white,Colors.white],
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                filteredData[index]['image']
                                                    .toString(),
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  print('Error loading image: $error');
                                                  return Icon(Icons.error);
                                                },
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                              (loadingProgress.expectedTotalBytes ?? 1)
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  filteredData[index]['name']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Rp ${filteredData[index]['price'].toString()}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  filteredData[index]['desc']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ],
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
