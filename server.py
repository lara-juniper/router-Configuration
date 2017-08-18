
# -*- coding: utf-8 -*-
# !/home/csim/venv/bin/python


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
import ast
import time
from time import sleep

# Set up TCP socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

HOST = '172.24.89.25'  # Change this to the IP address of your device on the network
PORT = 8055
MAX = 1024
all_routers = {'R1':'10.13.120.188', 'R2': '10.13.121.252', 'R3':'10.13.120.192', 'R4':'10.13.120.182', 'R5': '10.13.120.196', 'R6':'10.13.120.194', 'R7': '10.13.120.172', 'R8': '10.13.120.194', 'R9': '10.13.120.180' }
username1 = ''
password1 = ''
dict_2 = {}
sc = ''

# Connects to the device and returns dev object
def connect(hostname):

    try:
        dev = Device(host="{}".format(hostname), user=username1, passwd=password1)
        dev.open()
        dev.timeout = 3000
        msg = "Connected to {}".format(hostname)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        upgrade(dev, hostname)
    except JE.ConnectAuthError:
        msg = "Username or password is incorrect"
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        sys.exit()
    except Exception as errr:
        msg = "{} - Can't connect to the router {}".format(errr, hostname)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        return False
    except:
        msg = "Lost connection to {}".format(hostname)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)


# Gets dev object and performs an upgrade
def upgrade(device, hhh):
    ok = False
    sw = SW(device)
    try:
        sw._multi_RE = False
        msg = "Installing a Junos on {}, please wait".format(hhh)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        ok = sw.install(package=dict_2[hhh], no_copy=True, remote_path='/var/home/JUNOS-RW/', progress='update_progress',
                        validate=False)
    except Exception as err:
        msg = "Can't install software on {}".format(hhh)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        print err
        device.close()
        sys.exit(0)

    if ok is True:
        msg = "Rebooting after an upgrade {}".format(hhh)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        rsp = sw.reboot()
        device.close()
        sys.exit(0)
    else:
        msg = "Junos is not installed - {}".format(hhh)
        print msg
        sendMsg = "m:" + msg + "\n"
        sc.sendall(sendMsg)
        device.close()
        sys.exit(0)



# TCP function to receive data (iPad --> Python)
recvBuffer = ''


def recv_all(sock):
    global recvBuffer
    data = ''
    text = sock.recv(MAX)

    if (text[-1] == '\n') and (not recvBuffer):
        data = text[0:len(text) - 1]
    elif not recvBuffer:
        recvBuffer = text
    elif text[-1] == '\n':
        data = recvBuffer + text[0:len(text) - 1]
        recvBuffer = ''
    else:
        recvBuffer += text

    return data


def processReceivedString(socket, data):
    if data == "ls":
        ls = subprocess.check_output(["ls"])


def execute1(dict_swift, user1, password1):
    list = []
    dict_2 = {}
    print dict_swift
    for lll in dict_swift:
        list.append(all_routers[lll])
        dict_2[all_routers[lll]] = dict_swift[lll]
        print list
        print dict_2
    return list, dict_2

def show_ver(host_ver):
    print("********")
    dev = Device(host="{}".format(all_routers[host_ver]), user=username1, passwd=password1)
    dev.open()
    dev.timeout = 3000
    print_ver = dev.cli("show version", format='text', warning=False)
    msg = print_ver + '\n'
    sc.sendall(msg)


def show_chassis_hw(host_ver):
    dev = Device(host="{}".format(all_routers[host_ver]), user=username1, passwd=password1)
    dev.open()
    dev.timeout = 3000
    print_ver = dev.cli("show chassis hardware", format='text', warning=False)
    msg = print_ver + '\n'
    sc.sendall(msg)


# Function that runs when application reaches the "Enter Login Credentials" screen
def passwordView(sc):
    # Get Username from iPad
    global username1
    username1 = recv_all(sc)
    print 'The incoming message says', repr(username1)

    # Get Password from iPad
    global password1
    password1 = recv_all(sc)
    print 'The incoming message says', repr(password1)

    # do something with username and password, including error handling
    sc.sendall("loggedIn\n")

    # Get Router : Config-File dictionary from iPad
    dictString = recv_all(sc)
    print 'The incoming message says', repr(dictString)

    # Turn the string into a dictionary
    routerJunosDict = ast.literal_eval(dictString)
    global dict_2
    list, dict_2 = execute1(routerJunosDict, username1, password1)
    print "Routers to execute:"
    for d in list:
        print "Router {} - Junos - {}".format(d, dict_2[d])
    pool = Pool(8)
    pool.map(connect, list)
    pool.close()
    pool.join()
    time.sleep(1)
    msg = "All routers are upgraded"
    print msg
    sendMsg = "end:" + msg + "\n"
    sc.sendall(sendMsg)


    
    sc.close()
    print 'Reply sent, socket closed'

def configReport(sc):
    print "*********************"
    cmd = recv_all(sc)
    print 'received message: ' + cmd
    split = cmd.split(":")
    router = split[0]
    command = split[1]
    if command == "Show Version":
        show_ver(router)
    elif command == "Show Chassis Hardware":
        show_chassis_hw(router)



# Function executes when you are on the "Select Lab" screen
def selectLab(sc):
    check = recv_all(sc)

    # Navigate to "junos" folder and run ls
    path = "/Users/larao/Documents/routerConfiguration/junos"
    os.chdir(path)
    ls = subprocess.check_output(["ls"])
    print ls

    # send ls command results to iPad
    sc.sendall(ls)

    sc.close()
    print 'Reply sent, socket closed'


if __name__ == "__main__":

    # Initialize socket
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(1)
    print 'Listening at', s.getsockname()

    # Script runs on a loop receiving messages indicating which app screen the user selects
    while True:
        global sc
        sc, sockname = s.accept()
        print 'We have accepted a connection from', sockname
        print 'Socket connects', sc.getsockname(), 'and', sc.getpeername()
        navMessage = recv_all(sc)
        print 'received message: ' + navMessage
        arr = navMessage.split(":")
        if arr[0] == "nav":
            message = arr[1]
            print "message: " + message
            if message == "login":
                passwordView(sc)
            elif message == "lab":
                selectLab(sc)
            elif message == "configReport":
                configReport(sc)

    '''
    pool_num, list = printing()
#    list = parsing_hostnames(hostnames)
    pool = Pool(int(pool_num))
    pool.map(connect, list)
    pool.close()
    pool.join()
    print "All routers are upgraded"

'''
 