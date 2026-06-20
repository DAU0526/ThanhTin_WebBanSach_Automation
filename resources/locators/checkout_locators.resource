*** Settings ***
Documentation    Locators for the Checkout process.
...              Based on the source code audit, Checkout is performed directly on CartPage
...              via the "Checkout now" button, without a separate /checkout page.

*** Variables ***
${BTN_CHECKOUT_NOW}             xpath=//aside//button[contains(normalize-space(), 'Checkout now') or contains(normalize-space(), 'Processing order')]

${MSG_CHECKOUT_SUCCESS}         css=.border-sky-200.bg-sky-50.text-sky-600
${MSG_CHECKOUT_ERROR}           css=.border-red-200.bg-red-50.text-red-600
${MSG_LOGIN_WARNING}            css=.border-amber-200.bg-amber-50.text-amber-800
