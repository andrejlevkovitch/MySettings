# based on clang-format.py

from __future__ import absolute_import, division, print_function

import difflib
import platform
import subprocess
import sys
import vim
import os
import json


def findConfigFile(name, path):
    for curFile in os.listdir(path):
        retval = False
        if name == curFile:
            retval = os.path.join(path, name)
            break
    if retval:
        return os.path.abspath(retval)
    else:
        parrentPath = os.path.realpath(os.path.join(path, os.pardir))
        if os.path.split(parrentPath)[1]:
            return findConfigFile(name, parrentPath)


configFile = findConfigFile(".json-format.json", os.path.curdir)


def get_buffer(encoding):
    if platform.python_version_tuple()[0] == '3':
        return vim.current.buffer
    return [line.decode(encoding) for line in vim.current.buffer]


def main():
    # Get the current text.
    encoding = vim.eval("&encoding")
    buf = get_buffer(encoding)
    text = '\n'.join(buf)

    # Determine range to format.
    if vim.eval('exists("l:lines")') == '1':
        lines = ['-lines', vim.eval('l:lines')]
    elif vim.eval('exists("l:formatdiff")') == '1':
        with open(vim.current.buffer.name, 'r') as f:
            ondisk = f.read().splitlines()
        sequence = difflib.SequenceMatcher(None, ondisk, vim.current.buffer)
        lines = []
        for op in reversed(sequence.get_opcodes()):
            if op[0] not in ['equal', 'delete']:
                lines += ['-lines', '%s:%s' % (op[3] + 1, op[4])]
        if lines == []:
            return
    else:
        lines = [
            '-lines',
            '%s:%s' % (vim.current.range.start + 1, vim.current.range.end + 1)
        ]

    # Determine the cursor position.
    cursor = int(vim.eval('line2byte(line("."))+col(".")')) - 2
    if cursor < 0:
        print('Couldn\'t determine cursor position. Is your file empty?')
        return

    # Avoid flashing an ugly, ugly cmd prompt on Windows when invoking clang-format.
    startupinfo = None
    if sys.platform.startswith('win32'):
        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        startupinfo.wShowWindow = subprocess.SW_HIDE

    # Call formatter.
    params = {"indent": 4, "sort_keys": True}
    stderr = str
    if configFile:
        file = open(configFile, 'r')
        file_entry = file.read(-1)
        file.close()
        try:
            params = json.loads(file_entry)
        except:
            stderr = "invalid config file, using default settings"

    load = json.loads(text.encode(encoding))
    stdout = json.dumps(load, **params)

    # If successful, replace buffer contents.
    if stderr:
        print(stderr)

    if not stdout:
        print('No output from lua-format (crashed?).\n')
    else:
        lines = stdout.split('\n')
        sequence = difflib.SequenceMatcher(None, buf, lines)
        for op in reversed(sequence.get_opcodes()):
            if op[0] is not 'equal':
                vim.current.buffer[op[1]:op[2]] = lines[op[3]:op[4]]


main()

