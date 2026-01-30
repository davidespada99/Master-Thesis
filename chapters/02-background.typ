#pagebreak(to:"odd")

= Background <cap:background>

// - Overview più specifica sull'IoT
// - Architettura generale dell'IoT (layers, cloud compu, ecc)
// - Overview dei protocolli di comunicazione
// - Cenni sugli altri layer di comunicazione (network, transport, application)
// - Requisiti di sicurezza nell'IoT and challenges
// - cyber threats nell'IoT (main types of attacks)
// - MQTT 
//     - perché è usato nell'IoT
//     - caratteristcihe principali e funzionamento
//     - vantaggi e svantaggi
//     - casi d'uso
//     - sicurezza in MQTT (TLS, autenticazione, autorizzazione, ecc)
//     - quale è stato scelto
// - CoAP
//     - idem come sopra
// - Confronto tra MQTT e CoAP
// 
== Introduction <sec:background_introduction>
This section provides the necessary background information to contextualize the topics discussed in the #link(<cap:methodology>)[Methodology] section, where implementation details are presented.\

Firstly, a deeper overview of the Internet of Things is given, with a focus on its technical aspects and architecture. This includes a survey of the communication protocol stack, from the physical and network layers to the transport and application layers.\

Subsequently, the security requirements and challenges inherent to IoT are discussed, followed by an examination of common cyber threats in smart agriculture scenarios. \

Finally, the two most widely adopted IoT communication protocols, MQTT and CoAP, are analyzed in detail. For each protocol, we will examine their main characteristics, operational mechanisms, advantages, disadvantages and the specific security framework chosen for this work.\

The main reasons for choosing these two protocols is mainly derived from their widespread adoption in the IoT ecosystem, as well for their contrasting and opposite design philosophies. As we will see, MQTT is a lightweight publish-subscribe protocol based on TCP networking, while CoAP is a RESTful protocol based on UDP networking. This specular opposition makes them particularly compelling and technically challenging to make them work seamlessly together. Furthermore, their divergent security mechanisms add a significant layer of complexity to the task of ensuring a unified and secure communication environment.

== Internet of Things characteristics <sec:iot_characteristics>
The IoT is a technological paradigm still in an evolutionary phase. Currently, it can be interpreted from three main perspectives: Internet-oriented, which emphasizes the aspect of network connectivity; things-oriented, focused on sensors and smart objects; and semantic-oriented, concentrated on knowledge and data interpretation.

Depending on the intended use, the sector is further divided into Human Internet of Things (HIoT), focused on end-user applications, and Industrial Internet of Things (IIoT), aimed at optimizing industrial processes, reducing machine downtime, and saving energy @atzori2010internet. In this context, the concept of "object" is extremely broad and includes both personal devices such as smartphones and cameras, as well as infrastructural or industrial elements equipped with RFID tags and sensors capable of generating data and services autonomously.\
=== Infrastructure characteristics <sec:infrastructure_characteristics>
From an infrastructural point of view, the IoT inherits several characteristics from pre-existing systems such as wireless sensor networks (WSN) and Machine-to-Machine (M2M) communications, while introducing specific new elements.

One of the main peculiarities is the heterogeneity of devices, which range from low-cost and low-power computing platforms to more complex systems for routing and data processing. Furthermore, many of these nodes are intrinsically resource-constrained, with reduced memory and computing capacities that strongly condition the design of protocols. The resulting network is extremely dynamic and often lacks a fixed infrastructure; nodes can be static or mobile and can join or disconnect spontaneously, requiring constant cooperation to maintain active connectivity.

The nature of the IoT is also defined by its ultra-large-scale, with billions of devices interacting spontaneously, generating a massive volume of events that the system must be able to manage without congestion. To make such interactions effective and limit human mediation, the IoT relies on context-aware and location-aware systems, capable of interpreting environmental, temporal, and spatial information to enable adaptive and autonomous behaviors @cristea2013context. Finally, the infrastructure presents itself as a global and distributed system, where intelligent entities and virtual objects operate independently based on environmental circumstances @kyriazis2013smart.

=== Application characteristics <sec:application_characteristics>

IoT applications cover a wide range of domains, from healthcare, to transportation, logistics, agriculture and smart homes, each characterized by specific architectural requirements, whether event-driven or time-driven. 

