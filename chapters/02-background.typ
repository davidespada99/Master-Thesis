#pagebreak(to:"odd")

= Background <cap:background>

== Introduction <sec:background_introduction>
This section provides the necessary background information to contextualize the topics discussed in @cap:methodology, where implementation details are presented.\

Firstly, a deeper overview of the Internet of Things is given, with a focus on its technical aspects and architecture. This includes a survey of the communication protocol stack, from the physical and network layers to the transport and application layers.\

In particular, the two most widely adopted IoT communication protocols, MQTT and CoAP, are analyzed. For each protocol, we will examine their main characteristics, operational mechanisms, advantages, disadvantages and the specific security framework chosen for this work.\

Subsequently, the security requirements and challenges inherent to IoT are discussed, followed by an examination of common cyber threats and security mechanisms. \

The main reasons for choosing these two protocols is mainly derived from their widespread adoption in the IoT ecosystem, as well for their contrasting and opposite design philosophies. As we will see, MQTT is a lightweight publish-subscribe protocol based on TCP networking, while CoAP is a RESTful protocol based on UDP networking. This specular opposition makes them particularly compelling and technically challenging to make them work seamlessly together. Furthermore, their divergent security mechanisms add an additional layer of complexity to the task of ensuring a unified and secure communication environment.

== Internet of Things characteristics <sec:iot_characteristics>
The IoT is a technological paradigm still in an evolutionary phase. Currently, it can be interpreted from three main perspectives: internet-oriented, which emphasizes the aspect of network connectivity; things-oriented, focused on sensors and smart objects; and semantic-oriented, concentrated on knowledge and data interpretation.

Depending on the intended use, the sector is further divided into Human Internet of Things (HIoT), focused on end-user applications, and Industrial Internet of Things (IIoT), aimed at optimizing industrial processes, reducing machine downtime, and saving energy @atzori2010internet. In this context, the concept of _object_ is extremely broad and includes both personal devices such as smartphones and cameras, as well as infrastructural or industrial elements equipped with RFID tags and sensors capable of generating data and services autonomously.\
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

=== Perception layer <sec:perception_layer>
The perception layer constitutes the bottom of the IoT stack, where physical data collection occurs. The big data created by the IoT are initiated at this layer. It consists of sensors and actuators designed to perceive and interact with the surrounding environment, such as obtain data on location, weight, motion, vibration, acceleration etc.\

In a smart agriculture context, this includes a wide array of devices such as temperature, air humidity or soil moisture sensors, as well as smart cameras, RFID tags or weather stations. Furthermore, we may find automated systems like smart irrigation valves or lighting controls, to make some examples.
The versatility of this layer extends to other domains as well: in healthcare, it includes wearable devices like fitness trackers for health monitoring; in smart cities, it encompasses air quality monitors and smart thermostats; in Industrial IoT (IIoT), sensors for vibration and flow are utilized for predictive maintenance and process optimization and so on.\
To manage this inherent diversity, standardized plug-and-play mechanisms are essential to configure heterogeneous objects. Finally, the perception layer is responsible for digitizing raw information and transferring it to the upper layers through secure communication channels.

=== Transport layer <sec:transport_layer>
Also referred to as the network layer, the transport layer is responsible for transferring the collected data to the processing layer. This is possible via various communication technologies and protocols, such as RFID, 5G, WiFi, Bluetooth Low Energy (BLE) and ZigBee. The choice of technology depends on several critical factors, including transmission range, data rate, power consumption and specific environmental conditions. At this layer, we find key protocols like IPv6 (Internet Protocol version 6), which is essential for addressing the billions of "things" within the ecosystem. \

The IoT is an immense network that not only connects billions of individual devices but also encompasses a vast multitude of diverse networks. Therefore, ensuring robust and seamless communication between different networks and entities is a crucial challenge at this level.

=== Middleware layer <sec:middleware_layer>
The middleware layer, also known as the processing layer, serves as the core of the IoT architecture, bridging data collection and consumer services. Its main purpose is to store, analyze and process the information received from the transport layer. This layer enables IoT application programmers to work with heterogeneous objects without being constrained by specific hardware platforms, as it effectively pairs services with their respective requesters based on addresses and names.\

Furthermore, it is responsible for making decisions and delivering required services over network protocols. To achieve this, it employs a wide range of technologies, including databases, cloud computing and big data processing frameworks.\

As previously mentioned in the introduction, this layer represents the level where protocol interoperability is addressed. It is precisely within this middleware context that protocols such as MQTT and CoAP operate, acting as the fundamental tools to manage communication and integration across diverse IoT systems.

=== Application layer <sec:application_layer>
The application layer is responsible for providing the services requested by customers. 
Building upon the data processed in the middleware layer, it facilitates the development of diverse IoT applications, such as intelligent transportation, logistics management and emergency response systems.\

The importance relies in the ability to provide high-quality smart services to meet customers' needs, covering numerous markets such as smart home, transportation, industrial automation, smart healthcare or smart agriculture.\

For instance, in the smart agriculture scenario, this layer presents real-time measurements such as temperature, light intensity and air humidity to the user. These data points are then utilized for monitoring, historical analysis and smart decision making.\

=== Business layer <sec:business_layer>
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
These includes, for example, ESp8266 @esp8266, a wifi module that helps in establishing wireless connection between different components, DHT11 is a widely used sensor for measuring humidity and temperature, DHT11 @DHT11 is a widely used sensor for measuring humidity and temperature or the RTC @rtc_module module used to set up a real-time clock and keep the time and date up to date. Further details on the hardware components used in smart agriculture cab ne found in @sinha2022recent and @thilakarathne2025internet.
==== Hardware Security Modules (HSMs)
In these hardware ecosystems, Hardware Security Modules (HSMs) are essential tools for ensuring data protection and device integrity, where they function as devices made to safely create, store and handle cryptographic keys. HSMs facilitate secure device-to-device communication and regulatory compliance by offering strong hardware-based protection against unauthorized access and tampering, ensuring that sensitive information remains isolated from the wider environment. HSM security is still reliant on network integration and firmware integrity despite their high-assurance design. Attackers may target physical, logical, firmware, and network vectors in IIoT deployments, underscoring the necessity of fixing practical flaws found in these systems. A deeper analysis of HSM solutions, deployment, challenges and attacks is presented in @hsm.

==== Development Boards and Operating Systems
Prototyping and deployment are facilitated by electronic boards, such as Arduino, Raspberry Pi, BeagleBone and T-Mote Sky, which offer researchers accessible environments to test diverse wireless configurations. \

On the software side, some IoT application may leverage firmware and Real-Time Operating Systems (RTOS) @rtos_iot, including Contiki, RiotOS and TinyOS, which play a critical role. These operating systems are specifically architected for resource-constrained hardware, providing modular multitasking and low-power networking, essential for managing the device lifecycle in hostile environments. 

=== IoT wireless communication technologies <sec:iot_wireless_communication_technologies>
In IoT applications, the technological options are constrained by the hardware capabilities, the need for low-power consumption and the total cost of the device. Achieving low power consumption is, in general, a prerequisite for developing the IoT. In addition, there are cost of technology, security, ease of use and management, wireless data rates and ranges, which are just a few examples of crucial needs. Many developing wireless technologies, like ZigBee, Bluetooth Low Energy (BLE), LoRa, NB-IoT and 6LoWPAN protocols compete to offer the best wireless communication option trade-offs. @tab:iot_protocols_comparison compares the frequency bands, ranges, data rates, power consumption and security features of various wireless communication systems.\

