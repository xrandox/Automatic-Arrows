AA.utils = {
    distanceSettings = {
        Long = { 600, 300, 3},
        Medium = {300, 150, 3},
        Close = {200, 75, 3}
    },
    currentSetting = "Long"
}

AA.utils.currentSetting = Storage:ReadValue("automaticarrows", "currentSetting")
if (AA.utils.currentSetting == nil) then AA.utils.currentSetting = "Long" end

function AA_InterpolateColorByDistance(distance)
    -- Calculate the RGB components based on the mapped value
    local distanceLimits = AA.utils.distanceSettings[AA.utils.currentSetting]
    local far = I:Color(179, 16, 11)
    local mid = I:Color(214, 164, 13)
    local on = I:Color(70, 214, 13)
    local red = 0
    local green = 0
    local blue = 0

    if distance >= distanceLimits[1] then
        red = far.R
        green = far.G
        blue = far.B
    elseif distance >= distanceLimits[2] then
        local mappedValue = 1 - (distance - distanceLimits[2]) / (distanceLimits[1] - distanceLimits[2])
        red = far.R + ((mid.R - far.R) * mappedValue)
        green = far.G + ((mid.G - far.G) * mappedValue)
        blue = far.B + ((mid.B - far.B) * mappedValue)
    elseif distance > distanceLimits[3] then
        local mappedValue = distance / distanceLimits[2]
        red = on.R + ((mid.R - on.R) * mappedValue)
        green = on.G + ((mid.G - on.G) * mappedValue)
        blue = on.B + ((mid.B - on.B) * mappedValue)
    else
        red = on.R
        green = on.G
        blue = on.B
    end

    return I:Color(red, green, blue)
end