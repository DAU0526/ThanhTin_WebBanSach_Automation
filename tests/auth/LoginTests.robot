*** Settings ***
Documentation    Login & Logout Test Suite — Tiny Bookstore
...
...              Covers:
...              - TC-LGN-01 Login Success (admin)
...              - TC-LGN-02 Login With Wrong Password
...              - TC-LGN-03 Login With Wrong Username
...              - TC-LGN-04 Login With Empty Fields
...              - TC-LGN-05 Logout
...
...              All tests use the default seeded account:
...              - Auto-seeded when server starts (server.ts:setupDatabase)
...              - Never deleted or password-changed during tests
...
...              Setup: Open browser once for the suite.
...              Teardown: Each test clears session (localStorage + cookies).

Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/page_objects/navbar_page.resource
Resource         ../../resources/browser_keywords.resource
Resource         ../../resources/common_keywords.resource

Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close Browser Session

Test Setup       Clear Browser Session Data
Test Teardown    Test Teardown With Screenshot


*** Test Cases ***

TC-LGN-01 Login With Valid Admin Credentials Should Succeed
    [Documentation]    Login with admin/admin123 (default seeded account).
    ...                Result:
    ...                - Redirect to home page "/"
    ...                - Navbar shows Logout button
    ...                - Navbar shows "Admin" link (role=admin)
    ...                - No error message
    [Tags]    auth    login    smoke    TC-LGN-01

    Navigate To Login Page

    Login With Credentials
    ...    username=${ADMIN_USERNAME}
    ...    password=${ADMIN_PASSWORD}

    Should Be On Home Page
    Navbar Should Show Authenticated State
    Navbar Should Show Admin Link
    Error Message Should Not Be Visible


TC-LGN-02 Login With Wrong Password Should Fail
    [Documentation]    Login with correct username but wrong password.
    ...                Result:
    ...                - No redirect, stay at /login
    ...                - Show "Invalid credentials" error
    ...                - No token in localStorage
    [Tags]    auth    login    negative    TC-LGN-02

    Navigate To Login Page

    Login With Credentials
    ...    username=${ADMIN_USERNAME}
    ...    password=wrong_password_xyz

    Login Page Should Be Open
    Error Message Should Contain    Invalid credentials
    Navbar Should Show Guest State

    ${token}=    Get Local Storage Item    token
    Should Be Equal    ${token}    ${None}


TC-LGN-03 Login With Non-Existent Username Should Fail
    [Documentation]    Login with non-existent username in the system.
    ...                Result:
    ...                - No redirect, stay at /login
    ...                - Show "Invalid credentials" error
    ...                - Server does not reveal if user exists
    [Tags]    auth    login    negative    TC-LGN-03

    Navigate To Login Page

    Login With Credentials
    ...    username=user_does_not_exist_xyz999
    ...    password=anypassword123

    Login Page Should Be Open
    Error Message Should Contain    Invalid credentials
    Navbar Should Show Guest State


TC-LGN-04 Login With Empty Username And Password Should Be Blocked
    [Documentation]    Submit completely empty login form.
    ...                username and password have "required" attribute.
    ...                Browser blocks submit — HTML5 required validation.
    ...                Result: form not submitted, no server error.
    [Tags]    auth    login    negative    validation    TC-LGN-04

    Navigate To Login Page

    Submit Auth Form

    Login Page Should Be Open
    Error Message Should Not Be Visible
    Navbar Should Show Guest State


TC-LGN-04B Login With Empty Password Only Should Be Blocked
    [Documentation]    Fill username but leave password empty (required).
    ...                Result: browser blocks, stay at /login.
    [Tags]    auth    login    negative    validation    TC-LGN-04

    Navigate To Login Page

    Fill Login Username Only    ${ADMIN_USERNAME}
    Submit Auth Form

    Login Page Should Be Open
    Error Message Should Not Be Visible


TC-LGN-05 Logout Should Clear Session And Return To Guest State
    [Documentation]    Login successfully then click Logout.
    ...                Result:
    ...                - Navbar returns to guest state (shows "Log in")
    ...                - "Admin" link disappears from navbar
    ...                - Token is removed from localStorage
    ...                - Truy cập /profile bị redirect về /login
    [Tags]    auth    logout    smoke    TC-LGN-05

    Navigate To Login Page

    Login With Credentials
    ...    username=${ADMIN_USERNAME}
    ...    password=${ADMIN_PASSWORD}

    Should Be On Home Page
    Navbar Should Show Authenticated State

    Click Logout Button

    Navbar Should Show Guest State
    Navbar Should Not Show Admin Link

    ${token}=    Get Local Storage Item    token
    Should Be Equal    ${token}    ${None}

    Go To    ${URL_PROFILE}
    Login Page Should Be Open


TC-LGN-06 Password Visibility Toggle Should Work
    [Documentation]    Toggle password visibility.
    [Tags]    auth    login    ui    TC-LGN-06

    Navigate To Login Page
    Fill Login Form    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}

    Password Field Type Should Be Password
    Toggle Password Visibility
    Password Field Type Should Be Text
    Toggle Password Visibility
    Password Field Type Should Be Password
