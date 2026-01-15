#import "../config/constants.typ": chapter
#import "../config/variables.typ": myName, myTitle, myLang,
#let config(
    myAuthor: myName,
    myTitle: myTitle,
    myLang: myLang,
    body
) = {
  // Set the document's basic properties.
    set document(author: myAuthor, title: myTitle)
    show math.equation: set text(weight: 400)

    // LaTeX look (secondo la doc di Typst)
    set page(margin: 1.3in, number-align: center)
    // set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
    set par(
        leading: 0.8em,
        spacing: 0.55em,
        first-line-indent: 1em,
        justify: true,
        )

    set text(
        font: "EB Garamond", 
        size: 10pt, 
        features: (onum: 1, liga: 1),
        lang: myLang,
        )

    set heading(numbering: "1.1.1.1")

    // "Source Code Pro" for code blocks
    show raw: set text(font: "Source Code Pro", size: 11pt, lang: myLang)

    show heading: set block(above: 1.5em, below: 1em)


    show heading: it => {
        if it.level == 1 {
            align(right, 
                stack(
                dir: ttb,
                spacing: 1em,
                if it.numbering != none {
                    text(size: 5em, fill: rgb("#B5001B"), features: (onum: 0, liga: 0))[#counter(heading).display("1")]
                },
                text(size: 1.8em, it.body),
                []
            ))
        }
        else if it.level == 2 {
            align(left, 
                stack(
                    dir: ltr,
                    spacing: 1.5em,
                    if it.numbering != none {
                        text(size: 1.3em, font: "EB Garamond", weight: "light",  features: (onum: 1, liga: 1))[#counter(heading).display("1.1")]
                    },
                    text(size: 1.3em, weight: "light")[#smallcaps(it.body)],
                ))
            v(0.8em)
        }
        else if it.level == 3 {
            align(left, 
            stack(
                dir: ltr,
                spacing: 1em,
                if it.numbering != none {
                    text(size: 1.2em, font: "EB Garamond", weight: "light",  features: (onum: 1, liga: 1))[#counter(heading).display("1.1")]
                },
                text(size: 1.2em, weight: "light")[#smallcaps(it.body)],
                []
            ))
        }
        else if it.level > 3 {
            align(left, 
            stack(
                dir: ltr,
                spacing: 1em,
                if it.numbering != none {
                    text(size: 1em, font: "EB Garamond", weight: "light",  features: (onum: 1, liga: 1))[#counter(heading).display("1.1")]
                },
                text(size: 1em, weight: "light")[#smallcaps(it.body)],
                []
            ))
        }

    }
    body
}

/// Generates a formatted use case documentation block.
///
/// This function creates a structured representation of a use case, displaying
/// its number and name as a title, followed by a two-column table containing
/// all additional details.
///
/// - useCaseDetails (dictionary): A dictionary containing use case information.
///   Must include "number" and "name" keys for the title. All other key-value
///   pairs will be displayed in the table as property-value rows.
///
/// Returns: A formatted content block with the use case title and details table.
///
/// Example:
/// ```typst
/// #useCase((
///   number: "01",
///   name: "User Login",
///   Actor: "User",
///   Precondition: "User has valid credentials",
///   Description: "User logs into the system"
/// ))
/// ```
#let useCase(useCaseDetails) = {
    let n = 1
    if useCaseDetails.number != "" and useCaseDetails.name != "" {
        text(12pt, [ *UC#useCaseDetails.number: #useCaseDetails.name* ])
    }
    let result = for (k, v) in useCaseDetails {
        if k != "number" and k != "name" {
            (text(k, weight: "bold"),
            v,)
        }
        n = n + 1
    }
    table(
        inset: 8pt,
        stroke: none,
        columns: 2,
        ..result
    )
}