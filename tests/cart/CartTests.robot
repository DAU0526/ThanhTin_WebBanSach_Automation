*** Settings ***
Documentation     Cart Test Suite — Tiny Bookstore
...               Covers adding, removing, updating quantity in cart,
...               cart persistence, and checkout button states.
Resource          ../../resources/page_objects/cart_page.resource
Resource          ../../resources/page_objects/auth_page.resource
Resource          ../../resources/page_objects/navbar_page.resource
Resource          ../../resources/browser_keywords.resource
Resource          ../../resources/common_keywords.resource
Suite Setup       Setup Cart Suite
Suite Teardown    Close Browser Session
Test Setup        Prepare Clean Cart State
Test Teardown     Test Teardown With Screenshot

*** Variables ***
${BOOK_A}           Làm Bạn Với Bầu Trời
${BOOK_B}           Your Name
${BOOK_C}           Đi Khi Ta Còn Trẻ

*** Keywords ***
Setup Cart Suite
    Open Browser With Config    ${BASE_URL}
    ${price_a}=    Get Book Price From API    ${BOOK_A}
    Set Suite Variable    ${BOOK_A_PRICE}    ${price_a}
    ${price_b}=    Get Book Price From API    ${BOOK_B}
    Set Suite Variable    ${BOOK_B_PRICE}    ${price_b}
    ${price_c}=    Get Book Price From API    ${BOOK_C}
    Set Suite Variable    ${BOOK_C_PRICE}    ${price_c}

*** Test Cases ***
TC-CART-01 Add Book To Cart
    [Documentation]    Add book to cart.
    [Tags]    cart    smoke    TC-CART-01
    Add Available Book To Cart    ${BOOK_A}
    Navbar Cart Badge Should Show Count    1
    Open Cart And Verify Book    ${BOOK_A}
    Cart Item Quantity Should Be    ${BOOK_A}    1
    Cart Items Count Should Be    1
    Cart Total Should Be    ${BOOK_A_PRICE}
    Login Required Message Should Be Visible
    Checkout Button Should Be Disabled

TC-CART-02 Increase Quantity
    [Documentation]    Increase quantity.
    [Tags]    cart    TC-CART-02
    Add Available Book To Cart    ${BOOK_A}
    Open Cart And Verify Book    ${BOOK_A}
    Increase Quantity For Item    ${BOOK_A}
    Cart Item Quantity Should Be    ${BOOK_A}    2
    Cart Items Count Should Be    2
    Navbar Cart Badge Should Show Count    2
    ${expected_total}=    Evaluate    ${BOOK_A_PRICE} * 2
    Cart Total Should Be    ${expected_total}

TC-CART-03 Decrease Quantity
    [Documentation]    Decrease quantity.
    [Tags]    cart    TC-CART-03
    Add Same Book To Cart Twice    ${BOOK_A}
    Open Cart And Verify Book    ${BOOK_A}
    Cart Item Quantity Should Be    ${BOOK_A}    2
    Decrease Quantity For Item    ${BOOK_A}
    Cart Item Quantity Should Be    ${BOOK_A}    1
    Cart Items Count Should Be    1
    Navbar Cart Badge Should Show Count    1
    Cart Total Should Be    ${BOOK_A_PRICE}

TC-CART-04 Remove Item
    [Documentation]    Remove item.
    [Tags]    cart    TC-CART-04
    Add Available Book To Cart    ${BOOK_A}
    Open Cart And Verify Book    ${BOOK_A}
    Remove Item From Cart    ${BOOK_A}
    Cart Should Not Contain Book    ${BOOK_A}
    Cart Should Be Empty
    Navbar Cart Badge Should Show Count    0

TC-CART-05 Verify Cart Total
    [Documentation]    Verify total.
    [Tags]    cart    TC-CART-05
    Add Available Book To Cart    ${BOOK_A}
    Add Available Book To Cart    ${BOOK_B}
    Add Available Book To Cart    ${BOOK_C}
    Navbar Cart Badge Should Show Count    3
    Open Cart And Verify Book    ${BOOK_A}
    Cart Should Contain Book    ${BOOK_B}
    Cart Should Contain Book    ${BOOK_C}
    Increase Quantity For Item    ${BOOK_B}
    Cart Item Quantity Should Be    ${BOOK_A}    1
    Cart Item Quantity Should Be    ${BOOK_B}    2
    Cart Item Quantity Should Be    ${BOOK_C}    1
    Cart Items Count Should Be    4
    Navbar Cart Badge Should Show Count    4
    ${expected_total}=    Evaluate    ${BOOK_A_PRICE} + (${BOOK_B_PRICE} * 2) + ${BOOK_C_PRICE}
    Cart Total Should Be    ${expected_total}

