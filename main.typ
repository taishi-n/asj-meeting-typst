#import "asj-meeting.typ": onkoron, run-in
#import "@preview/citrus:0.2.1": init-csl-json, csl-bibliography

#show: init-csl-json.with(
  read("references.json"),
  read("styles/ieee-ja.csl"),
)

#let figure-placeholder(width: 56mm, height: 28mm) = rect(
  width: width,
  height: height,
  stroke: 0.6pt,
  inset: 0pt,
  align(
    center + horizon,
    text(fill: luma(45%), size: 9pt, [Figure placeholder]),
  ),
)

// 以下のコード表示は，テンプレートの使い方を示す本サンプル固有の設定である．
#let code-non-cjk = regex("[\u0000-\u2023]")
#let code-font = (
  (name: "DejaVu Sans Mono", covers: code-non-cjk),
  "Harano Aji Gothic",
)

#show: onkoron.with(
  title: [Typstによる日本音響学会研究発表会予稿の作成例],
  authors: [○発表太郎，共著花子（音響大学）],
  english-title: [An example of an ASJ meeting paper prepared with Typst.],
  english-authors: [Taro HAPPYO and Hanako KYOCHOKU (Acoustics University)],
  body-size: 11pt,
)

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (bottom: 2pt),
  radius: 2pt,
)
#show raw.where(block: true): it => {
  set text(font: code-font, weight: "regular")
  show strong: it => text(
    font: code-font,
    weight: "regular",
    it.body,
  )
  it
}
#show raw.where(block: true): set block(
  width: 100%,
  fill: luma(240),
  inset: (x: 8pt, y: 6pt),
  radius: 4pt,
  above: 5pt,
  below: 8pt,
)

= テンプレートの構成

本ファイルは，日本音響学会研究発表会の予稿をTypstで作成するための使用例である．
原稿では`asj-meeting.typ`から`onkoron`と`run-in`を読み込み，文書全体に`onkoron.with`を適用する．

== 紙面と段組

テンプレートが設定するページサイズ，余白，段組を次に示す．
本文領域は幅165 mm，高さ255 mmであり，二段組の各段は幅79 mmになる．

#table(
  columns: (25mm, 1fr),
  stroke: none,
  inset: (x: 4pt, y: 2.5pt),
  table.hline(stroke: 0.8pt),
  [項目], [設定値],
  table.hline(stroke: 0.45pt),
  [用紙], [A4縦，210 mm × 297 mm],
  [本文領域], [165 mm × 255 mm],
  [余白], [上20 mm，下22 mm，左23 mm，右22 mm],
  [段組], [二段組],
  [段間], [7 mm],
  [一段の幅], [79 mm],
  [ページ番号], [表示しない],
  table.hline(stroke: 0.8pt),
)

本文文字サイズは`body-size`へ`11pt`または`10pt`を指定する．
和文の実寸はpLaTeXのJFMに合わせて指定値の0.95862倍とし，基線間隔は文字の実寸とは独立に固定する．

#table(
  columns: (1.4fr, 1fr, 1fr),
  stroke: none,
  inset: (x: 4pt, y: 2.5pt),
  table.hline(stroke: 0.8pt),
  [項目], [`11pt`指定], [`10pt`指定],
  table.hline(stroke: 0.45pt),
  [本文], [10.497 pt], [9.586 pt],
  [基線間隔], [16.4 pt], [14.944 pt],
  [題目], [13.804 pt], [13.804 pt],
  [著者，節見出し], [11.503 pt], [11.503 pt],
  [項，目見出し], [10.497 pt], [9.586 pt],
  [英文脚注], [10 pt], [9 pt],
  table.hline(stroke: 0.8pt),
)

行送りは隣接する基線間の距離であり，11 pt指定では16.4 pt，10 pt指定では14.944 ptである．
改段落では通常の行送りに1 ptの余裕を加え，段落先頭を一字下げる．

== 既定フォントと和欧文組版

