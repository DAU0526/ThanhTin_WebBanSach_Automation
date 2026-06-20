*** Settings ***
Documentation    Book Detail Page Keywords.
Resource         ../locators/book_detail_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Verify Book Detail Loaded
    [Documentation]    Chờ đến khi thông tin tiêu đề và nút Add to cart xuất hiện
    Wait Until Element Is Visible    ${LBL_BOOK_TITLE}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${BTN_ADD_TO_CART_DETAIL}    timeout=${MEDIUM_TIMEOUT}

Click Add To Cart In Detail
    [Documentation]    Click vào nút Add To Cart
    Wait Until Element Is Visible    ${BTN_ADD_TO_CART_DETAIL}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${BTN_ADD_TO_CART_DETAIL}

Click Back To Catalog
    [Documentation]    Bấm nút quay lại Home
    Wait Until Element Is Visible    ${BTN_BACK_TO_CATALOG}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${BTN_BACK_TO_CATALOG}

Verify Book Not Found
    [Documentation]    Check màn hình lỗi sách không tồn tại
    Wait Until Element Is Visible    ${STATE_BOOK_NOT_FOUND}    timeout=${MEDIUM_TIMEOUT}