A fundamental distinction concerns temporal operations: many applications operate in real-time and require immediate data delivery, as any delays could compromise safety in critical scenarios. In parallel, the IoT is converging toward the Everything-as-a-Service (XaaS) model @banerjee2011everything, a concept present in literature for some time, transforming data sensing into a scalable and reusable online service. In this scenario, integration with Artificial Intelligence (AI) plays a decisive role. Since AI requires large volumes of data for training and processing complex models, the IoT paradigm proves to be the ideal ally, providing the information necessary to power predictive analytics and automated decision-making processes @pal2024iot.

However, wide connectivity and global accessibility entail significant challenges in terms of security and privacy. The exponential increase in the attack surface exposes networks to complex vulnerabilities, making it difficult to implement scalable defense mechanisms. At the same time, the constant collection of sensitive data on users (such as habitual routes or energy consumption) raises serious concerns regarding privacy. This aspect makes compliance with current regulations fundamental, such as those of the European Union with the recent Data Act @DataAct, to prevent applications from violating the fundamental rights of citizens through data leaks or unauthorized monitoring.

== Internet of Things architecture <sec:iot_architecture>

The IoT should be capable of interconnecting billions of heterogeneous objects through the Internet, so there is a critical need for a flexible layered architecture. However, the increasing number of proposed architectures has not yet converged to a reference model @krvco2014designing.
One of the main challenges to deal with the deployment of IoT systems is to define a reference architecture that supports current features and future extensions. For this reason, such an architecture must be @lombardi2021internet:
- scalable, in order to support a large number of devices and users;
- interoperable, to ensure seamless communication between heterogeneous devices and systems, even form different manufacturers;
- flexible, to adapt to changing requirements and technologies;
- resource-efficient, as IoT objects typically operate with limited computing power and energy;
- distributed, to facilitate an environment where data collected from multiple sources is processed across various network entities;
- secure, preventing unauthorized access and ensuring data protection.
Different models have been proposed by different researchers, which goes from the basic 3-layer @yang2011study architecture to the 5-layer architecture @wu2010research, as depicted in figure @fig:iot_layers. In the next sub-sections, we are going to present this last one, as it is the most comprehensive and widely accepted model. An important reminder, it should not be confused with the network layer of the ISO/OSI model.
#align(center)[
    #figure(image("../images/iot-layers.png", width: 8cm), 
    caption: "Architecture of IoT (A: 3-layers) (B: 5-layers)")
    <fig:iot_layers>
]

=== Perception layer
The perception layer constitutes the bottom of the IoT stack, where physical data collection occurs. The big data created by the IoT are initiated at this layer. It consists of sensors and actuators designed to perceive and interact with the surrounding environment, such as obtain data on location, weight, motion, vibration, acceleration etc.\

In a smart agriculture context, this includes a wide array of devices such as temperature, air humidity or soil moisture sensors, as well as smart cameras, RFID tags or weather stations. Furthermore, we may find automated systems like smart irrigation valves or lighting controls, to make some examples.
The versatility of this layer extends to other domains as well: in healthcare, it includes wearable devices like fitness trackers for health monitoring; in smart cities, it encompasses air quality monitors and smart thermostats; in Industrial IoT (IIoT), sensors for vibration and flow are utilized for predictive maintenance and process optimization and so on.\
To manage this inherent diversity, standardized plug-and-play mechanisms are essential to configure heterogeneous objects. Finally, the perception layer is responsible for digitizing raw information and transferring it to the upper layers through secure communication channels.

=== Transport layer
Also referred to as the network layer, the transport layer is responsible for transferring the collected data to the processing layer. This is possible via various communication technologies and protocols, such as RFID, 5G, WiFi, Bluetooth Low Energy (BLE) and ZigBee. The choice of technology depends on several critical factors, including transmission range, data rate, power consumption and specific environmental conditions. At this layer, we find key protocols like IPv6 (Internet Protocol version 6), which is essential for addressing the billions of "things" within the ecosystem. \

The IoT is an immense network that not only connects billions of individual devices but also encompasses a vast multitude of diverse networks. Therefore, ensuring robust and seamless communication between different networks and entities is a crucial challenge at this level.

