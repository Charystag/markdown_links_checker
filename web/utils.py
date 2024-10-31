#!/usr/bin/env python3
import os
import sys
import stat


def next_var(line: str, index: int = 0, begin_sep: str = '`', end_sep: str = "'") -> str
    var: str = ""
    index: int = line.find(begin_sep)
    if (index == -1):
        return (var)
    while (index < len(line) and end_sep != "'"):
        var += line[index]
        index += 1

#class Result(

class Result:
    def __init__(self, line: int, url: str, response_code: int):
        self.line = line
        self.url = url
        self.response_code = response_code

    def as_bool(self) -> bool:
        return (self.response_code >= 200 and self.response_code < 300)

    def parse(line: str) -> Result:
        line_number: str = ""
        url: str = ""
        response_code: str = ""
        first_index = line.find("`")


SCRIPT_PATH="/Users/noahsaintonge/.local/bin/markdown-links-checker"

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
    """
    The goal in this function is to retrieve only the 
    regular files
    """
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

def run_script(files: list, log_file: str) -> bool:
    if (len(log_file) != 0):
        try:
            fd = os.open(log_file, os.O_CREAT | os.O_WRONLY)
            print("opened")
            os.close(1)
            os.close(2)
            os.dup2(fd, 1)
            os.dup2(fd, 2)
            print("dupped")
            os.close(fd)
            print("Closed")
        except Exception:
            return (1)
    os.execv(SCRIPT_PATH, files)

def check_links(target: str, log_file: str) -> str:
    files: list = []
    retrieve_dir_contents(target, files)
    if len(files) == 0:
        return ("No file provided")
    try:
        pid: int = os.fork()
    except Exception:
        return ("Couldn't fork process")
    if (pid == 0):
        run_script(files, log_file)
    os.wait()

if __name__ == '__main__':
    if (len(sys.argv) > 2):
        check_links(sys.argv[1], sys.argv[2])
