#!/usr/bin/env python3

import argparse
import struct
from sys import stderr

def Main(args):
	f = open(args.filename, "r+b")

	if args.hex:
		offset = int(args.offset, 16)
		value  = int(args.value, 16)

	else:
		offset = int(args.offset, 10)
		value  = int(args.value, 10)

	if args.byte:
		value = struct.pack("B", value)

	elif args.word:
		value = struct.pack("H", value)

	elif args.dword:
		value = struct.pack("I", value)

	elif args.qword:
		value = struct.pack("L", value)

	f.seek(offset)

	f.write(value)

	f.close()

def ParseArgs():
	parser = argparse.ArgumentParser()

	parser.add_argument("--hex", action='store_true', help="offset and value will be interpreted as hex values instead of decimal")

	parser.add_argument("--byte", action='store_true')
	parser.add_argument("--word", action='store_true')
	parser.add_argument("--dword", action='store_true')
	parser.add_argument("--qword", action='store_true')


	parser.add_argument("offset")
	parser.add_argument("value")

	parser.add_argument("filename")

	args = parser.parse_args()

	one_true = False

	for bool in [args.byte, args.word, args.dword, args.qword]:
		if not one_true and bool:
			one_true = True

		elif one_true and bool:
			print("only one of 'byte, word, dword, qword' can be selected", file=stderr)
			exit(1)

	if not one_true:
		print("one of 'byte, word, dword, qword' must be selected", file=stderr)
		exit(1)

	return args

if __name__ == "__main__":
	Main(ParseArgs())
