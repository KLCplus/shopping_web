<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../common/top.jsp"%>

<%
    // 确保响应使用UTF-8编码
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!--
PET STORE THEME - UPDATE ACCOUNT
风格：蓝白洁净风格 (Blue & White)
逻辑：保留原有AJAX校验与日志埋点
-->
<style>
    :root {
        /* 核心配色：蓝白调 */
        --brand-primary: #3b82f6;       /* 主蓝色 */
        --brand-hover: #2563eb;         /* 悬停深蓝 */
        --brand-light: #eff6ff;         /* 极浅蓝背景 */
        --bg-gradient-start: #f0f9ff;   /* 背景渐变起始 */
        --bg-gradient-end: #e0f2fe;     /* 背景渐变结束 */

        --text-main: #1e293b;           /* 深蓝灰 */
        --text-muted: #64748b;          /* 次要文字 */
        --border-color: #cbd5e1;        /* 边框灰 */

        --card-bg: #ffffff;
        --card-shadow: 0 10px 25px -5px rgba(59, 130, 246, 0.1), 0 8px 10px -6px rgba(59, 130, 246, 0.05);

        --radius-sm: 8px;
        --radius-md: 12px;
        --radius-lg: 20px;
    }

    /* 深色模式适配 */
    @media (prefers-color-scheme: dark) {
        :root {
            --brand-primary: #60a5fa;
            --brand-hover: #93c5fd;
            --brand-light: #1e293b;
            --bg-gradient-start: #0f172a;
            --bg-gradient-end: #1e293b;
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --card-bg: #1e293b;
            --card-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }
    }

    html, body { height: 100%; }
    body {
        margin: 0;
        color: var(--text-main);
        background: linear-gradient(135deg, var(--bg-gradient-start) 0%, var(--bg-gradient-end) 100%);
        font-family: "Nunito", "Segoe UI", "PingFang SC", "Microsoft YaHei", sans-serif;
        -webkit-font-smoothing: antialiased;
    }

    .wrap {
        max-width: 960px;
        margin: 40px auto 80px;
        padding: 0 20px;
    }

    /* 卡片容器 */
    .card {
        background: var(--card-bg);
        border-radius: var(--radius-lg);
        box-shadow: var(--card-shadow);
        overflow: hidden;
        border-top: 5px solid var(--brand-primary); /* 顶部蓝色装饰线 */
        position: relative;
    }

    .head {
        padding: 30px 40px 10px;
        text-align: center; /* 标题居中 */
    }

    .title {
        margin: 0;
        font-size: 26px;
        color: var(--brand-primary);
        font-weight: 700;
        letter-spacing: -0.5px;
    }

    .divider {
        margin: 10px 40px;
        border: 0;
        height: 1px;
        background: var(--border-color);
        opacity: 0.5;
    }

    form { padding: 20px 40px 40px; }

    /* 分区样式 */
    .section { margin-bottom: 30px; }
    .section h3 {
        margin: 0 0 15px;
        font-size: 16px;
        color: var(--text-main);
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
        padding-bottom: 8px;
        border-bottom: 1px dashed var(--border-color);
    }

    .dot {
        width: 8px;
        height: 8px;
        background-color: var(--brand-primary);
        border-radius: 50%;
        box-shadow: 0 0 0 3px var(--brand-light);
    }

    /* 网格布局 */
    .grid { display: grid; gap: 20px; }
    @media (min-width: 768px) { .cols-2 { grid-template-columns: repeat(2, 1fr); } }

    /* 表单控件 */
    .field { position: relative; }
    .label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: var(--text-muted);
        margin-bottom: 6px;
    }

    .input, .select {
        width: 100%;
        box-sizing: border-box;
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: var(--radius-md);
        padding: 12px 16px;
        font-size: 14px;
        color: var(--text-main);
        transition: all 0.2s ease;
        outline: none;
    }

    .input:focus, .select:focus {
        border-color: var(--brand-primary);
        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15); /* 蓝色光晕 */
    }
    .input::placeholder { color: #94a3b8; }

    /* 消息提示 */
    .msg {
        padding: 12px 16px;
        border-radius: var(--radius-sm);
        margin-bottom: 20px;
        font-size: 14px;
        border: 1px solid transparent;
    }
    .msg-danger {
        background-color: #fef2f2;
        border-color: #fecaca;
        color: #b91c1c;
    }

    /* 复选框美化 */
    .inline-check {
        display: flex;
        align-items: center;
        gap: 10px;
        background: var(--brand-light);
        padding: 10px 14px;
        border-radius: var(--radius-md);
        border: 1px solid transparent;
        transition: border-color 0.2s;
    }
    .inline-check:hover { border-color: var(--brand-primary); }
    .checkbox { width: 16px; height: 16px; accent-color: var(--brand-primary); cursor: pointer; }
    .inline-check label { cursor: pointer; font-size: 14px; color: var(--text-main); font-weight: 500;}

    /* 按钮组 */
    .actions {
        margin-top: 30px;
        display: flex;
        justify-content: center;
        gap: 15px;
    }

    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 12px 24px;
        font-size: 15px;
        font-weight: 600;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.2s;
        border: 1px solid var(--border-color);
        background: #fff;
        color: var(--text-muted);
    }
    .btn:hover { background: var(--brand-light); color: var(--brand-primary); }

    .btn-primary {
        background: var(--brand-primary);
        border-color: var(--brand-primary);
        color: white;
        min-width: 160px;
        box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
    }
    .btn-primary:hover {
        background: var(--brand-hover);
        transform: translateY(-1px);
        color: white;
    }

    .btn:disabled {
        background: #e2e8f0;
        border-color: #e2e8f0;
        color: #94a3b8;
        cursor: not-allowed;
        box-shadow: none;
    }

    /* 显示隐藏密码按钮 */
    .btn-toggle {
        padding: 0 12px;
        height: 46px;
        border-radius: var(--radius-md);
        font-size: 13px;
    }

    /* 验证码 */
    .captcha-box {
        background: var(--brand-light);
        padding: 20px;
        border-radius: var(--radius-md);
        border: 1px dashed var(--brand-primary);
    }
    .captcha-line {
        display: flex;
        align-items: flex-end;
        gap: 15px;
        flex-wrap: wrap;
    }
    .captcha-img {
        height: 46px;
        border-radius: var(--radius-sm);
        border: 1px solid var(--border-color);
        cursor: pointer;
    }

    .foot {
        text-align: center;
        color: var(--text-muted);
        font-size: 12px;
        padding-bottom: 20px;
    }
