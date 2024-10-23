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
Tarkista löytyykö landing paget
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
    Set Screenshot Directory    Screenshots
    Capture Element Screenshot    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[1]/a/div/img


#LISÄTESTI 1
*** Test Cases ***
Hae tuotteen Nimi ja Hinta

    ${productName}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5
    Set Global Variable    ${productName}
    Log     ${productName}

    
    @{Product_price_list}=    Create List
    ${Productprice}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/div/span/span
    
    
    Log    ${Productprice}
    
    
    ${price}=    Split String    ${Productprice}    €
     

    Log    ${price}[0]
    
    
    ${newPrice}=    Set Variable    ${price}[0]
   

    ${newPrice}=    Replace String    ${newPrice}    ,    .
    

    ${newPrice}=    Convert To Number    ${newPrice}
    
    Log     ${newPrice}

# LISÄTESTI 2
*** Test Cases ***
Tarkista tuotteen saatavuus
    ${productAvailability}    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/availability-product/span/span
    Set Global Variable    ${productAvailability}
    Log To Console    ${productAvailability}


*** Test Cases ***
Ota Kuvakaappaus ja klikkaa "lisää koriin"
    Click Element    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[1]/a/div/img

    Page Should Contain    PS5
    
    Page Should Contain Link    xpath://a[@title='Lisää koriin']

    Capture Element Screenshot    xpath:/html/body/main/div[1]/div[2]/div/jim-product-cta-box/div/div[3]/div[2]/addto-cart-wrapper/div/a/span

    Click Link    xpath://a[@title='Lisää koriin']
    

# LISÄTESTI 3
*** Test Cases ***
Etsi ja siirry ostoskoriin. Tarkista ostoskori. Siirry kassalle
    Page Should Contain Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

    Click Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

    Sleep    5

    Page Should Contain    Siirry kassalle
    Page Should Contain    ${productName}

    Sleep    5

    Click Link    xpath:/html/body/main/div/div/div/div[2]/div/div[3]/a

    Sleep    5
    Close Browser


# LISÄTESTI 4
*** Test Cases ***
Useamman tuotteen lisääminen ostoskoriin
    @{productNames}=    Create List    # Alustetaan tyhjä lista

    Open Browser    https://www.jimms.fi/fi/Product/Search?q=ps5   Chrome
     ...    options=add_argument("disable-search-engine-choise-screen"); add_experimental_option("detach", True)

     Maximize Browser Window

    @{price_List}=    Create List

    FOR    ${index}    IN RANGE    ${NUMBER_OF_PRODUCTS}
    ${Real_Index}=    Set Variable    ${index + 1}
    ${Scroll_index}=    Set Variable    ${Real_Index + 1}
    Scroll Element Into View    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Scroll_index}]
    
    # Uudelleenhaku vierityksen jälkeen
    Wait Until Page Contains Element    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Scroll_index}]    timeout=10s
    
    # Haetaan tuotteen nimi
    ${productName}=    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[2]/h5
    Log    ${productName}
    
    # Haetaan hinta
    ${price}=    Get Text    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[3]/div/span/span
    Log    ${price}
    Append To List    ${price_List}    ${price}
    Sleep    5
    # Lisätään tuote koriin
    Page Should Contain Link    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[3]/addto-cart-wrapper/div/a
    
    Click Link    xpath:/html/body/main/div[2]/div/div[2]/div[5]/div/div[${Real_Index}]/product-box/div[2]/div[3]/addto-cart-wrapper/div/a
    END

    Log    ${price_List}
    Set Global Variable    ${price_List}
    ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath:/html/body/div[4]/div/div[2]
    Run Keyword If    ${is_visible}    Click Button    xpath:/html/body/div[4]/div/div[2]/div/div[3]/span


    Wait Until Element Is Visible    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a/span/span
    Click Link    xpath:/html/body/header/div/div[3]/jim-cart-dropdown/div/a

    Sleep    3


# LISÄTESTI 5
*** Test Cases ***
Tarkista, että ostoskorin tuotteiden hintojen 'Summa' == 'Yhteensä'
    Log    ${price_List}
    @{new_price_list}=    Create List

    # Poista ylimääräiset merkit hinnoista ja muuta ne numeroiksi
    FOR    ${element}    IN    @{price_List}
        ${element}=    Split String    ${element}    €
        ${element}=    Replace String    ${element[0]}    ,    .
        Log    ${element}
        ${element}=    Convert To Number    ${element}
        Append To List    ${new_price_list}    ${element}
    END

    # Summaa listan hinnat yhteen
    Log    ${new_price_list}
    ${totalSum}=    Evaluate    round(sum([float(x) for x in ${new_price_list}]), 2)
    Log    ${totalSum}
    
    #Poista ylimääräiset merkit 'Yhteensä' luvusta ja muuta se numeroksi
    ${total_Cost}=    Get Text    xpath:/html/body/main/div/div/div/div[2]/div/div[1]/ul/li[5]/span
    ${total_Cost}=    Split String    ${total_Cost}
    ${total_Cost}=    Replace String    ${total_Cost}[0]    ,    .
    ${total_Cost}=    Convert To Number   ${total_Cost}
    Log    ${total_Cost}

    # Vertaa että 'Summa' ja 'Yhteensä' ovat tasa-arvoiset
    Should Be Equal    ${totalSum}    ${total_Cost}


    Close Browser