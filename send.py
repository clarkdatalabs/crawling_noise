#import pythonosc as OSC
import OSC
import urllib2
from bs4 import BeautifulSoup
from urlparse import urljoin
import re


def TLDcode(url):   #checks Top Level Domain. .edu -->0, .com -->1, <anything else> --> 2
    if re.search('\.edu/|\.edu$',url):
        return 0                            #returns 0 for .edu or .edu/... endings
    elif  re.search('\.com/|\.com$',url):
        return 1                            #returns 1 for .com or .com/... endings
    else:                                       
        return 2                            #returns 2 for everything else

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
            joinurl = urljoin(url, href)
            if joinurl.startswith("http") and joinurl not in visted:
                stack.append(joinurl) 
                visted.append(joinurl)
        stack.append("newpage")       #once all links are added, insert a <newpage> counter into the stack


        c = OSC.OSCClient()
        c.connect(('127.0.0.1', 57120))  # connect to SuperCollider
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress("/startup")  # the name of the channel  ///once exhausting a page, send a new page event
        oscmsg.append(len(links))
        oscmsg.append(f.headers["Content-Length"])  ## size of the file
        oscmsg.append(len(divs))
        oscmsg.append(TLDcode(url))     # Top Level Domain (.edu=0, .com=1, other=2)
        c.send(oscmsg)

    except:
        print "bad url:" + url
        url = stack[0]
        stack = stack[1:]
        continue

    url = stack[0]
    if url == "newpage": ## whenever we go to the new page, send a message says new page.
#         print "newpage"
        stack = stack[1:]
        url = stack[0]
        
        c = OSC.OSCClient()
        c.connect(('127.0.0.1', 57120))  # connect to SuperCollider
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress("/newpage")  # the name of the channel
        oscmsg.append(1)
        c.send(oscmsg)

    stack = stack[1:]

