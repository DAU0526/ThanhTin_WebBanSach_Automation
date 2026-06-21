*** Settings ***
Documentation    Book Detail Page Keywords.
Resource         ../locators/book_detail_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Navigate To Book Detail By Id
    [Documentation]    Go to a book detail page by ID directly via URL.
    [Arguments]    ${book_id}
    Go To    ${BASE_URL}/books/${book_id}

Verify Book Detail Loaded
    [Documentation]    Wait until title and Add to cart button appear
    Wait Until Element Is Visible    ${LBL_BOOK_TITLE}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${BTN_ADD_TO_CART_DETAIL}    timeout=${MEDIUM_TIMEOUT}

Click Add To Cart In Detail
    [Documentation]    Click Add To Cart button
    Wait Until Element Is Visible    ${BTN_ADD_TO_CART_DETAIL}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${BTN_ADD_TO_CART_DETAIL}

Click Back To Catalog
    [Documentation]    Click button to return to Home
    Wait Until Element Is Visible    ${BTN_BACK_TO_CATALOG}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${BTN_BACK_TO_CATALOG}

Verify Book Not Found
    [Documentation]    Verify book not found error screen
    Wait Until Element Is Visible    ${STATE_BOOK_NOT_FOUND}    timeout=${MEDIUM_TIMEOUT}
