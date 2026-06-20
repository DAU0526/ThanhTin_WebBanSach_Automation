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
...              Tất cả test dùng tài khoản "admin / admin123":
...              - Được seed tự động khi server khởi động (server.ts:setupDatabase)
...              - Không bao giờ bị xóa hoặc thay đổi password trong test
...
...              Setup: Mở browser một lần cho cả suite.
...              Teardown: Mỗi test xóa session (localStorage + cookies).

Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/page_objects/navbar_page.resource
Resource         ../../resources/browser_keywords.resource
Library          SeleniumLibrary

Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close Browser Session

Test Setup       Clear Browser Session Data
Test Teardown    Run Keyword If Test Failed    Take Screenshot On Failure


*** Test Cases ***

TC-LGN-01 Login With Valid Admin Credentials Should Succeed
    [Documentation]    Login với admin/admin123 (tài khoản seeded mặc định).
    ...                Kết quả:
    ...                - Redirect về trang chủ "/"
    ...                - Navbar hiện nút Logout
    ...                - Navbar hiện link "Admin" (vì role=admin)
    ...                - Không có thông báo lỗi
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
    [Documentation]    Login với username đúng nhưng password sai.
    ...                Kết quả:
    ...                - Không redirect, vẫn ở /login
    ...                - Hiện lỗi "Invalid credentials"
    ...                - Không có token trong localStorage
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
    [Documentation]    Login với username không tồn tại trong hệ thống.
    ...                Kết quả:
    ...                - Không redirect, vẫn ở /login
    ...                - Hiện lỗi "Invalid credentials"
    ...                - Server không tiết lộ user tồn tại hay không
    [Tags]    auth    login    negative    TC-LGN-03

    Navigate To Login Page

    Login With Credentials
    ...    username=user_does_not_exist_xyz999
    ...    password=anypassword123

    Login Page Should Be Open
    Error Message Should Contain    Invalid credentials
    Navbar Should Show Guest State


TC-LGN-04 Login With Empty Username And Password Should Be Blocked
    [Documentation]    Submit form login hoàn toàn trống.
    ...                username và password đều có thuộc tính "required".
    ...                Browser chặn submit — HTML5 required validation.
    ...                Kết quả: form không gửi, không có server error.
    [Tags]    auth    login    negative    validation    TC-LGN-04

    Navigate To Login Page

    Submit Auth Form

    Login Page Should Be Open
    Error Message Should Not Be Visible
    Navbar Should Show Guest State


TC-LGN-04B Login With Empty Password Only Should Be Blocked
    [Documentation]    Điền username nhưng để trống password (required).
    ...                Kết quả: browser chặn, vẫn ở /login.
    [Tags]    auth    login    negative    validation    TC-LGN-04

    Navigate To Login Page

    Fill Login Username Only    ${ADMIN_USERNAME}
    Submit Auth Form

    Login Page Should Be Open
    Error Message Should Not Be Visible


TC-LGN-05 Logout Should Clear Session And Return To Guest State
    [Documentation]    Login thành công rồi click Logout.
    ...                Kết quả:
    ...                - Navbar trở về trạng thái guest (hiện "Log in")
    ...                - Link "Admin" biến mất khỏi navbar
    ...                - Token bị xóa khỏi localStorage
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

    Go To               ${URL_PROFILE}
    Wait Until Element Is Visible    ${HEADING_LOGIN}    timeout=${MEDIUM_TIMEOUT}
    Location Should Contain    /login


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
