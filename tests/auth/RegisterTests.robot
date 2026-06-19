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


# ══════════════════════════════════════════════════════════════
# TC-REG-02: DUPLICATE USERNAME
# ══════════════════════════════════════════════════════════════
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

    # Phải ở lại trang register, không redirect
    Register Page Should Be Open
    Error Message Should Contain    Username already exists


# ══════════════════════════════════════════════════════════════
# TC-REG-03: DUPLICATE EMAIL
# ══════════════════════════════════════════════════════════════
TC-REG-03 Register With Existing Email Should Fail
    [Documentation]    Đăng ký với email "admin@tinybookstore.local" đã tồn tại.
    ...                Email này được seed cùng tài khoản admin khi DB khởi tạo.
    ...                Kết quả: server trả lỗi "Email already exists".
    [Tags]    auth    register    negative    TC-REG-03

    # Tạo username unique để chắc chắn lỗi đến từ email, không phải username
    ${username}=    Generate Unique Username

    Navigate To Register Page

    Fill Register Form
    ...    full_name=Duplicate Email Test
    ...    username=${username}
    ...    email=admin@tinybookstore.local
    ...    password=Test@12345

    Submit Auth Form

    # Phải ở lại trang register
    Register Page Should Be Open
    Error Message Should Contain    Email already exists


# ══════════════════════════════════════════════════════════════
# TC-REG-04: INVALID EMAIL FORMAT
# ══════════════════════════════════════════════════════════════
TC-REG-04 Register With Invalid Email Format Should Be Blocked
    [Documentation]    Điền email không đúng format (thiếu "@").
    ...                Browser chặn submit vì input type="email" — HTML5 validation.
    ...                Kết quả: form không được gửi, vẫn ở trang register.
    [Tags]    auth    register    negative    validation    TC-REG-04

    Navigate To Register Page

    # Điền form với email không hợp lệ
    Fill Register Form
    ...    full_name=Invalid Email User
    ...    username=qa_invalidemail
    ...    email=notvalidemail
    ...    password=Test@12345

    # Click submit — browser sẽ chặn do type="email" validation
    Submit Auth Form

    # Vẫn ở trang register, không có server error (form không submit)
    Register Page Should Be Open
    Error Message Should Not Be Visible


# ══════════════════════════════════════════════════════════════
# TC-REG-05: EMPTY REQUIRED FIELDS
# ══════════════════════════════════════════════════════════════
TC-REG-05 Register With Empty Required Fields Should Be Blocked
    [Documentation]    Submit form register hoàn toàn trống.
    ...                username và password có thuộc tính "required".
    ...                Browser chặn submit — HTML5 required validation.
    ...                Kết quả: form không gửi, vẫn ở trang register.
    [Tags]    auth    register    negative    validation    TC-REG-05

    Navigate To Register Page

    # Không điền gì, click thẳng submit
    Submit Auth Form

    # Form bị giữ lại do required validation
    Register Page Should Be Open
    Error Message Should Not Be Visible
