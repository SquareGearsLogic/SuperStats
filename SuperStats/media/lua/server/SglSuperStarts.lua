--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************
--require 'zcontagion/main'
if isClient() then return end

SglSuperStats = {}

function SglSuperStats.onEveryOneMinute()
	--print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!->")
	local playersStats = SglSuperStats.getOnlinePlayersStats()
	SglSuperStats.backupStatsFile()
	SglSuperStats.updateStatsFile(playersStats)
	--print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!<-")
end

function SglSuperStats.getOnlinePlayersStats()
	local playersStats = {}
	local onlinePlayers = getOnlinePlayers()
	for i=0, onlinePlayers:size()-1 do
		local player = onlinePlayers:get(i)
		if player then
			playersStats[player:getUsername()] = {["hoursSurvived"] = player:getHoursSurvived(), ["zombieKills"] = player:getZombieKills()}
		end
	end
	return playersStats
end

function SglSuperStats.backupStatsFile()
	local isCreateMissingFile = true
	local fileW = getModFileWriter("gslSuperStats", getServerName() .. "_SuperStats.backup", isCreateMissingFile, false)
	fileW:close()
	fileW = getModFileWriter("gslSuperStats", getServerName() .. "_SuperStats.backup", isCreateMissingFile, true)
	local fileR = getModFileReader("gslSuperStats", getServerName() .. "_SuperStats.csv", isCreateMissingFile)
	local isBackupEmpty = true
	local line = "_"
	while line do
		line = fileR:readLine()
		if line then
			fileW:write(line.."\r\n")
			isBackupEmpty = false
		end
	end
	if isBackupEmpty then
		fileW:write("Username,HoursSurvived,ZombieKills,\r\n")
	end
	fileW:close()
	fileR:close()
end

function SglSuperStats.updateStatsFile(playersStats)
	local isCreateMissingFile = true
	local fileW = getModFileWriter("gslSuperStats", getServerName() .. "_SuperStats.csv", isCreateMissingFile, false)
	fileW:close()
	fileW = getModFileWriter("gslSuperStats", getServerName() .. "_SuperStats.csv", isCreateMissingFile, true)
	local fileR = getModFileReader("gslSuperStats", getServerName() .. "_SuperStats.backup", isCreateMissingFile)
	local line = "_"
	while line do
		line = fileR:readLine()
		if line then
			local lineArr = SglSuperStats.mysplit(line, ",")
			--print("Looking for", lineArr[0], playersStats[lineArr[0]])
			if playersStats[lineArr[0]] == nil then -- csv header will be added as well here
				--print("Adding backup line")
				fileW:write(line .. "\r\n")
			else
				local t1 = playersStats[lineArr[0]]["hoursSurvived"]
				local t2 = tonumber(lineArr[1])
				--print(lineArr[0], "Existing player ttl", t1, t2)
				if (t1 < t2) then
					--print("this player had better ttl before!")
					fileW:write(line .. "\r\n")
					playersStats[lineArr[0]] = nil
				end
			end
		end
	end
	fileR:close()
	--print("Adding online players...")
	for username,stats in pairs(playersStats) do
		--print("Adding "..username..","..stats["hoursSurvived"]..","..stats["zombieKills"])
		fileW:write(username..","..stats["hoursSurvived"]..","..stats["zombieKills"]..",\r\n")
	end
	fileW:close()
end

function SglSuperStats.mysplit(str)
	local objPropo = {}
	local i = 0
	for token in string.gmatch(str, "([^,]+),%s*") do
		objPropo[i] = token
		i = i + 1
	end
	return objPropo
end

Events.EveryOneMinute.Add(SglSuperStats.onEveryOneMinute)