In a smart agriculture scenario we can have two main deployment based on the application scenario. In open-field farming, the vast geographical distribution and inconsistent cellular coverage often necessitate the use of hub gateways. These gateways are typically connected to the Internet via WiFi or 5G, while the end devices communicate with the gateway using low-power wireless technologies such as LoRa, ZigBee or BLE.  Conversely, smart greenhouses can benefit from wired infrastructure and stable power sources. In these protected environments, devices can often communicate directly with the cloud through Wi-Fi or LTE modules.\

In the following sub-sections, we are going to briefly describe some of the most important wireless communication protocol employed for resource-constrained devices.
#v(1.5em)
#figure(
  table(
    columns: (1fr, 1.2fr, 1fr, 1fr, 0.9fr, 1fr),
    align: (horizon, horizon, horizon, horizon, horizon, horizon),
    stroke: 0.5pt,
    inset: 5pt,
    
    // Header row
    table.header(
      [*_Protocol_*],
      [*_Frequency Band_*],
      [*_Range_*],
      [*_Data Rate_*],
      [*_Power Consumption_*],
      [*_Encryption_*]
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
    [2.4 GHz (Global) \ 868 MHz (EU) \ 915 MHz (US)],
    [Up to 100m],
    [20-250 kbps],
    [Very Low],
    [128-bit AES],
    
    // LoRa/LoRaWAN
    [*LoRa/ \ LoRaWAN*],
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
    [*6LoWPAN & RPL*],
    [2.4 GHz (Global) \ 915 MHz (US) \ 868 MHz (EU)],
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

Its architecture relies on two distinct levels of protection: the Non-Access Stratum (NAS), which secures signaling between the device and the core network, and the Access Stratum (AS), which encrypts data over the radio interface. These layers utilize the EPS Encryption and Integrity Algorithms (EEA/EIA), typically based on AES-128, SNOW 3G or the ZUC stream cipher. This cryptographic framework ensures mutual authentication and data confidentiality.

However, this reliance on the 4G LTE radio access network infrastructure (the base stations or eNodeBs) also exposes it to legacy cellular vulnerabilities. A research indicates that NB-IoT sensors are susceptible to sniffing via rogue eNodeBs, which can compromise device privacy. Furthermore, protocol exploitation of the EPS Mobility Management (EMM) layer allows attackers to initiate DoS attacks. By sending unauthenticated "TAU Reject" or "Attach Reject" messages, a rogue base station can trick a sensor into deleting its security context and ceasing further connection attempts to legitimate networks @abdollahi2024privacy.

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
#v(1em)

===== Request-Response <sec:req_resp>
The request-response paradigm enables bidirectional communication between endpoints. In this model, a client sends a request message to a target server, which processes the information and returns a corresponding response, as shown in @fig:communication_paradigms_comparison(a). This paradigm is particularly well-suited for IoT deployments with the following characteristics:
- follows a client-server architecture;
- requires interactive communication: both endpoints have information to send to the other side;
- the receipt of information needs to be fully acknowledged.\
However, this model may not be the best solution for simple one-way communications, such as a sensor reporting data to an application, due to the overhead of unnecessary acknowledgement messages.\

In smart agriculture scenarios, for instance, a network of hundreds of soil moisture sensors providing periodic updates would mean unnecessary energy consumption and bandwidth congestion. This synchronous overhead is often redundant when the only goal is to obtain telemetry data rather than an interactive exchange. This is where the publish/subscribe model comes in.

===== Publish-Subscribe <sec:pub_sub>
The publish/subscribe paradigm, often referred to as pub/sub, enables unidirectional communication from a publisher to one or more subscribers. The subscribers
declare their interest in a particular topic subscribing to a broker messanger. When the publisher has new data available from that category, it pushes new messages to the broker, which in turn forwards them to all interested subscribers, as shown in @fig:communication_paradigms_comparison(b). This model is particularly well-suited for IoT deployments with the following characteristics:
- Better scalability by leveraging parallelism and the multicast capabilities of theunderlying transport network;
- Asynchronous communication, allowing loose coupling between publishers and subscribers to operate independently;
- Efficient use of network resources, especially in scenarios with many-to-many communication patterns.

==== Constrained Application Protocol (CoAP) <sec:coap>
CoAP was originally developed by the IETF Constrained RESTful Environments (CoRE) working group in 2010 and standardized in 2014. It is defined in the RFC7252 @RFC7252T73 as a lightweight and simple application protocol. It is a request-response application protocol, as discussed in @sec:req_resp, based on an asynchronous exchange of messages and it runs over User Datagram Protocol (UDP) which does not offer any reliability mechanisms. \

In a CoAP network we have two types of nodes, as depicted in @fig:coap_overview, CoAP servers are usually constrained devices (sensors or actuators), that can be accessed or controlled using a REST API, and CoAP clients, which can be user devices, gateways or cloud applications that want to retrieve some information or request some action from the server. HTTP clients could also communicate with CoAP servers using a proxy, which could be a local gateway close to the devices, which communicates itself with the CoAP server using the CoAP protocol.

#v(1.5em)
#align(center)[
    #figure(image("../images/coap.png", width: 11cm), 
    caption: "CoAP System Overview")
    <fig:coap_overview>
]
#v(1.5em)

Regarding how clients and servers discover each other can be done basically in two ways: through DNS (mDNS and DNS-SD), or through CoAP resource discovery (which can be multicast or based on directory).\

The former in the standard approach for most of the networks: mDNS (multicast DNS) allows a server to announce its presenceon a local network without requiring a central DNS server, while DNS-SD (DNS Service Discovery), which operates on top of mDNS, enables clients to discover the specific services offered by the server.\

The latter approach is native for CoAP: through multicast discovery, a client can query all available servers to identify their services. However, for more complex or power-sensitive networks, CoAP utilizes a Resource Directory (RD), that is a central entity where servers register their resources so that clients can discover them without querying the nodes directly. Regardless of the method, CoAP servers provide a standardized interface at the _/.well-known/core_ URI. When accessed, this endpoint returns a list of all hosted resources, allowing for automated and efficient service discovery.\ \

Regarding the message, CoAP defines four types: 
- Confirmable (CON): require an acknowledgement by the other communicating part. When the network does not cause packet losses, each CON message trigger exactly one return message of type Acknowledgement or type Reset. If no ACK or RST is received, after a certain time the CON
message is assumed to be lost and it is retransmitted.
- Non-confirmable (NON): do not require an acknowledgement, offering no reliability.
- Acknowledgement (ACK): acknowledges that a particular CON message arrived. It is also able to carry the response to the request, a process known as piggybacked response.
- Reset (RST): reports that a particular message was received, but it cannot be properly processed. This usually happens when the receiver has rebooted and has forgotten some state that is required to interpret the message. Provoking a Reset message (e.g. sending an empty CON message) is also useful to check of the liveness of an endpoint.
In figure @fig:coap_messaging, we can see an example of these message types in a typical CoAP request-response interaction.

