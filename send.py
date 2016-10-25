# import pythonosc as OSC
import OSC
import urllib2
from bs4 import BeautifulSoup
from urlparse import urljoin

#import re                           #not currently using Regular Expressions
#from random import randint          #not currently using randint


url = "http://www.umich.edu"
stack = []
visted = []

while (1 == 1):
    try:
        f = urllib2.urlopen(url)

        soup = BeautifulSoup(f, 'html.parser')
        links = soup.find_all('a', href=True)
        divs = soup.find_all('div')
        for link in links:
            href = link.get('href')
            if href.startswith("http:") and href not in visted:
                stack.append(href)
            elif href.startswith("/") and href not in visted:
                joinurl = urljoin(url, href)
                stack.append(joinurl)

        visted.append(url)  ### get some information of the color
        c = OSC.OSCClient()
        c.connect(('127.0.0.1', 57120))  # connect to SuperCollider
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress("/startup")  # the name of the channel  ///once exhausting a page, send a new page event
        oscmsg.append(len(links))
        oscmsg.append(f.headers["Content-Length"])  ## size of the file
        oscmsg.append(len(divs))
        c.send(oscmsg)

    except:
        print "bad url:" + url
        url = stack[0]
        stack = stack[1:]
        continue

    print len(links)
    url = stack[0]  ## whenever we go to the new page, send a message says new page.
    stack = stack[1:]
    print(url)
