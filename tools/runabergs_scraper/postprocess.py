# coding: utf-8

import json
import codecs

def loadJson(filename='runabergs_scraped.json'):
    data = []
    with codecs.open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            data.append(json.loads(line))
    return data

def process_all(data):
    return [process_obj(x) for x in data]

def process_obj(data):
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

    return data

def showSome(data):
    print(json.dumps(data[0], indent=4, ensure_ascii=False))

#postprocess.showSome(postprocess.process_all(postprocess.loadJson()))
