*** Settings ***
Documentation    Admin Books CRUD Test Suite
...              Verifies the Admin workflow for managing books.
Resource         ../../resources/page_objects/admin_page.resource
Resource         ../../resources/page_objects/auth_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close Browser Session
Test Setup       Reset Admin Test State
Test Teardown    Test Teardown With Screenshot

*** Variables ***
${TEST_BOOK_TITLE}    Auto Test Book
${TEST_BOOK_AUTHOR}   Auto Author
${TEST_BOOK_PRICE}    150000
${TEST_BOOK_STOCK}    10

${UPDATED_TITLE}      Auto Test Book Updated

*** Keywords ***
Login As Admin And Go To Dashboard
    [Documentation]    Log in with admin credentials and navigate to the admin dashboard.
    Login As Admin
    Navigate To Admin Dashboard

Navigate To Admin Dashboard
    [Documentation]    Navigate to the /admin page and wait for it to load.
    Go To    ${URL_ADMIN}
    Wait Until Element Is Visible    ${TAB_MANAGEMENT}    timeout=${MEDIUM_TIMEOUT}

Reset Admin Test State
    [Documentation]    Reset state: ensure logged out and go to home.
    Ensure Logged Out

*** Test Cases ***
TC-ADM-01 Unauthorized Access
    [Documentation]    Customers cannot access the /admin page.
    ...                Non-admin users are redirected back to Home.
    [Tags]    admin    TC-ADM-01    negative
    ${username}=    Generate Unique Username
    ${email}=       Generate Unique Email
    Navigate To Register Page
    Register With Full Data    Test Customer    ${username}    ${email}    Customer@123
    Should Be On Home Page
    Try To Access Admin Dashboard
    # App.tsx logic: if user role is not admin, redirect to Home (/)
    Should Be On Home Page

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
    Fill Book Form    ${UPDATED_TITLE}    ${TEST_BOOK_AUTHOR}    ${TEST_BOOK_PRICE}    ${TEST_BOOK_STOCK}
    Submit Book Form
    Verify Admin Success Message    Book updated successfully.

TC-ADM-06 Delete Book
    [Documentation]    Admin deletes a book.
    [Tags]    admin    TC-ADM-06    smoke
    Login As Admin And Go To Dashboard
    Switch To Inventory Tab
    Click Delete Book    ${UPDATED_TITLE}
    Verify Admin Success Message    Book deleted successfully.
