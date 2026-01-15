#import "../config/constants.typ": abstract
#set page(numbering: "i")
//#counter(page).update(1)

#heading(level: 1, numbering: none, outlined: true)[
  #text(weight: "regular", 1em)[Abstract]
]

#v(2em)
#set par(first-line-indent: 0pt)


In the past decades, since the introduction of the Internet of Things (IoT) paradigm, the number of connected devices has grown exponentially. The purpose of IoT is to connect everyday objects to the internet, enabling them to send and receive data, thus allowing for a wide range of applications that improve efficiency and quality of life through automation and remote control.\

This growth has proceeded hand in hand with the development of various protocols to support different requirements. These applications now dominate our everyday life across multiple domains, such as smart homes, healthcare or industrial automation. However, this technological variety introduces significant architectural fragmentation, which represents a limit for interoperability.\
Moreover, the nature of some IoT applications have raised significant security and privacy concerns, especially for what regards sensitive data or critical infrastructures, where the lack of security measures and cyber-attacks could lead to severe consequences. A risk analysis is therefore essential to identify vulnerabilities and therefore to design effective defense strategies.\
In this thesis I will present my work on a multi-protocol IoT architecture, designed to address the challenge of protocol fragmentation, by attempting to provide a unified and protected framework for communication. My work focuses on a comparative risk assessment and security analysis of the two most adopted IoT protocols: MQTT and CoAP. \
This architecture is applied to the specific use case of smart agriculture, focusing on monitored and automated greenhouses. The core of the study involves analyzing potential cyber threats and implementing specific security mechanisms, such as authentication, authorization or encryption, to mitigate risks without compromising the efficiency required by agricultural sensors.\ 
This work has been carried out during my internship at M31 S.r.l., a company located in Padova specialized in IoT solutions.\