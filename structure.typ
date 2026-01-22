// Frontmatter

#include "./preface/firstpage.typ"
#include "./preface/copyright.typ"
#include "./preface/dedication.typ"
#include "./preface/summary.typ"
#include "./preface/acknowledgements.typ"
#include "./preface/table-of-contents.typ"
// Mainmatter

#pagebreak(to:"odd")
#set page(numbering: "1")
#counter(page).update(1)

#include "./chapters/01-introduction.typ"
#include "./chapters/02-background.typ"
#include "./chapters/03-methodology.typ"
#include "./chapters/conclusion.typ"


// Bibliography
#include("./bibliography/bibliography.typ")


