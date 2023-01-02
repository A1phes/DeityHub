local Game = "BloxFruit"
if decoded == nil or not rawequal(decoded["status"],"success") or decoded["message"] ~= Game .. Game .. Game then
	repeat wait() until false
end
print("Loaded Blox Fruitt")
