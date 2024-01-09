import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/component/wishlist.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/style/color.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wishlist wishlist = Provider.of<Wishlist>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: wishlist.products.length,
                itemBuilder: (context, index) {
                  Product wishlistItem = wishlist.products[index];
                  String stockInfo = wishlistItem.stock == '0'
                      ? 'Stok Habis'
                      : 'Tersedia (${wishlistItem.stock} Barang)';

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(wishlistItem.image),
                      ),
                      title: Text(wishlistItem.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Harga: ${wishlistItem.price}'),
                          SizedBox(height: 4),
                          Text(stockInfo),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Panggil metode removeFromWishlist dari Provider<Wishlist>
                          Provider.of<Wishlist>(context, listen: false)
                              .removeFromWishlist(index);

                          // Tampilkan snackbar sebagai notifikasi
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${wishlistItem.name} dihapus dari Wishlist'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Hapus bagian navigasi ke PaymentScreen
          ],
        ),
      ),
    );
  }
}
