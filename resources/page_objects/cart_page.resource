*** Settings ***
Documentation    Cart page keywords.
Resource         ../locators/cart_locators.resource
Resource         ../locators/navbar_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary
Library          Collections

*** Keywords ***
Navigate To Cart Page
    Go To    ${URL_CART}
    Cart Page Should Be Open

Cart Page Should Be Open
    Wait Until Element Is Visible    ${CART_PAGE_HEADING}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${CART_ORDER_SUMMARY}    timeout=${MEDIUM_TIMEOUT}

Navigate To Catalog
    Wait Until Element Is Visible    ${NAV_LINK_CATALOG}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${NAV_LINK_CATALOG}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

Prepare Clean Cart State
    [Documentation]    Reset browser state.
    Execute Javascript    window.localStorage.clear()
    Execute Javascript    window.sessionStorage.clear()
    Delete All Cookies
    Go To    ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}
    Navbar Cart Badge Should Show Count    0

Switch To All Books Catalog
    Wait Until Element Is Visible    ${HOME_TAB_ALL_BOOKS}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${HOME_TAB_ALL_BOOKS}
    Wait Until Element Is Visible    ${HOME_SEARCH_INPUT}    timeout=${MEDIUM_TIMEOUT}

Search Catalog Book
    [Arguments]    ${book_title}
    Wait Until Element Is Visible    ${HOME_SEARCH_INPUT}    timeout=${MEDIUM_TIMEOUT}
    Clear Element Text    ${HOME_SEARCH_INPUT}
    Input Text    ${HOME_SEARCH_INPUT}    ${book_title}

Get Catalog Book Card Locator
    [Arguments]    ${book_title}
    ${locator}=    Set Variable    xpath=//article[.//h2[contains(normalize-space(),"${book_title}")]]
    RETURN    ${locator}

Get Catalog Add To Cart Button Locator
    [Arguments]    ${book_title}
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    ${locator}=    Set Variable    ${card}//button[normalize-space()='Add to cart']
    RETURN    ${locator}

Get Catalog Unavailable Button Locator
    [Arguments]    ${book_title}
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    ${locator}=    Set Variable    ${card}//button[normalize-space()='Unavailable']
    RETURN    ${locator}

Add Book To Cart From Catalog
    [Arguments]    ${book_title}
    Navigate To Catalog
    Switch To All Books Catalog
    Search Catalog Book    ${book_title}
    ${button}=    Get Catalog Add To Cart Button Locator    ${book_title}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Enabled    ${button}
    Click Element    ${button}
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    Wait Until Element Contains    ${card}    In cart:    timeout=${MEDIUM_TIMEOUT}

Add Available Book To Cart
    [Documentation]    Add one book.
    [Arguments]    ${book_title}
    Add Book To Cart From Catalog    ${book_title}

Add Same Book To Cart Twice
    [Documentation]    Add same book twice.
    [Arguments]    ${book_title}
    Add Book To Cart From Catalog    ${book_title}
    Click Cart Icon In Navbar
    Increase Quantity For Item    ${book_title}
    Navigate To Catalog

Open Cart And Verify Book
    [Documentation]    Open cart and verify book.
    [Arguments]    ${book_title}
    Click Cart Icon In Navbar
    Cart Should Contain Book    ${book_title}

Out Of Stock Book Should Not Be Addable
    [Arguments]    ${book_title}
    Navigate To Catalog
    Switch To All Books Catalog
    Search Catalog Book    ${book_title}
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    ${button}=    Get Catalog Unavailable Button Locator    ${book_title}
    Wait Until Element Is Visible    ${card}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Disabled    ${button}
    Element Should Contain    ${card}    Out of stock

Click Cart Icon In Navbar
    Wait Until Element Is Visible    ${NAV_LINK_CART}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${NAV_LINK_CART}
    Cart Page Should Be Open

Get Cart Item Locator
    [Arguments]    ${book_title}
    ${locator}=    Set Variable    xpath=//section//article[.//h2[contains(normalize-space(),"${book_title}")]]
    RETURN    ${locator}

