*** Settings ***
Documentation    Cart locators.

*** Variables ***
# Cart page
${CART_PAGE_HEADING}                xpath=//h1[normalize-space()='Your cart']
${CART_EMPTY_TITLE}                 xpath=//h2[normalize-space()='Cart is empty']
${CART_EMPTY_DESCRIPTION}           xpath=//*[contains(normalize-space(),'Add a few books from the catalog')]
${CART_BACK_TO_CATALOG_LINK}        xpath=//a[normalize-space()='Back to catalog']
${CART_ITEM_CARDS}                  xpath=//section//article[.//h2]

# Summary
${CART_ORDER_SUMMARY}               xpath=//aside[.//h2[normalize-space()='Order summary']]
${CART_ITEMS_COUNT_VALUE}           xpath=//aside[.//h2[normalize-space()='Order summary']]//div[span[normalize-space()='Items']]/span[2]
${CART_SUBTOTAL_VALUE}              xpath=//aside[.//h2[normalize-space()='Order summary']]//div[span[normalize-space()='Subtotal']]/span[2]
${CART_TOTAL_VALUE}                 xpath=//aside[.//h2[normalize-space()='Order summary']]//div[span[normalize-space()='Total']]/span[2]
${CART_LOGIN_REQUIRED_MESSAGE}      xpath=//aside//*[normalize-space()='Please log in before checking out.']
${CART_CHECKOUT_BUTTON}             xpath=//aside//button[normalize-space()='Checkout now' or normalize-space()='Processing order...']

# Navbar
${NAV_LINK_CART}                    xpath=//nav//a[contains(@href,'/cart')]
${NAV_CART_BADGE}                   xpath=//nav//a[contains(@href,'/cart')]//span[contains(@class,'rounded-full')]

# Catalog
${HOME_HERO_HEADING}                xpath=//h1[contains(normalize-space(),'Build your reading stack')]
${HOME_TAB_ALL_BOOKS}               xpath=//button[normalize-space()='All Books']
${HOME_SEARCH_INPUT}                xpath=//input[@placeholder='Search by title or author...']
${HOME_OUT_OF_STOCK_BADGE}          xpath=//span[normalize-space()='Out of stock']