=== Middleware layer
The middleware layer, also known as the processing layer, serves as the core of the IoT architecture, bridging data collection and consumer services. Its main purpose is to store, analyze and process the information received from the transport layer. This layer enables IoT application programmers to work with heterogeneous objects without being constrained by specific hardware platforms, as it effectively pairs services with their respective requesters based on addresses and names.\

Furthermore, it is responsible for making decisions and delivering required services over network protocols. To achieve this, it employs a wide range of technologies, including databases, cloud computing and big data processing frameworks.\

As previously mentioned in the introduction, this layer represents the level where protocol interoperability is addressed. It is precisely within this middleware context that protocols such as MQTT and CoAP operate, acting as the fundamental tools to manage communication and integration across diverse IoT systems.

=== Application layer
The application layer is responsible for providing the services requested by customers. 
Building upon the data processed in the middleware layer, it facilitates the development of diverse IoT applications, such as intelligent transportation, logistics management and emergency response systems.\

The importance relies in the ability to provide high-quality smart services to meet customers' needs, covering numerous markets such as smart home, transportation, industrial automation, smart healthcare or smart agriculture.\

For instance, in the smart agriculture scenario, this layer presents real-time measurements such as temperature, light intensity and air humidity to the user. These data points are then utilized for monitoring, historical analysis and smart decision making.\

=== Business layer
The business layer manages the overall activities and services of the IoT system. Its primary responsibility is to define business models, graphically represent business logic and ensure the economic viability of the infrastructure. This layer includes profit models, strategic applications and the implementation of user privacy policies. \

As is widely recognized, the success of a technology depends not only on technical superiority but also on the innovation and soundness of its business model. From this perspective, the Internet of Things cannot achieve effective, long-term development without a dedicated focus on business strategy.\
In addition, monitoring and management of the underlying four layers is achieved at this layer. \

Moreover, this layer compares the output of each layer with the expected output to enhance service quality, optimize performance and maintain users' privacy.\

== Enabling Technologies and Protocols <sec:enabling_technologies_protocols>
In this section, we are going to provide an overview of the main enabling technologies and communication protocols used in IoT systems.\

In reference to the architecture presented in @sec:iot_architecture, firstly we will briefly discuss the common IoT hardware platforms of the perception layer, followed by a survey of the main communication technologies of the transport layer and lastly, we will present the most widely adopted communication protocols of the middleware layer.
=== IoT hardware platforms <sec:iot_hardware_platforms>
In this section, we are going to briefly describe the main hardware components that constitute the lowest layer of the IoT stack, discussing on computational units architecture, security modules, operating systems and boards.
==== Computational Units
The performance and functional capabilities of IoT systems are fundamentally driven by specific processing elements, which can be categorized based on their level of integration and flexibility @antenna-in-package. These include:

- Microcontrollers (MCUs): they can easily described as "computers-on-a-chip". These units integrate a processor core, memory, and programmable input/output peripherals. They are designed for embedded applications where low power and small size are more critical than raw computing speed, such as in basic sensors or actuators.

- Systems-on-Chip (SoC): this technology represents the highest level of integration, where all necessary components (analog, digital, mixed-signal and radio-frequency circuitry) are put onto a single silicon die. This "monolithic" approach enhances system stability and reduces the manufacturing footprint, making it ideal for mass-produced devices. Though, it involves rigid performance-energy tradeoffs.

- Systems-in-Package (SiP): unlike SoC, SiP adopts a modular strategy by leveraging multiple functional units (such as MCUs, specialized memory, oscillators or antennas) within a single protective package. By placing chips side-by-side, SiP modules can achieve higher unit speeds and superior power utilization through optimized interconnects, albeit at the cost of increased complexity and higher assembly expenses.

- Field Programmable Gate Arrays (FPGAs): these are integrated circuits designed to be configured by the customer. A FPGA can be seen as a "blank sheet" of logic blocks that can be electrically rewired to perform specific  tasks, offering extreme flexibility and high performance for specialized IoT edge processing.
\

