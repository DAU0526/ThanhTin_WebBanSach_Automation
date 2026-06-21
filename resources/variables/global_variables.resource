*** Settings ***
Documentation    Global variables used across the entire test suite.
...              These variables can be overridden by --variable when running CLI.
Variables        ../environment.yaml


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

${ADMIN_USERNAME}           ${credentials['admin']['username']}
${ADMIN_PASSWORD}           ${credentials['admin']['password']}

${TEST_USERNAME}            ${credentials['test_user']['username']}
${TEST_PASSWORD}            ${credentials['test_user']['password']}
${TEST_FULL_NAME}           ${credentials['test_user']['full_name']}
${TEST_EMAIL}               ${credentials['test_user']['email']}

${URL_HOME}                 ${BASE_URL}/
${URL_LOGIN}                ${BASE_URL}/login
${URL_REGISTER}             ${BASE_URL}/register
${URL_CART}                 ${BASE_URL}/cart
${URL_PROFILE}              ${BASE_URL}/profile
${URL_ADMIN}                ${BASE_URL}/admin
