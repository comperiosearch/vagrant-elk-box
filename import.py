import csv
import urllib2
import elasticsearch
import logging
import json
import os


#fix Norwegian number formatting -> standard (sorry about that)
def fixNumber(str):
    if str.find(",") > -1:
            str = str.replace(',', '.')
    return str


def UnicodeDictReader(utf8_data, **kwargs):
    csv_reader = csv.DictReader(utf8_data, **kwargs)
    for row in csv_reader:
        yield dict([(key, unicode(value, 'cp1252'))
                    for key, value in row.iteritems()])

es = elasticsearch.Elasticsearch('http://localhost:9200/')
es_index = "vinmonopolet"
doctype = "produkt"


def main():
    logging.basicConfig(level=logging.WARN, format='%(asctime)s %(message)s')
    if es.indices.exists(index=es_index):
        es.indices.delete(es_index)
    es.indices.create(es_index)
    dirfile = os.path.dirname(os.path.realpath(__file__))
    json_mapping = json.loads(open(dirfile + "/mapping.json", "r").read())
    es.indices.put_template(name="vinmonopolettemplate", body=json_mapping)
    url = 'http://www.vinmonopolet.no/api/produkter'
    response = urllib2.urlopen(url)
    cr = UnicodeDictReader(response, delimiter=';')
    for row in cr:
        if len(row) > 2:
            #3,4,5,26
            row['Volum'] = fixNumber(row['Volum'])
            row['Pris'] = fixNumber(row['Pris'])
            row['Literpris'] = fixNumber(row['Literpris'])
            row['Alkohol'] = fixNumber(row['Alkohol'])
            es.index(index=es_index,
                     doc_type=doctype,
                     id=row['Varenummer'],
                     body=row)

if __name__ == '__main__':
    main()
