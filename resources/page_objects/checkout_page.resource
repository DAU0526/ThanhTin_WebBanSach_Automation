*** Settings ***
Documentation    Checkout page keywords.
...              Checkout in this project is integrated into CartPage.
Resource         ../locators/checkout_locators.resource
Resource         ../locators/cart_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Click Checkout Button
    [Documentation]    Click the Checkout now button.
    Wait Until Element Is Visible    ${BTN_CHECKOUT_NOW}    timeout=${MEDIUM_TIMEOUT}
    Element Should Be Enabled        ${BTN_CHECKOUT_NOW}
    Click Element                    ${BTN_CHECKOUT_NOW}


Checkout Success Message Should Be Visible
    [Documentation]    Verify the checkout success message is visible.
    Wait Until Element Is Visible    ${MSG_CHECKOUT_SUCCESS}    timeout=${MEDIUM_TIMEOUT}
    Element Should Contain           ${MSG_CHECKOUT_SUCCESS}    Checkout completed successfully.

Login Warning Message Should Be Visible
    [Documentation]    Verify the login requirement message is visible in the cart.
    Wait Until Element Is Visible    ${MSG_LOGIN_WARNING}    timeout=${MEDIUM_TIMEOUT}
    Element Should Contain           ${MSG_LOGIN_WARNING}    Please log in before checking out.

Submit Checkout
    [Documentation]    Perform the checkout action and wait for the success message.
    Click Checkout Button
    Checkout Success Message Should Be Visible
    Checkout Button Should Be Disabled

