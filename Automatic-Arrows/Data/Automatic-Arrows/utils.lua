function AA_InterpolateColorByDistance(distance)
    -- Calculate the RGB components based on the mapped value
    local far = I:Color(179, 16, 11)
    local mid = I:Color(214, 164, 13)
    local on = I:Color(70, 214, 13)
    local red = 0
    local green = 0
    local blue = 0

    if distance >= 600 then
        red = far.R
        green = far.G
        blue = far.B
    elseif distance >= 200 then
        local mappedValue = 1 - (distance - 300) / 300
        red = far.R + ((mid.R - far.R) * mappedValue)
        green = far.G + ((mid.G - far.G) * mappedValue)
        blue = far.B + ((mid.B - far.B) * mappedValue)
    elseif distance > 10 then
        local mappedValue = distance / 300
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