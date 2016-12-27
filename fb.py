#!/bin/python3
"""
Downloads all pictures from a public facebook page
"""
import requests, json, os

url = "{access_token}"

response = requests.get(url)
jdata = response.json()

path = "{path to store photos}"
files = os.listdir(path)

fileName = ''
url = ''

def download_image(fN, url):
    print(fN)
    f = open(fN, 'wb')
    f.write(requests.get(url).content)
    f.close()

for key, val in jdata.items():
    if key == "albums":
        for key1, val1 in val.items():
            if key1 == "data":
                for d in val1:
                    for key2, val2 in d.items():
                        if key2 == "photos":
                            for key3, val3 in val2.items():
                                if key3 == "data":
                                    for d1 in val3:
                                        for key4, val4 in d1.items():
                                            """GET ID"""
                                            if key4 == "id":
                                                fileName = ''.join([val4, ".jpg"])
                                            if key4 == "images":
                                                d2 = val4[0]
                                                for key5, val5 in d2.items():
                                                    if key5 == "source" and fileName not in files:
                                                        url = val5
                                                        download_image(fileName, url)



