
# -*- coding: utf-8 -*-

import argparse
from multiprocessing.dummy import Pool
from multiprocessing.dummy import Process
from jnpr.junos import Device
import jnpr.junos.exception as JE
from jnpr.junos.utils.sw import SW
import sys, os
from lxml import etree
import getpass
import socket
import subprocess
#from termcolor import colored

'''
parser = argparse.ArgumentParser('Upgrades Junos on multiple devices')
parser.add_argument("-f", help = "File with hosts to upgrade", type = file, required = True)
parser.add_argument("-j", help = "Junos file", type = file, required = True)
parser.add_argument("-s", help = "Simultaneous upgrade using multiprocessing", action = "store_true")
parser.add_argument("--load", help = "Upload Junos to /var/tmp directory", action = "store_true", default=False)


args = parser.parse_args()

hostnames =  args.f
filename = args.f.name
locp = os.getcwd()
#package = '/var/tmp/junos-install-mx-x86-64-16.1X75.15.tgz'
user_n = raw_input('Username: ')
password = getpass.getpass('Password: ')
#host = 'wf-r6mx240-csim.englab.juniper.net'

os.system('clear')
'''

#Set up socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

HOST = '172.24.83.118'
PORT = 80
MAX = 1024
routersToConfigure = []

#Define functions
def printing():
    list = []
    print colored("===========================================================================", 'green')
    if args.load:
        print "{} will be uploaded to these routers".format(args.j.name)
    else:
        print "Image should be already on all routers in /var/tmp folder"
    print colored("===========================================================================", 'green')
    print "\n"


    print colored("===========================================================================", 'red')
    for i in hostnames:
        print i.strip()
        list.append(i.strip())
    print colored("===========================================================================", 'red')
    print "\n"
    print colored("===========================================================================", 'green')

    if args.s:
        pool_num = 10
        print "All routers will be upgraded simultaneously"
    else:
        pool_num = 1
        print "Routers will be upgraded one by one, no multiprocessing"
    print colored("===========================================================================", 'green')
    print "\n"
    return pool_num, list


def parsing_hostnames(hostnames):
    for line in hostnames:
        list.append(line.strip())
        print list
    return list

# Connects to the device and returns dev object
def connect(hostname):
    try:
        dev = Device(host = "{}".format(hostname), user=user_n, passwd=password)
        dev.open()
        dev.timeout = 3000
        print colored("Connected to {}".format(hostname), "blue")
        upgrade(dev, hostname)
    except JE.ConnectAuthError:
        print "Username or password is incorrect"
        sys.exit()
    except Exception as errr:
        print "{} - Can't connect to the router {}".format(errr, hostname)
        return False
    except:
        print "Lost connection to {}".format(hostname)


# Gets dev object and performs an upgrade
def upgrade(device, hhh):
    ok = False
    sw = SW(device)
    try:
        sw._multi_RE = False
        print colored("Installing a Junos on {}, please wait".format(hhh), "red")
        ok = sw.install(package= args.j.name, no_copy=True, remote_path='/var/tmp/',progress='update_progress', validate=False)
    except Exception as err:
        print "Can't install software"
        print err
        device.close()
        sys.exit(0)

    if ok is True:
        print colored("Rebooting after an upgrade {}".format(hhh), "green")
        rsp = sw.reboot()
        device.close()
        sys.exit(0)
    else:
        print "Junos is not installed - {}".format(hhh)
        device.close()
        sys.exit(0)

recvBuffer = ''

def recv_all(sock):

   global recvBuffer
   data = ''
   text = sock.recv(MAX)

   if (text[-1] == '\n') and ( not recvBuffer):
        data = text[0:len(text)-1]
   elif not recvBuffer:
        recvBuffer = text
   elif text[-1] == '\n':
        data = recvBuffer + text[0:len(text)-1]
        recvBuffer = ''
   else:
        recvBuffer += text

   return data

def processReceivedString(socket,data):

    if data == "ls":
        ls = subprocess.check_output(["ls"])

def passwordView(socket):
    sc, sockname = socket.accept()
    print 'We have accepted a connection from', sockname
    print 'Socket connects', sc.getsockname(), 'and', sc.getpeername()
    username = recv_all(sc)
    print 'The incoming message says', repr(username)
    password = recv_all(sc)
    print 'The incoming message says', repr(password)
    #do something with username and password, including error handling
    sc.sendall("loggedIn\n")
    sc.close()
    print 'Reply sent, socket closed'

def selectLab(socket):
    sc, sockname = socket.accept()
    print 'We have accepted a connection from', sockname
    print 'Socket connects', sc.getsockname(), 'and', sc.getpeername()
    check = recv_all(sc)

    path = "/Users/larao/Documents/routerConfiguration/junos"
    os.chdir(path)
    ls = subprocess.check_output(["ls"])
    print ls

    sc.sendall(ls)

    sc.close()
    print 'Reply sent, socket closed'




if __name__ == "__main__":
    
    #Initialize socket
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(1)
    print 'Listening at', s.getsockname()

    selectLab(s)

    #get username and passowrd from user when the app loads
    passwordView(s)

    




    '''
    pool_num, list = printing()
#    list = parsing_hostnames(hostnames)
    pool = Pool(int(pool_num))
    pool.map(connect, list)
    pool.close()
    pool.join()
    print "All routers are upgraded"

'''


