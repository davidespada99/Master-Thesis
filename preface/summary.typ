#import "../config/constants.typ": abstract
#set page(numbering: "i")
//#counter(page).update(1)

#heading(level: 1, numbering: none, outlined: true)[
  #text(weight: "regular", 1em)[Abstract]
]

#v(2em)
#set par(first-line-indent: 0pt)

In the past decades, since the introduction of the Internet of Things (IoT) paradigm, the number of connected devices has grown exponentially. 
// The purpose of the IoT is to connect everyday objects to the internet and allowing for a wide range of applications that improve efficiency and quality of life through automation and remote control. 
These applications now dominate our everyday life across multiple domains, such as smart homes, healthcare or industrial automation. \
This growth has proceeded hand in hand with the development of various protocols to support different requirements.  However, this technological variety introduces significant architectural fragmentation, which may limit interoperability.\
Moreover, the nature of some IoT applications has raised significant security and privacy concerns, especially with regard to sensitive data or critical infrastructures, where a lack of security measures and cyber-attacks could have severe consequences. Therefore, a risk analysis is essential to identify potential vulnerabilities and design effective defence strategies.\
In this thesis, I present a multi-protocol IoT architecture designed to address the challenge of protocol fragmentation by providing a unified, protected communication framework. The work focuses on the study, implementation, and security analysis of the two most widely adopted IoT protocols: MQTT and CoAP.
This architecture is applied to the specific use case of smart agriculture, with a focus on monitored and automated greenhouses. The core of the study involves addressing potential cyber threats by implementing specific security mechanisms, such as authentication, authorization and encryption, to mitigate risks without compromising the efficiency required by agricultural sensors.\
This work was carried out during my internship at M31 S.r.l., an IoT solutions company based in Padova.\ \