Get Cart Quantity Locator
    [Arguments]    ${book_title}
    ${item}=    Get Cart Item Locator    ${book_title}
    ${locator}=    Set Variable    ${item}//button[normalize-space()='-']/following-sibling::span[1]
    RETURN    ${locator}

Get Cart Increase Button Locator
    [Arguments]    ${book_title}
    ${item}=    Get Cart Item Locator    ${book_title}
    ${locator}=    Set Variable    ${item}//button[normalize-space()='+']
    RETURN    ${locator}

Get Cart Decrease Button Locator
    [Arguments]    ${book_title}
    ${item}=    Get Cart Item Locator    ${book_title}
    ${locator}=    Set Variable    ${item}//button[normalize-space()='-']
    RETURN    ${locator}

Get Cart Remove Button Locator
    [Arguments]    ${book_title}
    ${item}=    Get Cart Item Locator    ${book_title}
    ${locator}=    Set Variable    ${item}//button[normalize-space()='Remove']
    RETURN    ${locator}

Increase Quantity For Item
    [Arguments]    ${book_title}
    ${old_quantity}=    Get Cart Item Quantity    ${book_title}
    ${button}=    Get Cart Increase Button Locator    ${book_title}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${button}
    ${expected}=    Evaluate    ${old_quantity} + 1
    Wait Until Keyword Succeeds    5x    500ms    Cart Item Quantity Should Be    ${book_title}    ${expected}

Click Increase Quantity For Item
    [Arguments]    ${book_title}
    ${button}=    Get Cart Increase Button Locator    ${book_title}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${button}

Decrease Quantity For Item
    [Arguments]    ${book_title}
    ${old_quantity}=    Get Cart Item Quantity    ${book_title}
    ${button}=    Get Cart Decrease Button Locator    ${book_title}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${button}
    ${expected}=    Evaluate    ${old_quantity} - 1
    IF    ${expected} > 0
        Wait Until Keyword Succeeds    5x    500ms    Cart Item Quantity Should Be    ${book_title}    ${expected}
    ELSE
        ${item}=    Get Cart Item Locator    ${book_title}
        Wait Until Element Is Not Visible    ${item}    timeout=${MEDIUM_TIMEOUT}
    END

Remove Item From Cart
    [Arguments]    ${book_title}
    ${button}=    Get Cart Remove Button Locator    ${book_title}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${button}
    ${item}=    Get Cart Item Locator    ${book_title}
    Wait Until Element Is Not Visible    ${item}    timeout=${MEDIUM_TIMEOUT}

Get Cart Item Quantity
    [Arguments]    ${book_title}
    ${quantity_locator}=    Get Cart Quantity Locator    ${book_title}
    Wait Until Element Is Visible    ${quantity_locator}    timeout=${MEDIUM_TIMEOUT}
    ${quantity_text}=    Get Text    ${quantity_locator}
    ${quantity}=    Convert To Integer    ${quantity_text}
    RETURN    ${quantity}

Get Cart Items Count
    Wait Until Element Is Visible    ${CART_ITEMS_COUNT_VALUE}    timeout=${MEDIUM_TIMEOUT}
    ${count_text}=    Get Text    ${CART_ITEMS_COUNT_VALUE}
    ${count}=    Convert To Integer    ${count_text}
    RETURN    ${count}

Convert VND Text To Number
    [Arguments]    ${currency_text}
    ${amount}=    Evaluate    int(re.sub(r'\\D', '', '''${currency_text}'''))    re
    RETURN    ${amount}

Get Cart Total Amount
    Wait Until Element Is Visible    ${CART_TOTAL_VALUE}    timeout=${MEDIUM_TIMEOUT}
    ${total_text}=    Get Text    ${CART_TOTAL_VALUE}
    ${total}=    Convert VND Text To Number    ${total_text}
    RETURN    ${total}

