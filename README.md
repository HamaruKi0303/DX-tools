# DX-tools

![](https://i.imgur.com/5TLFeAn.jpg)

# Index

- [Introduction](#introduction)
- [Updates!!](#updates)
- [Coming soon](#coming-soon)
- [Quick Start](#quick-start)
- [Detail](#detail)
  - [PDF class](#pdf-class)
- [Reference site](#reference-site)

## Introduction

DX-Toolを開発します．


## Updates!!
* 【2022/12/11】 PDFをCSVに変換する[NOTEBOOK](notebook\PDF_tools.ipynb)作成

## Coming soon
- [ ] HTMLダッシュボード
- [ ] アップロード機能
- [ ] スクリーニング機能
- [ ] 解析機能

## Quick Start

```bash
docker-compose up -d
```

## Detail



### PDF class

pdf ファイルを読み込みcsvに変換するclassを作成しました．

[notebook\PDF_tools.ipynb](notebook\PDF_tools.ipynb)


```python
class PdfReader:

    def __init__(self):
        self.dfs = None
        self.df_total = None

    def read(self, data_path):
        logger.info("read data_path : {}".format(data_path))
        self.dfs = read_pdf(data_path, lattice=True, pages = 'all')

    def merge(self):
        for i, df in enumerate(self.dfs):
            if(i==0):
                _df = df
            else:
                _df = pd.concat([_df, df])
        self.df_total =  _df.reset_index(drop=True)
    
    def get_df(self):
        return self.df_total
    
    def save_df(self, save_path):
        logger.info("save_pathh : {}".format(save_path))
        self.df_total.to_csv(save_path)
        
```

使用例


```python

delivery_slip_path = "./data/002_delivery_slip/002_delivery_slip_v4.pdf"
pdf_csv_save_path  = "./data/002_delivery_slip/pdf_raw_csv_v4.csv"


PReader = PdfReader()
PReader.read(data_path=delivery_slip_path)
PReader.merge()
pdf_df = PReader.get_df()
print(pdf_df)
PReader.save_df(save_path=pdf_csv_save_path)
```
```bash
    2022-12-11 13:40:37.141 | INFO     | __main__:read:8 - read data_path : ./data/002_delivery_slip/002_delivery_slip_v4.pdf
    Got stderr: Dec 11, 2022 1:40:38 PM org.apache.fontbox.ttf.CmapSubtable processSubtype14
    WARNING: Format 14 cmap table is not supported and will be ignored
    Dec 11, 2022 1:40:38 PM org.apache.fontbox.ttf.CmapSubtable processSubtype14
    WARNING: Format 14 cmap table is not supported and will be ignored
    
    2022-12-11 13:40:39.591 | INFO     | __main__:save_df:23 - save_pathh : ./data/002_delivery_slip/pdf_raw_csv_v4.csv


                摘要   数量 単位     単価       金額  2022/10/3  2022/10/4  2022/10/5  \
    0      Sample1  220  個    900  198,000         10         30         50   
    1      Sample2  200  個    600  120,000         10         30         40   
    2      Sample3  220  個    200   44,000         10         50         30   
    3      Sample4  240  個    300   72,000         30         50         10   
    4      Sample5  120  個    500   60,000         10         10         10   
    ..         ...  ... ..    ...      ...        ...        ...        ...   
    118  Sample119  190  個    900  171,000         10         10         20   
    119  Sample120  250  個    100   25,000         50         30         10   
    120  Sample121  230  個  1,000  230,000         30         30         30   
    121  Sample122  240  個    900  216,000         10         40         40   
    122  Sample123  250  個    800  200,000         40         10         40   
    
         2022/10/6  2022/10/7  2022/10/8  2022/10/9  2022/10/10  
    0           30         30         20         30          20  
    1           30         30         20         20          20  
    2           30         10         30         40          20  
    3           30         30         10         40          40  
    4           40         10         10         10          20  
    ..         ...        ...        ...        ...         ...  
    118         50         30         10         20          40  
    119         50         20         10         50          30  
    120         10         40         20         40          30  
    121         50         40         10         10          40  
    122         50         20         20         30          40  
    
    [123 rows x 13 columns]
```


## Reference site