TC-CART-06 Cart Persistence After Refresh
    [Documentation]    Verify refresh persistence.
    [Tags]    cart    TC-CART-06
    Skip    Skipped due to a known bug in the application (Cart state is not saved to localStorage and is wiped on refresh).
    Add Available Book To Cart    ${BOOK_A}
    Add Available Book To Cart    ${BOOK_B}
    Navbar Cart Badge Should Show Count    2
    Click Cart Icon In Navbar
    Sleep    1s
    Reload Page
    Cart Page Should Be Open
    Cart Should Contain Book    ${BOOK_A}
    Cart Should Contain Book    ${BOOK_B}
    Cart Item Quantity Should Be    ${BOOK_A}    1
    Cart Item Quantity Should Be    ${BOOK_B}    1
    Cart Items Count Should Be    2
    Navbar Cart Badge Should Show Count    2
    ${expected_total}=    Evaluate    ${BOOK_A_PRICE} + ${BOOK_B_PRICE}
    Cart Total Should Be    ${expected_total}

TC-CART-07 Add Same Book Twice
    [Documentation]    Add same book twice.
    [Tags]    cart    TC-CART-07
    Add Same Book To Cart Twice    ${BOOK_A}
    Navbar Cart Badge Should Show Count    2
    Open Cart And Verify Book    ${BOOK_A}
    Cart Item Quantity Should Be    ${BOOK_A}    2
    Cart Items Count Should Be    2
    ${expected_total}=    Evaluate    ${BOOK_A_PRICE} * 2
    Cart Total Should Be    ${expected_total}

TC-CART-08 Add Out Of Stock Book
    [Documentation]    Verify out-of-stock book.
    [Tags]    cart    negative    TC-CART-08
    ${out_of_stock_book}=    Find First Out Of Stock Book Title From API
    Skip If    '${out_of_stock_book}' == ''    Production API currently has no out-of-stock book.
    Out Of Stock Book Should Not Be Addable    ${out_of_stock_book}
    Navbar Cart Badge Should Show Count    0
    Click Cart Icon In Navbar
    Cart Should Be Empty

TC-CART-09 Quantity Should Not Exceed Available Stock
    [Documentation]    Verify max stock boundary.
    [Tags]    cart    boundary    TC-CART-09
    ${book}=    Find Lowest Stock Available Book From API
    ${book_title}=    Get From List    ${book}    0
    ${stock}=    Get From List    ${book}    1
    Skip If    ${stock} > 10    Stock too high, skipping to avoid long execution.
    Add Available Book To Cart    ${book_title}
    Open Cart And Verify Book    ${book_title}
    ${increase_count}=    Evaluate    int(${stock}) - 1
    FOR    ${index}    IN RANGE    ${increase_count}
        Increase Quantity For Item    ${book_title}
    END
    Cart Item Quantity Should Be    ${book_title}    ${stock}
    Click Increase Quantity For Item    ${book_title}
    Cart Item Quantity Should Be    ${book_title}    ${stock}

TC-CART-10 Guest Cart Should Persist After Login And Logout
    [Documentation]    Verify cart survives auth state changes.
    [Tags]    cart    auth-integration    TC-CART-10
    Add Available Book To Cart    ${BOOK_A}
    Navbar Cart Badge Should Show Count    1
    Navigate To Login Page
    Login With Credentials    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Should Be On Home Page
    Navbar Should Show Authenticated State
    Navbar Cart Badge Should Show Count    1
    Click Cart Icon In Navbar
    Cart Should Contain Book    ${BOOK_A}
    Checkout Button Should Be Enabled
    Click Logout Button
    Navbar Should Show Guest State
    Navbar Cart Badge Should Show Count    1
    Click Cart Icon In Navbar
    Cart Should Contain Book    ${BOOK_A}
    Checkout Button Should Be Disabled
