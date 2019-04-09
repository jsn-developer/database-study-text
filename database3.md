# データベース基礎(使用編)

## レコードを抽出する

### SELECT文の基本

データベースから値を取得するには、SELECT文を使用します。

SELECTは以下のルールに則って記述します。

```sql
SELECT カラム名1, カラム名2, ... FROM %テーブル名
```

例として、以下のような家財テーブルからの取得を想定します。

テーブル名：KAZAI

| ID | NAME | TYPE | PRICE |
|----|-----|-----|---|
|1 | 扇風機 | 家電|13000|
|2 | 冷蔵庫 | 家電 |98000|
|3 | スマートフォン | 電話|32000|
|4 | 枕 | 寝具|1980|

これらのすべての情報を取得する場合のSQLが以下になります。

```sql
SELECT ID, NAME, TYPE FROM KAZAI
```

#### 全てのカラムを取得する

テーブルを取得する際、カラム名を指定せず'*'を指定することで、
すべてのカラムを取得することが出来ます。

以下のようなSQL文を発行することで、KAZAIテーブルの全カラムを取得します。

```sql
SELECT * FROM KAZAI
```

### 条件を指定する

前項にて取得するための条件を紹介しましたが、<br>
実際の利用時には絞り込んで検索をする必要が出てきます。

以下に、条件を指定して検索するための方法を記載します。

#### WHERE句

検索条件を指定することを明示するために付与する語句で、
この語句の後に各条件を指定します。

#### 完全一致

特定のカラムの値が完全一致する場合、'=' で繋いで表記します。

例えば、価格が98,000円である家財を検索する場合、以下のようになります。

```sql
SELECT * FROM KAZAI WHERE PRICE = 98000
```

#### いずれかに完全一致(IN)

特定のカラムの値が、複数条件のどれかに含まれるレコードを検索したい場合、IN句を使用します。

例えば、種別が家電もしくは電話を検索したい場合、以下のようになります。

```sql
SELECT * FROM KAZAI WHERE TYPE IN ('家電', '電話')
```

#### 部分一致(LIKE)

特定のカラムの値が部分一致するレコードを検索したい場合、LIKE句を使用します。

例えば、名前が「スマート」で始まるレコードを取得する場合、以下のようになります。

```sql
SELECT * FROM KAZAI WHERE NAME LIKE 'スマート%'
```

##### ワイルドカードと前方一致・後方一致

SQLでワイルドカードを使用する場合、「%」の文字を使用します。

例えば、上記の例では、「スマート」の後ろに「%」を付与していますので、
「スマート」以降がワイルドカードとして指定されます。

なお、「%フォン」と指定することで、
「フォン」で終わるような後方一致を指定することができます。

#### 範囲指定(BETWEEN)

BETWEEN句は、AからBの間というような指定の際に使用します。

例えば、価格が10000~12000の間にある商品を取得する場合、
以下のようなSQL文を記載します。

```sql
SELECT * FROM KAZAI WHERE PRICE BETWEEN 10000 AND 12000
```

なお、上記の場合、
価格 ≧ 10000 かつ 価格 ≦ 12000 となる検索を実行します。

### 並び変えと件数制限

SQLでは、検索した結果を並び替えることが出来ます。

#### 取得順序(ORDER BY)

指定した項目を昇順、または降順で並べ替えた状態で取得したい場合、
ORDER BY句を使用します。

例えば、IDの昇順で並び替えたい場合、以下のようになります。

```sql
SELECT * FROM KAZAI ORDER BY ID ASC
```

カラム名の後ろに、昇順(ASC)または降順(DESC)を指定するのがポイントです。
<br>なお、省略することも可能ですが、その場合は自動で昇順が指定されます。

また、以下のように条件は複数個指定することもできます。

```sql
SELECT * FROM KAZAI ORDER BY PRICE DESC, Name
```

この場合、価格の降順(高いものが上位に来る)で取得し、
同じ価格のレコードがあった場合、名前の昇順で並び替えられます。

#### 最大件数(LIMIT)と開始位置(OFFSET)

検索結果のレコードが何千となるようなレコードを取得する場合、<br>
一度に全件を取得すると処理速度の低下やメモリ枯渇の問題が発生します。

そのため、ページングを適用することで処理速度の低下を防ぎます。

例えば、100レコード目から200レコード目を取得する場合、以下のようになります。

```sql
SELECT * FROM KAZAI WHERE ・・・ LIMIT 100 OFFSET 100
```

LIMITは取得件数、OFFSETは開始位置を指定します。
この場合、100件目～200件目を取得するため、100件目から100件を取得する、記載をします。

## レコードの更新と削除

### 更新

レコードを更新するには、UPDATE文を使用します。<br>
基本構文は以下になります。

```sql
UPDATE テーブル SET カラム名1=値1, カラム名2=値2, ... WHERE 条件
```

例として、ID=1のレコードを更新するSQL文は以下になります。

```sql
UPDATE KAZAI SET NAME=エアコン WHERE ID=1
```

### 削除

レコードを削除するには、DELETE文を使用します。<br>
基本構文は以下になります。

```sql
DELETE FROM テーブル名 WHERE 条件
```

例として、ID=3のレコードを削除するSQL文は以下になります。

```sql
DELETE FROM KAZAI WHERE ID=3
```

## テーブルの結合をする

これまでは単一のテーブルに対しての操作を学習してきましたが、
本項目では複数のテーブルに跨いだ検索について学びます。

### テーブルの結合とは

SQLを用いてレコードを取得する際、例えば以下のような2つのテーブルがあったとします。

**担当者テーブル**