In a smart agricultural scenario, MCUs are the optimal solution for both sensors and actuators. Since we expect that data is sent quite infrequently and environmental data changes slowly, MCUs are ideal since they include integrated analog-to-digital converters and consume very little power at a low cost. On the other hand, FPGAs are reserved for complex tasks such as real-time computer vision for plant health monitoring or pest detection.
==== Hardware Security Modules (HSMs)
In these hardware ecosystems, Hardware Security Modules (HSMs) are essential tools for ensuring data protection and device integrity, where they function as devices made to safely create, store and handle cryptographic keys. HSMs facilitate secure device-to-device communication and regulatory compliance by offering strong hardware-based protection against unauthorized access and tampering, ensuring that sensitive information remains isolated from the wider environment. HSM security is still reliant on network integration and firmware integrity despite their high-assurance design. Attackers may target physical, logical, firmware, and network vectors in IIoT deployments, underscoring the necessity of fixing practical flaws found in these systems. A deeper analysis of HSM solutions, deployment, challenges and attacks is presented in @hsm.

==== Development Boards and Operating Systems
Prototyping and deployment are facilitated by electronic boards, such as Arduino, Raspberry Pi, BeagleBone and T-Mote Sky, which offer researchers accessible environments to test diverse wireless configurations. \

On the software side, some IoT application may leverage firmware and Real-Time Operating Systems (RTOS) @rtos_iot, including Contiki, RiotOS and TinyOS, which play a critical role. These operating systems are specifically architected for resource-constrained hardware, providing modular multitasking and low-power networking, essential for managing the device lifecycle in hostile environments. 

=== IoT wireless communication technologies <sec:iot_wireless_communication_technologies>
In IoT applications, the technological options are constrained by the hardware capabilities, the need for low-power consumption and the total cost of the device. Achieving low power consumption is, in general, a prerequisite for developing the IoT. In addition, there are cost of technology, security, ease of use and management, wireless data rates and ranges, which are just a few examples of crucial needs. Many developing wireless technologies, like ZigBee, Bluetooth Low Energy (BLE), LoRa, NB-IoT and 6LoWPAN protocols compete to offer the best wireless communication option trade-offs. @tab:iot_protocols_comparison compares the frequency bands, ranges, data rates, power consumption and security features of various wireless communication systems.\

In a smart agriculture scenario, especially for greenhouses, but also extending to open-field farming, usually hub gateways are deployed closer to devices to collect data from distributed groups of sensors and sending to the cloud, acting like intermediaries. These gateways are typically connected to the Internet via WiFi or 5G, while the end devices communicate with the gateway using low-power wireless technologies such as LoRa, ZigBee or BLE.\

In the following sub-sections, we are going to briefly describe some of the most important ones.
#v(1.5em)
#figure(
  table(
    columns: (0.9fr, 1.2fr, 1fr, 1fr, 1fr, 1fr),
    align: (horizon, horizon, horizon, horizon, horizon, horizon),
    stroke: 0.4pt,
    inset: 6pt,
    
    // Header row
    table.header(
      [*_Protocol_*],
      [*_Frequency Band_*],
      [*_Range_*],
      [*_Data Rate_*],
      [*_Power \ Consumption_*],
      [*_Security_*]
    ),
    
    // BLE
    [*Bluetooth Low Energy (BLE)*],
    [2.4 GHz ISM],
    [100m (v4.2) \ 200m (v5.0)],
    [Up to 2 Mbps (v5.0)],
    [Very Low],
    [128-bit AES-CCM],
    
    // ZigBee
    [*ZigBee*],
    [868 MHz - EU \ 915 MHz -US \ 2.4 GHz - Global],
    [Up to 100m],
    [20-250 kbps],
    [Very Low],
    [128-bit AES],
    
    // LoRa/LoRaWAN
    [*LoRa/LoRaWAN*],
    [Sub-GHz ISM bands],
    [~5 km (urban) \ ~15 km (rural)],
    [0.3-50 kbps (typical)],
    [Very Low],
    [128-bit AES],
    
    // NB-IoT
    [*NB-IoT*],
    [Licensed LTE bands \ (180 kHz bandwidth)],
    [~1 km (urban) \ ~10 km (rural)],
    [127 kbps (downlink) \ 159 kbps (uplink)],
    [Low],
    [LTE security \ mechanisms],
    
    // 6LoWPAN
    [*6LoWPAN + RPL*],
    [2.4 GHz ISM \ 915 MHz, 868 MHz],
    [Up to 100m],
    [Up to 250 kbps],
    [Very Low],
    [AES-CCM \ (802.15.4 MAC)]
  ),
  caption: [Comparison of IoT wireless communication protocols]
) <tab:iot_protocols_comparison>
#v(1.5em)
==== Bluetooth Low Energy (BLE) <sec:ble>
Originally introduced by Ericsson in 1994 and standardized as IEEE 802.15.1 @zeadally201925, Bluetooth has evolved significantly from its "Classic" (BR/EDR) version focused on data streaming to the breakthrough of version 4.0 with the introduction of Bluetooth Low Energy (BLE) @koulouras2025evolution. Unlike its predecessor, BLE is optimized for low power consumption and intermittent data bursts, making it a key technology for the IoT ecosystem. Operating in the 2.4 GHz ISM band with a robust security framework based on 128-bit AES-CCM encryption, BLE has drastically reduced latency from 100ms in classic to less than 6ms, while supporting a data rate of up to 2Mbps in version 5.0. Recently, BLE 6.0 has been announced, enhancing real-time capabilities @BLE6.0.\

