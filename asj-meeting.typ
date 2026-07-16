// 日本音響学会研究発表会予稿用 Typst テンプレート
// onkoron.sty Ver.1.4 の寸法指定とコマンド再定義を基本とし，
// jarticle の既定値に依存する箇所を pLaTeX 版の PDF で確認している．

#import "@preview/js:0.1.3": js

#let non-cjk = regex("[\u0000-\u2023]")
#let serif-font = "New Computer Modern"
#let mincho-font = "Harano Aji Mincho"
#let sans-font = "New Computer Modern"
#let gothic-cjk-font = "Harano Aji Gothic"
#let body-font = ((name: serif-font, covers: non-cjk), mincho-font)
#let gothic-font = ((name: sans-font, covers: non-cjk), gothic-cjk-font)

// pLaTeX の和文 JFM では，10pt 指定時の全角幅が 9.5862pt になる．
// Typst の 1em は指定値どおりなので，和文の実寸を JFM に合わせる．
#let jfm-scale = 0.95862

#let heading-layout(it, size, above, below, number-gap) = {
  v(above, weak: true)

  let rendered = if it.numbering != none {
    context counter(heading).display(it.numbering) + h(1em + number-gap) + it.body
  } else {
    it.body
  }

  block(sticky: true, {
    set par(first-line-indent: 0pt, justify: false, leading: 0pt, spacing: 0pt)
    set text(
      font: gothic-font,
      size: size,
      weight: "medium",
      top-edge: 0.88em,
      bottom-edge: -0.12em,
    )
    rendered
  })

  v(below, weak: true)
}

// `\paragraph{...}` に相当する，番号なしの行内見出し．
#let run-in(title, body) = {
  v(20.449pt)
  set par(first-line-indent: 0pt)
  strong(title) + h(1em) + body
}

