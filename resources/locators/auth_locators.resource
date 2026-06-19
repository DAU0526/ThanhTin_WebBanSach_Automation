*** Settings ***
Documentation    Locators cho Auth pages — nguồn từ Auth.tsx (audit trực tiếp).
...
...              Ưu tiên: id > css > xpath ngắn
...
...              DOM gốc (Auth.tsx):
...                <input id="fullName" type="text"  />           ← Register only
...                <input id="username" type="text" required />
...                <input id="email"    type="email" />           ← Register only
...                <input id="password" type="password" required />
...                <button type="submit">Create account / Log in</button>
...                <button type="button" aria-label="Show password">...</button>
...                <div class="...text-red-600">{error}</div>    ← Error message


*** Variables ***
# ── Form Inputs (id trực tiếp từ JSX) ────────────────────────
${INPUT_FULL_NAME}              id=fullName
${INPUT_USERNAME}               id=username
${INPUT_EMAIL}                  id=email
${INPUT_PASSWORD}               id=password

# ── Submit Button ─────────────────────────────────────────────
# Duy nhất một button[type=submit] trong form auth
${BTN_SUBMIT}                   css=button[type="submit"]

# ── Password Toggle ───────────────────────────────────────────
# aria-label thay đổi động: "Show password" ↔ "Hide password"
${BTN_TOGGLE_PASSWORD}          css=button[type="button"]

# ── Navigation Links (guest state) ───────────────────────────
${LINK_TO_LOGIN}                css=a[href="/login"]
${LINK_TO_REGISTER}             css=a[href="/register"]

# ── Navigation Links (auth page switch) ──────────────────────
# "Log in here" / "Register here" links trong form
${LINK_SWITCH_TO_LOGIN}         xpath=//a[text()='Log in here']
${LINK_SWITCH_TO_REGISTER}      xpath=//a[text()='Register here']

# ── Error Message ─────────────────────────────────────────────
# Div hiển thị lỗi từ server: class="...border-red-200 bg-red-50...text-red-600"
${ERROR_MESSAGE}                css=.border-red-200.bg-red-50

# ── Page Headings ─────────────────────────────────────────────
${HEADING_LOGIN}                xpath=//h1[.='Welcome back']
${HEADING_REGISTER}             xpath=//h1[.='Create your reader account']

