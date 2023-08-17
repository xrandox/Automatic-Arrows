AA.storage = {
    maximumTargets = "3",
    currentDistanceSetting = "Long",
    firstTime = "true"
}

Debug:Watch("AA_Storage", AA.storage)

-- Load defaults on startup
for key, _ in pairs(AA.storage) do
    local storedValue = Storage:ReadValue("automaticarrows", key)
    if (storedValue ~= nil) then
        AA.storage[key] = storedValue
    end
end

-- Saves the the value into storage
function AA_SaveValue(key, value)
    Storage:UpsertValue("automaticarrows", key, tostring(value))
    AA.storage[key] = value
end