*** Settings ***
Documentation    Locators for Book Detail Page.
...              Based on the actual React component BookDetailPage.tsx.

*** Variables ***
${BTN_BACK_TO_CATALOG}         xpath=//a[normalize-space()='Back to catalog']
${LBL_BOOK_TITLE}              xpath=//h1[contains(@class, 'text-3xl')]
${LBL_BOOK_AUTHOR}             xpath=//h1[contains(@class, 'text-3xl')]/following-sibling::p
${LBL_STOCK_STATUS}            xpath=//span[contains(text(), 'in stock') or contains(text(), 'Out of stock')]
${LBL_PRICE_VALUE}             xpath=//div[text()='Price']/following-sibling::div[contains(@class, 'text-2xl')]
${LBL_STOCK_VALUE}             xpath=//div[text()='Stock']/following-sibling::div[contains(@class, 'text-2xl')]
${BTN_ADD_TO_CART_DETAIL}      xpath=//button[contains(., 'Add to cart') or contains(., 'Unavailable')]
${BTN_ADD_TO_WISHLIST}         xpath=//button[contains(., 'Wishlist')]
${STATE_BOOK_NOT_FOUND}        xpath=//h1[normalize-space()='Book not found']
