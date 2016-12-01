# import pythonosc as OSC
#import OSC
import urllib2
from bs4 import BeautifulSoup
import urlparse
import re
import sys
import sqlite3 as lite



con = lite.connect('crawl.db') # created crawl.db directly with sqllite in terminal via the command $ sqlite3 crawl.db
con.text_factory = str # to prevent possible issue passing 8-bit unicode data
cur = con.cursor()

while 1 == 1:
    cur.execute("SELECT * FROM stack LIMIT 1")
    data = cur.fetchone()
    url = data[2]
    idnum = data[0]
    cur.execute("DELETE FROM stack WHERE id = ?", (idnum,))
    con.commit()

    try:
        f = urllib2.urlopen(url)
        soup = BeautifulSoup(f, 'html.parser')

    except:
        #print "error:", sys.exc_info()[0] #this doesn't work currently on my (Z.'s) Mac so commented out
        print "bad url:" + url
        continue

    links = soup.find_all('a', href=True)
    for link in links:
        href = link.get('href')
        joinurl = urlparse.urljoin(url, urlparse.urlparse(href).path)
        if ("ai.umich.edu" in joinurl):
            url = url.encode("utf-8")
            if (url[-1] == '/'):
                url = url[:-1]
            joinurl = joinurl.encode("utf-8")
            if (joinurl[-1] == '/'):
                joinurl = joinurl[:-1]

                #get a count of rows invisted
                inVisted = cur.execute("SELECT COUNT(*) FROM visited WHERE JoinURL = ?", (joinurl,)).fetchone()[0]
                cur.execute("INSERT INTO output('fromURL', 'toURL') VALUES (?, ?)", (url, joinurl))
                if inVisted==0:
                    cur.execute("INSERT INTO stack('URL', 'JoinURL') VALUES (?, ?)", (url, joinurl))
                    cur.execute("INSERT INTO visited('URL', 'JoinURL') VALUES (?, ?)", (url, joinurl))
                    con.commit()


    print url + "   links in stack:" + str(cur.execute("SELECT COUNT(*) FROM stack").fetchone()[0])
