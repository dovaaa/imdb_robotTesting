*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${movie_name}     The Shawshank Redemption    # Variable is assigned value "the shawshank redemption"
${scen1_a_csspath}    li.ipc-metadata-list-summary-item:nth-child(1) > div:nth-child(2) > div:nth-child(1) > a:nth-child(1)
${scen2_a_csspath}    .lister-list > tr:nth-child(1) > td:nth-child(2) > a:nth-child(1)
${scen3_list_xpath}    xpath=/html/body/div[2]/div/div[2]/div[3]/div[1]/div/div[3]/div
${scen3_list_class}    lister-list
${last_rating}    10
${yearXpath}      /div[1]/div[3]/h3/span[2]
${year_css}       div.lister-item:nth-child(1) > div:nth-child(3) > h3:nth-child(1) > span:nth-child(3)













*** Test Cases ***
Scenario1
    [Documentation]    Scenario 1: Verify user can search for a movie on the IMDb homepage
    Open Browser    https://www.imdb.com/
    input text    id=suggestion-search    ${movie_name}
    click button    id=suggestion-search-button
    ${scen1ListItem}    Get WebElement    css=${scen1_a_csspath}
    element text should be    ${scen1ListItem}    ${movie_name}
    Close Browser

Scenario2
    [Documentation]    Scenario 2: Verify user can access the top-rated movies section
    Open Browser    https://www.imdb.com/
    click element    id=imdbHeader-navDrawerOpen
    Click Link    /chart/top/?ref_=nv_mv_250
    ${scen2ListItem}    Get webelement    css=${scen2_a_csspath}
    element text should be    ${scen2ListItem}    ${movie_name}
    Close Browser

Scenario3
    [Documentation]    Scenario3: Verify user can search for movies released in a specific year on IMDb
    open browser    https://www.imdb.com/
    click element    xpath=/html/body/div[2]/nav/div[2]/div[1]/form/div[1]/div/label
    click link    https://www.imdb.com/search/?ref_=nv_sr_menu_adv
    click link    /search/title
    select checkbox    id=title_type-1
    select checkbox    id=genres-1
    input text    name=release_date-min    2010
    input text    name=release_date-max    2020
    click button    class=primary
    wait until page contains element    class:${scen3_list_class}
    Comment    Year Loop
    @{scen3ListItems}    Get WebElements    class:lister-item-year
    FOR    ${scen3ListItem}    IN    @{scen3ListItems}
        page should contain element    ${scen3ListItem}
        ${yearText}    Get Text    ${scen3ListItem}
        IF    ${yearText[-5:-1]} > 2020
            Fail    Year Larger than 2020
        Else IF    ${yearText[-5:-1]} < 2010
            Fail    Year Smaller than 2010
        END
    END
    Comment    Genre Loop
    ${scen3ListItems}    Get WebElements    class:genre
    FOR    ${scen3ListItem}    IN    @{scen3ListItems}
        page should contain element    ${scen3ListItem}
        Element Should Contain    ${scen3ListItem}    Action
    END
    Comment    Rating Loop
    ${scen3ListItems}    Get WebElements    css:.ratings-imdb-rating
    ${lastRating}    Set Variable    ${10}
    FOR    ${scen3ListItem}    IN    @{scen3ListItems}
        ${Rating}    get Text    ${scen3ListItem}
        IF    ${Rating} < ${lastRating}
            ${lastRating}    Set Variable    ${Rating}
        ELSE
            FAIL    Ratings not sorted
        END
    END
    close browser
