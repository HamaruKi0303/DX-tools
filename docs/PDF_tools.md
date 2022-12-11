## Initialization

現状のフォルダを確認し，作業フォルダに移動します．

```python
!pwd
```
```bash
    /home/notebook
```


```python
%cd /home
```
```bash
    /home
```


```python
!ls
```
```bash
    Dockerfile  README.md  docker-compose.yml  notebook
    LICENSE     data       in_docker.bat
```

## Required packages


```python
import pandas as pd
from tabula.io import read_pdf
from loguru import logger
```

## Setting Param


```python
delivery_slip_path = "./data/002_delivery_slip/002_delivery_slip_v4.pdf"
pdf_csv_save_path  = "./data/002_delivery_slip/pdf_raw_csv_v4.csv"
```

## PDF scan

PDFをデータフレームのリストに変換


```python
# lattice=Trueでテーブルの軸線でセルを判定
dfs = read_pdf(delivery_slip_path, lattice=True, pages = 'all')
```
```bash
    Got stderr: Dec 11, 2022 11:16:51 AM org.apache.fontbox.ttf.CmapSubtable processSubtype14
    WARNING: Format 14 cmap table is not supported and will be ignored
    Dec 11, 2022 11:16:51 AM org.apache.fontbox.ttf.CmapSubtable processSubtype14
    WARNING: Format 14 cmap table is not supported and will be ignored
``` 


データフレームをマージ


```python
for i, df in enumerate(dfs):
    if(i==0):
        _df = df
        
    else:
        _df = _df.append(df)
```
```bash
    /tmp/ipykernel_190/572646924.py:6: FutureWarning: The frame.append method is deprecated and will be removed from pandas in a future version. Use pandas.concat instead.
      _df = _df.append(df)
    /tmp/ipykernel_190/572646924.py:6: FutureWarning: The frame.append method is deprecated and will be removed from pandas in a future version. Use pandas.concat instead.
      _df = _df.append(df)
```

番号のふり直し


```python
df_total =  _df.reset_index()
```

マージしたデータフレームを表示


```python
print(df_total)
```
```bash
         index         摘要   数量 単位     単価       金額  2022/10/3  2022/10/4  \
    0        0    Sample1  220  個    900  198,000         10         30   
    1        1    Sample2  200  個    600  120,000         10         30   
    2        2    Sample3  220  個    200   44,000         10         50   
    3        3    Sample4  240  個    300   72,000         30         50   
    4        4    Sample5  120  個    500   60,000         10         10   
    ..     ...        ...  ... ..    ...      ...        ...        ...   
    118     10  Sample119  190  個    900  171,000         10         10   
    119     11  Sample120  250  個    100   25,000         50         30   
    120     12  Sample121  230  個  1,000  230,000         30         30   
    121     13  Sample122  240  個    900  216,000         10         40   
    122     14  Sample123  250  個    800  200,000         40         10   
    
         2022/10/5  2022/10/6  2022/10/7  2022/10/8  2022/10/9  2022/10/10  
    0           50         30         30         20         30          20  
    1           40         30         30         20         20          20  
    2           30         30         10         30         40          20  
    3           10         30         30         10         40          40  
    4           10         40         10         10         10          20  
    ..         ...        ...        ...        ...        ...         ...  
    118         20         50         30         10         20          40  
    119         10         50         20         10         50          30  
    120         30         10         40         20         40          30  
    121         40         50         40         10         10          40  
    122         40         50         20         20         30          40  
    
    [123 rows x 14 columns]
```

マージしたデータフレームの統計量を表示


```python
print(df_total.describe())
```
```bash
                index          数量   2022/10/3   2022/10/4   2022/10/5   2022/10/6  \
    count  123.000000  123.000000  123.000000  123.000000  123.000000  123.000000   
    mean    16.219512  238.861789   29.024390   29.349593   30.325203   29.674797   
    std     10.475214   38.094000   15.063507   13.774521   12.990221   14.080271   
    min      0.000000  120.000000   10.000000   10.000000   10.000000   10.000000   
    25%      7.000000  210.000000   10.000000   20.000000   20.000000   20.000000   
    50%     15.000000  240.000000   30.000000   30.000000   30.000000   30.000000   
    75%     25.000000  260.000000   40.000000   40.000000   40.000000   40.000000   
    max     35.000000  350.000000   50.000000   50.000000   50.000000   50.000000   
    
            2022/10/7   2022/10/8   2022/10/9  2022/10/10  
    count  123.000000  123.000000  123.000000  123.000000  
    mean    29.918699   29.756098   31.056911   29.756098  
    std     14.054690   13.817512   13.599241   13.758063  
    min     10.000000   10.000000   10.000000   10.000000  
    25%     20.000000   20.000000   20.000000   20.000000  
    50%     30.000000   30.000000   30.000000   30.000000  
    75%     40.000000   40.000000   40.000000   40.000000  
    max     50.000000   50.000000   50.000000   50.000000  
```

## PDF class

pdf ファイルを読み込みcsvに変換するclassを作成しました．


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
