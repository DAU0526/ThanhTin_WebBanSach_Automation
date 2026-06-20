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
Library          SeleniumLibrary

Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close Browser Session

Test Setup       Clear Browser Session Data
Test Teardown    Run Keyword If Test Failed    Take Screenshot On Failure


*** Test Cases ***

TC-REG-01 Register With Valid Data Should Succeed
    [Documentation]    Đăng ký với dữ liệu hợp lệ
    [Tags]    auth    register    smoke

    ${username}=    Generate Unique Username
    ${email}=       Generate Unique Email

    Navigate To Register Page

    Fill Register Form
    ...    full_name=QA Automation User
    ...    username=${username}
    ...    email=${email}
    ...    password=Test@12345

    Submit Auth Form

    Should Be On Home Page
    Navbar Should Show Authenticated State
    Error Message Should Not Be Visible


TC-REG-02 Register With Existing Username Should Fail
    [Documentation]    Đăng ký với username "admin" đã tồn tại trong DB.
    ...                Kết quả: server trả lỗi "Username already exists".
    [Tags]    auth    register    negative    TC-REG-02

    Navigate To Register Page

    Fill Register Form
    ...    full_name=Duplicate Test
    ...    username=admin
    ...    email=duplicate_username_test@test.local
    ...    password=Test@12345

    Submit Auth Form

    Register Page Should Be Open
    Error Message Should Contain    Username already exists


TC-REG-03 Register With Existing Email Should Fail
    [Documentation]    Đăng ký với email "admin@tinybookstore.local" đã tồn tại.
    ...                Email này được seed cùng tài khoản admin khi DB khởi tạo.
    ...                Kết quả: server trả lỗi "Email already exists".
    [Tags]    auth    register    negative    TC-REG-03

    ${username}=    Generate Unique Username

    Navigate To Register Page

    Fill Register Form
    ...    full_name=Duplicate Email Test
    ...    username=${username}
    ...    email=admin@tinybookstore.local
    ...    password=Test@12345

    Submit Auth Form

    Register Page Should Be Open
    Error Message Should Contain    Email already exists


TC-REG-04 Register With Invalid Email Format Should Be Blocked
    [Documentation]    Điền email không đúng format (thiếu "@").
    ...                Browser chặn submit vì input type="email" — HTML5 validation.
    ...                Kết quả: form không được gửi, vẫn ở trang register.
    [Tags]    auth    register    negative    validation    TC-REG-04

    Navigate To Register Page

    Fill Register Form
    ...    full_name=Invalid Email User
    ...    username=qa_invalidemail
    ...    email=notvalidemail
    ...    password=Test@12345

    Submit Auth Form

    Register Page Should Be Open
    Error Message Should Not Be Visible


TC-REG-05 Register With Empty Required Fields Should Be Blocked
    [Documentation]    Submit form register hoàn toàn trống.
    ...                username và password có thuộc tính "required".
    ...                Browser chặn submit — HTML5 required validation.
    ...                Kết quả: form không gửi, vẫn ở trang register.
    [Tags]    auth    register    negative    validation    TC-REG-05

    Navigate To Register Page

    Submit Auth Form

    Register Page Should Be Open
    Error Message Should Not Be Visible


TC-REG-06 Register Without Email Should Succeed
    [Documentation]    Đăng ký thành công khi bỏ trống email (optional field).
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
