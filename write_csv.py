import csv
import sys
import os

# read the txt file from perl script.
seq_lines = {}
with open(sys.argv[1], 'r') as fp:
    for line in fp:
        line_list = line.split(',')
        key = '-'.join(line_list[0:4])
        if key not in seq_lines:
            seq_lines[key] = line_list[4]

# read the orignial csv and write the seq.
all_row = []
with open('example.csv', 'r') as fp:
    reader = csv.reader(fp, delimiter=',')
    for in_row in reader:
        all_row.append(in_row)

with open('output.csv','w') as fp:
    reader = csv.writer(fp, delimiter=',')
    for row in all_rows:
        key_list = 

