*** Settings ***
Documentation    Admin Books CRUD Test Suite
...              Verifies the Admin workflow for managing books.
Resource         ../../resources/page_objects/admin_page.resource
Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close All Browsers
Test Setup       Reset Test State

*** Variables ***
${ADMIN_USER}       admin
${ADMIN_PASS}       admin123

${CUSTOMER_USER}    qa_testuser
${CUSTOMER_PASS}    Test@12345

${TEST_BOOK_TITLE}    Auto Test Book
${TEST_BOOK_AUTHOR}   Auto Author
${TEST_BOOK_PRICE}    150000
${TEST_BOOK_STOCK}    10

${UPDATED_TITLE}      Auto Test Book Updated

*** Keywords ***
Login As Admin And Go To Dashboard
    [Documentation]    Helper: Log in with admin credentials and navigate to the dashboard.
    Go To    ${URL_LOGIN}
    Login With Credentials    ${ADMIN_USER}    ${ADMIN_PASS}
    Wait Until Location Is    ${URL_HOME}    timeout=${MEDIUM_TIMEOUT}
    Go To    ${BASE_URL}/admin
    Wait Until Element Is Visible    ${TAB_MANAGEMENT}    timeout=${MEDIUM_TIMEOUT}

Go To Home Page And Refresh
    [Documentation]    Reset trạng thái sau mỗi test.
    Go To    ${URL_HOME}

Ensure Logged Out
    [Documentation]    Remove token from localStorage to ensure a logged-out state.
    Execute Javascript    localStorage.removeItem('token');

Reset Test State
    [Documentation]    Reset state after each test.
    Ensure Logged Out
    Go To Home Page And Refresh

*** Test Cases ***
TC-ADM-01 Unauthorized Access
    [Documentation]    Customers cannot access the /admin page.
    [Tags]    admin    TC-ADM-01    negative
    # Register a new user (defaults to customer role)
    Go To    ${URL_REGISTER}
    Register With Full Data    Test Customer    test_cust_01    test_cust_01@test.com    Customer@123
    Wait Until Location Is    ${URL_HOME}    timeout=${MEDIUM_TIMEOUT}
    # The account is now logged in with customer privileges
    Go To    ${BASE_URL}/admin
    # App.tsx logic: if user role is not admin, redirect to Home (/)
    Wait Until Location Is    ${URL_HOME}    timeout=${MEDIUM_TIMEOUT}

TC-ADM-02 View Inventory
    [Documentation]    Admin can access the Inventory tab and view the list of books.
    [Tags]    admin    TC-ADM-02    smoke
    Login As Admin And Go To Dashboard
    Switch To Inventory Tab

TC-ADM-03 Create Book Successfully
    [Documentation]    Admin successfully creates a new book.
    [Tags]    admin    TC-ADM-03    smoke
    Login As Admin And Go To Dashboard
    Switch To Management Tab
    Fill Book Form    ${TEST_BOOK_TITLE}    ${TEST_BOOK_AUTHOR}    ${TEST_BOOK_PRICE}    ${TEST_BOOK_STOCK}
    Submit Book Form
    Verify Admin Success Message    Book added successfully.

TC-ADM-04 Create Book Missing Validation
    [Documentation]    Attempt to create a book with missing data (Title) -> HTML5 Validation should block it.
    [Tags]    admin    TC-ADM-04    negative
    Login As Admin And Go To Dashboard
    Switch To Management Tab
    Fill Book Form    ${EMPTY}    ${TEST_BOOK_AUTHOR}    ${TEST_BOOK_PRICE}    ${TEST_BOOK_STOCK}
    Submit Book Form
    # No success message because the browser blocks form submission (Title field is required)
    Run Keyword And Expect Error    *    Wait Until Element Is Visible    ${MSG_ADMIN_SUCCESS}    timeout=2s

TC-ADM-05 Update Book
    [Documentation]    Admin edits the recently created book.
    [Tags]    admin    TC-ADM-05    regression
    Login As Admin And Go To Dashboard
    Switch To Inventory Tab
    Click Edit Book    ${TEST_BOOK_TITLE}
    Switch To Management Tab
    # Switch back to Management tab and fill in new data
    Wait Until Element Is Visible    ${INPUT_BOOK_TITLE}    timeout=${MEDIUM_TIMEOUT}
    Clear Element Text    ${INPUT_BOOK_TITLE}
    Input Text            ${INPUT_BOOK_TITLE}    ${UPDATED_TITLE}
    Submit Book Form
    Verify Admin Success Message    Book updated successfully.

TC-ADM-06 Delete Book
    [Documentation]    Admin deletes a book.
    [Tags]    admin    TC-ADM-06    smoke
    Login As Admin And Go To Dashboard
    Switch To Inventory Tab
    Click Delete Book    ${UPDATED_TITLE}
    Verify Admin Success Message    Book deleted successfully.
