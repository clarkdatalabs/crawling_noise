import urllib2
import sqlite3 as lite



url = "http://ai.umich.edu"
stack = []
visted = []
con = lite.connect('crawl.db') # created crawl.db directly with sqllite in terminal via the command $ sqlite3 crawl.db
con.text_factory = str # to prevent possible issue passing 8-bit unicode data


cur = con.cursor()
cur.execute("DROP TABLE IF EXISTS stack") #overwrites any current table. This should be excluded if we end up adding "picking up where you left off" behavior
cur.execute("DROP TABLE IF EXISTS visited")
cur.execute("DROP TABLE IF EXISTS output")
cur.execute("CREATE TABLE stack(id INTEGER PRIMARY KEY AUTOINCREMENT, URL TEXT, JoinURL TEXT)")
cur.execute("INSERT INTO stack('URL', 'JoinURL')VALUES (?, ?)", (url,url))
cur.execute("CREATE TABLE visited(id INTEGER PRIMARY KEY AUTOINCREMENT, URL TEXT, JoinURL TEXT)")
cur.execute("INSERT INTO visited('URL', 'JoinURL')VALUES (?, ?)", (url,url))
cur.execute("CREATE TABLE output(id INTEGER PRIMARY KEY AUTOINCREMENT, fromURL TEXT, toURL TEXT)")
con.commit()
con.close()
