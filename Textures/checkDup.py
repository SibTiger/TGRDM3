import hashlib
import os
import string
hashes = {}

for file in os.listdir("."):
	hash = hashlib.sha1(open(file, "rb").read()).hexdigest()
	if hashes.has_key(hash):
		hashes[hash].append(file)
	else:
		hashes[hash] = [file]

for hash, names in hashes.iteritems():
	if len(names) > 1:
		print "files %s all have this hash: %s" % (string.join(names, ", "), hash)