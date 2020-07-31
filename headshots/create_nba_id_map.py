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
		#if playerId in playersById:
		#	print('WARN: player ID {} already exists'.format(playerId))
		playersById[playerId] = playerName
		#if playerName in playersByName:
		#	print('WARN: player name {} already exists'.format(playerName))
		playersByName[playerName] = playerId

nbaByName = {}
duplicateNames = {}
with open('nba_ids.csv', 'r') as file:
	firstLine = True
	for line in file:
		if firstLine:
			firstLine = False
			continue
		line = line.strip()
		items = line.split(',')
		nbaId = int(items[0])
		lastName = items[1]
		firstName = items[2]

		if len(firstName) > 0:
			indexName = firstName + ' ' + lastName
		else:
			indexName = lastName	# Nene

		if indexName in nbaByName:
			# There are some duplicate names. We need to figure these out manually.
			print('WARN: NBA player name {} already exists'.format(indexName))
			duplicateNames[indexName] = True
		else:
			nbaByName[indexName] = nbaId

for bdlId, name in playersById.items():
	if name in nbaByName and name not in duplicateNames:
		nbaId = nbaByName[name]
	else:
		nbaId = ''
	print('{},{},{},'.format(bdlId, nbaId, name))