#align(center)[
    #figure(image("../images/coap-messaging.png", width: 4.5cm), 
    caption: "CoAP Message Format")
    <fig:coap_messaging>
]
#v(1.5em)

The format of the messages of the protocol has been designed to be simple and light in order to reduce the typical overhead caused by the headers of the protocols, and is depicted in figure @fig:coap_message_format.
All the messages start with a fixed-size 4-byte header, which is mandatory. Then, they could be followed by a variable-length Token value (between 0 and 8 bytes), a
sequence of zero or more CoAP Options, a payload marker and an optional payload. Only the 4-byte header is mandatory, while the rest is optional.\
#v(1.5em)
#align(center)[
    #figure(image("../images/coap-format.png", width: 13cm), 
    caption: "CoAP Message Format")
    <fig:coap_message_format>
]
#v(1.5em)
The fields in the header include: _Version_ (Ver), which identifies the version of the CoAP protocol; _Type_ indicates the type of CoAP message: 0 for CON, 1 for NON, 2 for ACK and 3 for RST; _Token Length_(TKL) determines the length of the variable-length token field; _Code_ is an 8-bit field which is split into two parts, class (0-7) and detail (0-31), where class indicates request, success response or error response and detail gives additional information to the class; _Message ID_ is used as a unique ID in network byte order (match messages ACK or RST with the CON message), used to detect duplicates and optionally for reliability. The _Token_ field is used to match responses to requests independently from the Message ID, which is especially useful when using NON messages. The _Options_ field allows to add a list of one or more options (e.g. Content-Format, Max-Age, ...). The most important options are Uri-Host, Uri-Path, Uri-Portand Uri-Query and allow to specify the target resource of a request and to locate it inside the server’s hierarchy through the composition of an Uniform Resource Identifier (URI). 
\ \

CoAP, as for HTTP, utilizes methods such as GET, PUT, POST and DELETE to achieve Create, Retrieve, Update and Delete (CRUD) operations. GET is used to retrieve the current information specified through the request URI, POST to create or update a resource, PUT to update or create a resource with the given representation, and DELETE to remove a resource identified by the URI. The method of the requests is specified in the Code field of the CoAP header. Normally, through these methods, a client can interact with a server to retrieve sensor data or control actuators following a strict request-response pattern where the server provides (see @fig:coap_messaging).\

However, to optimize sensor monitoring and reduce network overhead, CoAP includes an optional _Observe_ extension, defined in RFC 7641 @RFC7641O68. This mechanism allows a client to subscribe to a resource by sending a GET request containing an Observe option.

Instead of closing the transaction after the first reply, the server establishes an observation relationship with the client. Whenever the state of the resource changes, such as a new temperature reading, the server automatically pushes a notification to the client. This approach is functionally similar to the publish/subscribe model. However, the difference is that it remains decentralized as it does not require a central broker. In this asynchronous flow, the Token field becomes essential, as it is included in every subsequent notification to allow the client to match the incoming data with the original subscription request, even over long periods of inactivity. \

At a first glance, the CoAP communication model may seem counterintuitive for UDP, since request-response is usually associated with TCP. However, this design choice is fundamental to meet the stringent requirements of constrained devices. Unlike TCP, which requires a resource-intensive and three-way handshake to establish a connection, CoAP over UDP allows for immediate data transmission, significantly reducing latency and power consumption. Furthermore, by being inherently stateless, it eliminates the need to maintain an active connection state in memory. From a protocol efficiency perspective, CoAP also minimizes the overhead: while a TCP header is at least 20 bytes, the CoAP header, as we saw, is just 4 bytes, ensuring that small packets can be transmitted without unnecessary fragmentation.
\ \

Regarding security, UDP transport is inherently unsecure, as it does not provide any encryption or authentication mechanisms. To address this, CoAP can be secured using Datagram Transport Layer Security (DTLS), which provides similar security guarantees as TLS for TCP. DTLS ensures encryption, integrity and authentication of CoAP messages, operating between UDP and the CoAP layer. 
According to RFC7252, four security modes are defined:
- NoSec: DTLS is disabled. If needed, security should be providedat lower layers, using IP Security (IPsec).
- PreSharedKey (PSK): DTLS is enabled and the device keeps a list of pre-shared keys (PSKs) associated to the nodes with which can communicate using these keys. Key derivation functions are used to obtain the keys that secure the connection. This scheme corresponds to symmetric cryptography.
- RawPublicKey: DTLS is enabled and the device has an asymmetric key pair (public and private) that has been validated somehow. Asymmetric cryptography is used to secure the session key exchange.
- Certificate: Similar to the previous one, but in this case, the public key pair comes with an X.509 certificate that binds it to its subject and has been signed by some trusted authority, compliant with a Public Key Infrastructure (PKI).

For this work, as we will examine in @cap:methodology, we implemented CoAP with DTLS using the PreSharedKey mode, as it is the most suitable for constrained devices due to its lower computational overhead compared to asymmetric cryptography.\ \

As we saw, CoAP is a peculiar protocol that was specifically engineered to operate within resource-constrained environments by streamlining message exchanges and optimizing the efficiency of network nodes. Here we will summarize its main advantages and limitations.\

One of the most significant advantages is the reduction of data transmission delays, achieved through a highly compact header and the utilization of UDP instead of the more resource demanding TCP protocol. This architectural choice minimizes power consumption by reducing overhead and lowers the hardware requirements compared to traditional standards like HTTP. Furthermore, CoAP supports asynchronous data pushing, allowing sensors to remain in a low-power "sleep" mode for extended periods and only activate when a state change occurs. The protocol also adheres to the end-to-end principle, which removes the necessity for intermediate brokers, and offers operational flexibility by allowing users to modulate communication reliability through optional "Confirmable" messages. Its native interoperability with existing web standards further simplifies integration across heterogeneous infrastructures.

Despite these benefits, CoAP presents several structural limitations that may consitute a limit in specific scenarios. System reliability can be compromised when using non-confirmable messages due to the connectionless nature of UDP; moreover, even when confirmable messages are used, they only verify the arrival of the packet without providing guarantees against application-level errors. Another concern is the lack of sophisticated congestion control mechanisms for unconfirmed traffic, which increases the risk of network saturation. Finally, the protocol is still considered relatively immature; as it continues to evolve, the variety of available open-source implementations can sometimes lead to compatibility issues, potentially obstructing full interoperability between devices from different vendors.


==== Message Queuing Telemetry Transport (MQTT) <sec:mqtt>
MQTT is a simple, open, lightweight messaging protocol designed to offer efficient communication in low bandwidth and resource conservation for constrained devices. Originally developed by IBM in the late 1990s, it has been standardized by OASIS in 2013 @mqtt_oasis.\

Differently from CoAP, MQTT is based on the publish-subscribe paradigm, as discussed in @sec:pub_sub and shoewed in @fig:mqtt_pub_sub. Another important feature is the reliability of communication as it runs over TCP for transport. Although TCP may have higher energy overhead than UDP, it provides critical advantages for IoT reliability, primarily through ordered and lossless delivery, important especially in scenarios where data integrity and ordering are crucial. Furthermore, the use of TCP enables persistent sessions and connection awareness, which are essential for maintaining stateful interactions. \
#v(1em)
#align(center)[
    #figure(image("../images/mqtt-pub-sub.png", width: 8cm),
    caption: "Publish/subscribe process in MQTT")
    <fig:mqtt_pub_sub>
]
#v(1em)

