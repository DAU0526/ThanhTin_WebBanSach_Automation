*** Settings ***
Documentation    Browser Keywords — quản lý lifecycle của WebDriver.
...
...              VAI TRÒ:
...              - Mở/đóng browser với cấu hình đúng
...              - Cài đặt timeouts, window size
...              - Chụp screenshot khi fail
...              - Làm sạch session (cookies, localStorage)

Resource         variables/global_variables.resource
Library          SeleniumLibrary


*** Keywords ***


Open Browser With Config
    [Documentation]    Open browser according to configuration in global_variables.
    [Arguments]    ${url}=${BASE_URL}

    ${options}=    Get Chrome Options

    Open Browser    ${url}    ${BROWSER}    options=${options}

    Set Window Size    1440    900
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Page Load Timeout    ${PAGE_LOAD_TIMEOUT}


Get Chrome Options
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys,selenium.webdriver
    ${chrome_binary}=    Evaluate    next((p for p in [r'C:\Program Files\Google\Chrome\Application\chrome.exe', r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'] if __import__('os').path.exists(p)), None)

    IF    $chrome_binary is not None
        Evaluate    setattr($options, 'binary_location', $chrome_binary)
    END

    IF    ${HEADLESS}
        Call Method    ${options}    add_argument    --headless
    END

    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu

    ${prefs}=    Create Dictionary
    ...    credentials_enable_service=${False}
    ...    profile.password_manager_enabled=${False}

    Call Method
    ...    ${options}
    ...    add_experimental_option
    ...    prefs
    ...    ${prefs}

    ${exclude}=    Create List    enable-automation
    Call Method
    ...    ${options}
    ...    add_experimental_option
    ...    excludeSwitches
    ...    ${exclude}

    RETURN    ${options}


Close Browser Session
    [Documentation]    Close browser and clean up WebDriver instance.
    Close All Browsers


Take Screenshot On Failure
    [Documentation]    Capture screenshot when test fails.

    ${timestamp}=    Evaluate    __import__('datetime').datetime.now().strftime('%Y%m%d_%H%M%S_%f')
    ${filename}=     Set Variable    failure_${timestamp}.png

    Capture Page Screenshot    ${SCREENSHOT_DIR}${/}${filename}



Clear Browser Session Data
    [Documentation]    Clear localStorage and cookies.

    Execute Javascript    window.localStorage.clear()
    Execute Javascript    window.sessionStorage.clear()
    Delete All Cookies
    Reload Page


Clear Local Storage
    Execute Javascript    window.localStorage.clear()


Set Local Storage Item
    [Arguments]    ${key}    ${value}
    Execute Javascript    window.localStorage.setItem('${key}','${value}')


Get Local Storage Item
    [Arguments]    ${key}

    ${value}=    Execute Javascript
    ...    return window.localStorage.getItem('${key}')

    RETURN    ${value}



Wait For Page To Load Completely
    Wait Until Page Contains Element    //body    timeout=${PAGE_LOAD_TIMEOUT}


Wait For Loading Spinner To Disappear
    Wait Until Element Is Not Visible
    ...    xpath=//*[contains(@class,'animate-spin')]
    ...    timeout=${LONG_TIMEOUT}


Scroll To Element
    [Arguments]    ${locator}

    Scroll Element Into View    ${locator}



Current URL Should Contain
    [Arguments]    ${expected_fragment}

    ${url}=    Get Location
    Should Contain    ${url}    ${expected_fragment}


Current URL Should Be
    [Arguments]    ${expected_url}

    Location Should Be    ${expected_url}
