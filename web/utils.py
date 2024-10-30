#!/usr/bin/env python3
import os
import sys
import stat

def my_flatten(grouped: list, flattened: list): 
    '''
    The first call to flatten should be made using an empty 
    list so that the calls after needn't empty the list
    thus invaliding the whole process
    '''
    for i in grouped:
        if type(i) is not list:
            flattened.append(i)
        if type(i) is list: 
            my_flatten(i, flattened)

def retrieve_dir_contents(directory: str, contents: list):
    if (stat.S_ISREG(os.stat(directory).st_mode) != 0):
        contents.append(directory)
        return
    dir_contents = os.listdir(directory)
    for i in dir_contents:
        file:str = "{0}/{1}".format(directory, i)
        mode = os.stat(file).st_mode
        if (stat.S_ISREG(mode) != 0):
            contents.append(file)
        if (stat.S_ISDIR(mode) != 0):
            retrieve_dir_contents(file, contents)
#        print(os.stat(i).st_mode)
#    print(os.listdir())

def check_links(target: str) -> str:
    files: list = []
    retrieve_dir_contents(target, files)
    if len(files) == 0:
        return ("No file provided")
    try:
        pid = os.fork()
    except Exception:
        return ("Couldn't fork process")
    if (pid == 0)
        os.execl(

if __name__ == '__main__':
    L: list = [ [1,2,3], [[1,2], [1]], [1,2, [1,2, [1,2,3,4]]]]
    print("The list is : ", L)
    t: list = []
    my_flatten(L, t)
    print("The flattened list is : ", t)
    print("Listing contents")
    n: list = []
    if (len(sys.argv) > 1):
        retrieve_dir_contents(sys.argv[1], n)
    print(n)
