# RLADS  Final Project and Presentation

Authors: 戴若竹、余孟琦、洪智恆、林宣戎  
Date: 2021.06.17

**打算回答什麼問題？**
```
探討疫情期間確診病例數與股市之間各面向的關係
```
## 資料來源

美股
* 資料區間：2020/01/01~2021/04/30
* 美國病例數：Our World in Data，是英國牛津大學全球變化數據實驗室的科學出版物
* sp500各類股歷史資料：MarketWatch，是一個提供金融信息、商業新聞、分析和股市數據的網站，道瓊公司的子公司(sp500將美國產業分成11大類股)

台股
* 資料區間：2020/04/01~2021/05/31
* 台灣病例數：台灣疫情報告(https://covid-19.nchc.org.tw/dt_005-covidTable_taiwan.php)
* 使用r語言的quantmod包中的getSymbols函數擷取股價資料，資料來源自yahoo finance
* 類股指數資料來源：來自台灣證券交易所公布之3-5月資料

情緒分析  
* 

