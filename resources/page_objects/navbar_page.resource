*** Settings ***
Documentation    Page Object for the Navbar component.
...
...              RESPONSIBILITIES:
...              - Navigate via navbar links
...              - Verify navbar state (logged-in vs guest)
...              - Perform logout action

Resource         ../locators/navbar_locators.resource
Resource         ../variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***

Click Catalog Link
    Click Element    ${NAV_LINK_CATALOG}
    Wait Until Page Contains Element    //article    timeout=${MEDIUM_TIMEOUT}

Click Cart Link
    Click Element    ${NAV_LINK_CART}
    Wait Until Page Contains    Cart    timeout=${MEDIUM_TIMEOUT}

Click Profile Link
    Click Element    ${NAV_LINK_PROFILE}
    Wait Until Page Contains    Profile    timeout=${MEDIUM_TIMEOUT}

Click Admin Link
    Click Element    ${NAV_LINK_ADMIN}
    Wait Until Page Contains    Admin    timeout=${MEDIUM_TIMEOUT}

Click Login Link
    Click Element    ${NAV_LINK_LOGIN}

Click Create Account Link
    Click Element    ${NAV_LINK_REGISTER}

Click Logout Button
    Click Element    ${NAV_BTN_LOGOUT}
    Wait Until Element Is Visible    ${NAV_LINK_LOGIN}    timeout=${MEDIUM_TIMEOUT}


Navbar Should Show Guest State
    [Documentation]    When not logged in, navbar must show Log in and Create account.
    Wait Until Element Is Visible    ${NAV_LINK_LOGIN}       timeout=${SHORT_TIMEOUT}
    Wait Until Element Is Visible    ${NAV_LINK_REGISTER}    timeout=${SHORT_TIMEOUT}
    Element Should Not Be Visible    ${NAV_BTN_LOGOUT}

Navbar Should Show Authenticated State
    [Documentation]    When logged in, navbar must show Profile and Logout.
    Wait Until Element Is Visible    ${NAV_LINK_PROFILE}    timeout=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${NAV_BTN_LOGOUT}      timeout=${MEDIUM_TIMEOUT}
    Element Should Not Be Visible    ${NAV_LINK_LOGIN}

Navbar Should Show Admin Link
    [Documentation]    Only admin can see Admin link in navbar.
    Wait Until Element Is Visible    ${NAV_LINK_ADMIN}    timeout=${MEDIUM_TIMEOUT}

Navbar Should Not Show Admin Link
    [Documentation]    Customer must not see Admin link in navbar.
    Element Should Not Be Visible    ${NAV_LINK_ADMIN}


Cart Badge Should Show
    [Documentation]    Verify cart badge shows expected count.
    [Arguments]         ${expected_count}
    Wait Until Element Is Visible    ${NAV_CART_BADGE}    timeout=${SHORT_TIMEOUT}
    Element Should Contain           ${NAV_CART_BADGE}    ${expected_count}

Navigate To Home Page
    [Documentation]    Navigate to the home page via navbar logo.
    Click Element    ${NAV_LOGO}
    Wait Until Page Contains Element    //article    timeout=${MEDIUM_TIMEOUT}
