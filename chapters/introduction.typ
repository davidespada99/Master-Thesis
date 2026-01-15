// Non su primo capitolo

= Introduction <cap:intro>

Introduzione al contesto applicativo.

// TODO: aggiungere riferimenti a:
// Termine nel glossario
// Citazione in linea
// Citazione nel pie' di pagina

Questo testo è in EB Garamond con numeri "old style": 1234567890.

```typst
// Questo codice sarà in Source Code Pro
fn main() {
    println!("Hello World");
}
```

== IoT Systems


=== Characteristics IoT Systems
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut 
labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris 
nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit 
esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in 
culpa qui officia deserunt mollit anim id est la

==== Scalability

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

== L'idea

Introduzione all'idea dello stage.

== Organizzazione del testo

#set par(first-line-indent: 0pt)
/ #link(<cap:processi-metodologie>)[Il secondo capitolo]: descrive.
/ #link(<cap:descrizione-stage>)[Il terzo capitolo]: descrive.
/ #link(<cap:progettazione-codifica>)[Il quarto capitolo]: descrive.
/ #link(<cap:verifica-validazione>)[Il quint capitolo]: descrive.
/ #link(<cap:conclusion>)[Il sesto capitolo]: descrive.


Riguardo la stesura del testo, relativamente al documento sono state adottate le seguenti convenzioni tipografiche:

- gli acronimi, le abbreviazioni e i termini ambigui o di uso non comune menzionati vengono definiti nel glossario, situato alla fine del presente documento;
- per la prima occorrenza dei termini riportati nel glossario viene utilizzata la seguente nomenclatura: _parola_ (glsfirstoccur);
- i termini in lingua straniera o facenti parti del gergo tecnico sono evidenziati con il carattere _corsivo_.

La bibliografia è gestita nel file `bibliography.typ` con il formato Bibtex. Per citare un elemento in bibliografia basta usare una semplice citazione `@citazione`, ad esempio per citare *il miglior libro di sempre* basta usare @p1 or @singh2023edge