# 汎用FAQ自動応答デモアプリ

このプロジェクトは、IBM Watson Natural Language Classifier (NLC) を使用したFAQ自動応答アプリです。

## 【実行環境】

- Runtime : Node-RED (Node.js)
- Services :
    - Cloudant NoSQL DB
    - Watson Natural Language Classifier

## 【環境構築手順】

1. ボイラープレート『Node-RED Starter』にて、ランタイムを作成する。
1. NLCサービスを作成し、ランタイムにバインドする。
1. 本プロジェクトをZIPでダウンロードし、ローカルPCに展開する。
1. 展開したディレクトリからcf push [app-name] でBluemixにデプロイする。
1. ランタイム起動後、『アプリの表示』ボタンにて、Node-REDアプリを起動する。
1. トップページ右側の赤いボタンより下の１～４の手順を実施する。
1. 環境が整ったのち、手順５でデモアプリを起動する。

## 【FAQデータ形式】

### 1. 回答データ

- JSON形式で定義します。データ項目はclass_name, answer, ref_url の3つです。
    - class_name : 一意なFAQのID
    - answer : 回答内容
    - ref_url : 詳細な内容に誘導するURL。URLが無い場合は""を指定する。
- 1つの回答データで、１対の{...}になります。データが複数ある場合は、コンマで区切ります。
    - {...}, {...}, ......
- utf-8で保存してください。

#### 設定例

~~~~
{ "class_name" : "FAQ001", "answer" : "よくある質問その１の回答です。詳細はURLをご参照ください。", "ref_url" : "http://www.foo.bar.com/faq/001"},
{ "class_name" : "FAQ002", "answer" : "よくある質問その２の回答です。詳細はURLをご参照ください。", "ref_url" : "http://www.foo.bar.com/faq/002"},
{ "class_name" : "FAQ003", "answer" : "最後の行の末尾にはコンマをつけないでください。", "ref_url" : ""}
~~~~

### 2. 質問データ

- CSV形式で定義します。データ項目は、質問文, class_name の２つです。
    - 質問文 : 回答を導き出すための質問を文章で登録します。
    - class_name : 回答データのclass_nameに対応します。
- 1つのFAQ-IDに複数の質問文を登録することで、Classifierの精度を高めることが出来ます。
- utf-8で保存してください。

#### 設定例

~~~~
回答データ001に対する質問文その１です, FAQ001
回答データ001に対する別の表現の質問文です, FAQ001
回答データ002用の質問文001, FAQ002
~~~~

### 【データの登録方法】

#### 1. 回答データの登録

1. JSON形式で回答データファイルを作成する。(utf-8)
1. Node-REDトップページにある手順3のリンクで登録画面を開き、回答データファイルを送信する。
1. 正常終了のメッセージ画面が表示すれば登録完了。
1. 登録エラーになった場合、Node-REDのフローエディタでdebugにエラーが出力されているか確認する。

#### 2. 質問データの登録

1. NLC ツールキット(ベータ版)を使用する場合
    1. BluemixコンソールからNLCサービスの管理画面に遷移し、『Access the beta toolkit』のボタンをクリック
    1. Login画面が表示された場合は、『Sign in with Bluemix』リンクをクリック
    1. ツールキット画面右上部にある『Training data』をクリック
    1. ファイルアップロードボタンを押し、質問データファイルを送信する
    1. ファイルの内容が画面に表示されたら、『Create classifier』ボタンをクリックして、Classifier名を指定する。
    1. 数分後にClassifiersが学習済みとなるので、表示されている『Classifier ID』のID番号をコピーする

1. コマンドライン(bash)を使用する場合
    1. Node-REDトップページの手順４のページで、1～4までのファイルをDLする。
    1. DLした『nlc.env』ファイルを開き、NLCの資格情報からusernameとpasswordを設定する。
    1. トレーニング実行コマンド『training.bash』に質問データファイルを引数にして実行する。
    1. 上記で表示されたClassifier IDを引数に、classifier.bashを実行し、statusが『Available』になれば、学習完了

### 【フロー定義】

- Node-REDフローエディタを開き、NLCノードのClassifier IDに学習済みのClassifier IDをセットしてDeployする
