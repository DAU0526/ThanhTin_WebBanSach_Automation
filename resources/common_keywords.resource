*** Settings ***
Documentation    Common Keywords — reusable business-level actions.
...
...              ROLE:
...              - Provide high-level keywords for test cases
...              - Combine multiple small steps from page objects into a complete workflow
...              - Shared Suite Setup / Suite Teardown
...
...              Example:
...              "Login As Admin" = Navigate To Login + Fill Form + Submit + Assert

Resource         browser_keywords.resource
Resource         variables/global_variables.resource
Resource         page_objects/auth_page.resource
Resource         page_objects/navbar_page.resource
Resource         page_objects/home_page.resource
Library          SeleniumLibrary


*** Keywords ***

Suite Setup With Browser
    [Documentation]    Open browser and navigate to home page.
    ...                Used as Suite Setup for the entire test suite.
    Open Browser With Config    ${BASE_URL}
    Wait For Loading Spinner To Disappear

Suite Teardown With Browser
    [Documentation]    Capture screenshot if needed and close browser.
    ...                Used as Suite Teardown.
    Close Browser Session

Test Teardown With Screenshot
    [Documentation]    Capture screenshot if test fails, then clear state.
    Run Keyword If Test Failed    Take Screenshot On Failure
    Clear Browser Session Data


Login As Admin
    [Documentation]    Login with standard admin account.
    ...                After calling this keyword, navbar must show Admin link.
    Navigate To Login Page
    Fill Login Form                 ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Submit Auth Form
    Navbar Should Show Admin Link

Login As Test User
    [Documentation]    Login with test user (qa_testuser).
    ...                Test user must exist before calling this keyword.
    Navigate To Login Page
    Fill Login Form                 ${TEST_USERNAME}    ${TEST_PASSWORD}
    Submit Auth Form
    Navbar Should Show Authenticated State

Login As
    [Documentation]    Login with any username/password.
    [Arguments]         ${username}    ${password}
    Navigate To Login Page
    Fill Login Form                 ${username}    ${password}
    Submit Auth Form

Logout Current User
    [Documentation]    Click Logout and verify guest state.
    Navbar Should Show Authenticated State
    Click Logout Button
    Navbar Should Show Guest State

Ensure Logged Out
    [Documentation]    Ensure no user is logged in (clear token).
    Clear Local Storage
    Reload Page
    Wait For Loading Spinner To Disappear

Ensure Logged In As Admin
    [Documentation]    If not logged in, automatically login as admin.
    ${is_logged_in}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${NAV_BTN_LOGOUT}    timeout=3s
    Run Keyword Unless    ${is_logged_in}    Login As Admin


Add Book To Cart By Title
    [Documentation]    Search for book on Home page and add to cart.
    ...                Automatically switch to "All Books" tab if needed.
    [Arguments]         ${book_title}
    Navigate To Home Page
    Switch To All Books Tab
    Search For Book              ${book_title}
    Click Add To Cart For Book   ${book_title}

Clear Cart
    [Documentation]    Clear all items in cart by clearing localStorage.
    Execute Javascript    window.localStorage.removeItem('cart')
    Reload Page


Generate Unique Username
    [Documentation]    Generate unique username based on timestamp.
    ...                Used for new user registration test.
    ${timestamp}=       Evaluate    __import__('datetime').datetime.now().strftime('%H%M%S%f')
    RETURN              qa_user_${timestamp}

Generate Unique Email
    [Documentation]    Generate random email based on timestamp.
    [Arguments]         ${prefix}=test
    ${timestamp}=       Evaluate    __import__('datetime').datetime.now().strftime('%H%M%S%f')
    RETURN              ${prefix}_${timestamp}@test.local

Page Should Show Error
    [Documentation]    Generic assertion: page must show some error message.
    [Arguments]         ${error_text}
    Wait Until Page Contains    ${error_text}    timeout=${MEDIUM_TIMEOUT}

Navigate To Profile Page
    [Documentation]    Navigate to the Profile page using the navbar.
    Wait Until Element Is Visible    ${NAV_LINK_PROFILE}    timeout=${MEDIUM_TIMEOUT}
    Click Element    ${NAV_LINK_PROFILE}
    Wait Until Location Is    ${URL_PROFILE}    timeout=${MEDIUM_TIMEOUT}

Profile Purchase History Should Be Visible
    [Documentation]    Wait for the purchase history section to load.
    Wait Until Element Is Visible    xpath=//h2[.='Purchase history']    timeout=${LONG_TIMEOUT}
