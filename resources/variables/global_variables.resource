*** Settings ***
Documentation    Global variables dùng chung cho toàn bộ test suite.
...              Các biến này có thể bị override bởi --variable khi chạy CLI.


*** Variables ***
# ── Environment ─────────────────────────────────────────────
${ENV}                      production
${BASE_URL}                 https://tiny-bookstore.vercel.app
${BROWSER}                  chrome
${IMPLICIT_WAIT}            5s
${PAGE_LOAD_TIMEOUT}        30s
${HEADLESS}                 ${FALSE}

# ── Timeouts ────────────────────────────────────────────────
${SHORT_TIMEOUT}            5s
${MEDIUM_TIMEOUT}           10s
${LONG_TIMEOUT}             30s

# ── Screenshot ──────────────────────────────────────────────
${SCREENSHOT_DIR}           ${CURDIR}${/}..${/}..${/}results${/}screenshots

# ── Admin Credentials ────────────────────────────────────────
# Hardcoded trong source (admin/admin123) — chỉ dùng cho test environment
${ADMIN_USERNAME}           admin
${ADMIN_PASSWORD}           admin123

# ── Test User (stable) ───────────────────────────────────────
# User này phải được tạo trước khi chạy test hoặc tạo trong Suite Setup
${TEST_USERNAME}            qa_testuser
${TEST_PASSWORD}            Test@12345
${TEST_FULL_NAME}           QA Test User
${TEST_EMAIL}               qa_testuser@test.local

# ── URLs ─────────────────────────────────────────────────────
${URL_HOME}                 ${BASE_URL}/
${URL_LOGIN}                ${BASE_URL}/login
${URL_REGISTER}             ${BASE_URL}/register
${URL_CART}                 ${BASE_URL}/cart
${URL_PROFILE}              ${BASE_URL}/profile
${URL_ADMIN}                ${BASE_URL}/admin
