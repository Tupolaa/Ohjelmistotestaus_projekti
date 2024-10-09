*** Settings ***
Library    SeleniumLibrary
Library    String
Library    OperatingSystem
Library    Collections
Library    RequestsLibrary

*** Keywords ***


*** Variables ***
${BASE_URL}    https://www.jimms.fi/fi/Product
@{PAGES}       /Tietokoneet    /Komponentit    /Oheislaitteet  /Pelaaminen    /SimRacing
...    /Verkkotuotteet    /Tarvikkeet    /Erikoistuotteet    /Ohjelmistot    /Palvelut    /Kampanjat
   
${NUMBER_OF_PRODUCTS}    3  


*** Test Cases ***
Check Landing pages
     open Browser    https://www.jimms.fi   Chrome
     ...    options=add_argument("disable-search-engine-choise-screen"); add_experimental_option("detach", True)

     Maximize Browser Window


    
    Create Session    website    ${BASE_URL}
    FOR    ${page}    IN    @{PAGES}
        ${response}=    GET On Session    website    ${page}
        Run Keyword If    ${response.status_code} != 200    Log    ERROR: Page ${page} not found! Status code: ${response.status_code}    level=ERROR
        Run Keyword If    ${response.status_code} == 200    Log    Page ${page} exists  
    END


*** Test Cases ***
Search ps5
    Click Element    id:searchinput
    Input Text    id:searchinput    ps5
    Press Keys    id:searchinput    ENTER  

    Sleep    3
    
*** Test Cases ***
Take Screenshot of Product
    Set Screenshot Directory    C:\\Users\\OMISTAJA\\Documents\\HAMK\\Ohjelmistotestaus\\Project\\Screenshots
    Capture Element Screenshot    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[1]/a/div/img

*** Test Cases ***
Go to Product Page
    Click Element    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[1]/a/div/img

    Page Should Contain    PS5


*** Test Cases ***
Find Lisää Koriin
    Page Should Contain Link    xpath://a[@title='Lisää koriin']


*** Test Cases ***
Screenshot Lisää Koriin
    Capture Element Screenshot    xpath://a[@title='Lisää koriin']

*** Test Cases ***
Add Product to basket
    Click Link    xpath://a[@title='Lisää koriin']



*** Test Cases ***
testicase
    @{productNames}=    Create List    # Alustetaan tyhjä lista

    Open Browser    https://www.jimms.fi/fi/Product/Search?q=ps5   Chrome
     ...    options=add_argument("disable-search-engine-choise-screen"); add_experimental_option("detach", True)

     Maximize Browser Window


    FOR    ${index}    IN RANGE    ${NUMBER_OF_PRODUCTS}
    ${Real_Index}=    Set Variable    ${index + 1}
    
    # Yritetään odottaa elementin löytymistä ja tallennetaan tulos muuttujaan
    ${result}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]    timeout=10s
    
    # Jos ensimmäinen arvo (tulos) on FAIL, vieritetään 300 pikseliä alas
    Run Keyword If    '${result[0]}' == 'FAIL'    Execute JavaScript    window.scrollBy(0, 300)
    
    # Uudelleenhaku vierityksen jälkeen
    Wait Until Page Contains Element    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]    timeout=10s
    
    # Haetaan tuotteen nimi
    ${productName}=    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[2]/h5
    Log    ${productName}
    
    # Haetaan hinta
    ${price}=    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[3]/div/span/span
    Log    ${price}
    Sleep    5
    # Lisätään tuote koriin
    Page Should Contain Link    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[3]/addto-cart-wrapper/div/a
    Click Link    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[3]/addto-cart-wrapper/div/a
    END



    

    ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath:/html/body/div[4]/div/div[2]
    Run Keyword If    ${is_visible}    Click Button    xpath:/html/body/div[4]/div/div[2]/div/div[3]/span


    Wait Until Element Is Visible    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a/span/span
    Click Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

    Sleep    3


    Close Browser
    