本文，題目，著者では，欧文に`New Computer Modern`，和文に`Harano Aji Mincho`を使用する．
見出しと強調では，欧文に`New Computer Modern`，和文に`Harano Aji Gothic Medium`を使用する．
数式には`New Computer Modern Math`を使用する．

#table(
  columns: (1.2fr, 1fr),
  stroke: none,
  inset: (x: 4pt, y: 2.5pt),
  table.hline(stroke: 0.8pt),
  [用途], [フォント],
  table.hline(stroke: 0.45pt),
  [本文，題目，著者の欧文], [`New Computer Modern`],
  [本文，題目，著者の和文], [`Harano Aji Mincho`],
  [見出し，強調の欧文], [`New Computer Modern`],
  [見出し，強調の和文], [`Harano Aji Gothic Medium`],
  [サンプルコードの欧文], [`DejaVu Sans Mono`],
  [サンプルコードの和文], [`Harano Aji Gothic Regular`],
  table.hline(stroke: 0.8pt),
)

`asj-meeting.typ`は，UnicodeのU+0000からU+2023までに含まれる文字を欧文フォントへ割り当て，それ以外の和文文字を和文フォントへフォールバックさせる．
和文組版には`js`パッケージを使用し，文書の言語を日本語，和文字高を0.88 emに設定して，欧文と和文の間隔にはTypstの既定の自動調整を利用する．
和文の文字寸法は0.95862倍へ補正する一方，基線間隔を別に指定することで，pLaTeX版に近い文字高と行送りを両立させる．
数値と単位の間は，48 kHzや80 dBのように半角空白を明示する．

== 本文中のフォント変更

本文の一部分だけフォントを変更する場合は，欧文用と和文用のフォントを組にして`text`へ渡す．
次の例では，欧文を`Libertinus Serif`，和文を`Noto Serif CJK JP`へ変更する．

```typ
#let latin-range = regex("[\u0000-\u2023]")
#let alternate-font = (
  (name: "Libertinus Serif", covers: latin-range),
  "Noto Serif CJK JP",
)

#text(font: alternate-font)[
  この部分だけThe quick brown foxと書体を変更する．
]
```

複数の段落を一時的に変更する場合は，コードブロック内へ`set text`を置き，設定のスコープを限定する．

```typ
#{
  set text(font: alternate-font)
  [
    このブロック内だけ和文とLatin textの書体を変更する．

    ブロックを抜けるとテンプレートの既定書体へ戻る．
  ]
}
```

`#set text(font: alternate-font)`を原稿の途中へ直接置くと，その位置以降の通常本文へ設定が適用される．
局所設定は通常本文に対するものであり，テンプレートが個別に組む題目，著者，英文脚注，見出しの書体は変更しない．
題目など特定の引数だけを変更する場合は，`title: text(font: "Noto Serif CJK JP", [和文題目])`のように，引数の内容へ`text`を指定する．
指定したフォントは，コンパイル環境でTypstから参照できる状態にしておく必要がある．

== 題目と著者

和文題目，和文著者，英題，英文著者，本文文字サイズは，原稿冒頭の`onkoron.with`に指定する．
題目は本文幅165 mmを使う段抜きで中央配置し，著者もその下へ段抜きで中央配置する．
講演者を示す記号と所属の略称は，`authors`の本文へ直接記述する．

```typ
#show: onkoron.with(
  title: [和文題目],
  authors: [○発表太郎，共著花子（所属）],
  english-title: [English title.],
  english-authors: [Taro HAPPYO et al.],
  body-size: 11pt,
)
```

`english-title`または`english-authors`を指定すると，題目末尾にアスタリスクを付け，一ページ目の下端に英文脚注を表示する．
英文脚注は本文幅全体を使い，上側に長さ165 mmの罫線，左右に各8.25 mmの余白を設ける．
脚注本文は`english-title`，`by`，`english-authors`の順に組み，文字サイズは11 pt指定時に10 pt，10 pt指定時に9 ptとする．
題目用の英文脚注は一つだけであり，通常の本文脚注とは別に配置する．
`body-size`の標準は`11pt`とし，規定ページ数へ収める必要がある場合に限って`10pt`を使う．

