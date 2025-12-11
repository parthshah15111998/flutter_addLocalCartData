import 'package:addtocartdatabase/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/cart_db.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  @override
  void onInit() {
    loadCartItems();
    super.onInit();
  }

  void loadCartItems() async {
    cartItems.value = await CartDB.fetchCartItems();
  }

  void increaseQuantity(Product product) async {
    product.quantity++;
    await CartDB.updateQuantity(product.id, product.quantity);
    loadCartItems();
  }

  void decreaseQuantity(Product product) async {
    if (product.quantity > 1) {
      product.quantity--;
      await CartDB.updateQuantity(product.id, product.quantity);
    } else {
      await CartDB.deleteProduct(product.id);
    }
    loadCartItems();
  }

  void addToCart(BuildContext context, Product product) async {
    final exists = await CartDB.isProductInCart(product.id);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This item is already in your cart."),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await CartDB.insertProduct(product);
      loadCartItems();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} has been added to your cart."),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void removeFromCart(int id) async {
    await CartDB.deleteProduct(id);
    loadCartItems();
  }
}