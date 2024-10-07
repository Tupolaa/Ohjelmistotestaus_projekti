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
        ${response}=    GET Request    website    ${page}
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

    
    @{Product_price_list}=    Create List
    ${Productprice}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/div/span/span
    ${Productprice1}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[3]/product-box/div[2]/div[3]/div/span/span
    
    Log    ${Productprice}
    Log    ${Productprice1}
    
    ${price}=    Split String    ${Productprice}    €
    ${price1}=    Split String    ${Productprice1}    €    


    Log    ${price}[0]
    Log    ${price1}[0]

    
    ${newPrice}=    Set Variable    ${price}[0]
    ${newPrice2}=    Set Variable    ${price1}[0]


    ${newPrice}=    Replace String    ${newPrice}    ,    .
    ${newPrice2}=    Replace String    ${newPrice2}    ,    .

    ${newPrice}=    Convert To Number    ${newPrice}
    ${newPrice2}=    Convert To Number    ${newPrice2}

    Append To List    ${Product_price_list}    ${newPrice}
    Append To List    ${Product_price_list}    ${newPrice2}

    Log To Console    ${Product_price_list}

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
Etsi ja siirry ostoskoriin. Tarkista ostoskori. Siirry kassalle
    Page Should Contain Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

    Click Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

    Sleep    3

    Page Should Contain    Siirry kassalle
    Page Should Contain    ${productName}

    Click Link    xpath:/html/body/main/div/div/div/div[2]/div/div[3]/a

    Sleep    2
    Close Browser