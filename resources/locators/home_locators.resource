*** Settings ***
Documentation    Locators cho Home page và Book Card component.
...              Nguồn: Home.tsx, renderBookCard()
...
...              Lưu ý: Book card là dynamic (render từ danh sách sách).
...              Sử dụng XPath tương đối để định vị theo tiêu đề sách.


*** Variables ***
${HOME_HERO_HEADING}            xpath=//h1[contains(.,'Build your reading stack')]

${HOME_TAB_RECENT}              xpath=//button[normalize-space()='Recent']
${HOME_TAB_ALL_BOOKS}           xpath=//button[normalize-space()='All Books']

${HOME_SEARCH_INPUT}            xpath=//input[@placeholder='Search by title or author...']

${HOME_FILTER_CATEGORIES}       xpath=//button[contains(.,'All Categories') or contains(.,'Categories')]
${HOME_FILTER_FORMAT}           xpath=//button[contains(.,'All Formats') or contains(.,'Format')]
${HOME_FILTER_PUBLISHER}        xpath=//button[contains(.,'All Publishers') or contains(.,'Publisher')]
${HOME_FILTER_PRICE}            xpath=//button[contains(.,'All Prices') or contains(.,'Price')]
${HOME_FILTER_SORT}             xpath=//button[contains(.,'Default Sorting') or contains(.,'Newest') or contains(.,'Oldest')]

${HOME_BOOK_GRID}               xpath=//div[contains(@class,'grid')]
${HOME_BOOK_CARDS}              xpath=//article[contains(@class,'rounded')]
${HOME_NO_RESULTS_MSG}          xpath=//div[contains(.,'No books match your search') or contains(.,'No recent books found')]


${HOME_BTN_ADD_TO_CART}         xpath=//button[normalize-space()='Add to cart' or normalize-space()='Unavailable']

${HOME_BTN_SEE_MORE}            xpath=//button[normalize-space()='See more']

${HOME_BADGE_OUT_OF_STOCK}      xpath=//span[normalize-space()='Out of stock']

${HOME_BADGE_IN_CART}           xpath=//div[starts-with(normalize-space(),'In cart:')]
