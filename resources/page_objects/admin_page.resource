*** Settings ***
Documentation    Page Object cho Admin Dashboard (/admin).
...
...              TRÁCH NHIỆM:
...              - Điều hướng giữa các tab Admin
...              - CRUD sách và danh mục
...              - Xác nhận access control

Resource         ../locators/admin_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***
Navigate To Admin Dashboard
    Go To               ${URL_ADMIN}
    Wait Until Element Is Visible    ${ADMIN_TAB_MANAGEMENT}    timeout=${LONG_TIMEOUT}

Switch To Management Tab
    Click Element       ${ADMIN_TAB_MANAGEMENT}
    Wait Until Element Is Visible    ${ADMIN_INPUT_BOOK_TITLE}    timeout=${MEDIUM_TIMEOUT}

Switch To Inventory Tab
    Click Element       ${ADMIN_TAB_INVENTORY}
    Wait Until Page Contains Element    ${ADMIN_BTN_EDIT_BOOK}    timeout=${MEDIUM_TIMEOUT}

Switch To Orders Tab
    Click Element       ${ADMIN_TAB_ORDERS}
    Wait Until Page Contains Element    ${ADMIN_ORDERS_LIST}    timeout=${MEDIUM_TIMEOUT}

Switch To Users Tab
    Click Element       ${ADMIN_TAB_USERS}
    Wait Until Page Contains Element    ${ADMIN_USERS_LIST}    timeout=${MEDIUM_TIMEOUT}

Fill Add Book Form
    [Documentation]    Điền form thêm sách mới. Category là tùy chọn.
    [Arguments]         ${title}    ${author}    ${price}    ${stock}
    ...                 ${cover}=${EMPTY}    ${description}=${EMPTY}
    Switch To Management Tab
    Input Text          ${ADMIN_INPUT_BOOK_TITLE}        ${title}
    Input Text          ${ADMIN_INPUT_BOOK_AUTHOR}       ${author}
    Input Text          ${ADMIN_INPUT_BOOK_PRICE}        ${price}
    Input Text          ${ADMIN_INPUT_BOOK_STOCK}        ${stock}
    Run Keyword If      '${cover}' != '${EMPTY}'
    ...    Input Text   ${ADMIN_INPUT_BOOK_COVER}        ${cover}
    Run Keyword If      '${description}' != '${EMPTY}'
    ...    Input Text   ${ADMIN_INPUT_BOOK_DESCRIPTION}  ${description}

Submit Add Book Form
    Click Button        ${ADMIN_BTN_ADD_BOOK}

Delete Book By Title
    [Documentation]    Tìm sách trong Inventory tab và click Delete.
    [Arguments]         ${book_title}
    Switch To Inventory Tab
    ${row_xpath}=       Set Variable    xpath=//*[contains(normalize-space(),'${book_title}')]/ancestor::tr | //*[contains(normalize-space(),'${book_title}')]/ancestor::*[contains(@class,'flex')][1]
    ${delete_btn}=      Set Variable    ${row_xpath}//button[normalize-space()='Delete']
    Wait Until Element Is Visible    ${delete_btn}    timeout=${MEDIUM_TIMEOUT}
    Click Element       ${delete_btn}
    # Confirm nếu có dialog
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ADMIN_BTN_CONFIRM_DELETE}    timeout=2s
    Run Keyword And Ignore Error    Click Element    ${ADMIN_BTN_CONFIRM_DELETE}

Admin Dashboard Should Be Accessible
    [Documentation]    Xác nhận admin đang thấy dashboard đúng cách.
    Wait Until Element Is Visible    ${ADMIN_TAB_MANAGEMENT}    timeout=${MEDIUM_TIMEOUT}
    Location Should Be               ${URL_ADMIN}

Should Be Redirected Away From Admin
    [Documentation]    Non-admin bị redirect ra khỏi /admin.
    Location Should Not Be    ${URL_ADMIN}
    Element Should Not Be Visible    ${ADMIN_DASHBOARD_CONTAINER}

Orders List Should Not Be Empty
    Switch To Orders Tab
    Wait Until Page Contains Element    ${ADMIN_ORDERS_LIST}    timeout=${MEDIUM_TIMEOUT}
    Page Should Not Contain    No orders

Users List Should Not Be Empty
    Switch To Users Tab
    Wait Until Page Contains Element    ${ADMIN_USERS_LIST}    timeout=${MEDIUM_TIMEOUT}
