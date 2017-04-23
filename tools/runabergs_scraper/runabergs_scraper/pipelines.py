# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import json
import codecs
import re
import csv

def replaceIfPresent(item, from_key, to_key, transform=lambda x : x):
    x = item.pop(from_key, None)
    if x is not None:
        item[to_key] = transform(x)


def lifeCycleTranslator(val):
    if val == u'Ettårig':
        return u'Annual'
    elif val == u'Tvåårig':
        return u'Biennial'
    elif val == u'Flerårig':
        return u'Perennial'

def heightTranslator(val):
    if val is not None:
        return val.rstrip('.').rstrip('cm').strip()


def descriptionTranslator(val):
    p= re.compile(u' En portion innehåller (ca\\. )?[0-9\\-]+ frön\\.')
    return p.sub(u'', val)


class RunabergsScraperPipeline(object):

    def process_item(self, item, spider):
        item.pop(u'Storlekssorterat', None)
        item.pop(u'Ekologiskt', None)
        item.pop(u'Nyhet', None)
        item.pop(u'Latinskt namn', None)

        replaceIfPresent(item, u'Höjd', 'height', heightTranslator)
        replaceIfPresent(item, u'Utvecklingstid, dagar', 'daysToMaturity')
        replaceIfPresent(item, u'F1 Hybrid', 'f1Hybrid')
        replaceIfPresent(item, u'Artikelnummer', 'runabergsArtNo')
        replaceIfPresent(item, u'Årighet', u'lifeCycle', lifeCycleTranslator)
        replaceIfPresent(item, u'Botanisk familj', u'botanicalFamily')
        replaceIfPresent(item, u'description', u'description', descriptionTranslator)

        return item

class JsonWithEncodingPipeline(object):

    def __init__(self):
        self.file = codecs.open('runabergs_utf8.json', 'w', encoding='utf-8')

    def process_item(self, item, spider):
        d = dict(item)
        line = json.dumps(d, ensure_ascii=False) + "\n"
        self.file.write(line)
        return item

    def spider_closed(self, spider):
        self.file.close()
