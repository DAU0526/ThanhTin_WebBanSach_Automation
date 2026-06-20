*** Settings ***
Documentation    Global variables dùng chung cho toàn bộ test suite.
...              Các biến này có thể bị override bởi --variable khi chạy CLI.


*** Variables ***
${ENV}                      production
${BASE_URL}                 https://tiny-bookstore.vercel.app
${BROWSER}                  chrome
${IMPLICIT_WAIT}            5s
${PAGE_LOAD_TIMEOUT}        30s
${HEADLESS}                 ${FALSE}

${SHORT_TIMEOUT}            5s
${MEDIUM_TIMEOUT}           10s
${LONG_TIMEOUT}             30s

${SCREENSHOT_DIR}           ${CURDIR}${/}..${/}..${/}results${/}screenshots

${ADMIN_USERNAME}           admin
${ADMIN_PASSWORD}           admin123

${TEST_USERNAME}            qa_testuser
${TEST_PASSWORD}            Test@12345
${TEST_FULL_NAME}           QA Test User
${TEST_EMAIL}               qa_testuser@test.local

${URL_HOME}                 ${BASE_URL}/
${URL_LOGIN}                ${BASE_URL}/login
${URL_REGISTER}             ${BASE_URL}/register
${URL_CART}                 ${BASE_URL}/cart
${URL_PROFILE}              ${BASE_URL}/profile
${URL_ADMIN}                ${BASE_URL}/admin
