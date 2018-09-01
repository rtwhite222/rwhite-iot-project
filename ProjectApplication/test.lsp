
<?lsp 
local t = { 
    ["name1"] = "value1",
    ["name2"] = { 1, false, true, 23.54, "a \021 string" },
}


local data=ba.json.encode(t)
--print(data)

value = ba.json.decode(data)
print(value.name2[2])
?>