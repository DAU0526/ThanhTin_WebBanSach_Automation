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
${INPUT_FULL_NAME}              id=fullName
${INPUT_USERNAME}               id=username
${INPUT_EMAIL}                  id=email
${INPUT_PASSWORD}               id=password

${BTN_SUBMIT}                   xpath=//form//button[@type='submit']

${BTN_TOGGLE_PASSWORD}          xpath=//form//button[@type='button']

${LINK_TO_LOGIN}                css=a[href="/login"]
${LINK_TO_REGISTER}             css=a[href="/register"]

${LINK_SWITCH_TO_LOGIN}         xpath=//a[text()='Log in here']
${LINK_SWITCH_TO_REGISTER}      xpath=//a[text()='Register here']

${ERROR_MESSAGE}                css=.bg-red-50.border-red-200

${HEADING_LOGIN}                xpath=//h1[.='Welcome back']
${HEADING_REGISTER}             xpath=//h1[.='Create your reader account']

