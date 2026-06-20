*** Settings ***
Documentation    Checkout Management Test Suite — Tiny Bookstore
...              Based on Source Code Audit: The Checkout feature does not have a separate page
...              or data entry form. It directly calls the POST /api/orders API
...              with the items available in the cart when the user clicks "Checkout now" on the CartPage.
Resource         ../../resources/page_objects/checkout_page.resource
Resource         ../../resources/page_objects/cart_page.resource
Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Setup Checkout Suite
Suite Teardown   Close All Browsers
Test Setup       Prepare Clean Cart And Auth State

*** Variables ***
${BOOK_A}           Làm Bạn Với Bầu Trời
${BOOK_B}           Your Name

*** Keywords ***
Setup Checkout Suite
    Open Browser With Config    ${BASE_URL}

Prepare Clean Cart And Auth State
    [Documentation]    Ensure the user is logged out and the cart is empty.
    Execute Javascript    window.localStorage.clear()
    Execute Javascript    window.sessionStorage.clear()
    Delete All Cookies
    Go To    ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}
    Navbar Cart Badge Should Show Count    0

*** Test Cases ***
TC-CHK-01 Checkout Success
    [Documentation]    Log in, add a book to the cart, checkout, and confirm the order successfully.
    [Tags]    checkout    TC-CHK-01
    Navigate To Login Page
    Login With Credentials    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Add Available Book To Cart    ${BOOK_A}
    Click Cart Icon In Navbar
    Cart Page Should Be Open
    Submit Checkout
    Navbar Cart Badge Should Show Count    0

TC-CHK-02 Checkout Empty Cart
    [Documentation]    An empty cart cannot be checked out.
    [Tags]    checkout    TC-CHK-02
    Navigate To Login Page
    Login With Credentials    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Click Cart Icon In Navbar
    Cart Page Should Be Open
    Checkout Button Should Be Disabled

TC-CHK-03 Checkout Without Login
    [Documentation]    Cannot checkout without logging in; warning is displayed.
    [Tags]    checkout    TC-CHK-03
    Add Available Book To Cart    ${BOOK_A}
    Click Cart Icon In Navbar
    Cart Page Should Be Open
    Login Warning Message Should Be Visible
    Checkout Button Should Be Disabled

TC-CHK-04 Order Appears In Profile History After Checkout
    [Documentation]    After checkout, the order must appear in the purchase history on the Profile page.
    [Tags]    checkout    TC-CHK-04
    Navigate To Login Page
    Login With Credentials    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Add Available Book To Cart    ${BOOK_A}
    Click Cart Icon In Navbar
    Submit Checkout
    Wait Until Element Is Visible    ${NAV_LINK_PROFILE}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${NAV_LINK_PROFILE}
    Wait Until Element Is Visible    xpath=//h2[.='Purchase history']    timeout=${LONG_TIMEOUT}
    Page Should Contain    ${BOOK_A}

TC-CHK-05 Checkout Multiple Items
    [Documentation]    Add multiple types of books with varying quantities and checkout.
    [Tags]    checkout    TC-CHK-05
    Navigate To Login Page
    Login With Credentials    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Add Available Book To Cart    ${BOOK_A}
    Add Available Book To Cart    ${BOOK_B}
    Click Cart Icon In Navbar
    Cart Page Should Be Open
    Increase Quantity For Item    ${BOOK_A}
    Submit Checkout
    Navbar Cart Badge Should Show Count    0