Cart Should Contain Book
    [Arguments]    ${book_title}
    ${item}=    Get Cart Item Locator    ${book_title}
    Wait Until Element Is Visible    ${item}    timeout=${MEDIUM_TIMEOUT}

Cart Should Not Contain Book
    [Arguments]    ${book_title}
    ${item}=    Get Cart Item Locator    ${book_title}
    Wait Until Element Is Not Visible    ${item}    timeout=${MEDIUM_TIMEOUT}

Cart Should Be Empty
    Wait Until Element Is Visible    ${CART_EMPTY_TITLE}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Visible    ${CART_EMPTY_DESCRIPTION}
    Cart Items Count Should Be    0
    Cart Total Should Be    0
    Checkout Button Should Be Disabled

Cart Should Not Be Empty
    Wait Until Page Contains Element    ${CART_ITEM_CARDS}    timeout=${MEDIUM_TIMEOUT}
    Element Should Not Be Visible    ${CART_EMPTY_TITLE}

Cart Item Quantity Should Be
    [Arguments]    ${book_title}    ${expected_quantity}
    ${actual_quantity}=    Get Cart Item Quantity    ${book_title}
    Should Be Equal As Integers    ${actual_quantity}    ${expected_quantity}

Cart Items Count Should Be
    [Arguments]    ${expected_count}
    ${actual_count}=    Get Cart Items Count
    Should Be Equal As Integers    ${actual_count}    ${expected_count}

Cart Total Should Be
    [Arguments]    ${expected_total}
    ${actual_total}=    Get Cart Total Amount
    Should Be Equal As Integers    ${actual_total}    ${expected_total}

Navbar Cart Badge Should Show Count
    [Arguments]    ${expected_count}
    Wait Until Element Is Visible    ${NAV_CART_BADGE}    timeout=${MEDIUM_TIMEOUT}
    ${actual_count}=    Get Text    ${NAV_CART_BADGE}
    Should Be Equal As Integers    ${actual_count}    ${expected_count}

Checkout Button Should Be Disabled
    Wait Until Element Is Visible    ${CART_CHECKOUT_BUTTON}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Disabled    ${CART_CHECKOUT_BUTTON}

Checkout Button Should Be Enabled
    Wait Until Element Is Visible    ${CART_CHECKOUT_BUTTON}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Enabled    ${CART_CHECKOUT_BUTTON}

Login Required Message Should Be Visible
    Wait Until Element Is Visible    ${CART_LOGIN_REQUIRED_MESSAGE}    timeout=${MEDIUM_TIMEOUT}

Find First Out Of Stock Book Title From API
    ${title}=    Execute Async Javascript
    ...    const done = arguments[arguments.length - 1];
    ...    fetch('/api/books')
    ...      .then((response) => response.json())
    ...      .then((books) => {
    ...        const book = books.find((item) => Number(item.stock) <= 0);
    ...        done(book ? book.title : '');
    ...      })
    ...      .catch(() => done(''));
    RETURN    ${title}

Find Lowest Stock Available Book From API
    ${book}=    Execute Async Javascript
    ...    const done = arguments[arguments.length - 1];
    ...    fetch('/api/books')
    ...      .then((response) => response.json())
    ...      .then((books) => {
    ...        const candidates = books
    ...          .filter((item) => Number(item.stock) > 1)
    ...          .sort((a, b) => Number(a.stock) - Number(b.stock));
    ...        const book = candidates[0];
    ...        done(book ? [book.title, Number(book.stock)] : []);
    ...      })
    ...      .catch(() => done([]));
    RETURN    ${book}

Get Book Price From API
    [Arguments]    ${book_title}
    ${price}=    Execute Async Javascript
    ...    const done = arguments[arguments.length - 1];
    ...    fetch('/api/books')
    ...      .then((response) => response.json())
    ...      .then((books) => {
    ...        const book = books.find((item) => item.title === '${book_title}');
    ...        done(book ? Number(book.price) : 0);
    ...      })
    ...      .catch(() => done(0));
    RETURN    ${price}
