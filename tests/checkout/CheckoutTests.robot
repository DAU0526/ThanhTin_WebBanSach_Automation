*** Settings ***
Documentation    Checkout Test Suite — Tiny Bookstore
...              Covers: successful checkout, empty cart checkout,
...              checkout without login, and order history verification.
Resource         ../../resources/page_objects/checkout_page.resource
Resource         ../../resources/page_objects/cart_page.resource
Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/page_objects/navbar_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Setup Checkout Suite
Suite Teardown   Close Browser Session
Test Setup       Prepare Clean Cart And Auth State
Test Teardown    Test Teardown With Screenshot

*** Variables ***
${BOOK_A}           Làm Bạn Với Bầu Trời
${BOOK_B}           Your Name

*** Keywords ***
Setup Checkout Suite
    [Documentation]    Open browser for the checkout test suite.
    Open Browser With Config    ${BASE_URL}

Prepare Clean Cart And Auth State
    [Documentation]    Ensure the user is logged out and the cart is empty.
    Clear Browser Session Data
    Navigate To Home Page And Wait
    Navbar Cart Badge Should Show Count    0

*** Test Cases ***
TC-CHK-01 Checkout Success
    [Documentation]    Log in, add a book to the cart, checkout, and confirm the order successfully.
    [Tags]    checkout    TC-CHK-01
    Login As Admin
    Add Available Book To Cart    ${BOOK_A}
    Click Cart Icon In Navbar
    Cart Page Should Be Open
    Submit Checkout
    Navbar Cart Badge Should Show Count    0

TC-CHK-02 Checkout Empty Cart
    [Documentation]    An empty cart cannot be checked out.
    [Tags]    checkout    TC-CHK-02
    Login As Admin
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
    Login As Admin
    Add Available Book To Cart    ${BOOK_A}
    Click Cart Icon In Navbar
    Submit Checkout
    Navigate To Profile Page
    Profile Purchase History Should Be Visible
    Page Should Contain    ${BOOK_A}

TC-CHK-05 Checkout Multiple Items
    [Documentation]    Add one book with quantity 2 and a second book, then checkout.
    [Tags]    checkout    TC-CHK-05
    Login As Admin
    Add Available Book To Cart    ${BOOK_B}
    Click Cart Icon In Navbar
    Cart Page Should Be Open
    Increase Quantity For Item    ${BOOK_B}
    Submit Checkout
    Navbar Cart Badge Should Show Count    0