</style>

<script>
    // 兜底：如果外部未注入 logEvent，不报错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // --- AJAX 验证用户名是否存在 (新增功能) ---
    function checkUsername() {
        var usernameInput = document.getElementById("username");
        var tip = document.getElementById("usernameTip");
        var val = usernameInput.value.trim();
        var submitBtn = document.getElementById("submitBtn");

        // 重置样式
        tip.innerHTML = "";
        usernameInput.style.borderColor = "";

        if (val === "") {
            return;
        }

        // 1. 创建 xhr 对象
        var xhr = new XMLHttpRequest();

        // 2. 准备请求 (加个时间戳t防止缓存)
        xhr.open("GET", "usernameCheck?username=" + encodeURIComponent(val) + "&t=" + new Date().getTime(), true);

        // 3. 回调函数
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if(xhr.status === 200) {
                    var result = xhr.responseText;
                    if (result === "EXIST") {
                        // 用户名已存在
                        tip.innerHTML = "❌ 该用户名已被占用，请更换";
                        tip.style.color = "#ef4444"; // 红色
                        usernameInput.style.borderColor = "#ef4444";
                        // 禁用提交按钮
                        if(submitBtn) submitBtn.disabled = true;
                    } else if (result === "OK") {
                        // 用户名可用
                        tip.innerHTML = "✅ 用户名可用";
                        tip.style.color = "#10b981"; // 绿色
                        usernameInput.style.borderColor = "#10b981";
                        // 启用提交按钮
                        if(submitBtn) submitBtn.disabled = false;
                    }
                }
            }
        };
        // 4. 发送请求
        xhr.send();
    }

    // 增强版更新账户尝试记录
    function logUpdateAttempt() {
        var username = document.querySelector('input[name="username"]').value || '';
        var email = document.querySelector('input[name="email"]').value || '';
        var changedFields = getChangedFields();

        logEvent('USER_UPDATE', '尝试更新账户', username, {
            email: email,
            changedFields: changedFields,
            totalFields: getFormFieldCount(),
            timestamp: new Date().toISOString()
        });
    }

    // 获取表单字段数量
    function getFormFieldCount() {
        var form = document.querySelector('form');
        return form ? form.elements.length : 0;
    }

    // 获取改变的字段（简化版）
    function getChangedFields() {
        var changed = [];
        var inputs = document.querySelectorAll('input[type="text"], select');
        inputs.forEach(function(input) {
            if (input.value && input.defaultValue !== input.value) {
                changed.push(input.name);
            }
        });
        return changed;
    }

    // 验证码刷新
    function logRefreshCaptcha(e){
        if (e) e.preventDefault();
        var img = document.getElementById('captchaImg');
        if (img) img.src = 'CaptchaServlet?ts=' + Date.now();
        logEvent('CAPTCHA_REFRESH', '刷新验证码', '更新账户页面', {
            action: 'manual_refresh',
            context: 'account_update',
            timestamp: new Date().toISOString()
        });
        return false;
    }

    // 显示/隐藏密码
    function togglePwd(){
        var el = document.querySelector('input[name="password"]');
        if(!el) return;
        var isVisible = el.type === 'password';
        el.type = isVisible ? 'text' : 'password';

        logEvent('BUTTON_CLICK', '切换密码显示', isVisible ? '显示密码' : '隐藏密码', {
            field: 'password',
            newState: isVisible ? 'visible' : 'hidden',
            context: 'update_form'
        });
    }

    // 页面加载时记录
    window.addEventListener('load', function() {
        var username = '${sessionScope.loginAccount.username}' || '未登录用户';
        logEvent('PAGE_VIEW', '访问账户更新页面', 'update.jsp', {
            user: username,
            referrer: document.referrer,
            timestamp: new Date().toISOString()
        });
    });

    // 字段变化监听
    document.addEventListener('DOMContentLoaded', function() {
        // 监听重要字段的变化
        var importantFields = ['email', 'phone', 'address1', 'city'];
        importantFields.forEach(function(fieldName) {
            var field = document.querySelector('input[name="' + fieldName + '"]');
            if (field) {
                field.addEventListener('blur', function() {
                    if (this.value && this.value !== this.defaultValue) {
                        logEvent('FORM_FIELD', '修改账户信息', fieldName, {
                            field: fieldName,
                            newValue: this.value,
                            oldValue: this.defaultValue || '空',
                            context: 'account_update'
                        });
                    }
                });
            }
        });
    });
