*** Settings ***
Documentation    Home Page Keywords.
...              Provides interactions with the Book Catalog, including search,
...              category filter, tab navigation, and catalog-based cart operations.
Resource         ../locators/home_locators.resource
Resource         ../locators/navbar_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***

# ── Navigation ──────────────────────────────────────────────
Navigate To Home Page And Wait
    [Documentation]    Navigate to home page URL and wait for it to fully load.
    Go To    ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

# ── Catalog State Assertions ────────────────────────────────
Catalog Should Load With Recent Tab Active
    [Documentation]    Verify catalog loads with Recent tab and shows at most 4 books.
    Wait Until Element Is Visible    ${TAB_RECENT}          timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${BOOK_CARD_ARTICLE}   timeout=${MEDIUM_TIMEOUT}
    ${count}=    Get Element Count   ${BOOK_CARD_ARTICLE}
    Should Be True    ${count} <= 4    Recent tab should show at most 4 books

Search Results Should Show Exactly One Book
    [Documentation]    Verify that only one book card is visible in the grid.
    ${count}=    Get Element Count    ${BOOK_CARD_ARTICLE}
    Should Be True    ${count} == 1    Only the searched book should appear

Books Should Be Visible
    [Documentation]    Verify at least one book card is visible (e.g., after clearing search).
    Wait Until Element Is Visible    ${BOOK_CARD_ARTICLE}    timeout=${MEDIUM_TIMEOUT}

# ── Search ──────────────────────────────────────────────────
Search For Book
    [Arguments]    ${search_term}
    [Documentation]    Enter text into the search box.
    Wait Until Element Is Visible    ${INPUT_SEARCH_BOX}    timeout=${MEDIUM_TIMEOUT}
    Clear Element Text               ${INPUT_SEARCH_BOX}
    Input Text                       ${INPUT_SEARCH_BOX}    ${search_term}
    Sleep                            1s

Clear Search Box
    [Documentation]    Clear the search box.
    Wait Until Element Is Visible    ${INPUT_SEARCH_BOX}    timeout=${MEDIUM_TIMEOUT}
    Press Keys                       ${INPUT_SEARCH_BOX}    CTRL+a+BACKSPACE
    Sleep                            1s

# ── Tabs ────────────────────────────────────────────────────
Switch To All Books Tab
    [Documentation]    Click the "All Books" tab.
    Wait Until Element Is Visible    ${TAB_ALL_BOOKS}       timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${TAB_ALL_BOOKS}
    Sleep                            0.5s

Switch To Recent Tab
    [Documentation]    Click the "Recent" tab.
    Wait Until Element Is Visible    ${TAB_RECENT}          timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${TAB_RECENT}
    Sleep                            0.5s

# ── Category Filter ─────────────────────────────────────────
Select Category
    [Arguments]    ${category_name}
    [Documentation]    Open the category dropdown and select a specific category.
    Wait Until Element Is Visible    ${BTN_CATEGORY_FILTER}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${BTN_CATEGORY_FILTER}
    Sleep                            0.5s
    ${category_option}    Set Variable
    ...    xpath=//div[contains(@class, 'absolute')]//button[contains(., '${category_name}')]
    Wait Until Element Is Visible    ${category_option}        timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${category_option}
    Sleep                            1s

Category Filter Should Be Active
    [Documentation]    Verify category badge appears on a book card.
    [Arguments]    ${category_name}
    Wait Until Element Is Visible    xpath=//article[contains(@class, 'group')]//span[normalize-space()='${category_name}']    timeout=${MEDIUM_TIMEOUT}

# ── Book Cards ──────────────────────────────────────────────
Get First Book Title
    [Documentation]    Get the title of the first book displayed.
    Wait Until Element Is Visible    ${BOOK_CARD_TITLE}    timeout=${MEDIUM_TIMEOUT}
    ${elements}=    Get WebElements    ${BOOK_CARD_TITLE}
    ${title}=       Get Text           ${elements}[0]
    RETURN          ${title}

Click Book Card
    [Arguments]    ${book_title}
    [Documentation]    Click the book card title to navigate to Book Detail page.
    Wait Until Element Is Visible    xpath=//article[contains(@class, 'group')]//h2[normalize-space()='${book_title}']    timeout=${MEDIUM_TIMEOUT}
    Click Element                    xpath=//article[contains(@class, 'group')]//h2[normalize-space()='${book_title}']

