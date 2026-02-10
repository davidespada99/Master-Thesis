#import "../config/constants.typ": figuresList, tablesList, acronymsList
#set page(numbering: "i")
#heading(level: 1, numbering: none, outlined: true)[#tablesList]
#outline(
    title: none,
    target: figure.where(kind: table),
    indent: auto
)
//new page
#pagebreak()

#heading(level: 1, numbering: none, outlined: true)[#figuresList]
#outline(
  title: none,
  target: figure.where(kind: image)
)

#pagebreak()

#let tab = context {
  let tab_left = 2.5cm // leftmost tab stop (i.e. page margin)
  let tab_width = 2.0cm // width of a single tab stop

  let pos = here().position() // caller position
  let column = 1 + calc.trunc( (pos.x - tab_left) / tab_width )   // column where this tab is located
  let advance_to = tab_left + column * tab_width   // position needed for the next tab stop

  // create box with the required width
  // the box requires visible content to actually occupy the correct width
  // for debug purposes we choose the computed column as content
  // box(width: advance_to - pos.x)[#text(size: 8pt, fill: purple)[#column]]
}
// Funzione per formattare gli acronimi con la sigla in grassetto
#let acronym(abbr, full) = {
  set par(spacing: 1.6em)
  [#grid(
    columns: (auto, auto, 10.5cm),
    text(weight: "bold")[#abbr],
    box(repeat[.]),
    full
  )]
}

#heading(level: 1, numbering: none, outlined: true)[#acronymsList]
#acronym("MQTT", "Message Queuing Telemetry Transport")
#acronym("CoAP", "Constrained Application Protocol")
#acronym("IoT", "Internet of Things")
#acronym("BLE", "Bluetooth Low Energy")
#acronym("LoRa", "Long Range")
#acronym("LoRaWAN", "Long Range Wide Area Network")
#acronym("NB-IoT", "Narrowband Internet of Things")
#acronym("6LoWPAN", "IPv6 over Low-Power Wireless Personal Area Networks")
#acronym("AES-CCM", "Advanced Encryption Standard - Counter with CBC-MAC")
#acronym("MAC", "Message Authentication Code")
#acronym("CSMA/CA", "Carrier Sense Multiple Access with Collision Avoidance")
#acronym("TCP", "Transmission Control Protocol")
#acronym("M2M", "Machine to Machine")
#acronym("IAM", "Identity Access Management")
#acronym("HA", "High Availability")
#acronym("RPL", "Routing Protocol for Low Power and Lossy Networks")
#acronym("IDS", "Intrusion Detection Systems")
#acronym("ReBAC", "Relationship-Based Access Control")