Although the range has expanded from 100m in version 4.2 to 200m in version 5.0, its short-range nature necessitates the use of an intermediate hub gateway for external network connectivity. Thanks to the introduction of mesh topology in 2017 @Ble_mesh and Beacon technology, BLE has moved beyond the limits of star networks (Piconets) to allow many-to-many communications, making it ideal for large-scale sensor networks in complex environments like smart greenhouses.\

Despite its widespread global adoption, this technology faces significant security challenges. As analyzed in @wang2024securing numerous threats and vulnerabilities persist, many of which are in the architectural complexities of the pairing process.  However, the inherent wireless nature of BLE interfaces exposes them to cybersecurity threats, necessitating robust security measures to mitigate risks and safeguard systems and data. Continuous research and development  are crucial to stay ahead of emerging threats and ensurethe integrity and confidentiality of BLE-enabled solutions.
==== ZigBee <sec:zigbee>
Standardized in 2004 under IEEE 802.15.4 for Personal Area Networks @zigbee, ZigBee is a protocol employed in sensor and control device integration. It operates across multiple frequency bands, including 868 MHz in Europe, 915 MHz in the United States, and 2.4 GHz globally, supporting data rates ranging from 20 kbps to 250 kbps. The protocol utilizes Direct Sequence Spread Spectrum (DSSS) modulation for robust transmission and employs CSMA/CA mechanisms to mitigate signal collisions, thereby enhancing network reliability. With a functional range of up to 100 meters and minimal power consumption, the technology has advanced through the ZigBee PRO and ZigBee 3.0 standards, towards the upcoming Zigbee 4.0 @ahmed2023introduction. Its architecture comprises coordinators, routers and end devices, facilitating star, tree and mesh topologies secured by 128-bit AES encryption.\

A recent study @zigbee_security evaluated the ZigBee 3.0 security features and enhancements over previous revisions, particularly in safeguarding symmetric keys through mechanisms that effectively mitigate historical vulnerabilities such as unencrypted network key transport. However, empirical studies indicate that the protocol remains susceptible to certain Denial of Service (DoS) attacks, including protocol flooding and network realignment, which can disrupt availability.\

Ultimately, the features of ZigBee are low power consumption, low cost, fast response, less interference, self-organization, multiple topologies and high security, makingZigbee a preferred solution for many medium and short-range IoT applications, including smart agriculture.

==== LoRa and LoRaWAN <sec:lora_lorawan>
Originally developed in 2009 and standardized by the LoRa Alliance, LoRa is a physical layer technology designed for long-range, low-power data transmission @raychowdhury2020survey. It utilizes a modulation technique derived from Chirp Spread Spectrum (CSS), which encodes information using radio frequency chirps to achieve exceptional signal robustness. This enables communication ranges of approximately 5 km in urban environments and up to 15 km in rural areas. This makes it ideal for smart agriculture, as it allows for the monitoring of vast rural farmlands with minimal infrastructure.\

While LoRa defines the physical modulation, LoRaWAN serves as the network protocol that establishes the system architecture and communication functionalities @rama2018comparison. The framework typically employs a star-of-stars topology, where gateways act as bridges between battery-operated end nodes and a central network server, a setup highly optimized for transmitting small sensor payloads with minimal energy consumption.\

