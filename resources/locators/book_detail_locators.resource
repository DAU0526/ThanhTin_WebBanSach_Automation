*** Settings ***
Documentation    Locators cho Book Detail page (/books/:id).
...              Nguồn: BookDetailPage.tsx


*** Variables ***
# ── Breadcrumb / Navigation ───────────────────────────────────
${BOOK_DETAIL_BACK_LINK}        xpath=//a[contains(.,'Back to catalog') or contains(.,'Back')]

# ── Book Info ────────────────────────────────────────────────
${BOOK_DETAIL_TITLE}            xpath=//h1[contains(@class,'font-black') or contains(@class,'title')]
${BOOK_DETAIL_AUTHOR}           xpath=//*[contains(@class,'author') or contains(.,'by ')]
${BOOK_DETAIL_PRICE}            xpath=//*[contains(@class,'price') or contains(@class,'font-black')][contains(.,'₫') or contains(.,'VND') or contains(.,'đ')]
${BOOK_DETAIL_STOCK}            xpath=//*[contains(.,'in stock') or contains(.,'Out of stock')]
${BOOK_DETAIL_DESCRIPTION}      xpath=//*[contains(@class,'description') or //p[string-length(.)>50]]
${BOOK_DETAIL_COVER_IMG}        xpath=//img[@alt]

# ── Actions ──────────────────────────────────────────────────
${BOOK_DETAIL_BTN_ADD_TO_CART}  xpath=//button[contains(normalize-space(),'Add to cart')]
${BOOK_DETAIL_BTN_WISHLIST}     xpath=//button[contains(normalize-space(),'Add to Wishlist') or contains(normalize-space(),'Remove from Wishlist')]

# ── Sale Badge ───────────────────────────────────────────────
${BOOK_DETAIL_SALE_BADGE}       xpath=//*[contains(@class,'bg-red') and contains(.,'%')]
${BOOK_DETAIL_SALE_COUNTDOWN}   xpath=//*[contains(.,'Kết thúc sau') or contains(.,'Ends in')]

# ── Out of stock state ────────────────────────────────────────
${BOOK_DETAIL_OUT_OF_STOCK}     xpath=//button[normalize-space()='Unavailable']
