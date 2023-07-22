local function toggleTutorial(menu)
    AA_ToggleTutorial()
end

local function changeTargetCategory(menu)
    local dispName = menu.Name
    for index, category in ipairs(AA.loader.visibleCategories) do
        if (category.DisplayName == dispName) then
            AA.AutomaticArrows.workingCategory = category
        end
    end

    menu.Checked = true
end

local function maximumTargets(menu)
    AA.AutomaticArrows.maximumTargets = menu.Name
    Storage:UpsertValue("automaticarrows", "maximumTargets", AA.AutomaticArrows.maximumTargets)
    AA_ChangeMaxArrows()
    menu.Checked = true
end

local function changeDistanceSetting(menu)
    AA.utils.currentSetting = menu.Name
    Storage:UpsertValue("automaticarrows", "currentSetting", menu.Name)
end

local function toggleButton(menu)
    if (AA.AutomaticArrows.arrowsToggledOn == "true") then
        AA.AutomaticArrows.arrowsToggledOn = "false"
    else
        AA.AutomaticArrows.arrowsToggledOn = "true"
        AA_LoadVisibleCategories()
        AA.AutomaticArrows.workingCategory = AA.loader.visibleCategories[1]
        AA_RefreshTargets()
    end

    Storage:UpsertValue("automaticarrows", "arrowsToggledOn", AA.AutomaticArrows.arrowsToggledOn)
    menu.Checked = (AA.AutomaticArrows.arrowsToggledOn == "true")
end

local mainMenu = Menu:Add("Automatic Arrows", nil)

local stut = mainMenu:Add("Show/Hide Tutorial", toggleTutorial, false, false, "Shows/Hides the tutorial")


local targetMenu = mainMenu:Add("Current Target Category", nil, false, false, "Allows you to change the currently targeted markers, if there are multiple shown currently")
local targets = {}


local maxTargMenu = mainMenu:Add("Change Maximum Arrows", nil, false, false, "Allows you to select how many arrows you would like to have shown at once. The arrows will point to the closest X markers")
maxTargMenu:Add("1", maximumTargets, false, false, "Sets the maximum number of arrows to only one")
maxTargMenu:Add("2", maximumTargets, false, false, "Sets the maximum number of arrows to two")
maxTargMenu:Add("3", maximumTargets, false, false, "Sets the maximum number of arrows to three")
maxTargMenu:Add("4", maximumTargets, false, false, "Sets the maximum number of arrows to four")
maxTargMenu:Add("5", maximumTargets, false, false, "Sets the maximum number of arrows to five")

local distSettingMenu = mainMenu:Add("Change Distance Calibration", nil, false, false, "Changes when the arrows transition through the different colors")
distSettingMenu:Add("Long", changeDistanceSetting, false, false, "For markers that are separated by long distances")
distSettingMenu:Add("Medium", changeDistanceSetting, false, false, "For markers that aren't really far apart, but aren't close")
distSettingMenu:Add("Close", changeDistanceSetting, false, false, "For markers that are close together")

local toggle = mainMenu:Add("Toggle Automatic Arrows On", toggleButton, true, (AA.AutomaticArrows.arrowsToggledOn == "true"), "This toggles Automatic Arrows on and off. Please ensure you have only the markers you want to be guided to visible.")

function AA_RefreshTargets()
    if (AA.AutomaticArrows.arrowsToggledOn == "false") then
        targetMenu:Add("None", nil, false, false, "Either toggle AA on, reopen the menu, or make sure at least one category is toggled on and restart AA")
    else
        for _, category in ipairs(AA.loader.visibleCategories) do
            if (targets[category.DisplayName] == nil) then
                targetMenu:Add(category.DisplayName, changeTargetCategory, false, false)
                targets[category.DisplayName] = true
            end
        end
    end
end

AA_RefreshTargets()