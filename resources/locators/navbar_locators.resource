*** Settings ***
Documentation    Locators cho Navbar component.
...              Nguồn: Navbar.tsx
...              - Nav thay đổi state dựa vào user (null | customer | admin)


*** Variables ***
${NAV_LOGO}                     xpath=//nav//a[contains(@href,'/') and contains(.,'Tiny')]

${NAV_LINK_CATALOG}             xpath=//nav//a[normalize-space()='Catalog']
${NAV_LINK_CART}                xpath=//nav//a[contains(@href,'/cart')]
${NAV_LINK_PROFILE}             xpath=//nav//a[normalize-space()='Profile']
${NAV_LINK_ADMIN}               xpath=//nav//a[normalize-space()='Admin']

${NAV_LINK_LOGIN}               xpath=//nav//a[normalize-space()='Log in']
${NAV_LINK_REGISTER}            xpath=//nav//a[normalize-space()='Create account']

${NAV_BTN_LOGOUT}               xpath=//nav//button[normalize-space()='Logout']

${NAV_CART_BADGE}               xpath=//nav//a[contains(@href,'/cart')]//span[contains(@class,'rounded-full')]
