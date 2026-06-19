*** Settings ***
Documentation    Locators cho Navbar component.
...              Nguồn: Navbar.tsx
...              - Nav thay đổi state dựa vào user (null | customer | admin)


*** Variables ***
# ── Logo / Brand ─────────────────────────────────────────────
${NAV_LOGO}                     xpath=//nav//a[contains(@href,'/') and contains(.,'Tiny')]

# ── Links chính ──────────────────────────────────────────────
${NAV_LINK_CATALOG}             xpath=//nav//a[normalize-space()='Catalog']
${NAV_LINK_CART}                xpath=//nav//a[contains(@href,'/cart')]
${NAV_LINK_PROFILE}             xpath=//nav//a[normalize-space()='Profile']
${NAV_LINK_ADMIN}               xpath=//nav//a[normalize-space()='Admin']

# ── Auth links (chưa đăng nhập) ──────────────────────────────
${NAV_LINK_LOGIN}               xpath=//nav//a[normalize-space()='Log in']
${NAV_LINK_REGISTER}            xpath=//nav//a[normalize-space()='Create account']

# ── Logout button ────────────────────────────────────────────
${NAV_BTN_LOGOUT}               xpath=//nav//button[normalize-space()='Logout']

# ── Cart counter badge ───────────────────────────────────────
# Hiện số lượng item đang trong cart
${NAV_CART_BADGE}               xpath=//nav//a[contains(@href,'/cart')]//span[contains(@class,'rounded-full')]
