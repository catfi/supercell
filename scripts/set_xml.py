#!/usr/bin/env python

from xml.dom.minidom import parse, parseString
import getopt
import sys

class DomHandler():
	def __init__(self, file_name):
		self.dom = parse(file_name)

	def setValue(self, attr_name, attr_value):
		result = False
		for node in self.dom.getElementsByTagName('parameter'):
			if node.getAttribute('name') == attr_name:
				""" parameter name is equal to attr_name """
				print "find attribute name: %s" % (attr_name)
				result = True
				if node.getAttribute('value') == attr_value:
					continue
				else:
					node.setAttribute('value', attr_value)
					print "set attribute value: %s" % (attr_value)
		return result

	def save(self, file_name):
		f = open(file_name, 'w')
		f.write(self.dom.toxml())
		f.close

def main():
	if len(sys.argv) < 4:
		usage()
		sys.exit(2)

	fileName  = sys.argv[1]
	attrName  = sys.argv[2]
	attrValue = sys.argv[3]

	simpleDom = DomHandler(fileName)
	result = simpleDom.setValue(attrName, attrValue)
	if not result:
		print "set attribute fail"
	else:
		simpleDom.save(fileName)

def usage():
	print "usage: %s [file] [name] [value]" % (__file__)
	print\
	"""
	[file]		xml file
	[name]		attribute name
	[value]		value to set to that attribute
	"""

def test():
	dom1 = parse( "/nfs/home/zac/zillians/lib/node/world-server/WorldServerModule.module" )   # parse an XML file
	dom2 = parseString( "<myxml>Some data <empty/> some more data</myxml>" )
	print dom1.toxml()
	#print dom2.toxml()
	for node in dom1.getElementsByTagName('parameter'):  # visit every node <bar />
		if node.getAttribute("name") == "local_id":
			print "node attribute value: %s" % (node.getAttribute("value"))

if __name__ == "__main__":
	main()
