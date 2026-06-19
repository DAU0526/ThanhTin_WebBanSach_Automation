*** Settings ***
Documentation    Page Object cho Auth pages (Login & Register).
...
...              THIẾT KẾ:
...              - Mỗi keyword là một hành động nguyên tử hoặc assertion rõ ràng.
...              - Test case KHÔNG bao giờ gọi SeleniumLibrary trực tiếp.
...              - Toàn bộ XPath/CSS tập trung tại auth_locators.resource.

Resource         ../locators/auth_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***
# ══════════════════════════════════════════════════════════════
# NAVIGATION
# ══════════════════════════════════════════════════════════════

Navigate To Login Page
    [Documentation]    Đi đến /login và đợi form xuất hiện.
    Go To               ${URL_LOGIN}
    Wait Until Element Is Visible    ${HEADING_LOGIN}    timeout=${MEDIUM_TIMEOUT}

Navigate To Register Page
    [Documentation]    Đi đến /register và đợi form xuất hiện.
    Go To               ${URL_REGISTER}
    Wait Until Element Is Visible    ${HEADING_REGISTER}    timeout=${MEDIUM_TIMEOUT}

Switch To Register Page Via Link
    [Documentation]    Click "Register here" từ trang Login.
    Click Element       ${LINK_SWITCH_TO_REGISTER}
    Wait Until Element Is Visible    ${HEADING_REGISTER}    timeout=${MEDIUM_TIMEOUT}

Switch To Login Page Via Link
    [Documentation]    Click "Log in here" từ trang Register.
    Click Element       ${LINK_SWITCH_TO_LOGIN}
    Wait Until Element Is Visible    ${HEADING_LOGIN}    timeout=${MEDIUM_TIMEOUT}

# ══════════════════════════════════════════════════════════════
# FORM ACTIONS — FILL
# ══════════════════════════════════════════════════════════════

Fill Login Form
    [Documentation]    Điền username + password vào form login.
    [Arguments]         ${username}    ${password}
    Input Text          ${INPUT_USERNAME}    ${username}
    Input Text          ${INPUT_PASSWORD}    ${password}

Fill Login Username Only
    [Documentation]    Điền username, để trống password.
    [Arguments]         ${username}
    Input Text          ${INPUT_USERNAME}    ${username}

Fill Register Form
    [Documentation]    Điền đầy đủ 4 trường form register.
    [Arguments]         ${full_name}    ${username}    ${email}    ${password}
    Input Text          ${INPUT_FULL_NAME}    ${full_name}
    Input Text          ${INPUT_USERNAME}     ${username}
    Input Text          ${INPUT_EMAIL}        ${email}
    Input Text          ${INPUT_PASSWORD}     ${password}

Fill Register Form Without Email
    [Documentation]    Điền form register, bỏ qua email (optional field).
    [Arguments]         ${full_name}    ${username}    ${password}
    Input Text          ${INPUT_FULL_NAME}    ${full_name}
    Input Text          ${INPUT_USERNAME}     ${username}
    Input Text          ${INPUT_PASSWORD}     ${password}

# ══════════════════════════════════════════════════════════════
# FORM ACTIONS — SUBMIT
# ══════════════════════════════════════════════════════════════

Submit Auth Form
    [Documentation]    Click nút submit (dùng chung cho cả Login & Register).
    Click Button        ${BTN_SUBMIT}

Toggle Password Visibility
    [Documentation]    Click icon mắt để show/hide password.
    Click Element       ${BTN_TOGGLE_PASSWORD}

# ══════════════════════════════════════════════════════════════
# COMPOSED ACTIONS (thường dùng trong test)
# ══════════════════════════════════════════════════════════════

Login With Credentials
    [Documentation]    Điền form và submit — shorthand cho login.
    [Arguments]         ${username}    ${password}
    Fill Login Form     ${username}    ${password}
    Submit Auth Form

Register With Full Data
    [Documentation]    Điền form đầy đủ và submit — shorthand cho register.
    [Arguments]         ${full_name}    ${username}    ${email}    ${password}
    Fill Register Form  ${full_name}    ${username}    ${email}    ${password}
    Submit Auth Form



# ══════════════════════════════════════════════════════════════
# ASSERTIONS — PAGE STATE
# ══════════════════════════════════════════════════════════════

Login Page Should Be Open
    [Documentation]    Xác nhận đang ở /login với form đúng.
    Location Should Be                   ${URL_LOGIN}
    Element Should Be Visible            ${HEADING_LOGIN}

Register Page Should Be Open
    [Documentation]    Xác nhận đang ở /register với form đúng.
    Location Should Be                   ${URL_REGISTER}
    Element Should Be Visible            ${HEADING_REGISTER}

Should Be On Home Page
    [Documentation]    Xác nhận đang ở trang chủ (sau khi auth thành công).
    Wait Until Location Is    ${URL_HOME}    timeout=${MEDIUM_TIMEOUT}

# ══════════════════════════════════════════════════════════════
# ASSERTIONS — ERROR MESSAGE
# ══════════════════════════════════════════════════════════════

Error Message Should Be Visible
    [Documentation]    Có thông báo lỗi từ server trên trang.
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${SHORT_TIMEOUT}

Error Message Should Contain
    [Documentation]    Nội dung thông báo lỗi phải chứa text mong đợi.
    [Arguments]         ${expected_text}
    Error Message Should Be Visible
    Element Should Contain    ${ERROR_MESSAGE}    ${expected_text}

Error Message Should Not Be Visible
    [Documentation]    Không có thông báo lỗi nào xuất hiện.
    Element Should Not Be Visible    ${ERROR_MESSAGE}

# ══════════════════════════════════════════════════════════════
# ASSERTIONS — FORM INPUT STATE
# ══════════════════════════════════════════════════════════════

Password Field Type Should Be Password
    [Documentation]    Xác nhận ô password đang ở chế độ ẩn.
    ${type}=    Get Element Attribute    ${INPUT_PASSWORD}    type
    Should Be Equal    ${type}    password

Password Field Type Should Be Text
    [Documentation]    Xác nhận ô password đang ở chế độ hiện (sau khi toggle).
    ${type}=    Get Element Attribute    ${INPUT_PASSWORD}    type
    Should Be Equal    ${type}    text

