# Tiny Bookstore — QA Automation Framework

**Tác giả:** Nguyễn Thành Tín

Framework kiểm thử tự động cho dự án **Tiny Bookstore** ([tiny-bookstore.vercel.app](https://tiny-bookstore.vercel.app)), xây dựng trên **Robot Framework + SeleniumLibrary** theo pattern **Page Object Model (POM)**.

---

## Yêu cầu hệ thống

| Công cụ | Phiên bản tối thiểu |
|---|---|
| Python | 3.10+ |
| Google Chrome | 120+ |
| ChromeDriver | Tương ứng với Chrome |
| pip | 23+ |

---

## Cài đặt

### 1. Tạo virtual environment

```bash
# Tại thư mục gốc của project này
python -m venv venv

# Windows
venv\Scripts\activate

# macOS / Linux
source venv/bin/activate
```

### 2. Cài đặt dependencies

```bash
pip install -r requirements.txt
```

### 3. Cài đặt ChromeDriver

ChromeDriver phải trùng phiên bản với Chrome đang dùng.

**Cách nhanh nhất (tự động qua Selenium Manager):**

Selenium 4.6+ tích hợp Selenium Manager — tự động tải đúng ChromeDriver.
Bạn chỉ cần cài Chrome và chạy test bình thường.

**Cách thủ công:**

```bash
# Kiểm tra phiên bản Chrome
google-chrome --version   # Linux/Mac
# Vào chrome://settings/help trên Windows

# Tải ChromeDriver tương ứng
# https://googlechromelabs.github.io/chrome-for-testing/
```

---

## Cấu trúc thư mục

```
tiny-bookstore-automation/
│
├── resources/
│   ├── locators/               # XPath/CSS selectors theo từng trang
│   │   ├── admin_locators.resource
│   │   ├── auth_locators.resource
│   │   ├── book_detail_locators.resource
│   │   ├── cart_locators.resource
│   │   ├── home_locators.resource
│   │   ├── navbar_locators.resource
│   │   └── orders_locators.resource
│   │
│   ├── page_objects/           # POM — keywords theo từng trang
│   │   ├── admin_page.resource
│   │   ├── auth_page.resource
│   │   ├── book_detail_page.resource
│   │   ├── cart_page.resource
│   │   ├── checkout_page.resource
│   │   ├── home_page.resource
│   │   ├── navbar_page.resource
│   │   └── orders_page.resource
│   │
│   ├── test_data/              # Dữ liệu test (YAML)
│   │   ├── users.yaml
│   │   └── books.yaml
│   │
│   ├── variables/              # Biến global cho toàn suite
│   │   └── global_variables.resource
│   │
│   ├── common_keywords.resource    # High-level business workflows
│   ├── browser_keywords.resource   # Browser setup/teardown/session
│   └── environment.yaml            # Config theo môi trường (prod/staging/ci)
│
├── tests/
│   ├── admin/                  # Test Admin Dashboard + Books CRUD
│   ├── auth/                   # Test Login, Register, Logout
│   ├── book_detail/            # Test Book Detail Page
│   ├── cart/                   # Test Cart management
│   ├── checkout/               # Test Checkout flow (end-to-end)
│   ├── home/                   # Test Home Catalog, Search, Filter
│   └── orders/                 # Test Purchase History & Orders
│
├── results/                    # Output: log.html, report.html, screenshots
│
├── requirements.txt
├── README.md
└── .gitignore
```

---

## Chạy Test

### Chạy toàn bộ test suite

```bash
robot --outputdir results tests/
```

### Chạy một suite cụ thể

```bash
robot --outputdir results tests/auth/
robot --outputdir results tests/checkout/
robot --outputdir results tests/admin/
```

### Chạy trên môi trường khác (staging / CI)

```bash
# Chạy trên localhost (staging)
robot --variable ENV:staging --variable BASE_URL:http://localhost:5173 --outputdir results tests/

# Chạy headless (cho CI/CD pipeline)
robot --variable HEADLESS:True --outputdir results tests/
```

### Chạy test có tag cụ thể

```bash
# Chỉ chạy smoke tests
robot --include smoke --outputdir results tests/

# Bỏ qua test đang bị skip
robot --exclude skip --outputdir results tests/
```

### Xem báo cáo

```bash
# Mở log.html sau khi chạy xong
start results/log.html        # Windows
open results/log.html         # macOS
xdg-open results/log.html     # Linux
```

---

## Kiến trúc POM

```
Test Case (.robot)
    └── common_keywords.resource       ← Business workflows
            └── page_objects/*.resource    ← Page-level interactions
                    └── locators/*.resource     ← XPath/CSS selectors
```

**Nguyên tắc:**
- **Locators**: Chỉ chứa biến XPath/CSS. Không logic.
- **Page Objects**: Keyword theo từng trang. Gọi locators, không hardcode XPath.
- **Common Keywords**: Ghép nhiều bước thành workflow (vd: "Login As Admin").
- **Test Cases**: Chỉ gọi high-level keywords. Không dùng Selenium trực tiếp.

---

## Thêm Test Case Mới

1. Tạo file `.robot` trong thư mục `tests/<module>/`
2. Import `common_keywords.resource` trong `*** Settings ***`
3. Thêm locators mới vào `resources/locators/` nếu cần
4. Thêm keyword mới vào page object tương ứng nếu cần
5. Gọi keyword từ `common_keywords` trong test case

**Ví dụ test case đơn giản:**

```robot
*** Settings ***
Resource    ../../resources/common_keywords.resource

*** Test Cases ***
Admin Can Access Dashboard
    [Tags]    smoke    admin
    Suite Setup With Browser
    Login As Admin
    Navigate To Admin Dashboard
    Admin Dashboard Should Be Accessible
    [Teardown]    Suite Teardown With Browser
```

---

## Biến cấu hình thường dùng

| Biến | Mặc định | Mô tả |
|---|---|---|
| `${BASE_URL}` | `https://tiny-bookstore.vercel.app` | URL gốc của ứng dụng |
| `${BROWSER}` | `chrome` | Browser (chrome, firefox, edge) |
| `${HEADLESS}` | `${FALSE}` | Chạy không hiện browser |
| `${ADMIN_USERNAME}` | `admin` | Tài khoản admin |
| `${ADMIN_PASSWORD}` | `admin123` | Mật khẩu admin |

---

## Xử lý lỗi thường gặp

**`WebDriverException: ChromeDriver not found`**
→ Selenium Manager sẽ tự tải. Nếu không, tải thủ công và thêm vào PATH.

**`ElementNotInteractableException`**
→ Tăng timeout hoặc thêm `Wait Until Element Is Visible` trước khi tương tác.

**`StaleElementReferenceException`**
→ SPA React re-render element. Dùng `Wait Until Element Is Visible` lại sau navigation.

**Test fail vì auth token hết hạn**
→ Gọi `Clear Browser Session Data` trong Test Teardown để reset trạng thái.
