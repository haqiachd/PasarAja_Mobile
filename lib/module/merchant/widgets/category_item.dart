import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoryItem({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Sesuaikan dengan kebutuhan
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(
                    categories[index]['photo'],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  categories[index]['category_name'],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Horizontal Category List'),
      ),
      body: CategoryItem(
        categories: [
          {
            "id_cp_prod": 1,
            "category_code": 100,
            "category_name": "Barang Bekas",
            "photo":
                "https://example.com/categories/barang_bekas.png", // Ganti URL sesuai dengan URL gambar
          },
          {
            "id_cp_prod": 2,
            "category_code": 101,
            "category_name": "Barang Antik",
            "photo":
                "https://example.com/categories/barang_antik.png", // Ganti URL sesuai dengan URL gambar
          },
          // Tambahkan data kategori lainnya di sini jika diperlukan
        ],
      ),
    ),
  ));
}
