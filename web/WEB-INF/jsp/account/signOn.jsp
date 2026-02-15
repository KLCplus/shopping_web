<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 确保响应使用UTF-8编码
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!--
PET STORE COMMERCE THEME - SPLIT LOGIN
风格：商业版左右布局 (Split Layout)
-->
<style>
    :root {
        /* 商业版配色：更沉稳的蓝 */
        --c-primary: #2563eb;       /* 标准蓝 */
        --c-primary-dark: #1e40af;  /* 深蓝 */
        --c-bg-light: #f8fafc;      /* 页面背景灰 */
        --c-text-head: #0f172a;     /* 标题色 */
        --c-text-body: #475569;     /* 正文色 */
        --c-border: #e2e8f0;        /* 边框色 */
        --c-input-bg: #ffffff;

        --radius: 8px;              /* 商业风格圆角较小，显得干练 */
        --shadow-card: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
        --transition: all 0.2s ease-in-out;
    }

    /* 全屏容器 */
    html, body { height: 100%; margin: 0; padding: 0; }
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        background-color: var(--c-bg-light);
        color: var(--c-text-body);
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
    }

    /* 登录卡片外壳 */
    .login-wrapper {
        width: 100%;
        max-width: 1000px; /* 宽卡片 */
        height: 600px;     /* 固定高度或最小高度 */
        background: #fff;
        border-radius: 16px;
        box-shadow: var(--shadow-card);
        overflow: hidden;
        display: flex;
        margin: 20px;
        position: relative;
    }

    /* --- 左侧：品牌展示区 --- */
    .brand-side {
        flex: 1; /* 占据 50% 宽度 */
        background-color: var(--c-primary);
        /*
           这里使用了一个在线的猫狗图片作为示例。
           实际项目中请替换为: url('../images/login-bg.jpg')
        */
        background-image: linear-gradient(135deg, rgba(30, 64, 175, 0.85), rgba(37, 99, 235, 0.6)),
        url('https://images.unsplash.com/photo-1450778869180-41d0601e046e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80');
        background-size: cover;
        background-position: center;
        color: #fff;
        padding: 60px 40px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        position: relative;
    }

    /* 品牌内容 */
    .brand-logo {
        font-size: 24px;
        font-weight: 800;
        letter-spacing: 1px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .brand-text h2 {
        font-size: 36px;
        margin: 0 0 16px 0;
        line-height: 1.2;
        font-weight: 700;
    }
    .brand-text p {
        font-size: 16px;
        opacity: 0.9;
        line-height: 1.6;
        max-width: 300px;
    }
    .brand-badge {
        display: inline-block;
        background: rgba(255,255,255,0.2);
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        backdrop-filter: blur(4px);
        margin-bottom: 20px;
    }

    /* --- 右侧：表单功能区 --- */
    .form-side {
        flex: 1; /* 占据 50% 宽度 */
        background: #fff;
        padding: 40px 60px;
        display: flex;
        flex-direction: column;
        justify-content: center; /* 垂直居中 */
        overflow-y: auto; /* 防止小屏幕高度不足时截断 */
    }

    /* 头部欢迎语 */
    .form-header { margin-bottom: 32px; }
    .form-header h1 {
        font-size: 28px;
        color: var(--c-text-head);
        margin: 0 0 8px 0;
        font-weight: 700;
    }
    .form-header p {
        margin: 0;
        font-size: 14px;
        color: var(--c-text-body);
    }

    /* 表单控件 */
    .form-group { margin-bottom: 20px; }
    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: var(--c-text-head);
        margin-bottom: 8px;
    }

    .input-wrapper { position: relative; }

    .form-input {
        width: 100%;
        padding: 12px 16px;
        font-size: 15px;
        border: 1px solid var(--c-border);
        border-radius: var(--radius);
        box-sizing: border-box;
        transition: var(--transition);
        outline: none;
        background: var(--c-input-bg);
        color: var(--c-text-head);
    }
    .form-input:focus {
        border-color: var(--c-primary);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
    }

    /* 密码切换按钮 */
    .toggle-password {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        cursor: pointer;
        color: #94a3b8;
        font-size: 13px;
        font-weight: 600;
        padding: 4px;
    }
    .toggle-password:hover { color: var(--c-primary); }

    /* 验证码区域 */
    .captcha-row {
        display: flex;
        gap: 12px;
        align-items: stretch;
    }
    .captcha-input-group { flex: 1; }
    .captcha-img {
        height: 46px; /* 与输入框高度一致 */
        border-radius: var(--radius);
        border: 1px solid var(--c-border);
        cursor: pointer;
    }
    .btn-refresh {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 46px;
        height: 46px;
        border: 1px solid var(--c-border);
        background: #fff;
        border-radius: var(--radius);
        cursor: pointer;
        color: var(--c-text-body);
        transition: var(--transition);
        text-decoration: none;
        font-size: 18px;
    }
    .btn-refresh:hover {
        background: #f1f5f9;
        color: var(--c-primary);
        border-color: var(--c-primary);
    }

    /* 消息提示 */
    .alert {
        padding: 12px 16px;
        border-radius: var(--radius);
        margin-bottom: 24px;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .alert-danger {
        background-color: #fef2f2;
        color: #ef4444;
        border: 1px solid #fee2e2;
    }

    /* 提交按钮 */
    .btn-submit {
        width: 100%;
        background-color: var(--c-primary);
        color: white;
        border: none;
        padding: 14px;
        font-size: 16px;
        font-weight: 600;
        border-radius: var(--radius);
        cursor: pointer;
        transition: var(--transition);
        margin-top: 10px;
    }
    .btn-submit:hover {
        background-color: var(--c-primary-dark);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    }

    /* 底部链接 */
    .form-footer {
        margin-top: 32px;
        text-align: center;
        font-size: 14px;
        color: var(--c-text-body);
    }
    .link {
        color: var(--c-primary);
        text-decoration: none;
        font-weight: 600;
    }
    .link:hover { text-decoration: underline; }

    /* 响应式适配：手机端隐藏左侧，只保留表单 */
    @media (max-width: 850px) {
        .login-wrapper { height: auto; max-width: 500px; flex-direction: column; }
        .brand-side { display: none; } /* 隐藏左侧 */
        .form-side { padding: 40px 30px; }
    }
</style>

<script>
    // 兜底日志函数
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // 记录登录行为
    function logLoginAttempt() {
        var username = document.querySelector('input[name="username"]').value || '';
        logEvent('USER_LOGIN', '尝试登录(商业版)', username, {
            formName: 'signOn',
            timestamp: new Date().toISOString()
        });
    }

    // 验证码刷新逻辑
    function logRefreshCaptcha(e){
        if (e) e.preventDefault();
        var img = document.getElementById('captchaImg');
        if (img) img.src = 'CaptchaServlet?ts=' + Date.now();
        logEvent('BUTTON_CLICK', '刷新验证码', 'Login_Page', { type: 'manual' });
        return false;
    }

    // 密码显示切换
    function togglePwd(){
        var el = document.querySelector('input[name="password"]');
        var btn = document.getElementById('toggleBtn');
        if(!el) return;

        var isVisible = el.type === 'password';
        el.type = isVisible ? 'text' : 'password';
        btn.innerText = isVisible ? '隐藏' : '显示';

        logEvent('BUTTON_CLICK', '切换密码可见性', isVisible ? 'show' : 'hide');
    }

    // 初始化
    window.addEventListener('load', function() {
        logEvent('PAGE_VIEW', '访问商业版登录页', 'signOn.jsp');
    });
</script>

<div class="login-wrapper">

    <!-- 左侧：品牌形象区 (手机端自动隐藏) -->
    <div class="brand-side">
        <div class="brand-logo">
            <!-- 简单的 CSS 爪印图标 -->
            <span style="font-size: 28px;">🐾</span>
            <span>JPetStore</span>
        </div>

        <div class="brand-text">
            <span class="brand-badge">2025 新版上线</span>
            <h2>给爱宠最好的呵护<br>从这里开始</h2>
            <p>加入全球最大的宠物爱好者社区，探索优质宠物食品、玩具与护理服务。</p>
        </div>

        <div style="font-size:12px; opacity:0.6">© 2025 JPetStore Inc. All rights reserved.</div>
    </div>

    <!-- 右侧：功能表单区 -->
    <div class="form-side">
        <div class="form-header">
            <h1>欢迎回来</h1>
            <p>请输入您的账号信息以管理您的订单。</p>
        </div>

        <form action="signOn" method="post" onsubmit="logLoginAttempt()">

            <!-- 错误提示 -->
            <c:if test="${requestScope.loginMsg != null}">
                <div class="alert alert-danger">
                    <span>⚠️</span> ${requestScope.loginMsg}
                </div>
            </c:if>

            <!-- 用户名 -->
            <div class="form-group">
                <label class="form-label">用户名 / Username</label>
                <input class="form-input" type="text" name="username" placeholder="请输入用户名" required>
            </div>

            <!-- 密码 -->
            <div class="form-group">
                <div style="display:flex;justify-content:space-between;">
                    <label class="form-label">密码 / Password</label>
                    <a href="#" class="link" style="font-size:12px;font-weight:400">忘记密码?</a>
                </div>
                <div class="input-wrapper">
                    <input class="form-input" type="password" name="password" placeholder="请输入密码" required>
                    <button type="button" class="toggle-password" id="toggleBtn" onclick="togglePwd()">显示</button>
                </div>
            </div>

            <!-- 验证码 -->
            <div class="form-group">
                <label class="form-label">安全验证 / Security Code</label>
                <div class="captcha-row">
                    <div class="captcha-input-group">
                        <input class="form-input" type="text" name="captcha" placeholder="验证码" maxlength="4" required>
                    </div>
                    <img id="captchaImg" class="captcha-img" src="CaptchaServlet" alt="验证码" onclick="logRefreshCaptcha(event)" title="点击图片刷新">
                    <a href="#" class="btn-refresh" onclick="return logRefreshCaptcha(event)" title="刷新">↻</a>
                </div>
            </div>

            <!-- 登录按钮 -->
            <button type="submit" class="btn-submit" onclick="logEvent('BUTTON_CLICK','点击登录主按钮')">
                立即登录
            </button>

            <!-- 底部引导 -->
            <div class="form-footer">
                还没有账号？ <a href="registerForm" class="link">免费注册账户</a>
            </div>
        </form>
    </div>
</div>
