*** Settings ***
Documentation    Page Object cho Navbar component.
...
...              TRÁCH NHIỆM:
...              - Điều hướng qua các link trong Navbar
...              - Xác nhận trạng thái Navbar (logged-in vs guest)
...              - Thực hiện logout

Resource         ../locators/navbar_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***
# ──────────────────────────────────────────────────────────────
# NAVIGATION
# ──────────────────────────────────────────────────────────────

Click Catalog Link
    Click Element    ${NAV_LINK_CATALOG}
    Wait Until Page Contains Element    //article    timeout=${MEDIUM_TIMEOUT}

Click Cart Link
    Click Element    ${NAV_LINK_CART}
    Wait Until Page Contains    Cart    timeout=${MEDIUM_TIMEOUT}

Click Profile Link
    Click Element    ${NAV_LINK_PROFILE}
    Wait Until Page Contains    Profile    timeout=${MEDIUM_TIMEOUT}

Click Admin Link
    Click Element    ${NAV_LINK_ADMIN}
    Wait Until Page Contains    Admin    timeout=${MEDIUM_TIMEOUT}

Click Login Link
    Click Element    ${NAV_LINK_LOGIN}

Click Create Account Link
    Click Element    ${NAV_LINK_REGISTER}

Click Logout Button
    Click Element    ${NAV_BTN_LOGOUT}
    Wait Until Element Is Visible    ${NAV_LINK_LOGIN}    timeout=${MEDIUM_TIMEOUT}

# ──────────────────────────────────────────────────────────────
# ASSERTIONS — STATE
# ──────────────────────────────────────────────────────────────

Navbar Should Show Guest State
    [Documentation]    Khi chưa login, navbar phải có Log in và Create account.
    Wait Until Element Is Visible    ${NAV_LINK_LOGIN}       timeout=${SHORT_TIMEOUT}
    Wait Until Element Is Visible    ${NAV_LINK_REGISTER}    timeout=${SHORT_TIMEOUT}
    Element Should Not Be Visible    ${NAV_BTN_LOGOUT}

Navbar Should Show Authenticated State
    [Documentation]    Khi đã login, navbar phải có Profile và Logout.
    Wait Until Element Is Visible    ${NAV_LINK_PROFILE}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${NAV_BTN_LOGOUT}      timeout=${MEDIUM_TIMEOUT}
    Element Should Not Be Visible    ${NAV_LINK_LOGIN}

Navbar Should Show Admin Link
    [Documentation]    Chỉ admin mới thấy link Admin trong navbar.
    Wait Until Element Is Visible    ${NAV_LINK_ADMIN}    timeout=${MEDIUM_TIMEOUT}

Navbar Should Not Show Admin Link
    [Documentation]    Customer không được thấy link Admin trong navbar.
    Element Should Not Be Visible    ${NAV_LINK_ADMIN}

# ──────────────────────────────────────────────────────────────
# ASSERTIONS — CART COUNTER
# ──────────────────────────────────────────────────────────────

Cart Badge Should Show
    [Documentation]    Xác nhận badge cart hiển thị số lượng nhất định.
    [Arguments]         ${expected_count}
    Wait Until Element Is Visible    ${NAV_CART_BADGE}    timeout=${SHORT_TIMEOUT}
    Element Should Contain           ${NAV_CART_BADGE}    ${expected_count}
