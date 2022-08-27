import csv 

with open('data/countries.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        print('Country code', row['Code'], 'is for', row['Name'])