As mentioned earlier, it has a topic-based architecture, where the exchanged data is classified by hierarchically organized topics in such a way that every message is associated with a topic. 
A topic can be described as a string that represents a specific category of information. For example, in a smart agriculture scenario, we could have messages on topics such as _/farm1/greenhouse2/temperature_ or _/farm1/field3/humidity_.  This hierarchical structure allows for efficient organization and filtering of messages.\
In MQTT, a publisher is any client, typically a sensor, that acts as a data producer by publishing messages associated with specific topics. Conversely, a subscriber functions as a data consumer by requesting information and subscribing to those same topics. It is important to note that these conditions are not exclusive; a single client can act both as a publisher and a subscriber across different data streams. The core is the broker, a central device that serves as the information hub and is responsible for maintaining the subscription interests of all clients, receiving published messages and routing them only to interested nodes. By acting as an intermediate filter, the broker ensures that each client receives only pertinent information.

\

In a MQTT network, sensor nodes may publish data directly to the cloud or to a local gateway, which then forwards the information to a cloud-based broker. This architecture, as for CoAP, depends on the specific application scenario. In open-field, for extensive farming, the use of a local gateway is often necessary due to the wide geographical distribution of devices. In contrast, smart greenhouses can often rely on direct cloud connectivity through Wi-Fi or LTE modules, given their controlled environments and stable power sources.\

#v(1em)
#align(center)[
    #figure(image("../images/mqtt_architecture.png", width: 11cm),
    caption: "MQTT System Overview")
    <fig:mqtt_system_overview>
]
#v(1em)
\

The main advantage of the architecture shown in @fig:mqtt_system_overview, is that it leaves all the complexity for the broker, so the clients can be really simple and lightweight, because implementing this architecture reduces the number of connections that a client must handle to communicate with all the nodes of the scenario, that is, just the broker. By contrast, the broker must handle a high number of connections but, typically, this is not a problem since it is implemented for tis purpose. \ \

MQTT benefits from its optimized message structure. The messages, known as MQTT Control Packets, consist of three elements: a fixed header, a variable header and a payload. The efficiency derives primarily from the fixed header, which determines the nature and behavior of the message @thangavel2014performance. As illustrated in @fig:mqtt_message_format, the first byte is divided into two main fields. The first four bits (0-3) define the _Message Type_, which categorizes the packet's function. These include connection requests (CONNECT and CONNACK , data exchange (PUBLISH and its acknowledgment PUBACK), topic management (SUBSCRIBE , SUBACK, UNSUBSCRIBE and UNSUBACK) and session maintenance (PINGREQ, PINGRESP, and DISCONNECT).\

The following four bits are specific flags that vary depending on the packet type. For instance, in a PUBLISH message, the _DUP_ flag indicate a duplicate, bits 5-6 define the _Quality of Service_ (QoS) Level and bit 7 is the _Retain_ flag. These flags allow for control over the data exchange; when certain QoS levels are required, the broker triggers additional acknowledgment messages (such as PUBACK) to ensure reliability. Furthermore, when the Retain flag is set, the broker stores the most recent state of a topic, allowing new subscribers to receive immediate updates without waiting for the next sensor cycle.\

This is immediately followed by the _Remaining Length_ field (1 to 4 bytes), which uses a variable length encoding scheme to support payloads of varying sizes with minimal overhead. Depending on the message type, the packet may also include an optional _Variable Length Header_, since it contains control information, such as the packet identifier, the topic name, the keep alive timer and protocol version. Finally, the _Message Payload_ contains the actual application data.
#v(1em)
#align(center)[
    #figure(image("../images/mqtt-message-format.ppm", width: 9cm, height: 5cm, fit: "stretch"),
    caption: "MQTT Message Format")
    <fig:mqtt_message_format>
]
#v(1em)

In a typical scenario, both the subscribers and the publishers initiate their connection to the server at any time by sending a CONNECT message and receiving the corresponding CONNACK. Once connected, each subscribers subscribes to its topics of interest by sending a SUBSCRIBE message and receiving the corresponding SUBACK. Any other client publishes information on a topic via a PUBLISH message to the broker, which then forwards the data to all interested subscribers. This is depicted in @fig:mqtt_messaging.\
#v(1em)
#align(center)[
    #figure(image("../images/mqtt-pub-sub-ack.png", width: 5.5cm),
    caption: "MQTT Messaging Example")
    <fig:mqtt_messaging>
]
#v(1em)
\

Within these exchanges, MQTT defines three distinct modes of QoS to manage message delivery reliability:
- QoS 0 (At most once delivery): Messages are delivered without retransmissions or  acknowledgments. This mode offers the lowest overhead.
- QoS 1 (At least once delivery): Each PUBLISH message must be acknowledged by a PUBACK; otherwise, it is retransmitted. This ensures delivery but may result in duplicate messages.
- QoS 2 (Exactly once delivery): This is the most reliable mode, utilizing a four-way handshake (PUBLISH, PUBREC, PUBREL, and PUBCOMP) to guarantee that the message arrives exactly once without duplicates.\

With regards to security, MQTT include some very basic security features, necessitating the use of external layers for protection. MQTT provides a simple authentication mechanism through the inclusion of a username and password in the CONNECT packet header. However, these credentials are transmitted in clear text if using plain TCP, making them vulnerable. To enhance security, MQTT can be secured using Transport Layer Security (TLS) on top of TCP, which is commonly referred to as MQTTS, which provide encryption, integrity and authentication.\

Beyond encryption, security is enforced at the broker level through authentication and authorization control. It is indeed important to verify and authorize publish or subscribe requests to particular topics, preventing unauthorized data injection or sensitive information leaks. For critical deployments, mutual TLS (mTLS) can be employed. In this configuration, both the client and the broker must provide digital certificates to establish a trusted connection. Furthermore, modern architectures often utilize JSON Web Tokens (JWT) for advanced and lightweight identity management, providing granular access tokens, as we implemented and discuss further in @cap:methodology.\

The specific security mechanisms will be detailed in @sec:security_solutions_iot. \

==== Other protocols <sec:other_protocols>
Here, just for completeness, we briefly mention other protocols, used to a lesser extent, that are used in IoT scenarios and share some characteristics with the ones presented above.
These include Advanced Message Queuing Protocol (AMQP), Data Distribution Service (DDS), Extensible Messaging and Presence Protocol (XMPP) or even Hypertext Transfer Protocol (HTTP).\ \

AMQP, developed by J.P. Morgan Chase and introduced in 2003, it is a messaging protocol designed
for reliability, security, provisioning and interoperability in enterprise systems. It supports both request/response and publish/subscribe models @amqp_dds_http_xmpp. It offers various features related
to messaging such as a reliable queuing, topic-based publish-subscribe messaging, flexible routing and transactions. For communication, the publisher or consumer creates an _exchange_ and broadcasts to the network. This exchange is used for the discovery of each other. After that, the consumer generates a queue and assigns it to the given exchange. A binding process binds the received messages to the proper queue.\

