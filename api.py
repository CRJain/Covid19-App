import flask
from flask import request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
from geopy.geocoders import Nominatim
import requests
import json
 
app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/', methods=['GET'])
def home():
    return '''<center><h1>COVID-19 Data Archive</h1></center><center><p><h3>An API for scraping COVID-19 recent data from web.</h3></p></center>'''

@app.route('/get_recent_data', methods=['GET'])
def get_recent_data():
    url = "https://www.covid19india.org/"
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)
    html_page = driver.page_source
    soup_data = BeautifulSoup(html_page, 'html5lib')
    html_table = soup_data.find_all('table')#, class_="table fadeInUp")
    world_data = {}
    world_data['States'] = []
    for tbody in html_table[0].find_all('tbody'):
        state = {}
        t_rows = tbody.find_all('tr')
        t_data = t_rows[0].find_all('td')
        state['Name'] = t_data[0].text
        rise = t_data[1].find('span')
        state['Rise'] = int(rise.text) if len(rise) else 0
        if len(rise):
            state['Confirmed'] = int(t_data[1].text[len(rise.text):]) if t_data[1].text != '-' else 0
        else:
            state['Confirmed'] = int(t_data[1].text) if t_data[1].text != '-' else 0
        state['Active'] = int(t_data[2].text) if t_data[2].text != '-' else 0
        state['Recovered'] = int(t_data[3].text) if t_data[3].text != '-' else 0
        state['Deceased'] = int(t_data[4].text) if t_data[4].text != '-' else 0
        if t_data[0].text != 'Total':
            state['Districts'] = []
            for data in t_rows[3:]:
                data = data.find_all('td')
                if len(data[0]):
                    district = {}
                    district['Name'] = data[0].text 
                    district['Confirmed'] = int(data[1].text)
                state['Districts'].append(district)
        world_data['States'].append(state)
    return jsonify(world_data)

@app.route('/get_city')
def reverseGeocode():
    geolocator = Nominatim()
    if 'lat' in request.args and 'lon' in request.args:
        location = geolocator.reverse(request.args['lat']+','+request.args['lon'])
        print(location)
        return jsonify({'City' : location.raw['address']['city']})
    else:
        return "Error: Please check latitude and longitude values"

app.run()