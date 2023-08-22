#!/usr/bin/env python3

import argparse
import os
from sys import stderr

def Main(args):
	stats = os.stat(args.filename)

	size = stats.st_size

	if args.tosector:
		remainder = size % 512
		if remainder > 0:
			remainder = 512 - remainder

		output = bytes(remainder)

	elif size > args.size:
		print(f"{args.filename} is already larger than {args.size}", file=stderr)
		exit(1)

	else:
		output = bytes(args.size - size)

	with open(args.filename, "ab") as f:
		f.write(output)

def ParseArgs():
	parser = argparse.ArgumentParser()

	parser.add_argument("--size", type=int)
	parser.add_argument("--tosector", action="store_true")
	parser.add_argument("filename")

	args = parser.parse_args()

	if args.size == None and not args.tosector:
		print("one of 'size, tosector' must be used", file=stderr)
		exit(1)

	if args.size != None and args.tosector:
		print("only one of 'size, tosector' can be used", file=stderr)
		exit(1)

	return args

if __name__ == "__main__":
	Main(ParseArgs())