Security in LoRaWAN is primarily maintained through 128-bit AES symmetric encryption, ensuring mutual authentication and data integrity. A recent study @hessel2023lorawan highlight that security has improved significantly with the transition from version 1.0.x to 1.1, specifically addressing vulnerabilities in the join process and frame counters. However, a primary challenge remains the slow adoption of these new specifications, as many devices in the field continue to operate on older, vulnerable versions due to their long operational lifecycles. The security is analyzed across three domains: physical, link-layer and backend infrastructure. While physical attacks on end devices or gateways tend to have localized impacts, the link-layer remains a critical area of concern where vulnerabilities such as ACK spoofing, replay attacks and traffic analysis persist. Furthermore, as the protocol evolves to include features like roaming, the security of the backend infrastructure requires further empirical investigation. Given that LoRaWAN deployments are expected to operate for decades in often unattended settings, researchers emphasize the need for automated tools to track emerging threats. Ultimately, the combination of deep penetration capabilities and wide geographical reach, positions LoRaWAN as a leading solution for industrial monitoring and large-scale agricultural deployments.

==== NB-IoT <sec:nbiot>
Narrowband IoT (NB-IoT) is a specialized mobile communications protocol standardized by 3GPP in 2016, designed specifically to facilitate machine-type communication within 5G and LTE frameworks @dangana2021suitability. Operating with a bandwidth of 180 kHz, the technology has evolved through successive releases that continuosly ehanched performances. In terms of transmission speeds, NB-IoT reaches a data rate of approximately 127 kbps in downlink and 159 kbps in uplink. However, this focus on coverage and power efficiency results in a significant latency, which typically ranges from 1.5 to 10 seconds. Depending on the environment, NB-IoT offers a coverage range from approximately 1 km in dense urban settings to 10 km in rural regions.\

While NB-IoT inherits robust LTE security mechanisms, its reliance on the 4G LTE radio access network (the base stations or eNodeBs) , infrastructure also exposes it to legacy cellular vulnerabilities. A research indicates that NB-IoT sensors are susceptible to sniffing via rogue eNodeBs, which can compromise device privacy. Furthermore, protocol exploitation of the EPS Mobility Management (EMM) layer allows attackers to initiate DoS attacks. By sending unauthenticated "TAU Reject" or "Attach Reject" messages, a rogue base station can trick a sensor into deleting its security context and ceasing further connection attempts to legitimate networks @abdollahi2024privacy.

Despite these risks, NB-IoT high sensitivity and architectural structure, consisting of the terminal, base station, core network, cloud platform, and vertical business center, make it a preferred solution for various solutions.
==== 6LoWPAN and RPL <sec:6lowpan_rpl>
Developed by the IETF in 2007, 6LoWPAN (IPv6 over Low-Power Wireless Personal Area Networks) enables the seamless integration of the IPv6 protocol into low-power wireless networks @6lowpan. Operating over IEEE 802.15.4 standard radios, it utilizes the 2.4 GHz ISM band globally, as well as the 915 MHz and 868 MHz bands. The protocol supports data rates up to 250 kbps within a 100 m range. Its primary innovation is an adaptation layer that sits between the network and data-link layers; this layer performs header compression (reducing the standard 40-byte IPv6 header to as little as 7 bytes) and fragmentation to allow large IPv6 packets to fit into small IEEE 802.15.4 frames.\

To manage communication in lossy environments, the IPv6 Routing Protocol for Low Power and Lossy Networks (RPL), a popular routing protocol due to its flexibility, energy-efficient routing capacity, and QoS support, was specifically designed as the  layer above 6LoWPAN @rpl. RPL organizes devices into a Destination Oriented Directed Acyclic Graph (DODAG), a tree-like logical structure where each node chooses a parent to route data toward the root. This mesh architecture ensures that if one path fails, the network automatically finds a new route.\

RPL-based 6LoWPAN networks face various security threats, categorized into DoS and routing attacks. Defense mechanisms are generally divided into two main categories: secure protocols and Intrusion Detection Systems (IDS) @verma2020security. Secure protocol solutions are embedded within RPL and include cryptography, trust-based metrics for node selection and threshold-based enhancements for the trickle timer. In contrast, IDS represents a second line of defense, utilizing signature or anomaly detection tailored for the resource-constrained nature of IoT devices.\

