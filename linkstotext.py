# import pythonosc as OSC
#import OSC
import urllib2
from bs4 import BeautifulSoup
import urlparse
import re
import sys




url = "http://rackham.umich.edu"
stack = []
visted = []
file = open("newfile.txt", "w")

while (1 == 1):

    try:
        f = urllib2.urlopen(url)
        soup = BeautifulSoup(f, 'html.parser')

    except:
        #print "error:", sys.exc_info()[0] #this doesn't work currently on my (Z.'s) Mac so commented out
        print "bad url:" + url
        url = stack[0]
        #print url
        stack = stack[1:]
        continue

    links = soup.find_all('a', href=True)
    for link in links:
        href = link.get('href')
        joinurl = urlparse.urljoin(url, urlparse.urlparse(href).path)
        if ("rackham.umich.edu" in joinurl):
            #file.write(url + "|" + joinurl +"\n")
            textURL = url + "|" + joinurl +"\n"
            file.write(textURL.encode("utf-8")) # to code in unicode over ASCII

            #print url + "|" + joinurl
            if joinurl not in visted:
                stack.append(joinurl)
                visted.append(joinurl)


    print url + "   links in stack:" + str(len(stack))


    url = stack[0]
    stack = stack[1:]

file.close()
