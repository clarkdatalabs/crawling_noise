# import pythonosc as OSC
#import OSC
import urllib2
from bs4 import BeautifulSoup
import urlparse
import re
import sys
import sqlite3 as lite



url = "http://rackham.umich.edu"
stack = []
visted = []
con = lite.connect('crawl.db') # created crawl.db directly with sqllite in terminal via the command $ sqlite3 crawl.db
con.text_factory = str # to prevent possible issue passing 8-bit unicode data

with con:
    cur = con.cursor()
    cur.execute("DROP TABLE IF EXISTS Links") #overwrites any current table. This should be excluded if we end up adding "picking up where you left off" behavior
    cur.execute("CREATE TABLE Links(Id INT, URL TEXT, JoinURL TEXT)")
    idcounter = 1
    
    while 1 == 1:

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
                url = url.encode("utf-8")
                joinurl = joinurl.encode("utf-8")
                cur.execute("INSERT INTO Links VALUES (?, ?, ?)", (idcounter, url, joinurl))
                idcounter += 1
                print str(url + " | " + joinurl)

                if joinurl not in visted:
                    stack.append(joinurl)
                    visted.append(joinurl)


        print url + "   links in stack:" + str(len(stack))


        url = stack[0]
        stack = stack[1:]

