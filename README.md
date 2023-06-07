# SuperStats
Project Zomboid mod to collect player statistics before server wipe

This is a server-side plugin that updates players statistics once per gape minute and keeps record of best survival and how many kills player made during that survival, so this information can be presented to participants at the end of game season (server wipe).
Keep in mind, while kill statistics gets updated on time, the player:getHoursSurvived() Api call is very lazy and will be updated by server from time to time...

As a result, you should find two files (the actual CSV with statistics and its backup) in plugin directory c:\users\USERNAME\Zomboid\mods\SuperStats\. Ignore the backup file - it exists just to save RAM.