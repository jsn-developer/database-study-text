# データベース基礎(データ投入編)

## レコードを挿入してみよう

### INSERT文の書き方

テーブルに値を挿入するには、INSERT文を発行します。

INSERT文の基本形は以下になります。

```sql
INSERT INTO テーブル名(カラム1, カラム2, ...) VALUES(値1, 値2, ...)
```

例として、以下のテーブルへ値を挿入してみましょう。

テーブル名: SAMPLETABLE

|カラム名|型|
|:-:|:-:|
|ID|INTEGER |
|NAME|VARCHAR(20) |  

このテーブルに挿入するSQL文は以下になります。

```sql
INSERT INTO SAMPLETABLE(ID, NAME) VALUES(1, 'スマートフォン')
```

## フィールドの制限を掛ける

テーブルを作成する際、登録できるデータに制限を設けることができます。
このセクションでは、それぞれの意味と書き方を解説します。

### NOT NULL

NOT NULLは、その名の通りNULLを非許容とします。
データベースに登録する際に、そのカラムに値がないとエラーとなります。

```sql
CREATE TABLE TABLE1 (
    COLUMN INTEGER NOT NULL
)
```

### DEFAULT

DEFAULT使用することで、デフォルトとして登録する値を設定できます。
例えば、以下のようなSQL文を発行したとします。

```sql
CREATE TABLE TABLE1 (
    COLUMN INTEGER DEFAULT 0
)
```

この場合、INSERTする際にCOLUMNを空で登録すると、自動で0が登録されます。  
自動で値が登録されますので、自動で0が入るようなフラグ管理などに使用出来ます。

### UNIQUE

UNIQUEは「そのテーブル内で一意である」ことを示します。

例えば、以下のようなテーブルを作成したとします。

```sql
CREATE TABLE TABLE1 (
    COLUMN INTEGER UNIQUE
)
```

この場合、COLUMNの値はテーブル内で一意とする必要がありますので、
同じ数字は2つ以上存在できません。

すでにCOLUMN=1という行が存在する場合、
COLUMN=1となる値を登録することは出来ず一意制約エラーとなります。

### 主キー(Primary Key)

主キーは、テーブルの行を一意に識別するためのカラムです。

例えば、社員情報であれば社員コードといったようにそのテーブル内で
必ず一意となるようにする必要があります。

また、主キーは必ず1つである必要はなく、複数の主キーをもつテーブルを作成することも可能です。

さて、ここまでの説明だとUNIQUEとあまり違いがあるように見えません。
違いは何なのでしょうか。

仕様上の大きな違いは「UNIQUEはNULLを許容する」ことにあります。

そのため、実質的な利用方法を考慮すると以下のINSERTで作成した2カラムはほぼ同じ意味を持ちます。

```sql
CREATE TABLE TABLE1 (
    PKEY INTEGER PRIMARY KEY,
    UNIQ INTEGER UNIQUE NOT NULL
)
```

ただし、前述の通り主キーは複数指定することができます。
そのため、下記のような値を設定することができます。

```sql
CREATE TABLE TABLE1 (
    PKEY1 INTEGER PRIMARY KEY,
    PKEY2 INTEGER PRIMARY KEY,
    UNIQ INTEGER UNIQUE NOT NULL
)
```

この時、以下のような値構造を持つことができます。

| PKEY1 | PKEY2 | UNIQ |
|-:|-:|-:|
|1|1|1|
|1|2|2|
|2|1|3|

単体ではPKEY1は一意とする必要がありますが、
PKEY2も主キーとしたことで、  
PKEY1とPKEY2の組み合わせで一意となれば一意制約エラーとはなりません。

### 連番

値を設定する際に、1または任意の数字から始まる連番を設定することができます。  
今回は、MariaDB用の連番の指定方法を紹介しますが、
データベースの種類によって連番の設定方法が異なりますのでご注意ください。

```sql
CREATE TABLE TABLE1 (
    PKEY1 INTEGER PRIMARY KEY AUTO_INCREMENT,
    NAME VARCHAR(100)
)
```

さて、この状態で以下のSQLを使用して挿入を行います。

```sql
INSERT INTO TABLE1 (NAME), VALUES('スマートフォン')
```

そうすると、以下のようにテーブルに登録されます。

| PKEY1 | NAME |
|-:|:-:|
|1|スマートフォン|

このように、自動で「PKEY1」に1が挿入されます。
なお、もう一度INSERTを実行すると今度はPKEY1に2が挿入されます。

