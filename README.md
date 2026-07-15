# asj-meeting-typst

`asj-meeting-typst`は，日本音響学会研究発表会の予稿をTypstで作成するための非公式テンプレートです．
A4判二段組，段抜きの題目と著者，英文脚注，見出し番号，図表番号など，研究発表会予稿の基本的な紙面を提供します．

> [!CAUTION]
> このテンプレートは，日本音響学会が公開，提供，保守する公式テンプレートではありません．
> 原稿を提出する前に，日本音響学会が公開する最新の講演募集と原稿作成要領を確認してください．

## 特長

- A4判，本文幅165 mm，二段組，段間7 mmの紙面を設定します．
- 本文文字サイズは11 ptと10 ptから選択できます．
- 和文題目と著者を段抜きで配置し，英題と英文著者を一ページ目の下端へ表示します．
- 節，項，目を`1`，`1.1`，`1.1.1`の形式で番号付けします．
- 図を`Fig.`，表を`Table`の接頭辞で番号付けします．
- 日本語と英語が混在する参考文献をCSL-JSONから生成できます．

## 必要な環境

サンプルはTypst 0.15.0で検証しています．
次のフォントをあらかじめインストールしてください．

- `New Computer Modern`
- [`Harano Aji Mincho`](https://github.com/trueroad/HaranoAjiFonts)
- [`Harano Aji Gothic`](https://github.com/trueroad/HaranoAjiFonts)

テンプレートは和欧文混在の基本組版に[`js` 0.1.3](https://typst.app/universe/package/js/)を使用します．
サンプル原稿は参考文献の処理に[`citrus` 0.2.1](https://typst.app/universe/package/citrus/)を使用します．
Typstは初回コンパイル時にこれらの依存パッケージを取得します．

## 導入

このテンプレートは，現時点ではTypst Universeへ公開していません．
リポジトリをクローンし，ローカルファイルとして読み込みます．

```console
git clone https://github.com/taishi-n/asj-meeting-typst.git
cd asj-meeting-typst
typst compile main.typ
```

コンパイルが完了すると，リポジトリのルートに`main.pdf`が生成されます．
編集中のPDFを自動更新する場合は，次のコマンドを使用します．

```console
typst watch main.typ
```

## 最小構成

原稿から`asj-meeting.typ`の`onkoron`と`run-in`を読み込み，`onkoron.with`を文書全体へ適用します．

```typst
#import "asj-meeting.typ": onkoron, run-in

#show: onkoron.with(
  title: [和文題目],
  authors: [○発表太郎，共著花子（所属略称）],
  english-title: [English title.],
  english-authors: [Taro HAPPYO and Hanako KYOCHOKU (Affiliation)],
  body-size: 11pt,
)

= はじめに

ここに本文を記述する．

#run-in([謝辞])[ここに謝辞を記述する．]
```

講演者を示す○，◎，☆，△などの記号と所属の略称は，`authors`へ直接記述します．
`english-title`または`english-authors`を指定すると，題目末尾のアスタリスクと一ページ目下端の英文脚注が表示されます．
題目用の英文脚注は一つだけ指定でき，通常の本文脚注にはTypst標準の`footnote`を使用します．

## API

### `onkoron`

`onkoron`は，題目情報と本文文字サイズを受け取り，研究発表会予稿の紙面を文書全体へ適用する関数です．

| 引数 | 型 | 既定値 | 内容 |
|---|---|---|---|
| `title` | `content`または`none` | `none` | 和文題目 |
| `authors` | `content`または`none` | `none` | 和文著者と所属 |
| `english-title` | `content`または`none` | `none` | 英題 |
| `english-authors` | `content`または`none` | `none` | 英文著者と英文所属 |
| `body-size` | `length` | `11pt` | 本文文字サイズ．`11pt`または`10pt` |

`body-size`へ指定できる値は`11pt`と`10pt`だけです．
標準は`11pt`とし，規定ページ数に収まらない場合に`10pt`を使用します．

### `run-in`

`run-in(title, body)`は，LaTeXの番号なし`\paragraph`に相当する行内見出しを出力します．
謝辞のように節番号を付けない短い項目へ使用します．

```typst
#run-in([謝辞])[本研究に協力いただいた関係者に感謝する．]
```

## 見出しと数式

節，項，目にはTypst標準の見出し記法を使用します．

```typst
= 節見出し
== 項見出し
=== 目見出し
```

番号と見出し本文の間には1 emの空きを置きます．
節見出しの前後には約0.8行と0.5行，項見出しと目見出しの前後には約0.5行と0.2行の空きを置きます．

ディスプレイ数式には丸括弧付きの番号が割り当てられます．
ラベルを付けると，本文から丸括弧付きの数式番号を参照できます．

```typst
$
  y(n) = sum_(k=0)^(K - 1) h(k) x(n - k)
$ <eq-convolution>

式 @eq-convolution に畳み込みを示す．
```

## 図表

一段幅の図にはTypst標準の`figure`を使用します．
図のキャプションは図版の下へ配置されます．
図表番号とキャプションの間には1 emの空きを置き，コロンは挿入しません．
一行に収まるキャプションは中央配置し，長いキャプションは利用可能な幅で折り返します．

```typst
#figure(
  placement: top,
  image("figures/result.png", width: 90%),
  caption: [測定結果],
) <fig-result>
```

二段を通す図では，`scope: "parent"`を追加します．

```typst
#figure(
  placement: top,
  scope: "parent",
  image("figures/result-wide.pdf", width: 80%),
  caption: [二段幅の測定結果],
) <fig-result-wide>
```

表は`table`を`figure`で包みます．
表のキャプションは表の上へ配置されます．

```typst
#figure(
  placement: top,
  table(
    columns: 2,
    [条件], [値],
    [標本化周波数], [48 kHz],
  ),
  caption: [実験条件],
) <tbl-condition>
```

## 参考文献

サンプルは書誌情報を`references.json`へCSL-JSON形式で記録し，`citrus`で引用と参考文献一覧を生成します．
表示にはIEEEスタイルを基に日本語レイアウトを加えた`styles/ieee-ja.csl`を使用します．
参考文献一覧の文字サイズは本文と同じであり，本文中の引用番号は一律に上付きへ変更しません．

```typst
#import "asj-meeting.typ": onkoron, run-in
#import "@preview/citrus:0.2.1": init-csl-json, csl-bibliography

#show: init-csl-json.with(
  read("references.json"),
  read("styles/ieee-ja.csl"),
)

#show: onkoron.with(
  title: [和文題目],
  authors: [○発表太郎（所属略称）],
  english-title: [English title.],
  english-authors: [Taro HAPPYO (Affiliation)],
)

先行研究 @lee1999nmf に基づいて評価する．

#csl-bibliography(
  title: heading(numbering: none, [参考文献]),
)
```

各書誌項目の`language`には，日本語文献なら`ja-JP`，英語文献なら`en`を指定します．
`citrus`はこの値に従って，日本語用と英語用のCSLレイアウトを切り替えます．
`styles/ieee-ja.csl`は，和文と欧文が混在する参考文献でも隣接項目の字面が重ならない項目間隔を設定しています．
登録例は[`references.json`](references.json)を参照してください．

## サンプル原稿

[`main.typ`](main.typ)には，題目，見出し，図表，数式，参考文献を含む使用例を収録しています．
サンプル内の図は外部画像を必要としないプレースホルダとして生成しています．
コード表示の背景，余白，等幅フォントは`main.typ`だけに定義しているため，実際の原稿では削除または変更できます．

## 紙面仕様と実装

このテンプレートは，日本音響学会が配布する[`onkoron.sty` Ver.1.4](https://acoustics.jp/cms/wp_asj/wp-content/uploads/2019/02/genkou-kit_shift-JIS.zip)と見本原稿を参考に作成しました．
配布元は，日本音響学会の[発表原稿テンプレート・スタイルファイル](https://acoustics.jp/annualmeeting/)です．
紙面仕様は`onkoron.sty`の寸法指定とコマンド再定義を基本とし，`jarticle`の既定値に依存する箇所を，`sample.tex`をpLaTeX，DVI，dvipdfmxの順に処理したPDFで確認しました．
移植元のファイルは，仕様の抽出と比較検証を完了した後に削除しています．

`onkoron.sty`のコメントでは左右余白を23 mmに統一していますが，A4の幅210 mm，左余白23 mm，本文幅165 mmから求めた右余白の実効値は22 mmです．
生成したpLaTeX版でも本文は左端23 mmから右端188 mmまでに配置されていたため，Typst版は右余白を22 mmに設定しています．

[`js` 0.1.3](https://typst.app/universe/package/js/)は，`jsarticle`と`jsbook`の作者によるTypst向け実装であり，和欧文フォントの切り替え，本文の行送り，字下げなどの一般的な和文組版を担当します．
[`asj-meeting.typ`](asj-meeting.typ)は，日本音響学会固有の余白，段組，題目，英文脚注，見出し間隔，図表表記を定義します．
会議原稿全体の構成を提供する[`jaconf`](https://typst.app/universe/package/jaconf/)も候補になりますが，このテンプレートでは`onkoron.sty`の寸法を重ねやすい基礎パッケージとして`js`を採用しています．

LaTeX版の主要な記法とTypst版の対応は次のとおりです．

| LaTeX | Typst |
|---|---|
| `\title{...\thanks{...}}` | `title`，`english-title`，`english-authors` |
| `\author{...}` | `authors` |
| `\section`，`\subsection`，`\subsubsection` | `=`，`==`，`===` |
| `figure` | `figure`と`placement` |
| `figure*` | `figure`と`scope: "parent"` |
| `table` | `figure(table(...))` |
| `\paragraph{謝辞}` | `run-in([謝辞])[...]` |
| `thebibliography` | `references.json`，`citrus`，`styles/ieee-ja.csl` |

## 移植時の検証

移植時には，LaTeX版とTypst版へ同じ本文と同じSVG図版を与え，両方のPDFを120 dpiの画像へ変換して左右比較画像と差分画像を確認しました．
10 pt版では，本文の和文字高は両方とも9.5862 pt，本文の基線間隔は両方とも14.944 ptでした．
先頭の節見出しはpLaTeX版のy = 113.748920 ptに対してTypst版がy = 113.748833 ptであり，差は0.000087 ptでした．
本文中の代表的な見出しと本文先頭も，おおむね0.01 pt以内に収まりました．

TypstとpLaTeXでは行分割とフロート配置の処理が異なるため，同じ文章でもすべての改行位置が一致するとは限りません．
フォントのグリフ幅と禁則処理にも差があるため，一部の改行位置と字面には差が残りますが，行数，基線格子，図表の縦位置はpLaTeX版へ合わせています．
提出前には，生成したPDFを日本音響学会の最新の原稿作成要領と照合してください．

## ファイル構成

| パス | 内容 |
|---|---|
| `asj-meeting.typ` | 予稿の紙面を定義するテンプレート |
| `main.typ` | 編集を始めるためのサンプル原稿 |
| `references.json` | CSL-JSON形式の書誌情報 |
| `styles/ieee-ja.csl` | 日本語と英語が混在する参考文献用CSLスタイル |

## ライセンス

このリポジトリで独自に作成したソースコードと文書は，[BSD 2-Clause License](LICENSE)で提供します．
改変と再配布では，著作権表示，ライセンス条項，免責事項を保持してください．

`styles/ieee-ja.csl`には，派生元と同じ[CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)が適用されます．
派生元のクレジットと個別のライセンスは[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)に記載しています．
