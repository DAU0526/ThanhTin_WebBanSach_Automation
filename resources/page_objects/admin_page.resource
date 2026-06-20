*** Settings ***
Documentation    Admin Page Keywords.
Resource         ../locators/admin_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Switch To Management Tab
    [Documentation]    Switch to the Management tab.
    Wait Until Element Is Visible    ${TAB_MANAGEMENT}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${TAB_MANAGEMENT}

Switch To Inventory Tab
    [Documentation]    Switch to the Inventory tab.
    Wait Until Element Is Visible    ${TAB_INVENTORY}     timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${TAB_INVENTORY}
    Wait Until Element Is Visible    ${TXT_INVENTORY_HEADER}    timeout=${MEDIUM_TIMEOUT}

Fill Book Form
    [Arguments]    ${title}    ${author}    ${price}    ${stock}
    [Documentation]    Fill in basic book information in the form.
    Wait Until Element Is Visible    ${INPUT_BOOK_TITLE}    timeout=${MEDIUM_TIMEOUT}
    # Using Clear Element Text & Input Text
    Clear Element Text    ${INPUT_BOOK_TITLE}
    Input Text            ${INPUT_BOOK_TITLE}    ${title}
    
    Clear Element Text    ${INPUT_BOOK_AUTHOR}
    Input Text            ${INPUT_BOOK_AUTHOR}    ${author}
    
    Clear Element Text    ${INPUT_BOOK_PRICE}
    Input Text            ${INPUT_BOOK_PRICE}    ${price}
    
    Clear Element Text    ${INPUT_BOOK_STOCK}
    Input Text            ${INPUT_BOOK_STOCK}    ${stock}

Submit Book Form
    [Documentation]    Click the Create/Update book button.
    Click Element         ${BTN_SUBMIT_BOOK}

Verify Admin Success Message
    [Arguments]    ${expected_msg}
    [Documentation]    Verify the success message is displayed.
    Wait Until Element Is Visible    ${MSG_ADMIN_SUCCESS}    timeout=${MEDIUM_TIMEOUT}
    Element Should Contain           ${MSG_ADMIN_SUCCESS}    ${expected_msg}

Click Edit Book
    [Arguments]    ${book_title}
    [Documentation]    Click the Edit button for the specified book in the Inventory.
    ${edit_btn}=    Set Variable    xpath=(//div[contains(@class, 'font-bold') and contains(text(), '${book_title}')]/ancestor::div[contains(@class, 'border-stone-200')]//button[contains(text(), 'Edit')])[1]
    Wait Until Element Is Visible    ${edit_btn}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${edit_btn}

Click Delete Book
    [Arguments]    ${book_title}
    [Documentation]    Click the Delete button for the specified book in the Inventory.
    ${delete_btn}=    Set Variable    xpath=(//div[contains(@class, 'font-bold') and contains(text(), '${book_title}')]/ancestor::div[contains(@class, 'border-stone-200')]//button[contains(text(), 'Delete')])[1]
    Wait Until Element Is Visible    ${delete_btn}    timeout=${MEDIUM_TIMEOUT}
    Click Element                    ${delete_btn}
