<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ include file="../common/top.jsp"%>

<%
    // 确保响应使用UTF-8编码
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!--
PET STORE THEME - MAIN PAGE
风格：蓝白商业风格 (Blue & White Commerce)
布局：左侧导航 + 右侧轮播
-->
<style>
    :root {
        /* 核心配色 */
        --brand-primary: #3b82f6;       /* 主蓝色 */
        --brand-hover: #2563eb;         /* 悬停深蓝 */
        --bg-page: #f8fafc;             /* 页面背景 */
        --bg-card: #ffffff;             /* 卡片背景 */
        --text-main: #1e293b;           /* 主要文字 */
        --text-sub: #64748b;            /* 次要文字 */
        --border-color: #e2e8f0;        /* 边框 */

        --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
        --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);

        --radius: 8px;
    }

    /* 深色模式适配 */
    @media (prefers-color-scheme: dark) {
        :root {
            --brand-primary: #60a5fa;
            --brand-hover: #93c5fd;
            --bg-page: #0f172a;
            --bg-card: #1e293b;
            --text-main: #f1f5f9;
            --text-sub: #94a3b8;
            --border-color: #334155;
        }
    }

    body {
        margin: 0;
        background-color: var(--bg-page);
        color: var(--text-main);
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }

    /* 主容器 */
    .main-container {
        max-width: 1200px;
        margin: 30px auto 60px;
        padding: 0 20px;
    }

    /* 欢迎横幅 */
    .welcome-banner {
        background-color: var(--bg-card);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        padding: 15px 20px;
        margin-bottom: 20px;
        box-shadow: var(--shadow-sm);
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
    }
    .welcome-badge {
        background-color: rgba(59, 130, 246, 0.1);
        color: var(--brand-primary);
        padding: 4px 10px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 12px;
    }

    /* 核心网格布局：左侧栏 + 右侧主内容 */
    .grid-layout {
        display: grid;
        grid-template-columns: 280px 1fr; /* 左侧固定280px，右侧自适应 */
        gap: 24px;
        align-items: start;
    }

    /* --- 左侧导航栏 --- */
    .sidebar-card {
        background-color: var(--bg-card);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        box-shadow: var(--shadow-md);
        overflow: hidden;
    }

    .sidebar-header {
        padding: 15px 20px;
        background: #f1f5f9;
        border-bottom: 1px solid var(--border-color);
        font-weight: 700;
        color: var(--text-main);
        font-size: 15px;
    }

    .nav-list {
        display: flex;
        flex-direction: column;
    }

    .nav-item {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 15px 20px;
        text-decoration: none;
        color: var(--text-main);
        border-bottom: 1px solid var(--border-color);
        transition: all 0.2s;
    }
    .nav-item:last-child { border-bottom: none; }

    .nav-item:hover {
        background-color: #f8fafc;
        padding-left: 25px; /* 悬停右移效果 */
    }

    .nav-icon {
        width: 32px;
        height: 32px;
        object-fit: contain;
    }

    .nav-info { display: flex; flex-direction: column; }
    .nav-title { font-weight: 600; font-size: 14px; color: var(--text-main); }
    .nav-desc { font-size: 12px; color: var(--text-sub); margin-top: 2px; }

    /* 悬停时文字变蓝 */
    .nav-item:hover .nav-title { color: var(--brand-primary); }


    /* --- 右侧轮播图 --- */
    .carousel-wrapper {
        background-color: var(--bg-card);
        border-radius: var(--radius);
        box-shadow: var(--shadow-md);
        overflow: hidden;
        height: 420px; /* 固定高度 */
        position: relative;
        border: 1px solid var(--border-color);
    }

    .carousel-inner {
        width: 100%;
        height: 100%;
        position: relative;
    }

    .carousel-slide {
        position: absolute;
        top: 0; left: 0;
        width: 100%; height: 100%;
        opacity: 0;
        transition: opacity 0.5s ease-in-out;
        display: flex; /* 确保图片居中 */
        justify-content: center;
        align-items: center;
        background: #000; /* 图片未加载时的背景 */
    }

    .carousel-slide.active { opacity: 1; z-index: 1; }

    .carousel-slide img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 关键：裁剪填充，保证美观 */
        display: block;
    }

    .carousel-caption {
        position: absolute;
        bottom: 0; left: 0; right: 0;
        background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
        padding: 40px 20px 20px;
        color: white;
        text-shadow: 0 1px 2px rgba(0,0,0,0.5);
    }
    .caption-title { font-size: 20px; font-weight: 700; margin-bottom: 5px; }
    .caption-desc { font-size: 14px; opacity: 0.9; }

    /* 轮播控制按钮 */
    .carousel-control {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        width: 44px; height: 44px;
        background: rgba(255,255,255,0.9);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 2;
        border: 1px solid rgba(0,0,0,0.1);
        transition: all 0.2s;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        color: #333;
        font-size: 20px;
        user-select: none;
    }
    .carousel-control:hover { background: white; color: var(--brand-primary); transform: translateY(-50%) scale(1.1); }
    .carousel-prev { left: 20px; }
    .carousel-next { right: 20px; }

    /* 轮播指示器 */
    .carousel-indicators {
        position: absolute;
        bottom: 20px;
        right: 20px;
        display: flex;
        gap: 8px;
        z-index: 2;
    }
    .indicator {
        width: 10px; height: 10px;
        border-radius: 50%;
        background: rgba(255,255,255,0.5);
        cursor: pointer;
        transition: all 0.3s;
        border: 1px solid rgba(0,0,0,0.1);
    }
    .indicator.active { background: white; transform: scale(1.2); border-color: transparent; }

    /* 响应式 */
    @media (max-width: 850px) {
        .grid-layout { grid-template-columns: 1fr; }
        .sidebar-card { display: none; /* 小屏时可选隐藏侧边栏或改为顶部横排 */ }
        .carousel-wrapper { height: 300px; }
    }
