import requests
import pandas as pd
from bs4 import BeautifulSoup


#today's exchange rate

currency = ['USD','EUR','JPY']
pageNo = [1,24,25]

dates = []
rates = []
currencies = []

for i in currency:
    for page in pageNo:

        url = 'https://finance.naver.com/marketindex/exchangeDailyQuote.nhn?marketindexCd=FX_'+i+'KRW&page='+str(page)
        #print(url)
        response = requests.get(url).text
        soup = BeautifulSoup(response, 'html.parser')

        for date in soup.find_all("td", class_="date"):
            rate = date.parent.find_all('td')[1]  # last cell in the row
            dates.append(date.get_text())
            rates.append(rate.get_text())
            currencies.append(str(i))
#print(dates, rates)

lists = {'dates': dates, 'rates': rates, 'currencies': currencies}
df = pd.DataFrame(lists)
pd.set_option('display.max_rows', 100)
print(df)

