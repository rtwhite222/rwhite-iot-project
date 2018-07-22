function selectQueryWhere(getValues,SQLtable,compareValue,compareCheck)
    local sql = ""
    for value, getValues in ipairs(getValues) do
        if(value == 1) then
            sql = getValues
        else
            sql = sql .. ", " .. getValues
        end
    end
    
    sql = sql .. " FROM " .. SQLtable .. " WHERE " .. compareValue .. " = '" .. compareCheck .. "';"
    return sql
end
-- Function to create string to be input as SQL select with inputs for WHERE comparisons. Only allows for 1 compare
    
function selectQuery(getValues,SQLtable)
    local sql = ""
    for value, getValues in ipairs(getValues) do
        if(value == 1) then
            sql = getValues
        else
            sql = sql .. ", " .. getValues
        end
    end
    sql = sql .. " FROM " .. SQLtable
    return sql
end
-- Function to create string to be input as SQL select

function updateQueryWhere(getValues,SQLtable,valueUpdates, attribute, entity)
    local sql = "UPDATE " .. SQLtable .. " SET "
    for value, getValues in ipairs(getValues) do
        if(value == 1) then
            sql = sql .. getValues .. " = '" .. valueUpdates[value] .. "'" 
        else
            sql = sql .. ", " .. getValues .. " = '" .. valueUpdates[value] .. "'"
        end
        
    end
    sql = sql .. " WHERE " .. attribute .. " = '" .. entity .. "';"
    return sql
end
-- Function to create string to be input as SQL update. Used to change values of already created entities