import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/component/add_barang.dart';
import 'package:tubes_ppb/component/detail_barang.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/style/color.dart';

class Barang extends StatefulWidget {
  Barang({Key? key});

  @override
  _BarangState createState() => _BarangState();
}

class _BarangState extends State<Barang> {
  final TextEditingController _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    _stream = db.collection("product").snapshots();
    super.initState();
  }

  void _filterData(String keyword) {
    setState(() {
      _stream = db
          .collection("product")
          .where('name', isGreaterThanOrEqualTo: keyword)
          .where('name', isLessThan: keyword + 'z')
          .snapshots();
    });
  }

  void _resetFilter() {
    setState(() {
      _searchController.clear();
      _stream = db.collection("product").snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Best Products",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Perfect Choices",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddBarang(),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: mediaQuery.size.width / 1.1,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      // Saat nilai teks berubah, panggil metode untuk memfilter data
                      if (value.isNotEmpty) {
                        _filterData(value);
                      } else {
                        _resetFilter();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Type here',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _resetFilter,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: gray),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                ),
                // Hapus FloatingActionButton dari sini
              ],
            ),
          ),
          StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              }
              var data = snapshot.data!.docs;

              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: data.length,
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
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: mediaQuery.size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    data[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              data[index]['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Rp ${data[index]['price']}",
                              style: TextStyle(
                                color: red,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              data[index]['desc'],
                              maxLines: 3, // Tampilkan maksimal 3 baris deskripsi
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
