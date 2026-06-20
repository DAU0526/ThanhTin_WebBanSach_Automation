*** Settings ***
Documentation    Book Detail Test Suite
Resource         ../../resources/page_objects/book_detail_page.resource
Resource         ../../resources/page_objects/home_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Setup Book Detail Suite
Suite Teardown   Close All Browsers
Test Setup       Go To Home Page And Refresh

*** Variables ***
${VALID_BOOK_ID}        1
${INVALID_BOOK_ID}      9999999

*** Keywords ***
Setup Book Detail Suite
    Open Browser With Config    ${BASE_URL}

Go To Home Page And Refresh
    Go To    ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

*** Test Cases ***
TC-BDT-01 View Book Detail
    [Documentation]    Truy cập trực tiếp detail bằng URL.
    [Tags]    book-detail    TC-BDT-01
    Go To    ${BASE_URL}/books/${VALID_BOOK_ID}
    Verify Book Detail Loaded

TC-BDT-02 Open Book From Home Page
    [Documentation]    Click từ Home Page sang Detail Page.
    [Tags]    book-detail    TC-BDT-02
    Wait Until Element Is Visible    ${BOOK_CARD_TITLE}    timeout=${MEDIUM_TIMEOUT}
    ${first_book}=    Get Text    xpath=(//article[contains(@class, 'group')]//h2)[1]
    Click Book Card    ${first_book}
    Verify Book Detail Loaded
    ${title_on_detail}=    Get Text    ${LBL_BOOK_TITLE}
    Should Be Equal    ${first_book}    ${title_on_detail}

TC-BDT-03 Add To Cart From Detail Page
    [Documentation]    Click nút Add to Cart.
    [Tags]    book-detail    TC-BDT-03
    Go To    ${BASE_URL}/books/${VALID_BOOK_ID}
    Verify Book Detail Loaded
    Click Add To Cart In Detail

TC-BDT-06 Refresh Book Detail Page
    [Documentation]    F5 lại trang và kiểm tra data có giữ nguyên không.
    [Tags]    book-detail    TC-BDT-06
    Go To    ${BASE_URL}/books/${VALID_BOOK_ID}
    Verify Book Detail Loaded
    Reload Page
    Verify Book Detail Loaded

TC-BDT-07 Invalid Book Id
    [Documentation]    Bắt lỗi khi nhập sai ID sách trên URL.
    [Tags]    book-detail    TC-BDT-07
    Go To    ${BASE_URL}/books/${INVALID_BOOK_ID}
    Verify Book Not Found

TC-BDT-08 Out Of Stock Book
    [Documentation]    Kiểm tra sách hết hàng (Cần setup ID OutOfStock vào biến). Tạm Pass Execution.
    [Tags]    book-detail    TC-BDT-08
    Pass Execution    Test này cần config 1 ID sách bị hết hàng trong Database.

TC-BDT-09 Navigate Back To Home
    [Documentation]    Sử dụng nút Back to catalog để về Home.
    [Tags]    book-detail    TC-BDT-09
    Go To    ${BASE_URL}/books/${VALID_BOOK_ID}
    Verify Book Detail Loaded
    Click Back To Catalog
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${MEDIUM_TIMEOUT}