</style>

<script>
    // 兜底日志
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    function logCategoryClick(categoryId, categoryName) {
        logEvent('CATEGORY_VIEW', '浏览分类: ' + categoryName + ' (ID: ' + categoryId + ')');
    }

    // 纯原生 JS 轮播图逻辑
    document.addEventListener('DOMContentLoaded', function() {
        const slides = document.querySelectorAll('.carousel-slide');
        const indicators = document.querySelectorAll('.indicator');
        const nextBtn = document.querySelector('.carousel-next');
        const prevBtn = document.querySelector('.carousel-prev');
        let currentIndex = 0;
        let intervalId;

        if (slides.length === 0) return;

        function showSlide(index) {
            // 处理索引越界
            if (index >= slides.length) currentIndex = 0;
            else if (index < 0) currentIndex = slides.length - 1;
            else currentIndex = index;

            // 切换 Slide class
            slides.forEach(slide => slide.classList.remove('active'));
            slides[currentIndex].classList.add('active');

            // 切换 Indicator class
            indicators.forEach(ind => ind.classList.remove('active'));
            if(indicators[currentIndex]) indicators[currentIndex].classList.add('active');
        }

        function nextSlide() { showSlide(currentIndex + 1); }
        function prevSlide() { showSlide(currentIndex - 1); }

        // 事件监听
        if(nextBtn) nextBtn.addEventListener('click', () => { nextSlide(); resetTimer(); });
        if(prevBtn) prevBtn.addEventListener('click', () => { prevSlide(); resetTimer(); });

        indicators.forEach((ind, i) => {
            ind.addEventListener('click', () => {
                showSlide(i);
                resetTimer();
            });
        });

        // 自动播放
        function startTimer() { intervalId = setInterval(nextSlide, 5000); }
        function resetTimer() { clearInterval(intervalId); startTimer(); }

        // 初始化
        showSlide(0);
        startTimer();
    });
</script>

