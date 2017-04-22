# coding: utf-8

import scrapy

# Run with:
# $ scrapy crawl runabergs

def strCleanup(s):
    return s.rstrip(':').replace(u'\xa0', u' ')

class RunabergsSpider(scrapy.Spider):
    name = "runabergs"

    def start_requests(self):
        urls = ['http://www.runabergsfroer.se']
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response, plantType=None):
        parts = response.url.split("?")
        if (len(parts) == 1):
            # http://www.runabergsfroer.se/?m=266
            resp = response.css('div.ddsmoothmenu').css('li a').re(r'm=([0-9]+)\">(.*)<')
            categories = zip(resp[0::2], resp[1::2])

            for (categoryUrl, text) in categories:
                ignore_list = ['Tillbehör',
                               'Boken Runåbergs Fröer', 'Krukmakare',
                               'SM 6 algextrakt', 'QR kompostaktivator',
                               'Skördekniv', 'Sticketiketter',
                               'Presentförpackning', 'Såkalender 2017',
                               'Info m.m.', 'Nya sorter 2016-2017',
                               'Aktuellt', 'Hos Runåbergs',
                               'Beställningsguide', 'Försäljningsvillkor',
                               'Danmark-Finland-Norge', 'Frökatalog',
                               'Sortlista', 'Utvecklingsdagar',
                               'Ekologiskt odlat frö', 'Groningstabell',
                               'Sommar- och höstsådd', 'Odla ditt frö själv',
                               'Adresser', 'Kontakt', 'Öppettider', 'Mässor 2017']
                if text in ignore_list:
                    continue

                next_page = response.urljoin('/?m=%s' % categoryUrl)
                yield scrapy.Request(next_page, callback=lambda x, pt=text: self.parse(x, pt))

        page_type = parts[-1:][0][0]
        if (page_type == 'm'):
            # process products type
            # http://www.runabergsfroer.se/?p=40
            products = response.css('a').re(r'p=([0-9]+)')
            for product in products:
                next_page = response.urljoin('/?p=%s' % product)
                yield scrapy.Request(next_page,
                                     callback=lambda x, pt=plantType: self.parse(x, pt))

        elif (page_type == 'p'):
            # process product
            # Ex. Early Nantes, ekofrö
            name = strCleanup(response.css('td.productLeft h1::text').extract_first())

            # Ex. Daucus carota ssp. sativus
            latin_name = strCleanup(response.css('td.productLeft i::text').extract_first())

            description = strCleanup("".join(
                [x.strip() for x in response.css('td.productLeft::text').extract()]))

            p = response.url.split('/?p=')[1]
            image_url = 'http://www.runabergsfroer.se/image.php?title=product_%s' % p

            res_dict = {
                'runabergsUrl': response.url,
                'name': name,
                'latinName': latin_name,
                'description': description,
                'plantType': plantType,
                'plantSubType': plantType,
                'image_urls': [image_url]
            }

            # Properties: Ex. [('Artikelnummer:', '2115'), (..), ..]
            res = response.css('td.productRight tr').re(r'<td>(.*)</td><td>(.*)</td>')
            properties = zip(res[0::2], res[1::2])
            for prop in properties:
                res_dict[strCleanup(prop[0])] = strCleanup(prop[1])

            yield res_dict


        else:
            # process error
            self.log('Error - unknown page type: %s' % response.url)
