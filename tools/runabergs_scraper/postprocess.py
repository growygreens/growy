# coding: utf-8

import json
import codecs
import csv
import uuid
import random

def loadJson(filename='runabergs_scraped.json'):
    data = []
    with codecs.open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            data.append(json.loads(line))
    return data

def loadNames(filename='plant-names.csv'):
    plantTypeDict = {}
    with codecs.open(filename, 'r', encoding='utf-8') as csvfile:
        csvreader = csv.reader(csvfile, delimiter=';', quotechar='\'')
        for names in csvreader:
            plantTypeDict[names[0]] = names[1:]
    return plantTypeDict

def process_all(data, names):
    return [process_obj(x, names) for x in data if x is not None]

def process_obj(data, names):
    data.pop('image_urls') # We allready have 'images'


    data['name'] = data['name'].rstrip(', ekofrö')


    rbUrl = data.pop('runabergsUrl')
    rbArtNo = data.pop('runabergsArtNo')
    data['dataOrigin'] = {'name': 'Runåbergs fröer',
                          'url': rbUrl}
    data['suppliers'] = [{'name': 'Runåbergs fröer',
                          'url': 'http://www.runabergsfroer.se/',
                          'productUrl': rbUrl,
                          'productCode': rbArtNo}]


    images = data.pop('images')
    if len(images) > 0:
        data['images'] = [images[0]['path']]
    else:
        data['images'] = []


    data['license'] = 'CC-BY-SA 4.0'


    data['id'] = int(uuid.uuid4())


    f1 = data['f1Hybrid']
    if f1 == 'Nej':
        data['f1Hybrid'] = 'No'
    elif f1 == 'Ja':
        data['f1Hybrid'] = 'Yes'
    else:
        data.pop('f1Hybrid')


    seKey = data.pop(u'plantType', None)
    if seKey is not None:
        seKey = seKey.replace('\xa0', ' ')
        if seKey not in names:
            return None
        else:
            data[u'plantGroup'] = names[seKey][0]
            data[u'plantSubGroup'] = names[seKey][1]
            data[u'plantType'] = names[seKey][2]
            data[u'plantSubType'] = names[seKey][3]

    if 'daysToMaturity' in data:
        s = data['daysToMaturity'].lstrip('ca. ')\
                                  .lstrip('drygt ')\
                                  .replace('1 meter', '100')\
                                  .replace('1,5-2,5 meter', '150-250')\
                                  .replace('3-4 meter', '300-400')
        data['daysToMaturity'] = intOrRange(s)

    if 'height' in data:
        data['height'] = intOrRange(data['height'])

    return data

def intOrRange(s):
    parts = [x.strip() for x in s.strip('-').split('-')]

    try:
        if len(parts) == 1:
            return int(parts[0])
        elif len(parts) == 2:
            return [int(x) for x in parts]
        else:
            print("Bad Range %s" % s)

    except ValueError:
        pass

    return None


def showSome(data):
    print(json.dumps(data[random.randint(0, len(data)-1)], indent=2, ensure_ascii=False))


def writeData(data, filename='runabergs.json'):
    with codecs.open(filename, 'w', encoding='utf-8') as f:
        f.write(json.dumps(data, indent=2, ensure_ascii=False))


# showSome(process_all(loadJson(), loadNames()))