AMQP is a binary protocol, which runs over the TCP transport protocol and uses TLS/SSL and SASL for security. AMQP supports the following two levels of QoS for the delivery of messages: Unsettle Format (not reliable & at least once) and Settle Format (reliable & at most once). Compared to MQTT, @luzuriaga2015comparative, AMQP offers more aspects related to security @standard2012oasis while MQTT is more energy efficient @lee2013correlation. The recomendation is to use AMQP protocol to build reliable, scalable and advanced clustering messaging infrastructures over an ideal WLAN and the use of MQTT protocol to support connections with simple sensors/actuators under constrained environments.
\ \

HTTP is the dominant messaging protocol used on the web, developed by IETF and W3C, introduced as a standard in 1997. HTTP can be considered as the reference protocol for request/response communication, using the model-based Representational State Transfer (REST) Web architecture. Unlike MQTT and AMQP working with topics, HTTP uses Universal Resource Identifier (URI) to identify data communication between the client and the server. HTTP runs on TCP protocol and uses TLS/SSL for security and don't provides QoS. As a result of being a network resource demanding protocol, HTTP is not mainly selected for the IoT domain. In fact, as denoted in this study @gemirter2021comparative, message latency and battery consumption in much higher compared to MQTT and AMQP, which makes it unsuitable for constrained devices. 
\ \

XMPP is an open communication protocol for IoT application based on XML (Extensible Markup Language). Standardized by the IETF in 1999, XMPP enables real-time, extensible, and interoperable message exchange across distributed networks @saint2011extensible @hornsby2010instant.\

XMPP uses a client-server architecture where clients connect to a server to exchange XML-formatted messages, presence information and structured data. The protocol supports both direct client-to-client and client-to-server communication. XMPP’s extensibility is achieved through XMPP Extension Protocols (XEPs), which allows for real-time messaging, integration with other protocols, enabling context-aware applications through presence information and support decentralized architecture. For instance, via XEP-0060, it supports publish/subscribe messaging, enabling scalable applications. XMPP provides robust security features, including end-to-end encryption, transport layer security (TLS) and strong authentication (SASL).
\ \ 

DDS is an advanced, real-time, publish-subscribe communication protocol standardized by the Object Management Group (OMG). Designed for scalable, high-performance and low-latency data exchange, it is suited for mission-critical applications, such as financial trading, air traffic control or smart grid management, requiring deterministic communication @dds_spec.\

DDS is both language and OS independent. The APIs have been implemented and standardized in different programming languages, which ensure that DDS applications can be ported easily between different vendor’s implementations. Also, it specifies a wire protocol, referred to as DDSI @dds_wire. It refers to the mechanism for transmitting data from point-to-point. In contrast to protocols at the transport level (like TCP or UDP), the wire protocol is used to describe a common way to represent information at the application level, to enable interoperability between different implementations of the same.\

DDS utilizes a decentralized architecture where nodes, known as publishers and subscribers, communicate directly through a shared data space, but differently from MQTT it doesn not use a central broker. DDS is based on the concept of topic, which describe the type and structure of data to be exchanged. It also supports QoS policies that allow control data delivery guarantees, reliability, latency and resource usage. DDS operates over standard transport protocols such as UDP and TCP.


== Security Requirements, Challenges and Threats <sec:iot_security>
The Internet of Things promises to make our lives more convenient by turning each physical object into a smart object that can sense the environment, communicate with the other devices, perform reasoning and respond properly to changes in the surrounding environment. However, IoT brings also new security risks and privacy issues that must be addressed properly. Ignoring these issues may have serious effects on  different aspects: from enterprise applications to our house and even our own life.\

Imagine the vulnerability of a home where smart meters and gadgets control lighting, heating and security. If these are hacked, an attacker gains direct access to personal data. The increasing connectivity of smart cars could allow a hacker to seize control of anything from door locks to brakes and steering. Most alarming is the threat to our own lives, as even implantable medical devices like pacemakers can be intercepted. By remotely tampering, an attacker could cause fatal health complications.\

The security risks are also extremely serious when IoT devices are used in business enterprises. If an attacker hacks any of those smart objects, then that same sensing capabilities can be used by the attacker to spy on the enterprise. Such cyberattacks can also be used to steal sensitive information such as the company earnings report and credit card information. In addition, attackers may also compromise or damage physical assets by causing abnormal operations, hence causing financial losses and even endangering human lives.\ 

In the context of smart agriculture, IoT devices integrated with sensor networks play a crucial role in improving productivity and efficiency. These devices can be used for various purposes, such as monitoring soil moisture, detecting plant diseases or pests or optimizing irrigation and illumination. By gathering and analyzing data in real-time, we can make better decisions and optimize operations to achieve higher yields and reduce waste. However, such type of applications are often vulnerable to cyber-attacks, leading to data breaches and compromising the safety and integrity of operations. Moreover, the data collected by IoT devices can contain sensitive information about farming and its activities, which malicious actors may exploit for various purposes.\

In this section we will present an overview of the main security challenges, requirements, threats and solutions in IoT systems, with a particular focus on smart agriculture applications and the MQTT and CoAP protocols presented in @sec:iot_communication_protocols.

=== Security requirements <sec:security_requirements_iot>
In the context of IoT, security requirements are crucial to ensure safe and reliable operations. CIA triad is considered to be the foundation of information security and it includes, as we saw in @sec:iot_overview, three main principles: Confidentiality, Integrity and Availability @CIA_triad. However, other security requirements are also important to consider. When designing secure IoT systems, such requirements must be taken into account. Here we are going to explain them.\

_Confidentiality_: it ensures that sensitive data is accessible only to authorized entities. In IoT, this involves encrypting data both in transit and at rest to prevent unauthorized access. 
Risks associated with confidentiality breaches include: unauthorized access, where attackers exploit vulnerabilities to access protected data; weak encryption, which can be easily broken; and insider threats, where individuals with legitimate access misuse their priviledge or accidentally expose confidential data.<fresh>

_Integrity_: it ensures that data remains accurate, authentic and unaltered during storage or transmission. Any unauthorized modification or corruption compromises the reliability of data. The main risks are data tampering, where attackers intentionally alter or corrupt data and malware or ransomware, which are malicious software that can modify, encrypt or destroy data. Mechanisms such as checksums and digital signatures are employed to detect and prevent data tampering.\

_Availability_: it ensures that systems, networks and data are accessible to authorized users whenever needed. Disruptions can halt operations and cause losses. Major risks include Denial of Service (DoS) and Distributed Denial of Service (DDoS) attacks, where attackers overwhelm a system with excessive traffic, making them unavailable to legitimate users. This can lead to disruptions, downtime and financial losses.
To ensure availability, redundancy, failover mechanisms, manage network traffic to avoid congestion or bottlenecks and robust network architectures must be implemented.
\ \

Beyond the traditional CIA triad, we have:

_Authentication_: it ensures that the entities involved in any operation are who they claim to be, before granting access to resources. Risks include weak or stolen credentials or lack of multi-factor authentication. A masquerade attack or an impersonation attack usually targets this requirement where an entity claims to be another identity. 

_Authorization_: it ensures that entities have the required control permissions to perform the operation they request to perform. Role-Based Access Control (RBAC), Attribute-Based Access Control (ABAC) and Relationship-Based Access Control (ReBAC) are commonly used mechanisms to enforce authorization policies.

