*** Settings ***
Documentation    Common Keywords — business-level actions tái sử dụng.
...
...              VAI TRÒ:
...              - Cung cấp high-level keyword cho test cases
...              - Ghép nhiều bước nhỏ từ page objects thành workflow hoàn chỉnh
...              - Suite Setup / Suite Teardown chung
...
...              Ví dụ:
...              "Login As Admin" = Navigate To Login + Fill Form + Submit + Assert

Resource         browser_keywords.resource
Resource         variables/global_variables.resource
Resource         page_objects/auth_page.resource
Resource         page_objects/navbar_page.resource
Resource         page_objects/home_page.resource
Library          SeleniumLibrary


*** Keywords ***

Suite Setup With Browser
    [Documentation]    Mở browser và điều hướng tới trang chủ.
    ...                Dùng làm Suite Setup cho toàn bộ test suite.
    Open Browser With Config    ${BASE_URL}
    Wait For Loading Spinner To Disappear

Suite Teardown With Browser
    [Documentation]    Chụp screenshot nếu cần và đóng browser.
    ...                Dùng làm Suite Teardown.
    Close Browser Session

Test Teardown With Screenshot
    [Documentation]    Chụp screenshot nếu test fail, sau đó xóa state.
    Run Keyword If Test Failed    Take Screenshot On Failure
    Clear Browser Session Data


Login As Admin
    [Documentation]    Login với tài khoản admin chuẩn.
    ...                Sau khi gọi keyword này, navbar phải hiện Admin link.
    Navigate To Login Page
    Fill Login Form                 ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Submit Auth Form
    Navbar Should Show Admin Link

Login As Test User
    [Documentation]    Login với test user (qa_testuser).
    ...                Test user phải tồn tại trước khi gọi keyword này.
    Navigate To Login Page
    Fill Login Form                 ${TEST_USERNAME}    ${TEST_PASSWORD}
    Submit Auth Form
    Navbar Should Show Authenticated State

Login As
    [Documentation]    Login với bất kỳ username/password nào.
    [Arguments]         ${username}    ${password}
    Navigate To Login Page
    Fill Login Form                 ${username}    ${password}
    Submit Auth Form

Logout Current User
    [Documentation]    Click Logout và xác nhận trạng thái guest.
    Navbar Should Show Authenticated State
    Click Logout Button
    Navbar Should Show Guest State

Ensure Logged Out
    [Documentation]    Đảm bảo không có user nào đang login (xóa token).
    Clear Local Storage
    Reload Page
    Wait For Loading Spinner To Disappear

Ensure Logged In As Admin
    [Documentation]    Nếu chưa login, tự động login admin.
    ${is_logged_in}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${NAV_BTN_LOGOUT}    timeout=3s
    Run Keyword Unless    ${is_logged_in}    Login As Admin


Add Book To Cart By Title
    [Documentation]    Tìm sách trên Home page và thêm vào cart.
    ...                Tự động switch sang "All Books" tab nếu cần.
    [Arguments]         ${book_title}
    Navigate To Home Page
    Switch To All Books Tab
    Search For Book              ${book_title}
    Click Add To Cart For Book   ${book_title}

Clear Cart
    [Documentation]    Xóa toàn bộ item trong cart bằng cách clear localStorage.
    Execute Javascript    window.localStorage.removeItem('cart')
    Reload Page


Generate Unique Username
    [Documentation]    Tạo username unique dựa trên timestamp.
    ...                Dùng cho test đăng ký user mới.
    ${timestamp}=       Evaluate    __import__('datetime').datetime.now().strftime('%H%M%S%f')
    RETURN              qa_user_${timestamp}

Generate Unique Email
    [Documentation]    Tạo email unique dựa trên timestamp.
    [Arguments]         ${prefix}=qatest
    ${timestamp}=       Evaluate    __import__('datetime').datetime.now().strftime('%H%M%S%f')
    RETURN              ${prefix}_${timestamp}@test.local

Page Should Show Error
    [Documentation]    Generic assertion: page phải hiện thông báo lỗi nào đó.
    [Arguments]         ${error_text}
    Wait Until Page Contains    ${error_text}    timeout=${MEDIUM_TIMEOUT}
