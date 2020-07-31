from __future__ import print_function
import subprocess
import sys


with open('headshots.csv', 'r') as file:
	for line in file:
		line = line.strip()
		items = line.split(',')

		bdlId = int(items[0].strip())
		nbaId = items[1].strip()
		name = items[2].strip()
		headshot = items[3].strip()

		if len(nbaId) < 1:
			# NBA id unknown
			print('// {}: ???, // {}'.format(bdlId, name))
			continue
		nbaId = int(nbaId)

		if headshot == '':
			headshot = 'none'

		print('{}: ({}, HeadshotStyle.{}), // {}'.format(bdlId, nbaId, headshot, name))