_Freshness_: it ensures that the data being used is up-to-date. Replay attacks target this requirement
where an old message is replayed in order to return an entity into an old state. This is particularly important in IoT where real-time data is critical for decision-making. For example, timestamps and sequence numbers are commonly used to ensure data freshness.


_Non-repudiation_: it ensures that entities cannot deny their actions. Digital signatures and audit logs are commonly used to provide non-repudiation. 

=== Challenges and Cyber Threats in Smart Agriculture <sec:security_challenges_iot>
The expansion of IoT in agriculture introduces security challenges across various dimensions and can be categorized into four critical areas: _device security_, where unauthorized manipulation and tampering must be prevented; _communication security_, requiring robust encryption for data transmission; _storage security_, demanding strict access controls and data minimization; and _processing security_, ensuring personal data handling complies with intended purposes and user consent. 

These challenges are further complicated by the distributed nature of agricultural sensors, resource constraints of devices, the volume of real-time data requiring encryption and the inherent vulnerabilities of wireless communications and open systems, which represent a limit to complex security algorithms. \ \

In a practical sense, these vulnerabilities manifest across the entire architectural stack. At the perception layer, physical components such as sensors and actuators are vulnerable to physical tampering, including theft, animal interference and malicious manipulation, while also being susceptible to node capture attacks where intruders extract cryptographic data directly from device memory. 
Moving to the transport layer, threats include Denial of Service (DoS) attacks, signal jamming, man-in-the-middle (MitM) attacks, routing manipulation and data transit interception, all of which can disrupt critical communication channels. At higher levels, middleware and application layers are exposed to malicious scripts, phishing attacks, SQL injection, signature wrapping and unauthorized actuator control. Cloud repositories supporting IoT infrastructure remain vulnerable to data tampering and unauthorized resource access. A critical concern in smart agriculture and similar IoT deployments is that security features in common protocols like MQTT and CoAP are typically disabled by default, requiring manual activation. Many existing IoT implementations lack fundamental security mechanisms, authentication procedures and failure diagnostics, leaving systems exposed to potential attacks.

In the following, we will present the most relevant cyber threats in smart agriculture IoT systems, categorized by layer.

==== Security threats in the perception layer <sec:security_threats_perception_layer>
At the perception layer, as we saw in @sec:perception_layer, comprises various devices, such as sensors and actuators. These collect information about environmental conditions such as heat, moisture, wind, plant diseases ecc. However, the physical devices are vulnerable to malfunctions caused by human actions, viruses, malware or cyberattacks. Several security issues need to be addressed in this layer. 

- _Node Capture_: it is a type of attack where an adversary physically captures a device to extract sensitive information, such as cryptographic keys. A type of this attack is node replication attack @parno2005distributed in which the attacker creates a replica of an existing node and adds it to the set of existing nodes to the network. This is particularly concerning in smart agriculture, where devices are often deployed in open fields and are easily accessible; in greenhouses, the risk is musch lower due to the controlled environment. Countermeasures include tamper-resistant hardware, HSM, secure key storage and monitoring for anomalous behavior. 

- _Replay Attacks_: in this attack, an adversary intercepts and retransmits valid data to create unauthorized effects. For example, an attacker could capture a command to activate irrigation and replay it later to cause overwatering.

- _Eavesdropping_: the attacker secretly listens to private communication of two parties without their knowledge. The aim is to obtain some confidential data or collect information. For example, an attacker could eavesdrop on the communication between a sensor and a gateway to steal sensitive data or credentials. This type of attack can be mitigated by using strong encryption like AES or RSA, but usually Elliptic Curve Cryptography (ECC) is preferred in IoT due to its resource constraints nature @ecc_iot.

- _Spleep Deprivation_: energy-constrained sensors typically rely on battery power. When these nodes are not in use, they should enter sleep mode to extend battery life. This attack involve draining the battery by sending repeated requests to keep them awake. Eventually, the device’s battery will be depleted, leading to node shutdown. This could be mitigated by implementing rate limiting, round robin scheduling, hash-based schema or random vote @sleep_deprivation_attack.

- _Jamming_: malicious signals are sent to disrupt wireless communication, causing packet loss. For instance, jamming the signal of a smoke detector could prevent a fire alarm from reaching the gateway. Defense measures include spread spectrum communication or analyzing packetd delivery ratio.

- _Physical Attack_: it include any attack that involves stealing or breaking the device so as to make it unavailable for service. The difference with node capture is that in this case the device is not used by the attacker, but the purpose is to disrupt the system's operation. Especially in open-field farming, countermeasures include locks, fences and surveillance cameras, as well as tamper resistant hardware.

==== Security threats in the transport layer <sec:security_threats_transport_layer>
The transport layer, as we saw in @sec:transport_layer, has the purpose transmit the agricultural data
collected by the perception layer to higher layers and enables the execution of actions by sensing layer devices through the delivery of control commands from the application layer to the perception layer. Due to its wide transmission range and the large volume of data being transmitted, this layer is vulnerable to various attacks that jeopardize the confidentiality and integrity of data. Despite the presence of relatively robust security mechanisms in the current communication network, common threats can still affect network resources. The following are the main security issues at the network layer.

- _RFID-based attacks_: all RFID tags have unique identities which distinguish them. If the tag does not employ any strong security features or not at all, then cloning involves replicating the tags ID and any data related to the clone tag. Similar to cloning is spoofing, where the attacker emulates the original tag and gain privileges. To mitigate these attacks strong authentication mechanism is required. Physical Unclonable Function (PUF) @puf_rfid, an authentication mechanism that uses a one-way function and challenge-response mechanism is widely used to mitigate RFID tag cloning. Several other authentication protocols based on cryptographic primitives like bitwise operator(XOR), pseudorandom numbers or hash-functions has also been proposed against such attacks.

- _Routing manipulation attacks_: these include several attacks that attempt to manipulate traffic by altering network routes. In IoT networks, malicious nodes may try to modify the routing paths used for data transmission. This may lead to incomplete or incorrect information reaching the target, delayed delivery or no delivery at all. \ In a _sinkhole attacks_ the malicious node attract traffic using false routing information to enable selective forwarding or data manipulation. In @sinkhole trust-based scheme is proposed for the routing protocol to detect and mitigate such attack. _Sybil attacks_ involve malicious nodes claiming multiple identities to spread spam or violate privacy. Mitigation includes mutual authentication or reputation techniques. _Wormhole attacks_ can be launched without compromising any node, even bypassing authenticity and confidentiality. The malicious node captures some packets from one location in the network and forwards it a distant location in the network. Most of the detection or mitigation techniques use distance or time analysis, such as in @wormhole_detection. _Hello Flood_ attacks use high-power transmissions to falsely advertise neighbor relationships and create inefficient multi-hop routes. In @hello_flood, verifying the bi-directionality of the link prior to taking any action over the message received from that link has been suggeste. Finally, _Selective forwarding_ occurs when a compromised intermediate node deliberately drop certain packets while forwarding others. Multi-path routing @de2003meshed can be used to mitigate this attack.

==== Security threats in the middleware and application layers <sec:security_threats_middleware_application_layer>
The middleware and application layers, as we saw in @sec:middleware_layer, are responsible for processing, storing and analyzing the data collected, with the purpose to provide the user a service or an application. 

