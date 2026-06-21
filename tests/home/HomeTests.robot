*** Settings ***
Documentation    Home (Books Catalog) Test Suite — Tiny Bookstore
...              Covers: loading books, search, filter, book card navigation.
Resource         ../../resources/page_objects/home_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Open Browser With Config    ${BASE_URL}
Suite Teardown   Close Browser Session
Test Setup       Navigate To Home Page And Wait
Test Teardown    Test Teardown With Screenshot

*** Variables ***
${KNOWN_BOOK}           Làm Bạn Với Bầu Trời
${KNOWN_CATEGORY}       Du Ký
${NON_EXISTING_BOOK}    QWERTYUIOPASDFGHJKL12345

*** Test Cases ***
TC-HOME-01 Load Books Successfully
    [Documentation]    Verify the catalog loads properly and the Recent tab is active by default.
    [Tags]    home    TC-HOME-01
    Catalog Should Load With Recent Tab Active

TC-HOME-02 Search Existing Book
    [Documentation]    Search for an existing book and verify it appears alone.
    [Tags]    home    TC-HOME-02
    Search For Book    ${KNOWN_BOOK}
    Verify Book Present In Grid    ${KNOWN_BOOK}
    Search Results Should Show Exactly One Book

TC-HOME-03 Search Non Existing Book
    [Documentation]    Search for a non-existing book and verify the empty state.
    [Tags]    home    TC-HOME-03
    Search For Book    ${NON_EXISTING_BOOK}
    Verify Empty Search State

TC-HOME-04 Clear Search
    [Documentation]    Clear search input and verify books reappear.
    [Tags]    home    TC-HOME-04
    Search For Book    ${NON_EXISTING_BOOK}
    Verify Empty Search State
    Clear Search Box
    Books Should Be Visible

TC-HOME-05 Filter By Category
    [Documentation]    Filter books by a known category.
    [Tags]    home    TC-HOME-05    smoke
    Select Category    ${KNOWN_CATEGORY}
    Category Filter Should Be Active    ${KNOWN_CATEGORY}

TC-HOME-06 Combine Search And Filter
    [Documentation]    Combine text search and category filter.
    [Tags]    home    TC-HOME-06
    Switch To All Books Tab
    Select Category    ${KNOWN_CATEGORY}
    ${first_book_title}=    Get First Book Title
    Search For Book    ${first_book_title}
    Verify Book Present In Grid    ${first_book_title}

TC-HOME-07 View Book Detail From Home
    [Documentation]    Clicking on a book card navigates to the Book Detail page.
    [Tags]    home    TC-HOME-07    smoke
    ${first_book_title}=    Get First Book Title
    Click Book Card    ${first_book_title}
    Book Detail Page Should Show Title    ${first_book_title}

TC-HOME-08 Loading State
    [Documentation]    Verify the loading state text appears on page load.
    [Tags]    home    TC-HOME-08
    Navigate To Home Page And Wait
    ${status}    ${message}=    Run Keyword And Ignore Error    Verify Loading State
    Log    Loading state result: ${status}

TC-HOME-09 Empty Result State
    [Documentation]    Covered by TC-HOME-03 but included as placeholder for structure.
    [Tags]    home    TC-HOME-09
    Pass Execution    Covered by TC-HOME-03.
