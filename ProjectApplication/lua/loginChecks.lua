function checklogin(hi)
    return hi
end

function selectQueryWhere(getValues,SQLtable,compareValue,compareCheck)
    local sql = ""
    for value, getValues in ipairs(getValues) do
        if(value == 1) then
            sql = getValues
        else
            sql = sql .. ", " .. getValues
        end
    end
    
    sql = sql .. " FROM " .. SQLtable .. " WHERE " .. compareValue .. " = '" .. compareCheck .. "'"
    return sql
end