# pip install requests bs4

import subprocess

result = subprocess.run(
    ['curl', '-s', 'https://www.olx.in/items/q-car-cover'],
    capture_output=True,
    text=True
)
# print(result.stdout[:1000])

from bs4 import BeautifulSoup
html_content = result.stdout
soup = BeautifulSoup(html_content, 'html.parser')

table = soup.find('ul', attrs={'class': '_266Ly _10aCo'})

car_covers = []
for li in table.find_all('li', {'class' : '_1DNjI'}):
  cover = {}
  image = {}
  content = {}
  image['src'] = li.a.figure.img.attrs['src']
  image['alt'] = li.a.figure.img.attrs['alt']

  cover['image'] = image
  contentDiv = li.find('div', attrs={'class': 'fTZT3'})
  spans = contentDiv.find_all('span')
  # print(spans)
  for span in spans:
    if span.has_attr('data-aut-id'):
      content[span.attrs['data-aut-id']] = span.text
  cover['content'] = content
  cover['link'] = li.a.attrs['href']
  car_covers.append(cover)

import json
with open('car_covers.json', 'w') as json_file:
    json.dump(car_covers, json_file, indent=4)