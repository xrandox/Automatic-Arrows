AA.loader = {
    visibleCategories = {},
    totalLoaded = 0,
}

Debug:Watch("AA_Loader", AA.loader)

-- Checks if the provided category is already loaded in the visible categories
local function alreadyLoaded(category)
    for _, loadedCategory in ipairs(AA.loader.visibleCategories) do
        if (loadedCategory.DisplayName == category.DisplayName) then
            return true
        end
    end
    return false
end

-- Recursively check that all the parent categories are also visible
local function validateParent(category)
    -- If one category is not visible, whole set is invalid
    if (category:IsVisible() == false) then return false end

    -- If it's the root category, then we can finally return true
    if (category.Root == true) then return true end

    -- Otherwise, if it has a parent (it better if it isnt a root), validate the parent
    if (category.Parent ~= nil) then return validateParent(category.Parent) end

    -- If we somehow get here, then we're just going to assume it isnt valid
    return false
end

-- Preloads all the currently visible categories
function AA_LoadVisibleCategories()
    Debug:Print("Loading visible category list...")
    -- Grab an arbitrarily large amount of "closest" markers
    local lotsOfMarkers = World:GetClosestMarkers(5000)

    -- Reset all
    AA.loader.totalLoaded = 0
    AA.loader.visibleCategories = {}

    -- For each marker grabbed
    for _, marker in ipairs(lotsOfMarkers) do
        -- If the marker is filtered, has no display name, or is already loaded then skip it
        if (marker.BehaviorFiltered == true or marker.Category.DisplayName == nil or alreadyLoaded(marker.Category)) then goto continue end

        -- If all of the categories parents are visible then we have a visible category, so insert it
        if (validateParent(marker.Category)) then
            table.insert(AA.loader.visibleCategories, marker.Category)
            Debug:Print("Found visible category: " .. marker.Category.DisplayName .. " with namespace " .. marker.Category.Namespace)
            AA.loader.totalLoaded = AA.loader.totalLoaded + 1
        end

        -- If we've loaded more than 15 categories, we should probably stop
        if (AA.loader.totalLoaded > 15) then
            Debug:Warn("Too many visible categories, stopped loading.")
            return
        end

        ::continue::
    end

    -- Set the working category to the first one loaded
    AA.AutomaticArrows.workingCategory = AA.loader.visibleCategories[1]

    Debug:Print("Loading complete.")
end