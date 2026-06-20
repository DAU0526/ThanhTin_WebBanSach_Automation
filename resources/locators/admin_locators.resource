*** Settings ***
Documentation    Locators for Admin Dashboard (Books CRUD).

*** Variables ***
${TAB_MANAGEMENT}          xpath=//button[contains(text(), 'Management')]
${TAB_INVENTORY}           xpath=//button[contains(text(), 'Inventory')]
${TAB_ORDERS}              xpath=//button[contains(text(), 'Orders')]

${INPUT_BOOK_TITLE}        xpath=//label[text()='Title']/following-sibling::input
${SELECT_BOOK_CATEGORY}    xpath=//label[text()='Category']/following-sibling::select
${INPUT_BOOK_AUTHOR}       xpath=//label[text()='Author']/following-sibling::input
${INPUT_BOOK_PRICE}        xpath=//label[text()='Price']/following-sibling::input
${INPUT_BOOK_STOCK}        xpath=//label[text()='Stock']/following-sibling::input
${INPUT_BOOK_DESC}         xpath=//label[text()='Description']/following-sibling::textarea
${BTN_SUBMIT_BOOK}         xpath=//button[contains(text(), 'Create book') or contains(text(), 'Update book')]
${BTN_CANCEL_EDIT}         xpath=//button[contains(text(), 'Cancel edit')]

${MSG_ADMIN_SUCCESS}       xpath=//div[contains(@class, 'bg-sky-50') and contains(@class, 'text-sky-600')]
${MSG_ADMIN_ERROR}         xpath=//div[contains(@class, 'bg-red-50') and contains(@class, 'text-red-600')]

${TXT_INVENTORY_HEADER}    xpath=//h2[text()='Inventory']