</script>

<div class="wrap">
    <div class="card" id="Catalog">
        <div class="head">
            <h1 class="title">My Account</h1>
        </div>
        <hr class="divider"/>

        <!-- 保持原有 action 不变 -->
        <form action="updateAcount" method="post" onsubmit="logUpdateAttempt()">
            <c:if test="${requestScope.loginMsg != null}">
                <div class="msg msg-danger">${requestScope.loginMsg}</div>
            </c:if>

            <!-- 登录信息 -->
            <div class="section">
                <h3><span class="dot"></span> 登录信息</h3>
                <div class="grid cols-2">
                    <div class="field">
                        <label class="label">Username</label>
                        <input class="input" type="text" id="username" name="username"
                               placeholder="例如：jane_doe" onblur="checkUsername()"
                               value="${sessionScope.loginAccount.username}">
                        <span id="usernameTip" style="font-size: 12px; margin-top: 5px; display: block; min-height: 18px;"></span>
                    </div>
                    <div class="field">
                        <label class="label">Password</label>
                        <div style="display:flex;gap:8px;align-items:center">
                            <input class="input" type="password" name="password" placeholder="留空则不修改密码" value="${sessionScope.loginAccount.password}">
                            <button class="btn btn-toggle" type="button" onclick="togglePwd()">
                                <span style="font-size:12px">👁️</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 个人信息 -->
            <div class="section">
                <h3><span class="dot"></span> 个人信息</h3>
                <div class="grid cols-2">
                    <div class="field">
                        <label class="label">First Name</label>
                        <input class="input" type="text" name="firstName" placeholder="名" value="${sessionScope.loginAccount.firstName}">
                    </div>
                    <div class="field">
                        <label class="label">Last Name</label>
                        <input class="input" type="text" name="lastName" placeholder="姓" value="${sessionScope.loginAccount.lastName}">
                    </div>
                    <div class="field">
                        <label class="label">Email</label>
                        <input class="input" type="text" name="email" placeholder="you@example.com" value="${sessionScope.loginAccount.email}">
                    </div>
                    <div class="field">
                        <label class="label">Status</label>
                        <input class="input" type="text" name="status" placeholder="状态" value="${sessionScope.loginAccount.status}">
                    </div>
                    <div class="field">
                        <label class="label">Phone</label>
                        <input class="input" type="text" name="phone" placeholder="电话" value="${sessionScope.loginAccount.phone}">
                    </div>
                </div>
            </div>

            <!-- 地址信息 -->
            <div class="section">
                <h3><span class="dot"></span> 地址信息</h3>
                <div class="grid cols-2">
                    <div class="field">
                        <label class="label">Address Line 1</label>
                        <input class="input" type="text" name="address1" placeholder="地址 1" value="${sessionScope.loginAccount.address1}">
                    </div>
                    <div class="field">
                        <label class="label">Address Line 2</label>
                        <input class="input" type="text" name="address2" placeholder="地址 2" value="${sessionScope.loginAccount.address2}">
                    </div>
                    <div class="field">
                        <label class="label">City</label>
                        <input class="input" type="text" name="city" placeholder="城市" value="${sessionScope.loginAccount.city}">
                    </div>
                    <div class="field">
                        <label class="label">State</label>
                        <input class="input" type="text" name="state" placeholder="省/州" value="${sessionScope.loginAccount.state}">
                    </div>
                    <div class="field">
                        <label class="label">Zip Code</label>
                        <input class="input" type="text" name="zip" placeholder="邮编" value="${sessionScope.loginAccount.zip}">
                    </div>
                    <div class="field">
                        <label class="label">Country</label>
                        <input class="input" type="text" name="country" placeholder="国家" value="${sessionScope.loginAccount.country}">
                    </div>
                </div>
            </div>

            <!-- 偏好设置 -->
            <div class="section">
                <h3><span class="dot"></span> 偏好设置</h3>
                <div class="grid cols-2">
                    <div class="field">
                        <label class="label">Favourite Category ID</label>
                        <select class="select" name="favouriteCategoryId">
                            <option value="">请选择...</option>
                            <option value="FISH" ${sessionScope.loginAccount.favouriteCategoryId == 'FISH' ? 'selected' : ''}>🐟 FISH</option>
                            <option value="DOGS" ${sessionScope.loginAccount.favouriteCategoryId == 'DOGS' ? 'selected' : ''}>🐶 DOGS</option>
                            <option value="BIRDS" ${sessionScope.loginAccount.favouriteCategoryId == 'BIRDS' ? 'selected' : ''}>🦜 BIRDS</option>
                            <option value="CATS" ${sessionScope.loginAccount.favouriteCategoryId == 'CATS' ? 'selected' : ''}>🐱 CATS</option>
                            <option value="REPTILES" ${sessionScope.loginAccount.favouriteCategoryId == 'REPTILES' ? 'selected' : ''}>🦎 REPTILES</option>
                        </select>
                    </div>
                    <div class="field">
                        <label class="label">Language Preference</label>
                        <select class="select" name="languagePreference">
                            <option value="">请选择...</option>
                            <option value="zh-CN" ${sessionScope.loginAccount.languagePreference == 'zh-CN' ? 'selected' : ''}>🇨🇳 zh-CN</option>
                            <option value="en-US" ${sessionScope.loginAccount.languagePreference == 'en-US' ? 'selected' : ''}>🇺🇸 en-US</option>
                        </select>
                    </div>

                    <!-- 复选框 -->
                    <div class="inline-check">
                        <input class="checkbox" type="checkbox" name="listOption" value="true" id="listOption"
                        ${sessionScope.loginAccount.listOption ? 'checked' : ''}>
                        <label for="listOption">Enable List Option</label>
                    </div>
                    <div class="inline-check">
                        <input class="checkbox" type="checkbox" name="bannerOption" value="true" id="bannerOption"
                        ${sessionScope.loginAccount.bannerOption ? 'checked' : ''}>
                        <label for="bannerOption">Enable Banner Option</label>
                    </div>

                    <div class="field" style="grid-column:1 / -1">
                        <label class="label">Banner Name</label>
                        <input class="input" type="text" name="bannerName" placeholder="横幅名称" value="${sessionScope.loginAccount.bannerName}">
                    </div>
                </div>
            </div>

            <!-- 验证码 -->
            <div class="section">
                <h3><span class="dot"></span> 安全验证</h3>
                <div class="captcha-box">
                    <div class="captcha-line">
                        <div class="field" style="flex:1">
                            <label class="label" for="captcha">验证码 *</label>
                            <input class="input" id="captcha" name="captcha" type="text"
                                   placeholder="输入右侧字符" maxlength="4" required>
                        </div>
                        <img id="captchaImg" class="captcha-img" src="CaptchaServlet" alt="验证码" onclick="logRefreshCaptcha(event)" title="点击刷新">
                        <a href="signOnForm" class="btn" style="font-size:13px" onclick="return logRefreshCaptcha(event)">↻ 换一张</a>
                    </div>
                </div>
            </div>

            <div class="actions">
                <input type="submit" value="保存修改" class="btn btn-primary" id="submitBtn"
                       onclick="logEvent('BUTTON_CLICK','点击保存按钮')">
            </div>

            <p class="foot">更新信息即表示您确认所有数据真实有效。</p>
        </form>
    </div>
</div>

<%@ include file="../common/bottom.jsp"%>