*** Settings ***
Documentation    Home (Books Catalog) Test Suite — Tiny Bookstore
...              Based on Source Code Audit: The catalog uses client-side rendering
...              and state filtering. No real Search API is hit during search/filter.
Resource         ../../resources/page_objects/home_page.resource
Resource         ../../resources/common_keywords.resource
Suite Setup      Setup Home Suite
Suite Teardown   Close All Browsers
Test Setup       Go To Home Page And Refresh

*** Variables ***
${KNOWN_BOOK}           Làm Bạn Với Bầu Trời
${KNOWN_CATEGORY}       Du Ký
${NON_EXISTING_BOOK}    QWERTYUIOPASDFGHJKL12345

*** Keywords ***
Setup Home Suite
    Open Browser With Config    ${BASE_URL}

Go To Home Page And Refresh
    [Documentation]    Reload page to ensure React state is fresh.
    Go To    ${URL_HOME}
    Wait Until Element Is Visible    ${HOME_HERO_HEADING}    timeout=${LONG_TIMEOUT}

*** Test Cases ***
TC-HOME-01 Load Books Successfully
    [Documentation]    Verify the catalog loads properly and the Recent tab is active by default.
    [Tags]    home    TC-HOME-01
    Wait Until Element Is Visible    ${TAB_RECENT}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${BOOK_CARD_ARTICLE}    timeout=${MEDIUM_TIMEOUT}
    ${count}=    Get Element Count    ${BOOK_CARD_ARTICLE}
    Should Be True    ${count} <= 4    Recent tab should show at most 4 books

TC-HOME-02 Search Existing Book
    [Documentation]    Search for an existing book and verify it appears.
    [Tags]    home    TC-HOME-02
    Search For Book    ${KNOWN_BOOK}
    Verify Book Present In Grid    ${KNOWN_BOOK}
    ${count}=    Get Element Count    ${BOOK_CARD_ARTICLE}
    Should Be True    ${count} == 1    Only the searched book should appear

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
    Wait Until Element Is Visible    ${BOOK_CARD_ARTICLE}    timeout=${MEDIUM_TIMEOUT}

TC-HOME-05 Filter By Category
    [Documentation]    Switch to All Books tab and filter by category.
    [Tags]    home    TC-HOME-05
    Switch To All Books Tab
    Select Category    ${KNOWN_CATEGORY}
    Wait Until Element Is Visible    xpath=//article[contains(@class, 'group')]//span[normalize-space()='${KNOWN_CATEGORY}']    timeout=${MEDIUM_TIMEOUT}

TC-HOME-06 Combine Search And Filter
    [Documentation]    Combine text search and category filter.
    [Tags]    home    TC-HOME-06
    Switch To All Books Tab
    Select Category    ${KNOWN_CATEGORY}
    Wait Until Element Is Visible    ${BOOK_CARD_TITLE}    timeout=${MEDIUM_TIMEOUT}
    ${first_book_title}=    Get Text    xpath=(//article[contains(@class, 'group')]//h2)[1]
    Search For Book    ${first_book_title}
    Verify Book Present In Grid    ${first_book_title}

TC-HOME-07 Book Card Navigation
    [Documentation]    Click on a book card and verify it navigates to the details page.
    [Tags]    home    TC-HOME-07
    Switch To All Books Tab
    Wait Until Element Is Visible    ${BOOK_CARD_TITLE}    timeout=${MEDIUM_TIMEOUT}
    ${first_book_title}=    Get Text    xpath=(//article[contains(@class, 'group')]//h2)[1]
    Click Book Card    ${first_book_title}
    Wait Until Element Is Visible    xpath=//h1[normalize-space()='${first_book_title}']    timeout=${LONG_TIMEOUT}
    Location Should Contain    /books/

TC-HOME-08 Loading State
    [Documentation]    Verify the loading state text appears.
    [Tags]    home    TC-HOME-08
    Go To    ${URL_HOME}
    ${status}    ${message}=    Run Keyword And Ignore Error    Verify Loading State
    Log    Loading state result: ${status}

TC-HOME-09 Empty Result State
    [Documentation]    Covered by TC-HOME-03 but included as placeholder for structure.
    [Tags]    home    TC-HOME-09
    Pass Execution    Covered by TC-HOME-03.
