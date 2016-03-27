import csv

output = []

with open('example.csv', 'r') as csvfile:
    reader = csv.reader(csvfile,delimiter=',')
    for row in reader:
        chr_id = row[0][3:]
        start = row[1]
        end = row[2]
        label = row[4]
        output.append([chr_id, start, end, label])

line_n = 0
with open('intermediate.csv','w') as midfile:
    writer = csv.writer(midfile, delimiter=',')
    for item in output:
        if line_n == 0:
            line_n = 1;
            continue
        writer.writerow(item)


