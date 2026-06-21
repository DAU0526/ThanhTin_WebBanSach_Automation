*** Settings ***
Documentation    Book Detail Test Suite — Tiny Bookstore
...              Covers: viewing book detail, navigation, add to cart, error states.
Resource         ../../resources/page_objects/book_detail_page.resource
Resource         ../../resources/page_objects/home_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Setup Book Detail Suite
Suite Teardown   Close Browser Session
Test Setup       Go To Home Page And Refresh
Test Teardown    Test Teardown With Screenshot

*** Variables ***
${VALID_BOOK_ID}        1
${INVALID_BOOK_ID}      9999999

*** Keywords ***
Setup Book Detail Suite
    [Documentation]    Open browser and navigate to home page.
    Open Browser With Config    ${BASE_URL}

Go To Home Page And Refresh
    [Documentation]    Navigate to home and wait for it to load.
    Go To    ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

*** Test Cases ***
TC-BDT-01 View Book Detail
    [Documentation]    Access detail page directly via URL.
    [Tags]    book-detail    TC-BDT-01
    Navigate To Book Detail By Id    ${VALID_BOOK_ID}
    Verify Book Detail Loaded

TC-BDT-02 Open Book From Home Page
    [Documentation]    Navigate from Home Page to Detail Page.
    [Tags]    book-detail    TC-BDT-02
    Wait Until Element Is Visible    ${BOOK_CARD_TITLE}    timeout=${MEDIUM_TIMEOUT}
    ${first_book}=    Get Text    xpath=(//article[contains(@class, 'group')]//h2)[1]
    Click Book Card    ${first_book}
    Verify Book Detail Loaded
    ${title_on_detail}=    Get Text    ${LBL_BOOK_TITLE}
    Should Be Equal    ${first_book}    ${title_on_detail}

TC-BDT-03 Add To Cart From Detail Page
    [Documentation]    Click Add to Cart button.
    [Tags]    book-detail    TC-BDT-03
    Navigate To Book Detail By Id    ${VALID_BOOK_ID}
    Verify Book Detail Loaded
    Click Add To Cart In Detail

TC-BDT-06 Refresh Book Detail Page
    [Documentation]    Refresh page and verify data persists.
    [Tags]    book-detail    TC-BDT-06
    Navigate To Book Detail By Id    ${VALID_BOOK_ID}
    Verify Book Detail Loaded
    Reload Page
    Verify Book Detail Loaded

TC-BDT-07 Invalid Book Id
    [Documentation]    Handle error when invalid book ID is in URL.
    [Tags]    book-detail    TC-BDT-07
    Navigate To Book Detail By Id    ${INVALID_BOOK_ID}
    Verify Book Not Found

TC-BDT-08 Out Of Stock Book
    [Documentation]    Verify out of stock book. (Requires OutOfStock ID setup). Temporarily Pass Execution.
    [Tags]    book-detail    TC-BDT-08
    Pass Execution    Test này cần config 1 ID sách bị hết hàng trong Database.

TC-BDT-09 Navigate Back To Home
    [Documentation]    Use Back to catalog button to return to Home.
    [Tags]    book-detail    TC-BDT-09
    Navigate To Book Detail By Id    ${VALID_BOOK_ID}
    Verify Book Detail Loaded
    Click Back To Catalog
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${MEDIUM_TIMEOUT}
