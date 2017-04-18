# coding: utf-8

import scrapy

# Run with:
# $ scrapy crawl runabergs -o runabergs.json

# Post-process:
# $ cat runabergs.json | sed 's/\\u00f6/ö/g' | sed 's/\\u00a0/ /g' | sed 's/\\u00e5/å/g' | sed 's/\\u00e4/ä/g' | sed 's/\\u00c5/Å/g' | sed 's/\\u00c4/Ö/g' | sed 's/\\u00e9/é/g'

class RunabergsSpider(scrapy.Spider):
    name = "runabergs"

    def start_requests(self):
        urls = ['http://www.runabergsfroer.se']
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        parts = response.url.split("?")
        if (len(parts) == 1):
            # http://www.runabergsfroer.se/?m=266
            categories = response.css('div.ddsmoothmenu').re(r'm=([0-9]+)')
            for category in categories:
                next_page = response.urljoin('/?m=%s' % category)
                yield scrapy.Request(next_page, callback=self.parse)

        page_type = parts[-1:][0][0]
        if (page_type == 'm'):
            # process products type
            # http://www.runabergsfroer.se/?p=40
            products = response.css('a').re(r'p=([0-9]+)')
            for product in products:
                next_page = response.urljoin('/?p=%s' % product)
                yield scrapy.Request(next_page, callback=self.parse)

        elif (page_type == 'p'):
            # process product

            # Ex. Early Nantes, ekofrö
            name = response.css('td.productLeft h1::text').extract_first()

            # Ex. Daucus carota ssp. sativus
            latin_name = response.css('td.productLeft i::text').extract_first()

            description = "".join([x.strip() for x in response.css('td.productLeft::text').extract()])

            res_dict = {
                'rb-url': response.url,
                'name': name,
                'latin_name': latin_name,
                'description': description
            }

            # Properties: Ex. [('Artikelnummer:', '2115'), (..), ..]
            res = response.css('td.productRight tr').re(r'<td>(.*)</td><td>(.*)</td>')
            properties = zip(res[0::2], res[1::2])
            for prop in properties:
                res_dict[prop[0].rstrip(':')] = prop[1]

            # Image
            #img_url = 'http://www.runabergsfroer.se/image.php?title=product_295'
            #with open('rb-img-%s.png' % res_dict['Artikelnummer'], 'wb') as f:
            #    f.write(response.body)

            yield res_dict


        else:
            # process error
            self.log('Error - unknown page type: %s' % response.url)
