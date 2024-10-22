*** Settings ***
Library    SeleniumLibrary
Library    String
Library    OperatingSystem
Library    Collections
Library    RequestsLibrary
Library    XML

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
Tuotteiden lisäys ostoskoriin
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
# TESTICASE
     ${length}=    Get Length    ${price_List}  # Hae listan pituus

    FOR    ${index}    IN RANGE    ${length}
        ${Real_Index}=    Set Variable    ${index + 1}
        
        # Haetaan hinta XPath:n avulla
        ${price}=    Get Text    xpath:/html/body/main/div/div/div/div[1]/article[${Real_Index}]/div/div[2]/div/div[3]/div[2]/div/span/span

        # Verrataan hintaa listan arvoon
        Log    Hinta sivulla: ${price}
        Log    Hinta listassa: ${price_List[${index}]}

        Should Be Equal As Strings    ${price}    ${price_List[${index}]}
        Log    Hinta sivulla: ${price} vastaa listan hintaa: ${price_List[${index}]}
    END


    Log    ${price_List}
    @{new_price_list}=    Create List
    FOR    ${element}    IN    @{price_List}
        ${element}=    Split String    ${element}    €
        ${element}=    Replace String    ${element[0]}    ,    .
        Log    ${element}
        Append To List    ${new_price_list}    ${element}
    END

    Log    ${new_price_list}


    FOR    ${price}    IN    @{new_price_list}
        # Lisätään hinta total-muuttujaan
        ${total}=    Set Variable    ${total+ ${price}}
        
        Log    Current total: ${total}
    END

    Log    Final total: ${total}

    Close Browser