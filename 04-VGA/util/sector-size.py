#!/usr/bin/env python3

import argparse
import os
from math import ceil

def Main(args):
	stats = os.stat(args.filename)
	size = stats.st_size

	sectors = ceil(size / 512)

	print(sectors)


def ParseArgs():
	parser = argparse.ArgumentParser()

	parser.add_argument("filename")

	args = parser.parse_args()

	return args

if __name__ == "__main__":
	Main(ParseArgs())
