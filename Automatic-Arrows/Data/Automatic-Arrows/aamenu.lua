local function toggleTutorial(menu)
    AA_ToggleTutorial()
end

local function isCurrentTarget(name)
    if (name == AA.AutomaticArrows.workingCategory.DisplayName) then
        return true
    end
    return false
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

local function isCurrentMax(str)
    if (AA.AutomaticArrows.maximumTargets == str) then return true
    else return false end
end

local function maximumTargets(menu)
    AA.AutomaticArrows.maximumTargets = menu.Name
    Storage:UpsertValue("automaticarrows", "maximumTargets", AA.AutomaticArrows.maximumTargets)
    AA_ChangeMaxArrows()
    menu.Checked = true
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
maxTargMenu:Add("1", maximumTargets, true, isCurrentMax("1"), "Sets the maximum number of arrows to only one")
maxTargMenu:Add("2", maximumTargets, true, isCurrentMax("2"), "Sets the maximum number of arrows to two")
maxTargMenu:Add("3", maximumTargets, true, isCurrentMax("3"), "Sets the maximum number of arrows to three")
maxTargMenu:Add("4", maximumTargets, true, isCurrentMax("4"), "Sets the maximum number of arrows to four")
maxTargMenu:Add("5", maximumTargets, true, isCurrentMax("5"), "Sets the maximum number of arrows to five")

local toggle = mainMenu:Add("Toggle Automatic Arrows On", toggleButton, true, (AA.AutomaticArrows.arrowsToggledOn == "true"), "This toggles Automatic Arrows on and off. Please ensure you have only the markers you want to be guided to visible.")

function AA_RefreshTargets()
    if (AA.AutomaticArrows.arrowsToggledOn == "false") then
        targetMenu:Add("None", nil, false, false, "Either toggle AA on, reopen the menu, or make sure at least one category is toggled on and restart AA")
    else
        for _, category in ipairs(AA.loader.visibleCategories) do
            if (targets[category.DisplayName] == nil) then
                targetMenu:Add(category.DisplayName, changeTargetCategory, true, isCurrentTarget(category.DisplayName))
                targets[category.DisplayName] = true
            end
        end
    end
end

AA_RefreshTargets()