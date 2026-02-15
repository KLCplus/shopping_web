package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.domain.Cart;
import csu.web.mypetstore.domain.CartItem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Iterator;

public class UpdateCartServlet extends HttpServlet {

    private static final String CART_FORM = "/WEB-INF/jsp/cart/cart.jsp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 设置字符编码
        resp.setContentType("text/html;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        Account loginAccount = (Account) session.getAttribute("loginAccount");
        Cart cart = (Cart) session.getAttribute("cart");

        if (loginAccount == null) {
            req.setAttribute("errorMessage", "请先登录才能更新购物车！");
            req.getRequestDispatcher(CART_FORM).forward(req, resp);
            return;
        }

        // 检查购物车是否为null
        if (cart == null) {
            // 如果购物车为null，从数据库重新加载
            try {
                cart = new Cart(loginAccount.getUsername());
                session.setAttribute("cart", cart);
                req.setAttribute("successMessage", "购物车已从数据库重新加载！");
            } catch (Exception e) {
                req.setAttribute("errorMessage", "加载购物车失败：" + e.getMessage());
                req.getRequestDispatcher(CART_FORM).forward(req, resp);
                return;
            }
        }

        // 更新购物车中的商品数量
        boolean hasUpdates = false;
        Iterator<CartItem> cartItems = cart.getAllCartItems();
        while (cartItems.hasNext()) {
            CartItem cartItem = (CartItem) cartItems.next();
            String itemId = cartItem.getItem().getItemId();
            try {
                String quantityStr = req.getParameter(itemId);

                if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                    int quantity = Integer.parseInt(quantityStr);

                    // 只有当数量发生变化时才更新
                    if (quantity != cartItem.getQuantity()) {
                        cart.setQuantityByItemId(itemId, quantity);
                        hasUpdates = true;

                        if (quantity < 1) {
                            cartItems.remove();
                        }
                    }
                }
            } catch (Exception e) {
                // 忽略解析异常
            }
        }

        // 如果有更新，保存到数据库
        if (hasUpdates) {
            req.setAttribute("successMessage", "购物车已更新并同步到数据库！");
        } else {
            req.setAttribute("infoMessage", "购物车内容未发生变化。");
        }

        req.getRequestDispatcher(CART_FORM).forward(req, resp);
    }

}