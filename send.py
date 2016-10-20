import OSC
import urllib2
from bs4 import BeautifulSoup
from random import randint


url = "http://www.umich.edu"
stack = []
visted = []

while (1==1):
    try:
        f = urllib2.urlopen(url)

        soup = BeautifulSoup(f, 'html.parser')
        links = soup.find_all('a', href=True)
        for link in links:
            href = link.get('href')
            if href.startswith("http:") and href not in visted:
                stack.append(href)
                visted.append(href)

        c = OSC.OSCClient()
        c.connect(('127.0.0.1', 57120))   # connect to SuperCollider
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress("/startup")
        oscmsg.append(len(links))
        oscmsg.append(10000)
        c.send(oscmsg)

    except:
        print "bad url:" + url
        url = stack[0]
        stack = stack[1:]
        continue

    print len(links)
    url = stack[0]
    stack = stack[1:]
    print(url)
