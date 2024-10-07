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

*** Test Cases ***
Tarkista löytyykö sivut
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
Hae hakukoneella ps5
    Click Element    id:searchinput
    Input Text    id:searchinput    ps5
    Press Keys    id:searchinput    ENTER  

    Sleep    3
    
*** Test Cases ***
Kuvakaappaa tuotekuva
    Set Screenshot Directory    C:\\Users\\OMISTAJA\\Documents\\HAMK\\Ohjelmistotestaus\\Project\\Screenshots
    Capture Element Screenshot    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[1]/a/div/img


#LISÄTESTI 1
*** Test Cases ***
Hae tuotteen Nimi ja Hinta
    ${productName}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5
    Set Global Variable    ${productName}
    Log To Console    ${productName}

    ${productPrice}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/div/span/span
    Set Global Variable    ${productPrice}
    Log To Console    ${productPrice}


# LISÄTESTI 2
*** Test Cases ***
Tarkista tuotteen saatavuus
    ${productAvailability}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/availability-product/span
    Set Global Variable    ${productAvailability}
    Log To Console    ${productAvailability}


*** Test Cases ***
Mene tuotesivulle
    Click Element    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[1]/a/div/img

    Page Should Contain    PS5


*** Test Cases ***
Etsi 'Lisää Koriin'
    Page Should Contain Link    xpath://a[@title='Lisää koriin']


*** Test Cases ***
Kuvakaappaa 'Lisää Koriin'
    Capture Element Screenshot    xpath://a[@title='Lisää koriin']

*** Test Cases ***
Klikkaa 'Lisää koriin'
    Click Link    xpath://a[@title='Lisää koriin']
    

# LISÄTESTI 3
*** Test Cases ***
Etsi ostoskori
    Page Should Contain Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

# LISÄTESTI 4
*** Test Cases ***
Siirry ostoskoriin
    Click Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

# LISÄTESTI 5
*** Test Cases ***
Tarkista onko oikea sivu ja löytyykö korista oikea tuote
    Page Should Contain    Siirry kassalle
    Page Should Contain    ${productName}

*** Test Cases ***
Siirry kassalle
    Click Link    xpath:/html/body/main/div/div/div/div[2]/div/div[3]/a
    