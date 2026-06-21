Automation Testing Framework cho hệ thống:

**Tiny Bookstore Management System** ([tiny-bookstore.vercel.app](https://tiny-bookstore.vercel.app))

Framework sử dụng để tự động kiểm thử giao diện Web Application.

### Mục tiêu:
- Automation UI Testing
- Kiểm thử chức năng Đăng ký & Đăng nhập (Authentication)
- Kiểm thử chức năng Giỏ hàng & Thanh toán (Cart & Checkout)
- Kiểm thử chức năng Tìm kiếm & Lọc sách (Home Catalog)
- Quản trị viên quản lý sách (Admin CRUD)
- Regression Testing
- Generate Test Report tự động

---

## Technology Stack
| Technology | Usage |
|---|---|
| Python | Programming Language |
| Robot Framework | Automation Framework |
| SeleniumLibrary | Web Automation |
| ChromeDriver | Browser Driver |
| YAML | Environment Configuration |
| Page Object Model | Test Architecture |

---

## Requirements
| Tool | Version |
|---|---|
| Python | 3.10+ |
| Google Chrome | Latest |
| ChromeDriver | Match Chrome |
| Robot Framework | 7.x |

Check version:
```bash
python --version
robot --version
```

---

## Installation

**Clone Repository**
```bash
git clone https://github.com/your-username/tiny-bookstore-automation.git
cd tiny-bookstore-automation
```

**Create Virtual Environment**
Windows:
```bash
python -m venv venv
venv\Scripts\activate
```
Linux / Mac:
```bash
python3 -m venv venv
source venv/bin/activate
```

**Install Libraries**
```bash
pip install -r requirements.txt
```

---

## Project Structure
```text
tiny-bookstore-automation/
│
├── resources/
│   ├── locators/
│   │   ├── admin_locators.resource
│   │   ├── auth_locators.resource
│   │   ├── book_detail_locators.resource
│   │   ├── cart_locators.resource
│   │   ├── checkout_locators.resource
│   │   ├── home_locators.resource
│   │   └── navbar_locators.resource
│   │
│   ├── page_objects/
│   │   ├── admin_page.resource
│   │   ├── auth_page.resource
│   │   ├── book_detail_page.resource
│   │   ├── cart_page.resource
│   │   ├── checkout_page.resource
│   │   ├── home_page.resource
│   │   └── navbar_page.resource
│   │
│   ├── test_data/
│   │   └── books.yaml
│   ├── variables/
│   │   └── global_variables.resource
│   ├── browser_keywords.resource
│   ├── common_keywords.resource
│   └── environment.yaml
│
├── results/
│   ├── log.html
│   ├── output.xml
│   └── report.html
│
├── tests/
│   ├── admin/
│   │   └── AdminBooksTests.robot
│   ├── auth/
│   │   ├── LoginTests.robot
│   │   └── RegisterTests.robot
│   ├── book_detail/
│   │   └── BookDetailTests.robot
│   ├── cart/
│   │   └── CartTests.robot
│   ├── checkout/
│   │   └── CheckoutTests.robot
│   └── home/
│   │   └── HomeTests.robot
│
├── .gitignore
├── robot.yaml
├── requirements.txt
└── README.md
```

---

## Automation Architecture
```text
Test Cases
      |
      v
Common Keywords
      |
      v
Page Objects
      |
      v
Locators
      |
      v
Tiny Bookstore Application
```

---

## Test Coverage

### Authentication Testing
**Login**
File: `tests/auth/LoginTests.robot`
Test Cases:
| ID | Description |
|---|---|
| TC-LGN-01 | Login With Valid Admin Credentials Should Succeed |
| TC-LGN-02 | Login With Wrong Password Should Fail |
| TC-LGN-03 | Login With Non-Existent Username Should Fail |
| TC-LGN-04 | Login With Empty Username And Password Should Be Blocked |
| TC-LGN-05 | Logout Should Clear Session And Return To Guest State |
| TC-LGN-06 | Password Visibility Toggle Should Work |

**Register**
File: `tests/auth/RegisterTests.robot`
Test Cases:
| ID | Description |
|---|---|
| TC-REG-01 | Register With Valid Data Should Succeed |
| TC-REG-02 | Register With Existing Username Should Fail |
| TC-REG-03 | Register With Existing Email Should Fail |
| TC-REG-04 | Register With Invalid Email Format Should Be Blocked |
| TC-REG-05 | Register With Empty Required Fields Should Be Blocked |
| TC-REG-06 | Register Without Email Should Succeed |

### Catalog & Search Testing
**Home / Catalog**
File: `tests/home/HomeTests.robot`
Test Cases:
| ID | Description |
|---|---|
| TC-HOME-01 | Load Books Successfully |
| TC-HOME-02 | Search Existing Book |
| TC-HOME-03 | Search Non Existing Book |
| TC-HOME-04 | Clear Search |
| TC-HOME-05 | Filter By Category |

### Cart & Checkout Testing
**Cart Management**
File: `tests/cart/CartTests.robot`
Test Cases:
| ID | Description |
|---|---|
| TC-CART-01 | Add Book To Cart |
| TC-CART-02 | Increase Quantity |
| TC-CART-03 | Decrease Quantity |
| TC-CART-04 | Remove Item |
| TC-CART-05 | Verify Cart Total |

**Checkout**
File: `tests/checkout/CheckoutTests.robot`
Test Cases:
| ID | Description |
|---|---|
| TC-CHK-01 | Checkout Success |
| TC-CHK-02 | Checkout Empty Cart |
| TC-CHK-03 | Checkout Without Login |
| TC-CHK-04 | Order Appears In Profile History After Checkout |

**Total: ~50 Tests** (bao gồm các module Book Detail và Admin)

---

## Running Tests

**Run All Tests (Sử dụng config từ robot.yaml)**
```bash
robot --argumentfile robot.yaml tests/
```

**Run Login Test**
```bash
robot --argumentfile robot.yaml tests/auth/LoginTests.robot
```

**Run Checkout Test**
```bash
robot --argumentfile robot.yaml tests/checkout/CheckoutTests.robot
```

---

## Test Report
After execution:
```text
results/
├── output.xml
├── log.html
└── report.html
```
Open report (Windows):
```bash
start results/log.html
```

---

## Page Object Model

### Locator Layer
Contains:
- XPath
- CSS Selector

Example (`auth_locators.resource`):
```robot
*** Variables ***
${INPUT_USERNAME}    id=username
${INPUT_PASSWORD}    id=password
${BTN_SUBMIT}        xpath=//form//button[@type='submit']
```

### Page Object Layer
Contains:
- Click action
- Input action
- Navigation

Example (`auth_page.resource`):
```robot
*** Keywords ***
Fill Login Form
    [Arguments]    ${username}    ${password}
    Input Text     ${INPUT_USERNAME}    ${username}
    Input Text     ${INPUT_PASSWORD}    ${password}

Submit Auth Form
    Click Button   ${BTN_SUBMIT}
```

### Test Layer
Only contains:
- Test scenario
- Expected result

Example (`LoginTests.robot`):
```robot
*** Test Cases ***
TC_01 Valid Login Should Succeed
    Navigate To Login Page
    Fill Login Form    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}
    Submit Auth Form
    Should Be On Home Page
```

---

## Environment Configuration
File: `resources/environment.yaml`

Example:
```yaml
production:
  base_url: "https://tiny-bookstore.vercel.app"
  browser: "chrome"
  headless: false

credentials:
  admin:
    username: "admin"
    password: "admin123"
```

---

## Troubleshooting

**Element Not Found**
Cause:
- Wrong XPath
- Page loading slow

Solution:
```robot
Wait Until Element Is Visible    ${LOCATOR}    timeout=10s
```

**Keyword Not Found**
Check resource:
```robot
Resource    ../resources/common_keywords.resource
```

**Browser Not Open**
Check:
```robot
Suite Setup    Open Browser With Config    ${BASE_URL}
```

---

## Git Workflow
Check changes:
```bash
git status
```
Add:
```bash
git add .
```
Commit:
```bash
git commit -m "Update automation tests"
```
Push:
```bash
git push origin main
```

---

## Future Improvements
- [ ] Add GitHub Actions CI/CD
- [ ] Implement Data-Driven Testing cho các form (Login/Register)
- [ ] Mở rộng scope test cho Profile Management
- [ ] Tích hợp API Testing để verify Database State sau khi Checkout