<div class="main-container">

    <!-- 1. 欢迎横幅 (仅登录可见) -->
    <c:if test="${not empty sessionScope.loginAccount}">
        <div class="welcome-banner">
            <span class="welcome-badge">Welcome Back</span>
            <span style="font-weight:600; color:var(--text-main)">${sessionScope.loginAccount.username}</span>
            <span style="color:var(--text-sub)">- Happy Shopping! 🎉</span>
            <script>logEvent('USER_LOGIN', '用户已登录: ${sessionScope.loginAccount.username}');</script>
        </div>
    </c:if>

    <!-- 2. 主体网格布局 -->
    <div class="grid-layout">

        <!-- 左侧：分类导航菜单 -->
        <aside class="sidebar-card">
            <div class="sidebar-header">Category</div>
            <div class="nav-list">
                <a href="categoryForm?categoryId=FISH" class="nav-item" onclick="logCategoryClick('FISH','Fish')">
                    <img src="images/fish_icon.gif" class="nav-icon" alt="Fish">
                    <div class="nav-info">
                        <span class="nav-title">Fish</span>
                        <span class="nav-desc">Saltwater, Freshwater</span>
                    </div>
                </a>

                <a href="categoryForm?categoryId=DOGS" class="nav-item" onclick="logCategoryClick('DOGS','Dogs')">
                    <img src="images/dogs_icon.gif" class="nav-icon" alt="Dogs">
                    <div class="nav-info">
                        <span class="nav-title">Dogs</span>
                        <span class="nav-desc">Various Breeds</span>
                    </div>
                </a>

                <a href="categoryForm?categoryId=CATS" class="nav-item" onclick="logCategoryClick('CATS','Cats')">
                    <img src="images/cats_icon.gif" class="nav-icon" alt="Cats">
                    <div class="nav-info">
                        <span class="nav-title">Cats</span>
                        <span class="nav-desc">Exotic Varieties</span>
                    </div>
                </a>

                <a href="categoryForm?categoryId=REPTILES" class="nav-item" onclick="logCategoryClick('REPTILES','Reptiles')">
                    <img src="images/reptiles_icon.gif" class="nav-icon" alt="Reptiles">
                    <div class="nav-info">
                        <span class="nav-title">Reptiles</span>
                        <span class="nav-desc">Lizards, Turtles</span>
                    </div>
                </a>

                <a href="categoryForm?categoryId=BIRDS" class="nav-item" onclick="logCategoryClick('BIRDS','Birds')">
                    <img src="images/birds_icon.gif" class="nav-icon" alt="Birds">
                    <div class="nav-info">
                        <span class="nav-title">Birds</span>
                        <span class="nav-desc">Parrots, Finches</span>
                    </div>
                </a>
            </div>
        </aside>

        <!-- 右侧：商业级轮播图 -->
        <main class="carousel-wrapper">
            <div class="carousel-inner">

                <!-- Slide 1: Fish -->
                <div class="carousel-slide active">
                    <a href="categoryForm?categoryId=FISH" onclick="logCategoryClick('FISH','Fish')">
                        <!-- 使用 contextPath 确保图片路径正确 -->
                        <img src="${pageContext.request.contextPath}/images/mfish.png" alt="Fish">
                    </a>
                    <div class="carousel-caption">
                        <div class="caption-title">Underwater World</div>
                        <div class="caption-desc">Explore our wide collection of freshwater and saltwater fish.</div>
                    </div>
                </div>

                <!-- Slide 2: Dogs -->
                <div class="carousel-slide">
                    <a href="categoryForm?categoryId=DOGS" onclick="logCategoryClick('DOGS','Dogs')">
                        <img src="${pageContext.request.contextPath}/images/mdog.png" alt="Dogs">
                    </a>
                    <div class="carousel-caption">
                        <div class="caption-title">Loyal Companions</div>
                        <div class="caption-desc">Find your perfect best friend from our dog breeds.</div>
                    </div>
                </div>

                <!-- Slide 3: Cats -->
                <div class="carousel-slide">
                    <a href="categoryForm?categoryId=CATS" onclick="logCategoryClick('CATS','Cats')">
                        <img src="${pageContext.request.contextPath}/images/mcat.png" alt="Cats">
                    </a>
                    <div class="carousel-caption">
                        <div class="caption-title">Feline Friends</div>
                        <div class="caption-desc">Soft, cuddly, and independent.</div>
                    </div>
                </div>

                <!-- Slide 4: Reptiles -->
                <div class="carousel-slide">
                    <a href="categoryForm?categoryId=REPTILES" onclick="logCategoryClick('REPTILES','Reptiles')">
                        <img src="${pageContext.request.contextPath}/images/mxiyi.png" alt="Reptiles">
                    </a>
                    <div class="carousel-caption">
                        <div class="caption-title">Exotic Life</div>
                        <div class="caption-desc">Discover the fascinating world of reptiles.</div>
                    </div>
                </div>

                <!-- Slide 5: Birds -->
                <div class="carousel-slide">
                    <a href="categoryForm?categoryId=BIRDS" onclick="logCategoryClick('BIRDS','Birds')">
                        <img src="${pageContext.request.contextPath}/images/mbird.png" alt="Birds">
                    </a>
                    <div class="carousel-caption">
                        <div class="caption-title">Take Flight</div>
                        <div class="caption-desc">Colorful birds to brighten your home.</div>
                    </div>
                </div>

            </div>

            <!-- 控制按钮 -->
            <div class="carousel-control carousel-prev">‹</div>
            <div class="carousel-control carousel-next">›</div>

            <!-- 指示器 -->
            <div class="carousel-indicators">
                <div class="indicator active"></div>
                <div class="indicator"></div>
                <div class="indicator"></div>
                <div class="indicator"></div>
                <div class="indicator"></div>
            </div>
        </main>
    </div>
</div>

<%@ include file="../common/bottom.jsp"%>