|ID | 氏名 | 会社ID |
|---| ----|---|
|1 | 佐藤太郎 | 1 |
|2 | 小林次郎 | 2 |
|3 | 田中三郎 | 2 |
|4 | 山本四郎 | 0 |

**取引先テーブル**

|会社ID | 会社名 | 住所 |
|---|---|---|
|1  | 株式会社○× | 東京都渋谷区・・・|
|2  | ABC(株) | 東京都千代田区・・・|
|3  | (株)XYZ | 東京都港区・・・

このとき、取引先の会社情報とセットにして担当者のレコードを取得したいと考えています。

その場合、以下のようなSQLを発行することで2つのテーブルをまとめて検索できます。

例えば、上記の２テーブルから以下のような検索結果を得ることができます。

|ID|氏名|会社名|住所|
|--|--|--|--|
|1 | 佐藤太郎 |  株式会社○× | 東京都港区・・・|
|2 | 小林次郎 |  ABC(株) | 東京都千代田区・・・|
|3 | 田中三郎 |  ABC(株) | 東京都千代田区・・・|

### 内部結合と外部結合

テーブルを結合する場合、「内部結合」と「外部結合」という2つの結合方法があります。<br>
取得したいデータの取り方に応じて適宜使い分けを行います。

#### 内部結合

内部結合は、結合する２つのテーブル指定したカラムの情報があるレコードを取得します。

以下のSQLを発行することで、<br>
先ほど例として挙げた検索結果を取得をすることが出来ます。

```sql
SELECT
    ID, 担当者.氏名, 取引先.会社名, 取引先.住所
FROM
    担当者 INNER JOIN 取引先 ON 担当者.会社ID=取引先.会社ID
```

ポイントとして、

- 結合する２つのテーブルの結合条件に合致しないレコードは検索されない

ということにあります。
<br>
データ上、「山本四郎」のレコードは担当者レコードに存在しますが、
取引先に対応するレコードが存在しないため、レコードは取得されません。

#### 外部結合

外部結合は、内部結合と違いどちらかにしかないデータも取得されます。
<br>
例えば、以下のようなSQLを発行したとします。

```sql
SELECT
    ID, 担当者.氏名, 取引先.会社名, 取引先.住所
FROM
    担当者 LEFT OUTER JOIN 取引先 ON 担当者.会社ID=取引先.会社ID
```

すると、以下のような検索結果を得ることが出来ます。

|ID|氏名|会社名|住所|
|--|--|--|--|
|1 | 佐藤太郎 |  株式会社○× | 東京都港区・・・|
|2 | 小林次郎 |  ABC(株) | 東京都千代田区・・・|
|3 | 田中三郎 |  ABC(株) | 東京都千代田区・・・|
|4 | 山本四郎 | _NULL_ | _NULL_ |

内部結合の場合と違い、取引先にレコードのない「山本四郎」のレコードを取得することが出来ました。
<br>
ただし、対応する取引先のデータはないため、対応するカラムにはNULLが入ります。

一方、担当者が存在しない「(株)XYZ」のレコードは取得されませんでした。

次に、以下のようなSQLを発行してみます。

```sql
SELECT
    ID, 担当者.氏名, 取引先.会社名, 取引先.住所
FROM
    担当者 RIGHT OUTER JOIN 取引先 ON 担当者.会社ID=取引先.会社ID
```

すると、以下のような検索結果を取得することが出来ます。

|ID|氏名|会社名|住所|
|--|--|--|--|
|1 | 佐藤太郎 |  株式会社○× | 東京都港区・・・|
|2 | 小林次郎 |  ABC(株) | 東京都千代田区・・・|
|3 | 田中三郎 |  ABC(株) | 東京都千代田区・・・|
|_NULL_ | _NULL_ | (株)XYZ | 東京都港区・・・|

今度は担当者の存在しない（株）XYZの情報が取得できましたが、
「山本四郎」のデータは取得できませんでした。

ほとんど同じSQL文ですが、結合するテーブルの条件を変更しています。

- LEFT OUTER
- RIGHT OUTER

上記のSQLでは、どちらも担当者を基準に取引先を結合しています。
<br>
この結合元のテーブルを左、結合するテーブルを右とし、
どちらが基準になるのかを決めています。

#### UNION

外部結合の項では、LEFT OUTERとRIGHT OUTERで取得できるレコードに差が出ることを学びました。

次に、それぞれで取得できるレコードの両方を取得したい場合について学びます。

複数のSELECTを結合する方法として、「UNION」という手法があります。
<br>
前述の２つのSQLをUNIONすることで、結果がマージされた形で検索結果を得ることが出来ます。

```sql
SELECT
    ID, 担当者.氏名, 取引先.会社名, 取引先.住所
FROM
    担当者 LEFT OUTER JOIN 取引先 ON 担当者.会社ID=取引先.会社ID

UNION

SELECT
    ID, 担当者.氏名, 取引先.会社名, 取引先.住所
FROM
    担当者 RIGHT OUTER JOIN 取引先 ON 担当者.会社ID=取引先.会社ID
```

すると、以下のような検索結果を取得することが出来ます。

|ID|氏名|会社名|住所|
|--|--|--|--|
|1 | 佐藤太郎 |  株式会社○× | 東京都港区・・・|
|2 | 小林次郎 |  ABC(株) | 東京都千代田区・・・|
|3 | 田中三郎 |  ABC(株) | 東京都千代田区・・・|
|4 | 山本四郎 | _NULL_ | _NULL_ |
|_NULL_ | _NULL_ | (株)XYZ | 東京都港区・・・|

UNIONを使用することで、２つのクエリの検索結果を結合することが出来ます。
<br>
また、検索結果が重複する場合、そのレコードは1回のみ出力されます。

### 外部キー制約