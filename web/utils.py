#!/usr/bin/env python3
import os
import sys
import stat


def next_var(line: str, vars: list, index: int = 0, \
begin_sep: str = '`', end_sep: str = "'") -> int
    '''
    The next var function takes a formatted string as 
    an input and adds the next value contained 
    within this formatted string to a list.
    The function returns -1 if no separator is to be found
    and the index of the end delitimer of the value otherwise
    '''
    var: str = ""
    index: int = line.find(begin_sep)
    if (index == -1):
        return (index)
    while (index < len(line) and end_sep != "'"):
        var += line[index]
        index += 1
    vars.append(var)
    return (index)

#class Result(

class Result:
    def __init__(self, line: int, url: str, response_code: int):
        self.line: int = line
        self.url: str = url
        self.response_code: int = response_code

    def as_bool(self) -> bool:
        return (self.response_code >= 200 and self.response_code < 300)

    @classmethod
    def parse(line: str) -> Result:
        vars: list = []
        index = 0
        for i in range(3):
            index = next_var(line, vars, index)
            if (index == -1):
                return (Result(-1, "", -1))
            if (not (vars[0].isdigit() or vars[2].isdigit())):
                return (Result(-1, "", -1))
        return (Result(int(vars[0]), vars[1], int(vars[2])))

class FileResult:
    def __init__(self, file: str):
        self.file: str = file
        self.results: list = []
        self.links_number: int = 0
        self.broken_links: int = 0
    
    def push(result: Result):
        if (result.line == -1):
            return
        self.results.append(result)
        self.links_number += 1
        if (not result.as_bool()):
            self.broken_links += 1

    def __iter__() -> iter:
        return (self.results.__iter__())


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

def check_links(target: str, log_file: str) -> int:
    files: list = []
    retrieve_dir_contents(target, files)
    if len(files) == 0:
        return (-1) #No files provided
    try:
        pid: int = os.fork()
    except Exception:
        return (-2) #Couldn't fork process
    if (pid == 0):
        run_script(files, log_file)
    return (os.waitstatus_to_exitcode(os.wait()[1]))

#def parse_result(log_file: str, results: list) -> list:

if __name__ == '__main__':
    if (len(sys.argv) > 2):
        check_links(sys.argv[1], sys.argv[2])