Security is further enhance via cross-layer solutions at the IEEE 802.15.4 MAC layer, providing confidentiality (AES-CCM), integrity (MAC), and replay protection. While frameworks like Network Access Control (NAC) improve node authorization and data filtering, their implementation is often limited by the high resource demands of symmetric encryption and the complexities of secure neighbor discovery in constrained IoT environments.

=== IoT communication protocols
<sec:iot_communication_protocols>
In this section, we are going to present the most widely adopted communication protocols used in IoT, more specifically at the middleware layer. These protocols can be classified into two main categories based on their message and communication pattern: publish-subscribe and request-response protocols. The former category includes protocols such as MQTT and AMQP, while the latter encompasses protocols like CoAP and HTTP.\

Also, as an important note, these protocols are often referred to as application layer protocols in the literature, following the ISO/OSI model. However, in the context of the IoT architecture presented in @sec:iot_architecture, they are specifically categorized as middleware because the classification shifts from the packet structure to their logical function. While the ISO/OSI model provides a purely structural view, the middleware perspective describes what these protocols actually do for the ecosystem: providing the abstraction and processing necessary for the upper layers to manipulate raw data and manage heterogeneous types of devices, even within the same category.

==== Communication Paradigms
As mentioned, we can broadly classify the most common IoT communication protocols into two main paradigms: publish-subscribe and request-response.\
#align(bottom)[
   #figure(
    grid(
    columns: (1fr, 1fr), // Divide width into two equal columns
    gutter: 5pt, 
    image("../images/req-resp.png", width: 100%),       // Space between figures
    image("../images/pub-sub.png", width: 110%),
  ),
  caption: [Comparison between (a) Request-Response and (b) Publish-Subscribe paradigms ]
)
    <fig:communication_paradigms_comparison>
]
#v(2em)

===== Request-Response
The request-response paradigm enables bidirectional communication between endpoints. In this model, a client sends a request message to a target server, which processes the information and returns a corresponding response, as shown in @fig:communication_paradigms_comparison(a). This paradigm is particularly well-suited for IoT deployments with the following characteristics:
- follows a client-server architecture;
- requires interactive communication: both endpoints have information to send to the other side;
- the receipt of information needs to be fully acknowledged.\
However, this model may not be the best solution for simple one-way communications, such as a sensor reporting data to an application, due to the overhead of unnecessary acknowledgement messages.\

In smart agriculture scenarios, for instance, a network of hundreds of soil moisture sensors providing periodic updates would mean unnecessary energy consumption and bandwidth congestion. This synchronous overhead is often redundant when the only goal is to obtain telemetry data rather than an interactive exchange. This is where the publish/subscribe model comes in.

===== Publish-Subscribe
The publish/subscribe paradigm, often referred to as pub/sub, enables unidirectional communication from a publisher to one or more subscribers. The subscribers
declare their interest in a particular topic subscribing to a broker messanger. When the publisher has new data available from that category, it pushes new messages to the broker, which in turn forwards them to all interested subscribers, as shown in @fig:communication_paradigms_comparison(b). This model is particularly well-suited for IoT deployments with the following characteristics:
- Better scalability by leveraging parallelism and the multicast capabilities of theunderlying transport network;
- Asynchronous communication, allowing loose coupling between publishers and subscribers to operate independently;
- Efficient use of network resources, especially in scenarios with many-to-many communication patterns.

==== Message Queuing Telemetry Transport (MQTT)

==== Constrained Application Protocol (CoAP) <sec:coap>

==== Other protocols <sec:other_protocols>
Oher protocols have been also used to a lesser extent, such as Advanced Message Queuing Protocol (AMQP), Data Distribution Service (DDS), Extensible Messaging and Presence Protocol (XMPP) or even Hypertext Transfer Protocol (HTTP).


== Security requirements in IoT <sec:security_requirements_iot>
In the context of IoT, security requirements are crucial to ensure the safe and reliable operations.

CIA triad: 3+2 main security requirements:
- Confidentiality
- Integrity
- Availability
- Authentication
- Authorization 


== Cyber Threats in IoT <sec:cyber_threats_iot>

- DDOS
- Spoofing
- Eavesdropping
- Snffing
- Man-in-the-middle
- Replay attacks
- Physical attacks