- _Malicious code injection_: The adversary can inject malicious code in the node and control the IoT devices. The malicious code may crash the system, steal or tamper the confidentiality of the data. Protocols like MQTT and CoAP treat payloads as transparent data packets, if not using proper authentication and validation mechanisms, and an attacker can publish messages containing harmful scripts, such as SQL Injection or Cross-Site Scripting. Proper input validation, sanitization are helpful to mitigate this attack.

- _Phishing Attack_: in this attack, the attacker sends fraudulent messages that appear to come from a trusted source, with the aim to trick the recipient into revealing sensitive information or performing an action. For example, an attacker could induce monitoring devices to connect to a fake server, intercepting login credentials or sending false alarm states that unnecessarily activate greenhouse systems. 

- _Protocol-Specific Exploits_ : Specific protocols face unique high-layer risks. CoAP, for instance, is highly susceptible to _amplification attacks_, in which an attacker can use the end devices to convert a small packet into a larger packet, or cross-protocol attacks, where the translation from TCP to UDP is liable to attacks. Regarding MQTT, a lack of permission access can lead to unauthorized subscriptions, where a malicious client listens on sensitive topics or publishes unauthorized commands to actuators. These protocol-specific vulnerabilities can be mitigated by implementing proper packet encryption, authentication, and authorization mechanisms.

==== Security threats in the middleware and application layers <sec:security_threats_middleware_application_layer>
The middleware and application layers, as we saw in @sec:middleware_layer, are responsible for processing, storing and analyzing the data collected, with the purpose to provide the user a service or an application. 

- _Malicious code injection_: The adversary can inject malicious code in the node and control the IoT device. The malicious code may crash the system, steal or break the confidentiality of the data. Protocols like MQTT and CoAP treat payloads as transparent data packets, and without proper authentication and validation mechanisms, an attacker can publish messages containing harmful scripts, such as SQL Injection or Cross-Site Scripting (XSS). This can be avoided through input validation and sanitization on all incoming data, implementation of permission checks for accepted commands and payloads or appropriate use of firewalls and intrusion detection systems.

- _Phishing Attack_: in this attack, the attacker sends fraudulent messages that appear to come from a trusted source, with the aim to trick the recipient into revealing sensitive information, like login credentials, or performing an action. For example, an attacker could induce monitoring devices to connect to a fake server, intercepting credentials or sending false alarm states that unnecessarily activate greenhouse systems. 

- _Unauthorized access and data manipulation_: attackers may attempt to gain unauthorized access to application interfaces or cloud services, leading to incorrect decision-making and system failures. Countermeasures include implementing RBAC to limit user privileges, encryption, session timeout or token expiration mechanisms.

==== Multi-layer attacks <sec:multi_layer_attacks>
Multi-layer attacks, as the name suggests, target multiple layers of the IoT architecture simultaneously, making them particularly dangerous and difficult to mitigate. Some of the most important are the following.

- _DoS and DDoS Attacks_:  these attacks can target multiple layers of the IoT architecture. For example, an attacker could launch a DDoS attack on the network layer to overwhelm the communication channels, while simultaneously targeting the application layer with a flood of requests to exhaust server resources @ddos. Smart systems, due to their high susceptibility, pervasiveness, internet connectivity and heterogeneity, are particularly vulnerable to such attacks. This multi-layer approach can amplify the impact and make it more difficult to mitigate. In smart agriculture, for  instance, it impede the timely transmission of measurements or commands on time, especially during critical operations.


- _MitM Attacks_: in man-in-the-middle attack, the attacker inserts a malicious device into a conversation between two parties, impersonates both parties and gains access to information transmitted between them. As MitM attacks occur in different layers of IoT, mitigation techniques depends on the type of MitM attack. The attack can be countered by the using efficient cryptographic schemes. Public key cryptography are widely used to counter this attack.
\
As we saw, securing IoT systems is a complex task that addresses vulnerabilities at each layer of the architecture and requires a deep understanding of the potential threats and attack vectors. We presented some of the most important ones, with a focus on smart agriculture, but there are many more. In the next section we will present some of the most important security solutions.


== Security solutions <sec:security_solutions_iot>
To address the security challenges and threats in IoT systems, various solutions and best practices can be implemented, following the requirements discussed in @sec:security_requirements_iot. In this section, we will present and describe the most relevant security solutions for IoT systems, which are also implemented in this work on MQTT and CoAP protocols, as presented in @cap:methodology. These solutions aim to enhance the security by provinding mechanisms for authentication, authorization, encryption, integrity and availability.

=== MQTT security solutions <sec:security_solutions_mqtt>
MQTT, as we saw in @sec:mqtt, is a widely used protocol in IoT applications, but it has some security vulnerabilities that need to be addressed. Here we discuss the most important authentication and authorization mechanisms. 
==== Authentication methods
The most basic authentication mechanism in MQTT is based on the username and password fields in the CONNECT control packet, located within the variable header, as we briefly mentioned in @sec:mqtt. When a client attempts to establish a session, it submits these strings to the broker, which then validates them against an internal database, an external plugin or a dedicated service. However, because the MQTT protocol was designed for efficiency rather than native security, this method is inherently insecure as the credentials are transmitted in clear text when using plain TCP. This creates a vulnerability gap to eavesdropping, allowing unauthorized parties to silently monitor and capture sensitive information. Furthermore, it exposes the system to MitM attacks, where an intruder intercepts and potentially alters the login data, and replay attacks, where a captured CONNECT packet is later retransmitted to impersonate a legitimate client and gain unauthorized access to the broker.

To address this, in a production environment TLS is employed, which establishes an encrypted tunnel before the MQTT handshake occurs. By using TLS, the entire packet, including the username and password, is transformed into ciphertext, ensuring that even if the data is intercepted, the credentials remain unreadable to unauthorized parties.

TLS works through a multi step process. It begins with the _handshake_, where the client and broker agree on the version of TLS and the specific cryptographic algorithms to be used for the session. Following this agreement, _server authentication_ takes place and the broker sends its digital certificate containing its public key, allowing the client to verify this certificate against a trusted authority if it is a legitimate broker. Once the identity is confirmed, the _key exchange_ occurs, during which both parties securely generate a temporary symmetric session key using the broker's public key. Finally, the _encryption_ step ensures that all MQTT traffic is encrypted with this session key, allowing only the two parties to decrypt the data in transit.
\ \

Mutual TLS (mTLS), represents a variant from standard TLS, where only the server's identity is verified, by requiring both the broker and the client to authenticate each other using unique X.509 digital certificates. In mTLS, each device is issued a certificate and during the handshake, both send its public certificate with a digital signature created by its physical private key. Then, they both validates against a Trusted Root Certificate Authority (CA) to ensure the legitimacy of the other party.

This mutual authentication process is essential for IoT environments. Differently from password based authentication, here the private key never leaves the hardware (especially if combined HSM), preventing identity spoofing even if the password is compromised. Infact, during the handshake the client only sends a digital signature created by the key, not the key itself. However, the management of certificates and the computational overhead of mTLS can be challenging for resource constrained IoT devices. For these reasons often it is reserved for security or battery critical applications.
\ \

