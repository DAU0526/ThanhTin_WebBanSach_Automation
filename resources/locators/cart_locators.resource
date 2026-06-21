*** Settings ***
Documentation    Cart page locators.
...              NOTE: Home page locators (HOME_HERO_HEADING, TAB_ALL_BOOKS, INPUT_SEARCH_BOX)
...              are imported via cart_page.resource -> home_page.resource -> home_locators.resource.

*** Variables ***
${CART_PAGE_HEADING}                xpath=//h1[normalize-space()='Your cart']
${CART_EMPTY_TITLE}                 xpath=//h2[normalize-space()='Cart is empty']
${CART_EMPTY_DESCRIPTION}           xpath=//*[contains(normalize-space(),'Add a few books from the catalog')]
${CART_BACK_TO_CATALOG_LINK}        xpath=//a[normalize-space()='Back to catalog']
${CART_ITEM_CARDS}                  xpath=//section//article[.//h2]

${CART_ORDER_SUMMARY}               xpath=//aside[.//h2[normalize-space()='Order summary']]
${CART_ITEMS_COUNT_VALUE}           xpath=//aside[.//h2[normalize-space()='Order summary']]//div[span[normalize-space()='Items']]/span[2]
${CART_SUBTOTAL_VALUE}              xpath=//aside[.//h2[normalize-space()='Order summary']]//div[span[normalize-space()='Subtotal']]/span[2]
${CART_TOTAL_VALUE}                 xpath=//aside[.//h2[normalize-space()='Order summary']]//div[span[normalize-space()='Total']]/span[2]
${CART_LOGIN_REQUIRED_MESSAGE}      xpath=//aside//*[normalize-space()='Please log in before checking out.']
${CART_CHECKOUT_BUTTON}             xpath=//aside//button[normalize-space()='Checkout now' or normalize-space()='Processing order...']

${HOME_OUT_OF_STOCK_BADGE}          xpath=//span[normalize-space()='Out of stock']
