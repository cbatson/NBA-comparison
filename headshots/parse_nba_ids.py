import re

name_count = 0
id_count = 0
print('nbaId,lastName,firstName')
with open('nba_ids.txt', 'r') as file:
	for line in file:
		line = line.strip()
		if not line.startswith('<li'):
			continue

		m = re.search(r'>([^<]+)</a>', line)
		if m:
			name = m.group(1)
			name_count += 1
		else:
			name = None

		m = re.search(r'href="/player/([0-9]+)/"', line)
		if m:
			nba_id = int(m.group(1))
			id_count += 1
		else:
			nba_id = None

		if name:
			names = name.split(',')
			if len(names) > 1:
				lastName = names[0].strip()
				firstName = names[1].strip()
			else:
				lastName = name
				firstName = ''
		else:
			lastName = None
			firstName = None
		print('{},{},{}'.format(nba_id, lastName, firstName))

print('{} names, {} ids'.format(name_count, id_count))
