from __future__ import print_function
import subprocess
import sys


with open('headshots.csv', 'r') as file:
	for line in file:
		line = line.strip()
		items = line.split(',')
		bdlId = int(items[0].strip())
		nbaId = items[1].strip()
		if len(nbaId) < 1:
			# NBA id unknown
			print(line)
			continue
		nbaId = int(nbaId)
		name = items[2].strip()
		headshot = items[3].strip()
		if len(headshot) > 0:
			# already has headshot
			print(line)
			continue

		headshot = ''
		for path in ['latest']:
			url = 'https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/{}/260x190/{}.png'.format(path, nbaId)
			#print(url)
			stdout = subprocess.check_output(['curl', '-s', '-i', '--head', url])
			httpResult = stdout.split('\n')[0].strip()
			print('>> {} -> {} -> {}'.format(name, httpResult, url), file=sys.stderr)
			results = httpResult.split(' ')
			if results[1].startswith('2'):
				headshot = path
				break

		items[3] = headshot
		print(','.join(items))
