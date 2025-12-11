import 'package:addtocartdatabase/controller/cart_controller.dart';
import 'package:addtocartdatabase/model/product_model.dart';
import 'package:addtocartdatabase/view/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  final List<Product> sampleProducts = [
    Product(id: 1, name: "Apple", imageUrl: "assets/apple.jpg", price: 1.0),
    Product(id: 2, name: "Banana", imageUrl: "assets/Banana.jpg", price: 0.5),
    Product(id: 3, name: "Orange", imageUrl: "assets/Orange.jpg", price: 0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => CartScreen()),
          )
        ],
      ),
      body: ListView.builder(
      itemCount: sampleProducts.length,
      itemBuilder: (context, index) {
        final product = sampleProducts[index];

        return Obx(() {
          final isInCart = cartController.cartItems
              .any((element) => element.id == product.id);

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(product.imageUrl, width: 60),
              title: Text(product.name),
              subtitle: Text("\$${product.price}"),
              trailing: ElevatedButton(
                onPressed: () {
                  if (!isInCart) {
                    cartController.addToCart(context, product);
                  } else {
                    Get.to(() => CartScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? Colors.grey : Colors.blue,
                ),
                child: Text(isInCart ? 'Go To Cart' : 'Add'),
              ),
            ),
          );
        });
      },
    ),
    );
  }
}
