<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 确保响应使用UTF-8编码
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
%>

<!--
PET STORE THEME - FOOTER
风格：蓝白商业风格 (Blue & White Commerce)
-->
<style>
    /* 作用域限定在 Footer 内部，防止污染全局 */
    #Footer {
        /* 核心变量 - 与 TopBar/Login 保持一致 */
        --brand-primary: #3b82f6;       /* 主蓝色 */
        --bg-footer: #f8fafc;           /* 页脚浅灰背景 */
        --text-main: #1e293b;           /*以此深蓝灰代替纯黑 */
        --text-muted: #64748b;          /* 次要文字 */
        --border-color: #e2e8f0;        /* 边框灰 */
        --card-bg: #ffffff;

        width: 100%;
        background-color: var(--bg-footer);
        border-top: 1px solid var(--border-color);
        padding: 24px 0;
        margin-top: auto; /* 配合 flex body 实现沉底 */
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        font-size: 14px;
        color: var(--text-muted);
    }

    /* 深色模式适配 */
    @media (prefers-color-scheme: dark) {
        #Footer {
            --brand-primary: #60a5fa;
            --bg-footer: #0f172a;
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
            --border-color: #1e293b;
            --card-bg: #1e293b;
        }
    }

    /* 内容容器 - 限制宽度以对齐 Header */
    .footer-inner {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 20px;
    }

    /* 左侧：版权信息 */
    #PoweredBy {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    #PoweredBy .copy {
        font-weight: 500;
        color: var(--text-main);
    }

    #PoweredBy a {
        color: var(--text-muted);
        text-decoration: none;
        transition: color 0.2s;
        border-bottom: 1px dotted transparent;
    }

    #PoweredBy a:hover {
        color: var(--brand-primary);
        border-bottom-color: var(--brand-primary);
    }

    /* 右侧：个性化横幅 (Banner) */
    #Banner {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 13px;
        /* 左侧蓝色装饰条，突出“推荐/通知”感 */
        border-left: 4px solid var(--brand-primary);
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        min-height: 36px;
        transition: transform 0.2s;
    }

    #Banner:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
    }

    /* JS 动态生成的 Badge 样式 */
    #Banner .badge {
        background-color: var(--brand-primary);
        color: #fff;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    #Banner .muted {
        color: var(--text-muted);
        font-style: italic;
    }

    /* 移动端适配 */
    @media (max-width: 768px) {
        .footer-inner {
            flex-direction: column;
            text-align: center;
            padding-bottom: 20px; /* 移动端底部留白 */
        }
        #Banner {
            width: 100%;
            justify-content: center;
            box-sizing: border-box;
        }
    }
</style>

<script>
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    window.addEventListener('DOMContentLoaded', function(){
        var y = document.getElementById('year');
        if (y) y.textContent = new Date().getFullYear();

        var footer = document.getElementById('Footer');
        var banner = document.getElementById('Banner');

        // 若 Banner 为空，展示温和的占位内容（不影响后端后续渲染）
        // 样式调整为符合商业版的文字
        if (banner && banner.children.length === 0 && banner.textContent.trim() === '') {
            banner.innerHTML =
                '<span class="badge" aria-hidden="true">Tip</span>' +
                '<span class="muted">登录以查看您的专属优惠</span>';
        }

        if ('IntersectionObserver' in window && footer) {
            var io = new IntersectionObserver(function(es){
                es.forEach(function(e){
                    if (e.isIntersecting){
                        logEvent('FOOTER_VIEW','页脚区域可见');
                        io.unobserve(e.target);
                    }
                });
            });
            io.observe(footer);
        }
    });
</script>

<footer id="Footer" role="contentinfo" aria-label="Site footer">
    <div class="footer-inner">
        <!-- 左侧版权 -->
        <div id="PoweredBy">
            <span class="copy">&copy; <span id="year">2025</span> JPetStore</span>
            <span style="color:var(--border-color)">|</span>
            <a href="http://www.csu.edu.cn" target="_blank" rel="noopener noreferrer">Central South University</a>
        </div>

        <!-- 右侧 Banner (原有逻辑) -->
        <div id="Banner">
            <c:if test="${sessionScope.loginAccount != null }">
                <c:if test="${sessionScope.loginAccount.bannerOption}">
                    <!-- 如果有内容，添加一个图标增加视觉效果 -->
                    <span style="color: var(--brand-primary); font-size: 14px;">✨</span>
                    <span style="color: var(--text-main); font-weight: 500;">
                            ${sessionScope.loginAccount.bannerName}
                    </span>
                </c:if>
            </c:if>
        </div>
    </div>
</footer>

</body>
</html>