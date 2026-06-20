*** Settings ***
Documentation    Locators cho Admin Dashboard (/admin).
...              Nguồn: AdminDashboard.tsx
...
...              Dashboard có 3 tab chính: Management | Inventory | Orders
...              + Stats cards ở đầu trang


*** Variables ***
${ADMIN_STAT_BOOKS}             xpath=//*[contains(.,'Books in catalog')]/following-sibling::* | //*[contains(.,'Books in catalog')]/../*[contains(@class,'text-') and contains(@class,'font-')]
${ADMIN_STAT_USERS}             xpath=//*[contains(.,'Registered users')]
${ADMIN_STAT_REVENUE}           xpath=//*[contains(.,'Total revenue')]

${ADMIN_TAB_MANAGEMENT}         xpath=//button[normalize-space()='Management']
${ADMIN_TAB_INVENTORY}          xpath=//button[normalize-space()='Inventory']
${ADMIN_TAB_ORDERS}             xpath=//button[normalize-space()='Orders']
${ADMIN_TAB_USERS}              xpath=//button[normalize-space()='Users']

${ADMIN_INPUT_BOOK_TITLE}       xpath=//input[@placeholder='Title' or @name='title']
${ADMIN_INPUT_BOOK_AUTHOR}      xpath=//input[@placeholder='Author' or @name='author']
${ADMIN_INPUT_BOOK_PRICE}       xpath=//input[@placeholder='Price' or @name='price' or @type='number'][1]
${ADMIN_INPUT_BOOK_STOCK}       xpath=//input[@placeholder='Stock' or @name='stock' or @type='number'][2]
${ADMIN_INPUT_BOOK_COVER}       xpath=//input[@placeholder='Image URL' or @name='cover']
${ADMIN_INPUT_BOOK_DESCRIPTION}    xpath=//textarea[@placeholder='Description' or @name='description']
${ADMIN_SELECT_CATEGORY}        xpath=//select[@name='categoryId' or contains(@class,'category')]
${ADMIN_BTN_ADD_BOOK}           xpath=//button[normalize-space()='Add Book' or normalize-space()='Add book']

${ADMIN_INPUT_CATEGORY_NAME}    xpath=//input[@placeholder='Category name' or @name='categoryName']
${ADMIN_BTN_ADD_CATEGORY}       xpath=//button[normalize-space()='Add Category' or normalize-space()='Add category']

${ADMIN_INVENTORY_ROWS}         xpath=//table//tbody//tr | //div[contains(@class,'inventory')]//article
${ADMIN_BTN_EDIT_BOOK}          xpath=//button[normalize-space()='Edit']
${ADMIN_BTN_DELETE_BOOK}        xpath=//button[normalize-space()='Delete']
${ADMIN_BTN_CONFIRM_DELETE}     xpath=//button[normalize-space()='Confirm' or normalize-space()='Yes, delete']

${ADMIN_ORDERS_LIST}            xpath=//table//tbody//tr | //div[contains(@class,'order')]
${ADMIN_ORDER_DETAIL}           xpath=//div[contains(@class,'order-detail') or contains(@class,'order')]

${ADMIN_USERS_LIST}             xpath=//table//tbody//tr | //div[contains(@class,'user-row')]
${ADMIN_BTN_CHANGE_ROLE}        xpath=//button[contains(.,'Make Admin') or contains(.,'Make Customer')]
${ADMIN_BTN_DELETE_USER}        xpath=//button[normalize-space()='Delete' and ancestor::*[contains(@class,'user')]]

${ADMIN_DASHBOARD_CONTAINER}    xpath=//*[contains(@class,'admin') or contains(.,'Admin Dashboard')]