JWT (JSON Web Token) is an open standard defined in the RFC7519 @jwt_rfc. It defines a compact  way for securely transmitting identity information between parties as a JSON object. This information can be verified and trusted because it is digitally signed using a secret or a public/private key pair. JWTs are central for decoupling authentication from the broker. Instead of hardcoding static credentials into an IoT device, the client first authenticates with an Identity Provider (IdP). Once the IdP verifies the device's identity, it issues a JWT structured in three parts: a _header_, specifying the signing algorithm, a _payload_, containing claims about the device identity and permissions, and a _signature_. @fig:jwt_example shows the structure of a JWT. 

The IoT client then places this token in the MQTT password field during connection. The broker does not need to contact the IdP for every message, but instead, it validates the signature using the IdP's public key. This architecture supports granular security policies, short-lived sessions where tokens automatically expire and reduce the risk of unauthorized access if a token is intercepted.
This solution if particularly preferred for IoT, as it is lightweight, stateless and scalable, making it suitable for large deployments. Ususally, it is combined with TLS encryption to protect the token during transmission, as JWTs are vulnerable to interception and replay attacks.

The use of JWT authentication is implemented in this work, as we will see in @cap:methodology, as it is a modern, lightweight, scalable and extensible solution that fits well with the resource constraints.
#v(1em)
#align(center)[
    #figure(image("../images/jwt-example.png", width: 9cm),
    caption: "JWT Structure")
    <fig:jwt_example>
]
#v(1em)

Enhanced Authentication, introduced in MQTT 5.0, allows for multi-step authentication exchanges @mqtt5. Unlike previous versions where authentication was a unique attempt, MQTT 5.0 allows the broker to respond with an AUTH packet, triggering a challenge-response mechanism. 
The broker sends a random nonce and a salt to the client. The client performs cryptographic hashes using its password and sends the result. This allows the broker to verify that the client knows the password without the password ever being transmitted, even in encrypted form. This adds protection against replay attacks.
==== Authorization methods
Authorization is the process of determining what actions an authenticated client is permitted to perform. 

The simplest method is the use of Access Control Lists (ACLs), which provide a granular framework to define which clients can publish or subscribe. Usually, ACLs are implemented on the broker but can also be managed by an external service. For large scale IoT deployments, this method could be very inefficient, as it is statically defined and requires regular checks and maintenance, constituting a single point of failure. 
\ \

A smarter approach is the use of RBAC, where permissions are assigned to roles rather than individual clients, and clients are assigned to these roles. In this model, JTW claims, specific metadata defining roles and permitted topic scopes, can be included in the token payload. The broker then evaluates these claims to determine permissions without the need for external database lookups, enabling a stateless architecture.
\ \

For more advanced permission control, ReBAC paradigm offers a dynamic alternative by basing authorization decisions on the relationships between entities (such asusers, devices or groups) and resources (topics or data streams). Unlike traditional methods that rely on static lists, ReBAC evaluates permissions through a graph structure. For example, a maintainer might only be authorized to publish commands to a specific set of devices because they are currently assigned to the _maintenance_team_ that _manages_ that specific set. This approach is highly effective for complex and hierarchical IoT environments where access rights may change frequently based on ownership, proximity or organizational shifts. This solution was implemented in this work, as we will see in @cap:methodology.



=== CoAP security solutions <sec:security_solutions_coap>
CoAp, as we saw in @sec:coap, is a protocol designed for constrained devices and networks, but it has some security vulnerabilities that need to be addressed. Here we discuss the most important authentication and authorization mechanisms.

==== Authentication methods
DTLS is the CoAP primary security mechanism @RFC7252T73, which operates over UDP and provides authentication, integrity and confidentiality. DTLS supports three operational modes. 

- PreSharedKey (PSK): before deployment, each device is provisioned with a shared secret key known to both the client and the server. During the DTLS handshake, the client and server mutually authenticate by demonstrating knowledge of the shared key through a challenge-response mechanism, without ever transmitting the key itself. The key is used to derive session keys for encrypting subsequent communication. The main limitation is key management at scale: in large deployments, each device ideally requires a unique PSK, making secure distribution and storage of keys a significant operational challenge.

- RawPublicKey (RPK): each device holds an asymmetric key pair, typically based on ECC for efficiency. During the DTLS handshake, devices exchange their raw public keys, which are validated not through a CA but through an specific trust mechanism, such as a pre-configured list of trusted public keys. The private key never leaves the device, and the public key is used to verify digital signatures during the handshake. This approach eliminates the overhead of certificate parsing and CA validation while still providing asymmetric security guarantees.

- Certificate mode: This mode implements a full PKI. Each device has an X.509 certificate issued and signed by a trusted CA. During the DTLS handshake, devices exchange and validate each other's certificates by verifying the CA's digital signature, checking validity period and if the certificate has not been revoked. This provides a scalable and standardized trust model, but since it is resource demanding it is less suitable for constrained devices.
\ 

OSCORE (Object Security for Constrained RESTful Environments), standardized in RFC8613 @RFC8613O99, is a more recent alternative to DTLS that shifts protection from the transport layer to the application layer. It encrypts and authenticates individual CoAP messages end-to-end, ensuring protection even when passing through untrusted intermediaries. 
OSCORE is built on top of COSE (CBOR Object Signing and Encryption) @RFC8152C18, which provides a standardized framework for applying cryptographic operations to data serialized in CBOR (Concise Binary Object Representation) format. CBOR itself is a binary data format designed as a compact alternative to JSON, particularly suited for constrained devices due to its minimal parsing overhead and reduced message size. COSE extends CBOR by defining a set of structures for representing encrypted, signed and authenticated data. 
Within OSCORE, each security context is established from a master secret and salt, from which session keys are derived using HKDF (HMAC-based Key Derivation Function), ensuring independent keys for each communication direction. These keys are then used to perform AEAD (Authenticated Encryption with Associated Data) operations, with AES-CCM, combining encryption and authentication in a single lightweight operation. 

A notable extension of OSCORE is EDHOC (Ephemeral Diffie-Hellman Over COSE), key exchange protocol to allow two parties to negotiate fresh cryptographic keys using ephemeral Diffie-Hellman key pairs. Even if long term keys are compromised, past communications remain protected. This combination of EDHOC and OSCORE provides a complete, lightweight security solution that covers both key establishment and message protection, making it particularly well-suited for IoT environments.

==== Authorization methods
The primary authorization framework for CoAP is ACE-OAuth (Authentication and Authorization for Constrained Environments), standardized by the IETF, which adapts the well-known OAuth 2.0 framework to the characteristics of constrained IoT devices. In this scheme, an Authorization Server (AS) issues access tokens that clients present to resource servers to obtain access, maintaining a clear separation between authentication and authorization. These tokens are typically expressed as CWTs (CBOR Web Tokens), a compact binary variant of the more common JWTs, designed to minimize overhead on memory and computationally limited devices. ACE-OAuth supports multiple transport profiles, including DTLS and OSCORE, ensuring seamless integration with the authentication mechanisms described above. At a more granular level, authorization can be managed through Access Control Lists (ACLs), which explicitly define which resources are accessible by which devices or users, and through which CoAP methods (GET, POST, PUT, DELETE). In more complex smart agriculture deployments, Role-Based Access Control (RBAC) or the more flexible Attribute-Based Access Control (ABAC) are often adopted, with the latter enabling authorization decisions based on contextual attributes such as device location, time of day, or current system state, offering a particularly suitable access control model for the dynamic and distributed nature of agricultural IoT scenarios.