Click See More On First Book
    [Documentation]    Click the "See more" button on the first book.
    Wait Until Element Is Visible    ${BTN_SEE_MORE}    timeout=${MEDIUM_TIMEOUT}
    ${elements}=    Get WebElements    ${BTN_SEE_MORE}
    Click Element    ${elements}[0]

# ── Book Detail Assertions ───────────────────────────────────
Book Detail Page Should Show Title
    [Documentation]    Verify detail page shows the requested title and URL contains /books/.
    [Arguments]    ${expected_title}
    Wait Until Element Is Visible    xpath=//h1[normalize-space()='${expected_title}']    timeout=${LONG_TIMEOUT}
    Location Should Contain    /books/

# ── Assertions ───────────────────────────────────────────────
Verify Book Present In Grid
    [Arguments]    ${book_title}
    [Documentation]    Verify that a book card with the exact title is displayed.
    Wait Until Element Is Visible    xpath=//article[contains(@class, 'group')]//h2[normalize-space()='${book_title}']    timeout=${MEDIUM_TIMEOUT}

Verify Empty Search State
    [Documentation]    Verify that the "No books match your search." message is displayed.
    Wait Until Element Is Visible    ${STATE_EMPTY_SEARCH}    timeout=${MEDIUM_TIMEOUT}

Verify Loading State
    [Documentation]    Verify the "Discovering books for you..." loader is shown.
    Wait Until Element Is Visible    ${STATE_LOADING_BOOKS}   timeout=${SHORT_TIMEOUT}

# ── Catalog Cart Operations ──────────────────────────────────
Get Catalog Book Card Locator
    [Arguments]    ${book_title}
    [Documentation]    Build and return the locator for a book card on the catalog page.
    ${locator}=    Set Variable    xpath=//article[.//h2[contains(normalize-space(),"${book_title}")]]
    RETURN    ${locator}

Get Catalog Add To Cart Button Locator
    [Arguments]    ${book_title}
    [Documentation]    Build the locator for the Add to Cart button on a book card.
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    ${locator}=    Set Variable    ${card}//button[normalize-space()='Add to cart']
    RETURN    ${locator}

Get Catalog Unavailable Button Locator
    [Arguments]    ${book_title}
    [Documentation]    Build the locator for the Unavailable button on an out-of-stock book card.
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    ${locator}=    Set Variable    ${card}//button[normalize-space()='Unavailable']
    RETURN    ${locator}

Navigate To Catalog
    [Documentation]    Navigate to catalog via Navbar without reloading the page.
    Wait Until Element Is Visible    ${NAV_LINK_CATALOG}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${NAV_LINK_CATALOG}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

Switch To All Books Catalog
    [Documentation]    Switch to All Books tab on the catalog page.
    Wait Until Element Is Visible    ${TAB_ALL_BOOKS}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${TAB_ALL_BOOKS}
    Wait Until Element Is Visible    ${INPUT_SEARCH_BOX}    timeout=${MEDIUM_TIMEOUT}

Search Catalog Book
    [Arguments]    ${book_title}
    [Documentation]    Search for a book by title in the catalog search box.
    Wait Until Element Is Visible    ${INPUT_SEARCH_BOX}    timeout=${MEDIUM_TIMEOUT}
    Press Keys    ${INPUT_SEARCH_BOX}    CTRL+a+BACKSPACE
    Sleep    0.5s
    Input Text    ${INPUT_SEARCH_BOX}    ${book_title}
    Sleep    0.5s

Add Book To Cart From Catalog
    [Arguments]    ${book_title}
    [Documentation]    Navigate to catalog, search for book, and click Add to Cart.
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
    [Documentation]    Navigate to catalog and add one copy of the book to cart.
    [Arguments]    ${book_title}
    Add Book To Cart From Catalog    ${book_title}


Out Of Stock Book Should Not Be Addable
    [Arguments]    ${book_title}
    [Documentation]    Verify an out-of-stock book cannot be added to cart.
    Navigate To Catalog
    Switch To All Books Catalog
    Search Catalog Book    ${book_title}
    ${card}=    Get Catalog Book Card Locator    ${book_title}
    ${button}=    Get Catalog Unavailable Button Locator    ${book_title}
    Wait Until Element Is Visible    ${card}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${button}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Disabled    ${button}
    Element Should Contain    ${card}    Out of stock
