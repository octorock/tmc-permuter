#!/usr/bin/env python3

# Imports code and asm from a NONMATCH submission into a folder for the permuter.
# usage: ./import.py NONMATCH_URL

import sys
import re
import requests
import os
import shutil
import subprocess
import multiprocessing

BACKEND_URL = 'https://backend.uk.to'

if len(sys.argv) != 2:
    print(f'usage: {sys.argv[0]} NONMATCH_URL')
    exit(1)

url = sys.argv[1]
result = re.match('https://nonmatch.netlify.app/functions/(\d+)/submissions/(\d+)', url)
if not result:
    result = re.match('https://nonmatch.netlify.app/z/(\d+)/(\d+)', url)

if not result:
    print(f'Does not seem to be a NONMATCH url: {url}')
    exit(1)

(function, submission) = result.groups()

res = requests.get(f'{BACKEND_URL}/functions/{function}')
if not res.ok:
    print(f'Could not fetch function {function}.')
    exit(1)
function_data = res.json()

res = requests.get(f'{BACKEND_URL}/submissions/{submission}')
if not res.ok:
    print(f'Could not fetch submission {submission}.')
    exit(1)
submission_data = res.json()

print(f'func: {function} subm: {submission}')

name = function_data['name']
asm = function_data['asm']
code = submission_data['code']

# TODO check already exists
os.mkdir(name)

shutil.copy('example/compile.sh', f'{name}/compile.sh')
shutil.copy('example/prepare.sh', f'{name}/prepare.sh')
shutil.copy('example/prepare.py', f'{name}/prepare.py')
with open(f'{name}/input.c', 'w') as file:
    file.write(code)
with open(f'{name}/input.s', 'w') as file:
    file.write(asm)

subprocess.check_call('./prepare.sh', cwd=name)

full_path = os.path.abspath(name)

cpus = multiprocessing.cpu_count()
threads = max(1, round(cpus/2), cpus-2)

print(f'Sucessfully imported into {name} folder.\n')
print('Run the permuter locally:')
print(f'./permuter.py -j {threads} --stop-on-zero {full_path}\n')
print('Run with permuter@home:')
print(f'./permuter.py -J -j {threads} --stop-on-zero {full_path}\n')