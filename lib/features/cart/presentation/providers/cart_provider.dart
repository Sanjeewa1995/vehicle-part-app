import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cart_item.dart';
import '../../../requets/domain/entities/product.dart';
import '../../domain/usecases/create_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/add_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../../domain/usecases/delete_cart_item_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';

class CartProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final CreateCartUseCase _createCartUseCase;
  final GetCartItemsUseCase _getCartItemsUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final DeleteCartItemUseCase _deleteCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  static const String _cartIdKey = 'cart_id';

  CartProvider(
    this._prefs,
    this._createCartUseCase,
    this._getCartItemsUseCase,
    this._addCartItemUseCase,
    this._updateCartItemUseCase,
    this._deleteCartItemUseCase,
    this._clearCartUseCase,
  ) {
    _loadCart();
  }

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _cartId;
  final Map<int, bool> _updatingItems = {}; // Track items being updated to prevent duplicate updates

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int? get cartId => _cartId;

  Future<void> _ensureCart() async {
    if (_cartId == null) {
      try {
        final cart = await _createCartUseCase();
        _cartId = cart.id;
        await _prefs.setInt(_cartIdKey, _cartId!);
      } catch (e) {
        debugPrint('Error creating cart: $e');
        throw Exception('Failed to create cart: $e');
      }
    }
  }

  Future<void> _loadCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load cart ID from storage
      _cartId = _prefs.getInt(_cartIdKey);

      if (_cartId != null) {
        // Load cart items from API
        try {
          final cartItems = await _getCartItemsUseCase();
          // Remove duplicates by product ID (keep the one with the highest cartItemId)
          final Map<int, CartItem> uniqueItems = {};
          for (var item in cartItems) {
            final productId = item.product.id;
            if (!uniqueItems.containsKey(productId) || 
                (item.cartItemId != null && 
                 uniqueItems[productId]!.cartItemId != null &&
                 item.cartItemId! > uniqueItems[productId]!.cartItemId!)) {
              uniqueItems[productId] = item;
            }
          }
          _items = uniqueItems.values.toList();
          debugPrint('Loaded ${_items.length} unique cart items');
        } catch (e) {
          debugPrint('Error loading cart items: $e');
          // If loading fails, keep existing items or set to empty
          _items = [];
        }
      } else {
        // No cart exists yet, create one
        await _ensureCart();
        _items = [];
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
      _errorMessage = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      await _ensureCart();

      // Check if product already exists in cart
      final existingIndex = _items.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        // Product already exists, update quantity
        final existingItem = _items[existingIndex];
        debugPrint('Product ${product.id} already in cart with quantity ${existingItem.quantity}, updating to ${existingItem.quantity + 1}');
        await updateQuantity(product.id, existingItem.quantity + 1);
      } else {
        // Add new item
        debugPrint('Adding new product ${product.id} to cart');
        final cartItem = await _addCartItemUseCase(
          cartId: _cartId!,
          productId: product.id,
          quantity: 1,
        );
        // Check again if item was added by another process
        final checkIndex = _items.indexWhere(
          (item) => item.product.id == product.id,
        );
        if (checkIndex >= 0) {
          // Item already exists, update instead
          debugPrint('Product ${product.id} was added by another process, updating quantity');
          final existingItem = _items[checkIndex];
          await updateQuantity(product.id, existingItem.quantity + 1);
        } else {
          // Add the new item
          _items.add(cartItem);
          notifyListeners();
        }
      }
      
      // Refresh cart to ensure sync with backend
      await refreshCart();
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      final item = _items.firstWhere(
        (item) => item.product.id == productId,
      );

      if (item.cartItemId != null) {
        await _deleteCartItemUseCase(item.cartItemId!);
      }

      _items.removeWhere((item) => item.product.id == productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    // Prevent duplicate updates for the same product
    if (_updatingItems[productId] == true) {
      debugPrint('Update already in progress for product: $productId');
      return;
    }

    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    _updatingItems[productId] = true;
    
    try {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index < 0) {
        debugPrint('Product not found in cart: $productId');
        return;
      }

      // Get the current item to ensure we have the latest state
      final item = _items[index];
      debugPrint('Updating quantity for product $productId from ${item.quantity} to $quantity');
      
      // Check if item has a valid cart item ID (not -1 or null)
      if (item.cartItemId != null && item.cartItemId! > 0) {
        // Update via API
        try {
          final updatedItem = await _updateCartItemUseCase(
            cartItemId: item.cartItemId!,
            quantity: quantity,
          );
          // Replace the item at the same index to prevent duplicates
          _items[index] = updatedItem;
          notifyListeners();
        } catch (e) {
          final errorMessage = e.toString();
          debugPrint('Error updating via API: $e');
          
          // Handle case where update succeeds but API returns no response body
          if (errorMessage.contains('UPDATE_SUCCESS_NO_RESPONSE')) {
            debugPrint('Update succeeded but no response body, refreshing cart');
            await refreshCart();
            return;
          }
          
          // If update fails, reload cart to get latest state
          await refreshCart();
          // Try to find the item again after refresh
          final refreshedIndex = _items.indexWhere((item) => item.product.id == productId);
          if (refreshedIndex >= 0) {
            final refreshedItem = _items[refreshedIndex];
            if (refreshedItem.cartItemId != null && refreshedItem.cartItemId! > 0) {
              // Try update again with refreshed ID and current quantity
              try {
                final updatedItem = await _updateCartItemUseCase(
                  cartItemId: refreshedItem.cartItemId!,
                  quantity: quantity,
                );
                _items[refreshedIndex] = updatedItem;
                notifyListeners();
              } catch (e2) {
                final errorMessage2 = e2.toString();
                debugPrint('Error updating after refresh: $e2');
                
                // Handle case where update succeeds but API returns no response body
                if (errorMessage2.contains('UPDATE_SUCCESS_NO_RESPONSE')) {
                  debugPrint('Update succeeded but no response body after refresh, refreshing cart');
                  await refreshCart();
                  return;
                }
                
                throw Exception('Failed to update quantity: ${e2.toString()}');
              }
            } else {
              throw Exception('Item does not have a valid cart item ID');
            }
          } else {
            throw Exception('Item not found after refresh');
          }
        }
      } else {
        // Item doesn't have valid ID, need to add via API first
        await _ensureCart();
        try {
          final cartItem = await _addCartItemUseCase(
            cartId: _cartId!,
            productId: productId,
            quantity: quantity,
          );
          // Replace the item at the same index to prevent duplicates
          _items[index] = cartItem;
          notifyListeners();
        } catch (e) {
          debugPrint('Error adding item via API: $e');
          // If add fails, reload cart to sync state
          await refreshCart();
          throw Exception('Failed to update quantity: ${e.toString()}');
        }
      }
    } catch (e) {
      debugPrint('Error updating quantity: $e');
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _updatingItems[productId] = false;
    }
  }

  Future<void> clearCart() async {
    try {
      if (_cartId != null) {
        await _clearCartUseCase(_cartId!);
      }
      _items.clear();
      _cartId = null;
      await _prefs.remove(_cartIdKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  CartItem? getCartItem(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshCart() async {
    await _loadCart();
  }
}
