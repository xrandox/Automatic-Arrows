AA.loader = {
    visibleCategories = {}
}

Debug:Watch("AA_Loader", AA.loader)

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
    -- if any are not visible, not valid
    if (category:IsVisible() == false) then
        return false
    end

    -- if it's the root category, then we can finally return true
    if (category.Root == true) then
        return true
    end

    if (category.Parent ~= nil) then
        return validateParent(category.Parent) -- Keep going to validate that all parent categories are shown
    end
end

function AA_LoadVisibleCategories()
    Debug:Print("Loading visible category list...")
    local lotsOfMarkers = World:GetClosestMarkers(5000)
    local totalLoaded = 0

    for _, marker in ipairs(lotsOfMarkers) do
        if (alreadyLoaded(marker.Category)) then goto continue end
        if (validateParent(marker.Category)) then
            table.insert(AA.loader.visibleCategories, marker.Category)
            Debug:Print("Found visible category: " .. marker.Category.DisplayName .. " with namespace " .. marker.Category.Namespace)
            totalLoaded = totalLoaded + 1
        end
        if (totalLoaded > 15) then
            Debug:Warn("Too many visible categories, please reduce the number of visible categories. Stopped loading.")
            return
        end
        ::continue::
    end

    Debug:Print("Loading complete.")
end