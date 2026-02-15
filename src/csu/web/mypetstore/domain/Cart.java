package csu.web.mypetstore.domain;

import csu.web.mypetstore.persistence.CartDao;
import csu.web.mypetstore.persistence.impl.CartDaoImpl;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.*;

public class Cart implements Serializable {
    private static final long serialVersionUID = 8329559983943337176L;
    private final Map<String, CartItem> itemMap = Collections.synchronizedMap(new HashMap<String, CartItem>());
    private final List<CartItem> itemList = new ArrayList<CartItem>();
    private String userId; // 添加用户ID字段
    private CartDao cartDao = new CartDaoImpl(); // 数据访问对象
    private boolean loadedFromDatabase = false; // 标记是否已从数据库加载

    // 构造函数
    public Cart() {}

    public Cart(String userId) {
        this.userId = userId;
        loadFromDatabase(); // 从数据库加载购物车数据
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
        if (!loadedFromDatabase) {
            loadFromDatabase(); // 只在第一次设置用户ID时加载购物车数据
        }
    }

    // 从数据库加载购物车数据
    private void loadFromDatabase() {
        if (userId != null) {
            List<CartItem> dbItems = cartDao.getCartItemsByUserId(userId);
            // 只在第一次加载时清空并重新填充
            if (!loadedFromDatabase) {
                itemMap.clear();
                itemList.clear();

                for (CartItem cartItem : dbItems) {
                    itemMap.put(cartItem.getItem().getItemId(), cartItem);
                    itemList.add(cartItem);
                }
                loadedFromDatabase = true; // 标记为已加载
            }
        }
    }

    // 保存到数据库
    private void saveToDatabase() {
        if (userId != null) {
            // 这里可以根据需要实现增量保存逻辑
        }
    }




    public Iterator<CartItem> getCartItems() {
        return itemList.iterator();
    }

    public List<CartItem> getCartItemList() {
        return itemList;
    }

    public int getNumberOfItems() {
        return itemList.size();
    }

    public Iterator<CartItem> getAllCartItems() {
        return itemList.iterator();
    }

    public boolean containsItemId(String itemId) {
        return itemMap.containsKey(itemId);
    }

    public void addItem(Item item, boolean isInStock) {
        CartItem cartItem = (CartItem) itemMap.get(item.getItemId());
        if (cartItem == null) {
            cartItem = new CartItem();
            cartItem.setItem(item);
            cartItem.setQuantity(0);
            cartItem.setInStock(isInStock);
            itemMap.put(item.getItemId(), cartItem);
            itemList.add(cartItem);
            if (userId != null) {
                cartDao.addItemToCart(userId, item.getItemId(), 1);
            }
        }
        cartItem.incrementQuantity();
        if (userId != null) {
            cartDao.updateCartItemQuantity(userId, item.getItemId(), cartItem.getQuantity());
        }
    }

    public Item removeItemById(String itemId) {
        CartItem cartItem = (CartItem) itemMap.remove(itemId);
        if (cartItem == null) {
            return null;
        } else {
            itemList.remove(cartItem);
            if (userId != null) {
                cartDao.removeItemFromCart(userId, itemId);
            }
            return cartItem.getItem();
        }
    }

    public void incrementQuantityByItemId(String itemId) {
        CartItem cartItem = (CartItem) itemMap.get(itemId);
        cartItem.incrementQuantity();

        if (userId != null) {
            cartDao.updateCartItemQuantity(userId, itemId, cartItem.getQuantity());
        }
    }

    public void setQuantityByItemId(String itemId, int quantity) {
        CartItem cartItem = (CartItem) itemMap.get(itemId);
        cartItem.setQuantity(quantity);

        if (userId != null) {
            cartDao.updateCartItemQuantity(userId, itemId, cartItem.getQuantity());
        }
    }

    public BigDecimal getSubTotal() {
        BigDecimal subTotal = new BigDecimal("0");
        Iterator<CartItem> items = getAllCartItems();
        while (items.hasNext()) {
            CartItem cartItem = (CartItem) items.next();
            Item item = cartItem.getItem();
            BigDecimal listPrice = item.getListPrice();
            BigDecimal quantity = new BigDecimal(String.valueOf(cartItem.getQuantity()));
            subTotal = subTotal.add(listPrice.multiply(quantity));
        }
        return subTotal;
    }

    // 清空购物车（包括数据库）
    public void clear() {
        itemMap.clear();
        itemList.clear();
        loadedFromDatabase = false; // 重置加载标记

        if (userId != null) {
            cartDao.clearCart(userId);
        }
    }

    // 获取总价（兼容性方法）
    public BigDecimal getTotalPrice() {
        return getSubTotal();
    }
}
