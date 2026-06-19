*** Settings ***
Documentation    Page Object cho Home page (catalog, search, filters).
...
...              TRÁCH NHIỆM:
...              - Điều hướng và tương tác với catalog sách
...              - Search sách theo tên/tác giả
...              - Dùng filters (category, format, price, sort)
...              - Thêm sách vào cart từ card

Resource         ../locators/home_locators.resource
Resource         ../locators/navbar_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***
# ──────────────────────────────────────────────────────────────
# NAVIGATION
# ──────────────────────────────────────────────────────────────

Navigate To Home Page
    Go To               ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

Switch To All Books Tab
    Click Element       ${HOME_TAB_ALL_BOOKS}
    Wait Until Element Is Visible    ${HOME_SEARCH_INPUT}    timeout=${SHORT_TIMEOUT}

Switch To Recent Tab
    Click Element       ${HOME_TAB_RECENT}

# ──────────────────────────────────────────────────────────────
# SEARCH
# ──────────────────────────────────────────────────────────────

Search For Book
    [Documentation]    Nhập từ khoá vào ô tìm kiếm. Kết quả filter client-side.
    [Arguments]         ${query}
    Wait Until Element Is Visible    ${HOME_SEARCH_INPUT}    timeout=${MEDIUM_TIMEOUT}
    Clear Element Text               ${HOME_SEARCH_INPUT}
    Input Text                       ${HOME_SEARCH_INPUT}    ${query}
    # Đợi ít nhất một kết quả (hoặc no-results) xuất hiện
    Wait Until Element Is Visible    ${HOME_BOOK_GRID}    timeout=${MEDIUM_TIMEOUT}

Clear Search
    Clear Element Text    ${HOME_SEARCH_INPUT}
    Press Keys            ${HOME_SEARCH_INPUT}    CTRL+a    DELETE

# ──────────────────────────────────────────────────────────────
# BOOK CARD INTERACTIONS
# ──────────────────────────────────────────────────────────────

Get Book Card By Title
    [Documentation]    Trả về XPath của book card theo tiêu đề sách.
    [Arguments]         ${title}
    RETURN              xpath=//article[.//h2[contains(normalize-space(),'${title}')]]

Click Add To Cart For Book
    [Documentation]    Tìm card sách theo tiêu đề và click "Add to cart".
    [Arguments]         ${title}
    ${card_xpath}=      Get Book Card By Title    ${title}
    ${btn_xpath}=       Set Variable    ${card_xpath}//button[contains(normalize-space(),'Add to cart')]
    Wait Until Element Is Visible    ${btn_xpath}    timeout=${MEDIUM_TIMEOUT}
    Click Element       ${btn_xpath}

Click Book Card To Open Detail
    [Documentation]    Click vào title/cover của book card để vào Book Detail page.
    [Arguments]         ${title}
    ${card_xpath}=      Get Book Card By Title    ${title}
    ${link_xpath}=      Set Variable    ${card_xpath}//a
    Wait Until Element Is Visible    ${link_xpath}    timeout=${MEDIUM_TIMEOUT}
    Click Element       ${link_xpath}

# ──────────────────────────────────────────────────────────────
# FILTERS
# ──────────────────────────────────────────────────────────────

Select Category Filter
    [Documentation]    Mở dropdown Category và chọn theo tên.
    [Arguments]         ${category_name}
    Click Element       ${HOME_FILTER_CATEGORIES}
    ${option}=          Set Variable    xpath=//button[normalize-space()='${category_name}']
    Wait Until Element Is Visible    ${option}    timeout=${SHORT_TIMEOUT}
    Click Element       ${option}

Select Price Range Filter
    [Documentation]    Mở dropdown Price và chọn theo label.
    [Arguments]         ${price_label}
    Click Element       ${HOME_FILTER_PRICE}
    ${option}=          Set Variable    xpath=//button[normalize-space()='${price_label}']
    Wait Until Element Is Visible    ${option}    timeout=${SHORT_TIMEOUT}
    Click Element       ${option}

# ──────────────────────────────────────────────────────────────
# ASSERTIONS
# ──────────────────────────────────────────────────────────────

Book Card Should Be Visible
    [Arguments]         ${title}
    ${card_xpath}=      Get Book Card By Title    ${title}
    Wait Until Element Is Visible    ${card_xpath}    timeout=${MEDIUM_TIMEOUT}

No Results Message Should Be Visible
    Wait Until Element Is Visible    ${HOME_NO_RESULTS_MSG}    timeout=${MEDIUM_TIMEOUT}

Book Cards Should Be Displayed
    [Documentation]    Xác nhận có ít nhất một book card trên trang.
    Wait Until Page Contains Element    ${HOME_BOOK_CARDS}    timeout=${LONG_TIMEOUT}

In Cart Badge Should Show For Book
    [Documentation]    Xác nhận badge "In cart: N" xuất hiện trên card sách.
    [Arguments]         ${title}    ${expected_qty}
    ${card_xpath}=      Get Book Card By Title    ${title}
    ${badge_xpath}=     Set Variable    ${card_xpath}//div[contains(.,'In cart:')]
    Wait Until Element Is Visible    ${badge_xpath}          timeout=${SHORT_TIMEOUT}
    Element Should Contain           ${badge_xpath}    ${expected_qty}
