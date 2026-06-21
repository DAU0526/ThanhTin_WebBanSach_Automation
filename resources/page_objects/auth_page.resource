*** Settings ***
Documentation    Page Object for Auth pages (Login & Register).
...
...              DESIGN:
...              - Each keyword is an atomic action or a clear assertion.
...              - Test cases NEVER call SeleniumLibrary directly.
...              - All XPath/CSS selectors are centralized in auth_locators.resource.

Resource         ../locators/auth_locators.resource
Resource         ../locators/navbar_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***

Navigate To Login Page
    [Documentation]    Navigate to /login and wait for the form to appear.
    Wait Until Element Is Visible    ${NAV_LINK_LOGIN}    timeout=${MEDIUM_TIMEOUT}
    Click Element       ${NAV_LINK_LOGIN}
    Wait Until Element Is Visible    ${HEADING_LOGIN}    timeout=${MEDIUM_TIMEOUT}

Navigate To Register Page
    [Documentation]    Navigate to /register and wait for the form to appear.
    Go To               ${URL_REGISTER}
    Wait Until Element Is Visible    ${HEADING_REGISTER}    timeout=${MEDIUM_TIMEOUT}

Switch To Register Page Via Link
    [Documentation]    Click 'Register here' from the Login page.
    Click Element       ${LINK_SWITCH_TO_REGISTER}
    Wait Until Element Is Visible    ${HEADING_REGISTER}    timeout=${MEDIUM_TIMEOUT}

Switch To Login Page Via Link
    [Documentation]    Click 'Log in here' from the Register page.
    Click Element       ${LINK_SWITCH_TO_LOGIN}
    Wait Until Element Is Visible    ${HEADING_LOGIN}    timeout=${MEDIUM_TIMEOUT}


Fill Login Form
    [Documentation]    Fill username and password into the login form.
    [Arguments]         ${username}    ${password}
    Input Text          ${INPUT_USERNAME}    ${username}
    Input Text          ${INPUT_PASSWORD}    ${password}

Fill Login Username Only
    [Documentation]    Fill username, leave password empty.
    [Arguments]         ${username}
    Input Text          ${INPUT_USERNAME}    ${username}

Fill Register Form
    [Documentation]    Fill all 4 fields in the register form.
    [Arguments]         ${full_name}    ${username}    ${email}    ${password}
    Input Text          ${INPUT_FULL_NAME}    ${full_name}
    Input Text          ${INPUT_USERNAME}     ${username}
    Input Text          ${INPUT_EMAIL}        ${email}
    Input Text          ${INPUT_PASSWORD}     ${password}

Fill Register Form Without Email
    [Documentation]    Fill register form, skip email (optional field).
    [Arguments]         ${full_name}    ${username}    ${password}
    Input Text          ${INPUT_FULL_NAME}    ${full_name}
    Input Text          ${INPUT_USERNAME}     ${username}
    Input Text          ${INPUT_PASSWORD}     ${password}


Submit Auth Form
    [Documentation]    Click the submit button (shared for Login & Register).
    Click Button        ${BTN_SUBMIT}

Toggle Password Visibility
    [Documentation]    Click the eye icon to show/hide password.
    Click Element       ${BTN_TOGGLE_PASSWORD}


Login With Credentials
    [Documentation]    Fill form and submit — shorthand for login.
    [Arguments]         ${username}    ${password}
    Fill Login Form     ${username}    ${password}
    Submit Auth Form

Register With Full Data
    [Documentation]    Fill form completely and submit — shorthand for register.
    [Arguments]         ${full_name}    ${username}    ${email}    ${password}
    Fill Register Form  ${full_name}    ${username}    ${email}    ${password}
    Submit Auth Form

Register Without Email
    [Documentation]    Fill form completely except email and submit.
    [Arguments]         ${full_name}    ${username}    ${password}
    Fill Register Form Without Email    ${full_name}    ${username}    ${password}
    Submit Auth Form




Login Page Should Be Open
    [Documentation]    Verify we are on /login with the correct form.
    Location Should Be                   ${URL_LOGIN}
    Element Should Be Visible            ${HEADING_LOGIN}

Register Page Should Be Open
    [Documentation]    Verify we are on /register with the correct form.
    Location Should Be                   ${URL_REGISTER}
    Element Should Be Visible            ${HEADING_REGISTER}

Should Be On Home Page
    [Documentation]    Verify we are on the home page (after successful auth).
    Wait Until Location Is    ${URL_HOME}    timeout=${MEDIUM_TIMEOUT}


Error Message Should Be Visible
    [Documentation]    Server error message is visible on the page.
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${SHORT_TIMEOUT}

Error Message Should Contain
    [Documentation]    Error message must contain the expected text.
    [Arguments]         ${expected_text}
    Error Message Should Be Visible
    Element Should Contain    ${ERROR_MESSAGE}    ${expected_text}

Error Message Should Not Be Visible
    [Documentation]    No error message should be visible.
    Element Should Not Be Visible    ${ERROR_MESSAGE}


Password Field Type Should Be Password
    [Documentation]    Verify the password field is hidden.
    ${type}=    Get Element Attribute    ${INPUT_PASSWORD}    type
    Should Be Equal    ${type}    password

Password Field Type Should Be Text
    [Documentation]    Verify the password field is visible (after toggle).
    ${type}=    Get Element Attribute    ${INPUT_PASSWORD}    type
    Should Be Equal    ${type}    text

