repeat task.wait(.1) until game:IsLoaded()

local Collection = {} ; Collection.__index = Collection

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local baseFolder = "Deity_Hub_Next_Generation/Temp/Fisch"
local serverTempFile = baseFolder .. "/ServerTemp.json"

local serverVersionText = ReplicatedStorage.world.version.Value
local serverVersion = serverVersionText:gsub("%.", "")

local function ensureFolders()
	local paths = {
		"Deity_Hub_Next_Generation",
		"Deity_Hub_Next_Generation/Temp",
		baseFolder
	}
	for _, path in ipairs(paths) do
		if not isfolder(path) then
			makefolder(path)
		end
	end
end

local function ensureServerTempFile()
	if not isfile(serverTempFile) then
		writefile(serverTempFile, "[]")
	end
end

local function getServerList(placeId)
	local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"):format(placeId)
	local response = request({ Url = url, Method = "GET" }).Body
	local data = HttpService:JSONDecode(response).data

	local servers = {}
	for _, server in ipairs(data) do
		servers[server.id] = {
			jobId = server.id,
			playerCount = server.playing,
			maxPlayers = server.maxPlayers,
			placeId = placeId,
		}
	end
	return servers
end

function Collection:switchToNewServer()
	local placeId = game.PlaceId
	ensureFolders()
	ensureServerTempFile()

	local savedServers = HttpService:JSONDecode(readfile(serverTempFile))
	local servers = getServerList(placeId)

	for _, info in pairs(servers) do
		if tostring(info.placeId) == tostring(placeId)
			and not table.find(savedServers, info.jobId)
			and tonumber(info.playerCount) < Players.MaxPlayers / 2 then

			table.insert(savedServers, info.jobId)
			writefile(serverTempFile, HttpService:JSONEncode(savedServers))
			TeleportService:TeleportToPlaceInstance(placeId, info.jobId)
			break
		end
	end
end

if tonumber(serverVersion) <= 152 then
	StarterGui:SetCore("SendNotification", {
		Title = "🐟 Server Version",
		Text = "You are running version " .. serverVersionText,
		Duration = 5
	})
else
	Collection:switchToNewServer()
end
