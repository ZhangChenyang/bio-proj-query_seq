import csv
import sys
import os
import subprocess

output = []
all_row = []
with open(sys.argv[1], 'r') as csvfile:
    reader = csv.reader(csvfile,delimiter=',')
    for row in reader:
        all_row.append(row)
        chr_id = row[0][3:]
        start = row[1]
        end = row[2]
        label = row[17]
        output.append([chr_id, start, end, label])

line_n = 0
with open('./data/intermediate.csv','w') as midfile:
    writer = csv.writer(midfile, delimiter=',')
    for item in output:
        if line_n == 0:
            line_n = 1;
            continue
        writer.writerow(item)

# Call a perl subroutine
print("Calling perl ...")
subprocess.call(['perl', 'gen_seq.pl', './data/intermediate.csv'])
print("Writing output csv ...")

# read the txt file from perl script.
seq_lines = {}
with open('./data/output.txt', 'r') as fp:
    for line in fp:
        line_list = line.split(',')
        key = '-'.join(line_list[0:4])
        if key not in seq_lines:
            seq_lines[key] = line_list[4]

# Base pairing.
p = {}
p['C'] = 'G'
p['G'] = 'C'
p['A'] = 'T'
p['T'] = 'A'
file_n = 0

# Reduce the output file size.
visited = {}
with open(sys.argv[1].split('.csv')[0]+'-output.csv','w') as fp:
    writer = csv.writer(fp, delimiter=',')
    for row in all_row:
        if file_n == 0:
            writer.writerow(row)
            file_n = 1
            continue
        chid = row[0][3:]
        start = row[1]
        end = row[2]
        label = row[17]
        key = '-'.join([chid, start, end, label])
        if key in visited:
            continue
        else:
            visited[key] = 1
        if key in seq_lines:
            seq = seq_lines[key]
        else:
            print "not right"
            exit(-1)
        if label == '-':
            seq_copy = seq
            seq = [p[c] for c in seq_copy[::-1]]
            seq = ''.join(seq)
        row.append(seq)
        writer.writerow(row)




