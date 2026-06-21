*** Settings ***
Documentation    Register Test Suite — Tiny Bookstore
...
...              Covers:
...              - TC-REG-01 Register Success
...              - TC-REG-02 Duplicate Username
...              - TC-REG-03 Duplicate Email
...              - TC-REG-04 Invalid Email Format
...              - TC-REG-05 Empty Required Fields

Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/page_objects/navbar_page.resource
Resource         ../../resources/browser_keywords.resource
Resource         ../../resources/common_keywords.resource

Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close Browser Session

Test Setup       Clear Browser Session Data
Test Teardown    Test Teardown With Screenshot


*** Test Cases ***

TC-REG-01 Register With Valid Data Should Succeed
    [Documentation]    Register with valid data
    [Tags]    auth    register    smoke

    ${username}=    Generate Unique Username
    ${email}=       Generate Unique Email

    Navigate To Register Page

    Register With Full Data
    ...    full_name=QA Automation User
    ...    username=${username}
    ...    email=${email}
    ...    password=Test@12345

    Should Be On Home Page
    Navbar Should Show Authenticated State
    Error Message Should Not Be Visible


TC-REG-02 Register With Existing Username Should Fail
    [Documentation]    Register with existing username "admin" in DB.
    ...                Result: server returns "Username already exists" error.
    [Tags]    auth    register    negative    TC-REG-02

    Navigate To Register Page

    Register With Full Data
    ...    full_name=Duplicate Test
    ...    username=admin
    ...    email=duplicate_username_test@test.local
    ...    password=Test@12345

    Register Page Should Be Open
    Error Message Should Contain    Username already exists


TC-REG-03 Register With Existing Email Should Fail
    [Documentation]    Register with existing email "admin@tinybookstore.local".
    ...                This email is seeded along with the admin account during DB initialization.
    ...                Result: server returns "Email already exists" error.
    [Tags]    auth    register    negative    TC-REG-03

    ${username}=    Generate Unique Username

    Navigate To Register Page

    Register With Full Data
    ...    full_name=Duplicate Email Test
    ...    username=${username}
    ...    email=admin@tinybookstore.local
    ...    password=Test@12345

    Register Page Should Be Open
    Error Message Should Contain    Email already exists


TC-REG-04 Register With Invalid Email Format Should Be Blocked
    [Documentation]    Fill invalid email format (missing "@").
    ...                Browser blocks submit because input type="email" — HTML5 validation.
    ...                Result: form not submitted, stays at register page.
    [Tags]    auth    register    negative    validation    TC-REG-04

    Navigate To Register Page

    Register With Full Data
    ...    full_name=Invalid Email User
    ...    username=qa_invalidemail
    ...    email=notvalidemail
    ...    password=Test@12345

    Register Page Should Be Open
    Error Message Should Not Be Visible


TC-REG-05 Register With Empty Required Fields Should Be Blocked
    [Documentation]    Submit completely empty register form.
    ...                username and password have "required" attribute.
    ...                Browser blocks submit — HTML5 required validation.
    ...                Result: form not submitted, stays at register page.
    [Tags]    auth    register    negative    validation    TC-REG-05

    Navigate To Register Page

    Submit Auth Form

    Register Page Should Be Open
    Error Message Should Not Be Visible


TC-REG-06 Register Without Email Should Succeed
    [Documentation]    Register successfully when leaving email blank (optional field).
    [Tags]    auth    register    TC-REG-06

    ${username}=    Generate Unique Username

    Navigate To Register Page

    Fill Register Form Without Email
    ...    full_name=No Email User
    ...    username=${username}
    ...    password=Test@12345

    Submit Auth Form

    Should Be On Home Page
    Navbar Should Show Authenticated State
    Error Message Should Not Be Visible
