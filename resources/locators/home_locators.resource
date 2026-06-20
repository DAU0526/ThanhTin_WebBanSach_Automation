*** Settings ***
Documentation    Locators for the Home (Books Catalog) Page.
...              Based on the actual React component Home.tsx.

*** Variables ***
# ── Hero ────────────────────────────────────────────────────────
${HOME_HERO_HEADING}           xpath=//h1[contains(., 'Build your reading stack')]

# ── Search & Tabs ────────────────────────────────────────────────
${INPUT_SEARCH_BOX}            xpath=//input[@placeholder='Search by title or author...']
${TAB_RECENT}                  xpath=//button[normalize-space()='Recent']
${TAB_ALL_BOOKS}               xpath=//button[normalize-space()='All Books']

# ── Filters & Sort ──────────────────────────────────────────────
${BTN_CATEGORY_FILTER}         xpath=//button[contains(@class, 'bg-sky-400') and .//*[local-name()='svg']]
${BTN_FORMAT_FILTER}           xpath=//button[contains(normalize-space(), 'All Formats') or contains(@class, 'bg-white') and .//*[local-name()='svg']][1]
${DROPDOWN_MENU_OPTIONS}       css=div.absolute.left-0.top-full button

# ── Book Grid & Cards ───────────────────────────────────────────
${BOOK_GRID}                   css=div.grid.grid-cols-1.gap-5
${BOOK_CARD_ARTICLE}           css=article.group
${BOOK_CARD_TITLE}             css=article.group h2.line-clamp-2
${BTN_SEE_MORE}                xpath=//button[normalize-space()='See more']

# ── States ──────────────────────────────────────────────────────
${STATE_EMPTY_RECENT}          xpath=//div[contains(@class, 'border-dashed') and contains(text(), 'No recent books found.')]
${STATE_EMPTY_SEARCH}          xpath=//div[contains(@class, 'border-dashed') and contains(text(), 'No books match your search.')]
${STATE_EMPTY_SEARCH_CAT}      xpath=//div[contains(@class, 'border-dashed') and contains(text(), 'No books found matching your search in this category.')]
${STATE_LOADING_BOOKS}         xpath=//div[contains(text(), 'Discovering books for you...')]