#let onkoron(
  title: none,
  authors: none,
  english-title: none,
  english-authors: none,
  body-size: 10pt,
  body,
) = {
  assert(
    body-size == 10pt or body-size == 11pt,
    message: "body-size は 10pt または 11pt を指定してください．",
  )

  // LaTeX の 11pt 指定では，実際の normalsize は 10.95pt になる．
  let normal-size = if body-size == 11pt { 10.95pt * jfm-scale } else { 10pt * jfm-scale }
  // 英文脚注の \small は欧文フォントの指定値をそのまま使う．
  let small-size = if body-size == 11pt { 10pt } else { 9pt }
  // 文字の実寸を縮めても，基準線間隔は 10pt 時 14.944pt，
  // 11pt 時 16.4pt のまま維持する．
  let baseline-skip = if body-size == 11pt { 16.4pt } else { 14.944pt }
  let cjk-height = 0.88
  // onkoron.sty は段落設定を jarticle に委ねており，jarticle の
  // \parskip は 0pt plus 1pt である．Typst には同じ可伸長グルーが
  // ないため，改段落では通常の行送りに 1pt の余裕を明示的に加える．
  let paragraph-spacing = baseline-skip - cjk-height * normal-size + 1pt
  let large-size = 12pt * jfm-scale
  let title-size = 14.4pt * jfm-scale

  js(
    lang: "ja",
    seriffont: serif-font,
    seriffont-cjk: mincho-font,
    sansfont: sans-font,
    sansfont-cjk: gothic-cjk-font,
    fontsize: normal-size,
    baselineskip: baseline-skip,
    non-cjk: non-cjk,
    cjkheight: cjk-height,
    {
      set document(title: title)
      // A4 幅 210mm から左余白 23mm と本文幅 165mm を引くと，
      // 右余白の実効値は 22mm になる．元スタイルのコメントよりも，
      // pLaTeX 版の実際の本文領域を優先する．
      set page(
        paper: "a4",
        margin: (
          top: 20mm,
          right: 22mm,
          bottom: 22mm,
          left: 23mm,
        ),
        columns: 2,
        numbering: none,
        header: none,
        footer: none,
      )
      set columns(gutter: 7mm)
      set par(spacing: paragraph-spacing)
      // js の本文ウェイト 450 に 50 を加え，強調を Medium にする．
      set strong(delta: 50)

      // 見出し前後の空きは，節が約 0.8行と0.5行，項と目が約
      // 0.5行と0.2行になるよう，pLaTeX 版で測定した位置に合わせる．
      show heading.where(level: 1): it => context {
        let number = counter(heading).get().at(0, default: 0)
        let above = if number == 1 { 18.238pt } else { 18.768pt }
        heading-layout(it, large-size, above, 12.6pt, 2.056pt)
      }
      show heading.where(level: 2): it => context {
        let number = counter(heading).get().at(1, default: 0)
        let above = if number == 1 { 12.599pt } else { 13.98pt }
        heading-layout(it, normal-size, above, 8.347pt, 2.428pt)
      }
      show heading.where(level: 3): it => heading-layout(
        it,
        normal-size,
        13.98pt,
        8.347pt,
        2.428pt,
      )
      set heading(numbering: "1.1.1")
      set math.equation(numbering: "(1)")
      // 数式への通常参照だけを番号表示に差し替え，番号の丸括弧を保つ．
      show ref: it => {
        let element = it.element
        if (
          it.form != "normal"
          or element == none
          or element.func() != math.equation
        ) {
          return it
        }
        link(
          element.location(),
          counter(math.equation).display(at: element.location()),
        )
      }

      // 図は下，表は上にキャプションを置く．番号との間を 1em 空け，
      // onkoron.sty と同じくコロンを挿入しない．
      set figure(gap: 10pt)
      set figure.caption(separator: h(1em))
      show figure.where(kind: image): set figure(supplement: [Fig.])
      show figure.where(kind: table): set figure(supplement: [Table])

      let english-note = if english-title != none or english-authors != none {
        [#english-title#h(0.4em)by#h(0.4em)#english-authors]
      } else {
        none
      }

      // page-level columns から段抜きするため，タイトルを親スコープの float にする．
      // 題目と著者の寸法はそれぞれ 14.4pt と 12pt を JFM 比で補正する．
      place(
        top + center,
        float: true,
        scope: "parent",
        block(width: 100%)[
          #set par(first-line-indent: 0pt, justify: false, spacing: 0pt)

          #v(4.49pt)
          #align(center)[
            #text(
              font: body-font,
              size: title-size,
              top-edge: 0.88em,
              bottom-edge: -0.12em,
            )[
              #title#if english-note != none {
                super(
                  typographic: false,
                  baseline: -0.08em,
                  size: 1em,
                  "*",
                )
              }
            ]
          ]
          #v(6.456pt)
          #align(center)[
            #text(
              font: body-font,
              size: large-size,
              top-edge: 0.88em,
              bottom-edge: -0.12em,
            )[#authors]
          ]
          #v(5.803pt)
        ],
      )

      // onkoron.sty の \thanks は保存先を一つだけ持つため，この関数も
      // タイトル用の英文脚注を一つだけ構成する．Typst の footnote は
      // float 内から脚注本文を生成できないため，英文脚注自体を
      // ページ下端の段抜き float として配置する．
      if english-note != none {
        place(
          bottom + left,
          float: true,
          scope: "parent",
          clearance: 3mm,
          move(
            dy: 7pt,
            block(width: 100%)[
              #line(length: 100%, stroke: 0.4pt)
              #v(-7pt)
              #grid(
                columns: (8.25mm, 1fr, 8.25mm),
                column-gutter: 0pt,
                align(
                  top + right,
                  move(
                    dx: -1.17pt,
                    dy: -2.574pt,
                    text(font: body-font, size: 7.63pt, "*"),
                  ),
                ),
                par(
                  first-line-indent: 0pt,
                  justify: true,
                  leading: 11pt - small-size,
                  spacing: 0pt,
                  text(
                    font: body-font,
                    size: small-size,
                    lang: "en",
                    top-edge: 0.88em,
                    bottom-edge: -0.12em,
                    english-note,
                  ),
                ),
                [],
              )
            ],
          ),
        )
      }

      v(0.62pt)
      body
    },
  )
}
