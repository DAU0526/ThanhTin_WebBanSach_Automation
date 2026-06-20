*** Settings ***
Documentation    Home Page Keywords.
...              Provides interactions with the Book Catalog.
Resource         ../locators/home_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Search For Book
    [Arguments]    ${search_term}
    [Documentation]    Enter text into the search box.
    Wait Until Element Is Visible    ${INPUT_SEARCH_BOX}    timeout=${MEDIUM_TIMEOUT}
    Clear Element Text               ${INPUT_SEARCH_BOX}
    Input Text                       ${INPUT_SEARCH_BOX}    ${search_term}
    Sleep                            1s

Clear Search Box
    [Documentation]    Clear the search box.
    Wait Until Element Is Visible    ${INPUT_SEARCH_BOX}    timeout=${MEDIUM_TIMEOUT}
    Press Keys                       ${INPUT_SEARCH_BOX}    CTRL+a+BACKSPACE
    Sleep                            1s

Switch To All Books Tab
    [Documentation]    Click the "All Books" tab.
    Wait Until Element Is Visible    ${TAB_ALL_BOOKS}       timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${TAB_ALL_BOOKS}
    Sleep                            0.5s

Switch To Recent Tab
    [Documentation]    Click the "Recent" tab.
    Wait Until Element Is Visible    ${TAB_RECENT}          timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${TAB_RECENT}
    Sleep                            0.5s

Select Category
    [Arguments]    ${category_name}
    [Documentation]    Open the category dropdown and select a specific category.
    Wait Until Element Is Visible    ${BTN_CATEGORY_FILTER}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${BTN_CATEGORY_FILTER}
    Sleep                            0.5s
    ${category_option}    Set Variable    xpath=//div[contains(@class, 'absolute left-0 top-full')]//button[normalize-space()='${category_name}']
    Wait Until Element Is Visible    ${category_option}        timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${category_option}
    Sleep                            1s

Verify Book Present In Grid
    [Arguments]    ${book_title}
    [Documentation]    Verify that a book card with the exact title is displayed.
    Wait Until Element Is Visible    xpath=//article[contains(@class, 'group')]//h2[normalize-space()='${book_title}']    timeout=${MEDIUM_TIMEOUT}

Verify Empty Search State
    [Documentation]    Verify that the "No books match your search." message is displayed.
    Wait Until Element Is Visible    ${STATE_EMPTY_SEARCH}    timeout=${MEDIUM_TIMEOUT}

Verify Loading State
    [Documentation]    Verify the "Discovering books for you..." loader is shown.
    Wait Until Element Is Visible    ${STATE_LOADING_BOOKS}   timeout=${SHORT_TIMEOUT}

Click Book Card
    [Arguments]    ${book_title}
    [Documentation]    Click the book card link to navigate to Book Details.
    Wait Until Element Is Visible    xpath=//article[contains(@class, 'group')]//h2[normalize-space()='${book_title}']    timeout=${MEDIUM_TIMEOUT}
    Click Element                    xpath=//article[contains(@class, 'group')]//h2[normalize-space()='${book_title}']
