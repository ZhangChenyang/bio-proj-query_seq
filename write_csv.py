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
with open('./data/example.csv', 'r') as fp:
    reader = csv.reader(fp, delimiter=',')
    for in_row in reader:
        all_row.append(in_row)

p = {}
p['C'] = 'G'
p['G'] = 'C'
p['A'] = 'T'
p['T'] = 'A'
file_n = 0
with open('./data/output.csv','w') as fp:
    writer = csv.writer(fp, delimiter=',')
    for row in all_row:
        if file_n == 0:
            file_n = 1
            continue
        chid = row[0][3:]
        start = row[1]
        end = row[2]
        label = row[4]
        key = '-'.join([chid, start, end, label])
        if key in seq_lines:
            seq = seq_lines[key]
        else:
            print "not right"
            exit(-1)
        if label == 'Rev':
            seq_copy = seq
            seq = [p[c] for c in seq_copy[::-1]]
            seq = ''.join(seq)
        row.append(seq)
        writer.writerow(row)


