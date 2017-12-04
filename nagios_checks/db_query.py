import MySQLdb
import sys
import argparse
import ConfigParser


if __name__ == '__main__':
        parser = argparse.ArgumentParser(description="Simple Nagios plugin to execute query on any MySQL database. \n\
                                                                                                                                                                      Just provide DB information via command line parameters")
        parser.add_argument("-H", "--host", help="Host where the DB is located", dest='host', required=False)
        parser.add_argument("-P", "--port", help="Port of the DB Instance", dest="port", required=False)

        parser.add_argument("-s", "--schema", help="DB schema", dest='schema', required=True)
        parser.add_argument("-q", "--query", help="The actual query to execute", dest='query', required=True)
        parser.add_argument("-u", "--user", help="User with rights to execute the query", dest='user', required=False)
        parser.add_argument("-p", "--password", help="Password of the user", dest='password', required=False)

        args = parser.parse_args()

        host = args.host
        if host is None:
                host = '127.0.0.1'

        port = args.port
        if port is None:
                port = 3306
        port = int(port)

        schema = args.schema
        query = args.query

        user = args.user
        password = args.password
        if user is None and password is None:
                sql_ini_fileparser = ConfigParser.RawConfigParser()
                sql_ini_fileparser.read('/root/.my.cnf')
                user = sql_ini_fileparser.get('client', 'user')
                password = sql_ini_fileparser.get('client', 'password')

#       print "Query exec: Host=%s, Port=%s, User=%s, Password=%s, DB=%s" % (host, port, user, password, schema)
        try:
                db = MySQLdb.connect(host=host, port=port, user=user, passwd=password, db=schema)
                cursor = db.cursor()
                cursor.execute(query)
                res = cursor.fetchall()
                print "OK - %s" % str(res[0][0])
                db.close()
        except:
                print "WARNING - Error executing query"

        sys.exit(0)