== 見出しと本文

節，項，目はTypstの見出し記法で記述する．
テンプレートは見出しの階層に応じて`1`，`1.1`，`1.1.1`の形式で番号を付ける．

```typ
= 節見出し
== 項見出し
=== 目見出し
```

本文では，段落間に空行を置く．

= 図表と数式

== 一段幅の図

図はTypst標準の`figure`で配置する．
一段幅の図では`placement: top`または`placement: bottom`を指定し，図の後ろにラベルを付ける．
本文ではFig. @fig-single のように図番号を参照できる．
以下の枠は外部の画像ファイルを使わず，Typstの`rect`で生成したプレースホルダである．

#figure(
  kind: image,
  placement: top,
  figure-placeholder(),
  caption: [一段幅の図のプレースホルダ],
) <fig-single>

実際の画像を挿入する場合は，`image`に原稿からの相対パスを渡す．
`width`は段幅に対する比率または`mm`などの長さで指定できる．
PNG，JPEG，SVG，PDFなどの図版を同じ書き方で配置できる．

```typ
#figure(
  placement: top,
  image("figures/result.png", width: 90%),
  caption: [測定結果],
) <fig-result>
```

== 表

表は`table`を`figure`で包んで配置する．
テンプレートは表のキャプションを上側に置き，`Table 1`の形式で番号を付ける．
Table @tbl-condition は，三つの実験条件を記載した例である．

#figure(
  placement: top,
  table(
    columns: 3,
    stroke: none,
    inset: (x: 6pt, y: 2.5pt),
    table.hline(stroke: 0.8pt),
    [条件], [周波数], [音圧レベル],
    table.hline(stroke: 0.45pt),
    [A], [500 Hz], [60 dB],
    [B], [1 kHz], [70 dB],
    [C], [2 kHz], [80 dB],
    table.hline(stroke: 0.8pt),
  ),
  caption: [実験条件],
) <tbl-condition>

== 数式

ディスプレイ数式にはラベルを付けて参照できる．
次の式は，離散時間信号 $x(n)$ とインパルス応答 $h(k)$ の畳み込みを表す．

$
  y(n) = sum_(k=0)^(K - 1) h(k) x(n - k)
$ <eq-convolution>

式 @eq-convolution の番号は，テンプレートによって丸括弧付きで表示される．

== 段抜きの図

二段を通す図では，一段幅の指定に`scope: "parent"`を加える．
段抜き図は利用可能なページ上端へ配置されるため，本文中での指定位置と表示位置が離れる場合がある．

#figure(
  kind: image,
  placement: top,
  scope: "parent",
  figure-placeholder(width: 90mm, height: 24mm),
  caption: [二段を通す図のプレースホルダ],
) <fig-wide>

= 原稿末尾の要素

== 箇条書き

Typst標準の箇条書きと番号付き箇条書きを利用できる．
予稿を提出する前に，次の項目を確認する．

- 題目と著者名が演題登録の内容と一致している．
- 図表の文字を印刷時に判読できる．
- 本文からすべての図表と参考文献を参照している．
- 規定のページ数とPDFファイルサイズに収まっている．

== 参考文献

参考文献はCSL-JSON形式の`references.json`に登録し，本文から`@key`で引用する．
`citrus`は引用順に番号を割り当て，`csl-bibliography`の位置へ引用済みの文献だけを出力する．
表示にはIEEEを基にした`styles/ieee-ja.csl`を使用する．

各項目の `language` には `en` または `ja-JP` を指定する．登録例には，非負値行列因子分解の原論文 @lee1999nmf，信号処理の書籍 @oppenheim2010dsp，日本音響学会研究発表会の予稿 @Nakashima:2022:ASJ:S，Typst公式Webサイト @typst2026bibliography を使用した．

#run-in([謝辞])[本テンプレートの検証に協力いただいた関係者に感謝する．]

#csl-bibliography(
  title: heading(numbering: none, [参考文献]),
)
