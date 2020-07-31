import re

playersById = {}
playersByName = {}
with open('balldontlie_players.csv', 'r') as file:
	firstLine = True
	for line in file:
		if firstLine:
			firstLine = False
			continue
		line = line.strip()
		items = line.split(',')
		playerId = int(items[0])
		playerName = items[3]
		if playerId in playersById:
			print('WARN: player ID {} already exists'.format(playerId))
		playersById[playerId] = playerName
		if playerName in playersByName:
			print('WARN: player name {} already exists'.format(playerName))
		playersByName[playerName] = playerId

name_count = 0
url_count = 0
playerid_count = 0
with open('nba.txt', 'r') as file:
	for line in file:
		line = line.strip()
		if line.startswith('<section class="nba-player-index__trending-item'):
			m = re.search(r'<a title="([^"]+)"', line)
			if m:
				name = m.group(1)
				name_count += 1
			else:
				name = None
		elif line.startswith('<div class="nba-player-index__headshot_wrapper'):
			m = re.search(r'data-src="([^"]+)"', line)
			if m:
				url = m.group(1)
				url_count += 1
			else:
				url = None
			if name in playersByName:
				playerId = playersByName[name]
				playerid_count += 1
			else:
				playerId = None
			print('{}: "http:{}", // {}'.format(playerId, url, name))
print('{} names, {} ids, {} urls'.format(name_count, playerid_count, url_count))
