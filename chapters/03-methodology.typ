#pagebreak(to:"odd")
= Methodology <cap:methodology>

== Introduction <sec:introduction3>
In this chapter, we will describe the framework's architecture and design choices, implementation details and the evolution of the project through its development stages. All the choices were guided by the requirements outlined in the previous chapter. We will also as well as the challenges encountered during development and how they were addressed. The chapter is structured to provide a comprehensive overview of the framework's construction, from high-level architectural decisions to low-level implementation details.

== Architectural requirements <sec:arch_requirements>
For completeness, we restate here the architectural requirements, as depicted in @fig:arch_requirements as they guided the design and implementation, with a deeper description.  \



*Multi-tenancy and Data Isolation*: A tenant is a logically isolated organizational unit that shares the same infrastructure but operates independently from others. In this context, each tenant represent a different company, with its own devices, users and data streams. Isolation must be enforced at every layer: device authentication, message routing, data storage and access control, ensuring that no tenant can access another's resources. This requirement directly influences the choice and implementation of every service in the stack and the technical communication specifications.

#align()[
   #figure(image("../images/requirements.png", width: 24em),
    caption: "Architectural requirements")
    <fig:arch_requirements>
]
#v(1em)

*Open Source*: All components must be based on open-source technologies. Beyond promoting transparency and avoiding vendor lock-in, this requirement is practically motivated by the nature of the project itself: being a thesis internship without dedicated funding, commercial licensing costs are not an option. Open-source solutions also tend to have greater community support and better long-term and low-cost maintainability.

*High Availability*: HA refers to the ability of a system to remain operational even when the failure of an individual service happens. In production environments, HA is achieved through redundancy: multiple instances of a service running concurrently as a single unit so that if one fails, others can take over without interruption. This is also a security requirement, as availability is one of the CIA principles. In practice, this means that services must support clustering or horizontal scaling, which directly conditions technology selection.

*Identity and Access Management*: IAM refers to the set of policies and mechanisms that govern who can access what within a system. In a multi-tenant IoT platform, this involves managing two distinct classes of identities: human users such as administrators, operators or maintainers, each with different permission levels; and device identities, which must be authenticated before being allowed to publish or consume data. IAM must therefore be handled by a service that supports both user management with role-based access control and machine identity management.

*Machine-to-Machine Authentication*: the framework should also consider, if possible, that internal backend services need to authenticate with each other to prevent unauthorized access to internal APIs and message brokers. M2M authentication relies on service accounts and short-lived tokens, typically issued by the IAM service, ensuring that even internal communication is subject to access control policies.

*Interoperability*: The architecture must support heterogeneous application protocols that coexist and cooperate together, and must be designed with extensibility. This means adding support for a new IoT protocol or a custom user-defined protocol should require low effort and no structural changes to the existing system. MQTT and CoAP devices must interact with the rest of the system without upper layers being aware of the underlying protocol differences. The integration layer must abstract away protocol-specific details, translating between different communication paradigms while preserving message semantics and delivery guarantees. From the perspective of backend services and end users, a CoAP sensor and an MQTT sensor should appear equivalent, differing only in their data, not in how they are handled.

*Authentication and Authorization.* All entities interacting with the system, human users or IoT devices, must be properly authenticated and authorized. Authentication ensures that each entity is who it claims to be, while authorization governs what it is permitted to do. For human users, this involves standard flows based on credentials and MFA support with role-based access control. For IoT devices, authentication must account for the constrained nature, favoring lightweight protocols. 

== Architectural overview <sec:arch_overview>
The whole architecture can be broken into three main components or layers: 
+ the device layer;
+ the cloud infrastructure layer;
+ the end user layer.
@fig:arch_overview depicts the high-level architecture and how these layers interact with each other.
#v(1.5em)
#align()[
   #figure(image("../images/schemas/arch_overview.png", width: 40em),
    caption: "Architectural requirements")
    <fig:arch_overview>
]
\ 

The device layer corresponds to the perception layer of the IoT stack (@sec:perception_layer) and is composed of the physical devices, that collect data from the environment or perform specific actions. These devices are heterogeneous and could be produced by different manufacturers, hence using different communication protocols. Also, we need to consider custom and proprietary devices or protocols, which are common in industrial environments. For this reason, the architecture must be designed to be extensible and support multiple protocols, with a focus on MQTT and CoAP.\ 

Devices can be classified into two categories: 
- _sensors_: which collect telemetry data from the environment and publish it to the cloud infrastructure.
- _actuators_: which receive commands from the cloud infrastructure (e.g., user commands, automated trigger or a command directly coming from a sensor) to perform specific actions in the environment.
\

The cloud infrastructure layer corresponds to the middleware layer of the IoT stack (@sec:middleware_layer) and is responsible for managing the incoming data from devices, authenticate and authorize requests, processing it and making it available for end users. This layer includes in particular: _message brokers_ that handle the communication with devices, protocol translation and data routing; _databases_ that store and manage data for visualization, analysis and subsequent actions; _authentication and authorization services_ that ensure only authorized users and devices can access the system. As we wil see, the system is much more complex than this simplified description, especially considering the interoperability requirement.
\ \

The end user layer corresponds to the application layer of the IoT stack (@sec:application_layer) and includes the interfaces and applications that allow users to interact with the system, such as dashboards, APIs and control panels. This layer provides the means for users to visualize data, configure devices (e.g., setting thresholds for alerts or sending commands to actuators) and manage their accounts and permissions. This layer must consider the different types of users and their needs, ensuring that the system is able to assign to each user the appropriate level of access and functionality based on their role, that determines what they can see and do within the system. 
At the implementation level, for this layer we only designed and considered roles, permissions and the corresponding APIs, without implementing a UI, as the focus of the project is on the backend infrastructure that manages the devices and data. However, the architecture is designed to be extensible, so that a UI can be added in the future without requiring deep structural changes.


== Use Case Scenario: Smart Agriculture <sec:use_case_agriculture>

=== Motivation <sec:use_case_motivation>
After defining the architectural requirements and providing a high-level structure of how the system should be implemented, we will now describe a concrete use case scenario. This is necessary to guide the design and implementation of the framework, as it provides a practical context in which to apply the architectural principles and requirements outlined above and that influence important design choices. \

As we mentioned in the introduction (@sec:problem_statement), a general purpose solution that attempts to consider every possible scenario, while theoretically feasible, introduces a level of complexity that is difficult to justify in practice. The cost of designing, testing and maintaining such a system grows exponentially as the number of supported configurations increases. Introducing a universal cloud infrastrcure layer would require accounting for an immense variety of edge cases, packet formats, timing constraints and so on. \ 

This is also true when security is taken into account: each additional use case brings its own set of actors, roles, permissions and threat models, which must all be accounted for and validated. When the system already has to bridge the gap between two protocols with opposite  communication paradigms, adding an unbounded set of contextual assumptions it increase the workload and multiplies the number of possible interactions and failure modes. For this reason, bounding the design to a concrete and defined scenario allows us to make reasonable choices, without sacrificing the clarity or the correctness of the system. 
\ \ 

=== Scenario Description <sec:use_case_description>

The use case scenario we designed falls within the domain of smart agriculture, which is gaining increasing attention as a promising application of IoT technologies. In particular, we focus on smart greenhouses, which are controlled environments that optimize plant growth by regulating factors such as temperature, humidity, light and soil moisture. For these reasons, greenhouse may be compared to a chemical laboratory, where different resources are controlled and monitored to achieve a specific outcome. This makes them an ideal context for an IoT framework to optimize crop yields. However, the framework is designed to be extensible and can be adapted also to open field agriculture. \
#v(1em)
#align(center)[
   #figure(image("../images/smart-greenhouse.png", width: 36em),
    caption: "Smart greenhouse use case scenario example")
    <fig:smart_greenhouse>
]
#v(1em)

In this scenario, as depicted in @fig:smart_greenhouse, we can see an example of a greenhouse equipped with a variety of sensors and actuators that monitor and control the environment. 

- *Thermal control.* Temperature and humidity sensors are distributed across the greenhouse in specific zones, tracking ambient conditions and transmitting readings. The cloud servers may calculate average values or apply specific logic through a series of telemetry readings, to analyze trends or detect anomalies and trigger alerts to operators. For example, if temperature exceeds acceptable limits, commands are sent to controllers to activate air conditioning or ventilation fans in the affected zones, with actions logged and displayed on the dashboard.

- *Irrigation.* Soil moisture sensors measure water content in the soil, providing data that informs irrigation decisions. Rather than watering on a fixed schedule, the system can trigger irrigation only when needed, reducing water waste and preventing overwatering or drought stress. Automated valves or pumps connected as actuators enable precise control over water delivery.

- *Light and shading.* Light intensity sensors measure illumination levels and trigger automated responses: closing shading curtains when light is excessive or activating LED lights when necessary. The dashboard may displays real-time status and historical trends to optimize light exposure.

- *pH and nutrient monitoring.* pH and electrical conductivity sensors monitor substrate solution chemistry. When values deviate from optimal ranges, dosing pumps automatically add base solutions or nutrients, with all corrections logged and displayed graphically.

- *Local gateway.* Data collection and command distribution are mediated by a local gateway situaded within the greenhouse. This gateway serves as a bridge between the edge devices (sensors and actuators) and the cloud infrastructure, aggregating telemetry data from sensors and forwarding it to the central platform for storage and processing, while simultaneously receiving commands from the cloud and forwarding them to the appropriate actuators. In this initial abstraction, the local gateway is considered primarily as a data transit point. A detailed discussion is done in Section X, as its role has important implications on the communication. \ \

This form a comprehensive monitoring and control infrastructure. It is important to note that, being situated in an agricultural context rather than a critical industrial environment or a life-critical application, the system tolerates moderate delays and inaccuracies. Environmental parameters change gradually, and while certain operations (such as irrigation or dosing pumps require timely responses) failures or delays do not result in catastrophic consequences. This allows for low to moderate data transmission frequencies (in order of seconds or minutes) and provides some margin for error. Hence, the computational and network load remains manageable. 

=== Hierarchical Zoning and Topic Structure <sec:hierarchical_zoning>

The physical organization of the greenhouse and the deployment of devices directly influence the design of the communication infrastructure, particularly the topic structure used to distinguish between different devices and data streams. This reinforces the concept introduced earlier: defining a precise use case scenario is essential because it conditions the entire communication architecture.

The decision to adopt a topic-based communication paradigm, rather than a traditional RESTful approach, is motivated by various factors. Topic-based messaging accommodates a wide variety of devices and data types while providing a flexible and horizontally scalable structure. It enables efficient routing and filtering of messages based on semantic content, simplifies audit logging and traceability, and supports multi-tenant environments where different organizations have distinct data streams and access requirements.

This design choice is further justified by the need to support both MQTT and CoAP devices, which operate on fundamentally different paradigms: MQTT is inherently topic-based, while CoAP is resource-based. By designing a topic structure, the system achieves interoperability. The topic structure serves as a unifying abstraction that bridges the gap between these protocols, allowing them to coexist and interact seamlessly without requiring significant changes to the underlying communication mechanisms.

==== Design and Evolution <sec:hierarchical_zoning_design>
In the system we designed, because of the multi-tenancy requirement, the topic structure must include a field for the tenant ID, to ensure logical isolation between different organizations. Each tenant may have multiple sites, which can be either greenhouses or open fields, and each site is identified by a unique site ID. Within each site, there are sections and zones that further subdivide the physical space, allowing for more granular organization and management of devices. Each device is categorized by its type (e.g., sensor or actuator) and subclass (e.g., temperature sensor, irrigation pump), with a unique identifier for each individual device. Finally, the message type field distinguishes between different types of messages (telemetry, command, state, alert, config) and the target ID field specifies the intended recipient of commands or configuration messages. 
\ \ 

During the design process, topic structure evolved from a 9 to a 10 level hierarchy. This modification was necessary to address two critical requirements that emerged during implementation: the need to explicitly specify the target device when sending commands, and authentication constraints that emerged and will be discussed in detail in the following sections .

The initial 9-level structure was sufficient for telemetry flows, where sensors publish data about themselves without needing to address other entities. However, when devices or gateways (which, as we will see, act as devices themselves in certain scenarios) need to send `command` messages to actuators, the topic must explicitly identify the target recipient. Without a dedicated field for the target device ID, the system would have no way to determine which actuator should execute the command, particularly in zones where multiple actuators of the same type may be present.

The final 10-level topic hierarchy is structured as follows in @tab:topic_hierarchy:

#v(1em)
#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    align: (center, left, left, left),
    stroke: 0.5pt,
    inset: 5pt,
    [*Level*], [*Field*], [*Description*], [*Example*],
    [1], [`tenant_id`], [Logical isolation between organizations], [`agroTech01`],
    [2], [`site_type`], [Type of agricultural facility], [`greenhouse`, `openfield`],
    [3], [`site_id`], [Physical site identifier], [`GH-001`],
    [4], [`section_id`], [Section within the site], [`section-2`],
    [5], [`zone_id`], [Operational zone], [`zone-A`],
    [6], [`entity_type`], [Device category], [`sensor`, `actuator`],
    [7], [`entity_subclass`], [Specific device type], [`temp`, `ph`, `waterpump`],
    [8], [`entity_id`], [Unique device identifier], [`mqtt-device-03`],
    [9], [`message_type`], [Message classification], [`data`, `cmd`, `status`, `alert`],
    [10], [`target_id`], [Target device for commands (optional)], [`cooler-001`],
  ),
  caption: [10-level topic hierarchy structure]
) <tab:topic_hierarchy>
#v(1em)


For example, a temperature sensor publishing telemetry would use:
```
agroTech01/greenhouse/GH-001/section-2/zone-A/sensor/temp/mqtt-device-03/telemetry/
```

While a gateway sending a command to activate a cooling system would use:
```
agroTech01/greenhouse/GH-001/section-2/zone-A/actuator/cooler/gateway-01/command/cooler-001
```

This structure ensures that commands are unambiguously addressed, authorization policies can be enforced based on the sender-target relationship and the topic itself carries sufficient semantic information for routing and filtering at every layer of the architecture.


=== MQTT vs CoAP Deployment Scenario <sec:mqtt_vs_coap_deployment>
In agricultural IoT deployments, the selection between MQTT and CoAP is primarily dictated by the specific environmental constraints and the reliability of the available network infrastructure. Within a greenhouse setting, where devices typically operate under stable connectivity and consistent power supplies, MQTT is often the preferred communication protocol. By utilizing persistent TCP connections, MQTT ensures low-latency transmission and reliable data delivery, which is essential for the real-time telemetry required in controlled environments. Conversely, in open-field agriculture where sensors are often battery-powered and distributed across vast areas with intermittent network access, CoAP provides a more efficient alternative. Based on the UDP transport layer and a request-response architecture, CoAP significantly reduces the energy overhead associated with connection management, allowing highly constrained devices to maximize their battery life, even for several month without any manual intervention, while operating in lossless environments.

== Authentication and Authorization Services <sec:authz>
Beyond the general architectural decisions and the specific use case scenario, among the first design choices we had to make was selecting the appropriate authentication and authorization services. The IAM service must support both user and machine identity management and ensure that only authorized users and devices can access the system.
A study on authentication and authorization methods for MQTT and CoAP was conducted, as described in @sec:security_solutions_iot, to evaluate the available options and select the most suitable solution that we hope to implement in the future.

For MQTT, we chose to secure the transport layer with TLS rather than relying on X.509 client certificates, primarily because mutual authentication with certificates introduces computational overhead that increases battery consumption. For authentication, we selected JWT tokens, given their wide adoption, high security properties and compatibility with imited devices. JWTs also support custom claims, which allows the broker to enforce permission control directly from the token payload.

For CoAP, our initial choice was to use CWT tokens, motivated by their structural similarity to JWTs and the expectation that this would simplify interoperability at the broker side. However, we found that CWT, despite being designed for constrained environments, was not the best solution in our scenario: the ecosystem support is still limited, the tooling is less mature and the effort required to integrate CWT issuance and validation would have been comparable to a heavier solution. In particular, the _Zitadel_ service we chose do not support CWT token for machine users. However, as we will see in @sec:coap_implementation, this turned out to be not the best solution, leading us to adopt a different authentication mechanism for CoAP devices. We therefore moved to DTLS with PSK, which provides a secure and encrypted communication channel while remaining lightweight. This approach also handles device identification implicitly through the key identity, removing the need for a separate token layer at the transport level.

=== Zitadel <sec:zitadel>
As already discussed in @sec:authentication_service, among the different authentication services available, based on the architectural requirements and goals of the project, we chose to implement _Zitadel_ service. The decision was driven by the need to support JWT authentication for MQTT devices, as it was the first protocol we decided to implement, and the fact that it provides native support for JWT issuance and validation, which simplifies integration with the MQTT broker. _Zitadel_ also supports a wide range of authentication methods for human users, including password-based authentication, MFA and social login options, making it a versatile choice for managing user identities in a multi-tenant environment.

While not directly supporting CWT tokens for machine users, it was still essential to manage user identities for the overall system, providing a solid and dedicated IAM service. At this point, is clear that finding a unified solution for both protocols is challenging, especially under the constraints of the project, we need to make trade-offs and adapt our choices.

==== Deployment and Configuration <sec:zitadel_deployment>

Zitadel was implemented using its official Docker image, without any modifications to the
base image itself. All configuration varua is supplied through environment variables at container
startup, following the recommended approach for containerized deployments.

On first startup, Zitadel initializes its own database schema on a PostgreSQL instance and
bootstraps a default organization and administrator account, whose credentials are injected
via environment variables. A machine user acting as a login client is also provisioned
automatically, along with a Personal Access Token (PAT) that is written to a shared volume
and consumed by other services that need to interact with the Zitadel API.

The instance is configured to use the v2 login interface, a recent implementation of
the authentication flow. The relevant OIDC, SAML and logout URLs are set explicitly to
point to this interface, which is served on a dedicated port alongside the main Zitadel
backend. For the purposes of the project, we disabled TLS since we were running the service locally, as the infrastructure is intended for local development and testing. In a
production environment, TLS termination and a proper external domain would need to be
configured.

#text(fill: rgb("#d60d0d"))[In the following sections, we will see how Zitadel is integrated with the rest of the system, particularly with the MQTT broker and the authorization service.]

=== Permify <sec:permify>
Regarding authorization, we had to define first the roles and permissions model for both human users and devices. The proposed system adopts a multi-tenant hierarchical architecture in which a single _Super-Admin_ oversees the entire platform and is responsible for provisioning and managing tenants and their respective administrators. It has no direct access to tenant data, ensuring strict isolation between organizations. 

#align(center)[
    #figure(image("../images/schemas/tenants.png", width: 39em),
      caption: "Authorization schema")
      <fig:authorization_schema>
]
#v(0.5em)
\

Each tenant is governed by an _Admin_, who holds full read, write, and edit privileges exclusively within their own tenant . Inside each tenant, resources (users and devices) can be organized into groups, which act as permission containers: any entity belonging to a group automatically inherits the permissions defined at the group level, reducing configuration overhead and enforcing consistent access policies. Alternatively, users and devices can be managed individually without group membership when finer control is required. 


Users are further classified into two roles: _Members_, responsible for usage of the system with low privileges, such as viewing data or controlling devices in their specific greenhouse, macro section or sub-section of the greenhouse, and _Maintainers_, who carry out technical or maintenance tasks with admin-like privileges. 
Members, who belong to the tenant, can be further divided in _Supervisors_, who are responsible for managing and overseeing the activities in a specific macro section of the greenhouse, and _Operators_, who are responsible for overseeing the operations in a specific section (or zone). 

This relational model is depicted as an example in @fig:authorization_schema.

\ 

Given that permissions, especially those assigned to users, are subject to change over time, the system must support dynamic access control policies. ABAC was discarded, as it requires defining and maintaining a large number of attributes for each entity and make the system quickly unmanageable as it scales. RBAC, while more practical, proved insufficiently flexible to address the complex and evolving permission requirements of a multi-tenant architecture, particularly given the hierarchical nature of the resources involved.

These considerations led to the adoption of ReBAC, a model that enables fine-grained and dynamic permission management by expressing access rights in terms of relationships between entities. As discussed in @sec:authorization_service, the chosen solution is _Permify_, an open-source ReBAC service.

==== Schema Design, Implementation and Evolution <sec:permify_design>

The authorization _schema_ designed for Permify reflects the hierarchical structure of the
platform. At the top level, a `platform` entity holds `super_admin` relations, granting
the ability to manage tenants without direct access to their data. Each `tenant` entity
defines three roles, `admin`, `maintainer`, and `member`,  which can be assigned either
to individual users or to user groups, so that permissions are inherited by all group members.
Below the tenant level, the hierarchy continues through `macro_section` and `section`
entities, each inheriting and refining permissions from the level above. For example, an
operator assigned to a section can issue commands to devices within it, while a plain
member can only read data. Access rights are expressed as relations between entities and
are evaluated by traversing the relationship graph at query time. In @code:permify_schema_example (#link(<sec:appendix_a>, "Appendix A")), we put a simplified version of the authorization schema designed, which captures the main entities, relations and permissions. The actual implementation is more complex, with additional entities for user and device groups and specific rules for device capabilities, but this example illustrates the core structure and logic of the authorization model.

Devices are represented by a `device` entity that carries three key relations: `section`, which places it within the hierarchy, `type`, which points to a `device_type` that defines the capabilities, and hence the permissions,  of that class and `controllers`, which defines which member in the tenant is allowed to control that device. 


#figure(
  image("../images/permify_schema.png", width: 15em),
  caption: [Example of Permify authorization schema],
) <fig:permify_schema>
#v(1em)
@fig:permify_schema shows a simplified representation of the authorization schema as visualized by the Permify Playground. The graph illustrates the core concepts of the model: the `platform` entity at the top, connected to `super_admin` users through a relation that grants the `manage_tenants` permission. Each `tenant` defines `admin` and `member`, whose composition drives the computed permissions `is_admin`, `is_member`, `manage_devices` and `view_devices`. The `device` entity then inherits
these permissions by following its relation to the tenant, while also allowing a direct `controller` relation for device assignment. Note that this schema is intentionally minimal and we put it here only to illustrate the general structure of how relational model works. The actual schema used in the system is considerably more complex, using additional entity types, a deeper organizational hierarchy and a greater set of permissions and relations.

\ 

The data model in Permify is based on the _tuple_, written as a triple following the schema structure of the form `(entity, relation, subject)` that records a single relationship in the system. For
instance, the fact the `john_doe` is an admin of `tenant:agroTech01`   is stored as the tuple:
`
{ 
  "entity": { "type": "tenant", "id": "agroTech01" },
  "relation": "admin",
  "subject": { "type": "user", "id": "john_doe" }
}
` 
Permission checks are resolved by traversing the graph of tuples starting from the queried entity, combining relations and computed permissions according to the schema. 
\ \

During the design phase, device capabilities were initially modeled as relations on the `device_type`
entity, meaning that each individual device had to be explicitly linked to its type for
every capability it was allowed to use. This approach introduced a significant scalability
problem: with six capabilities per device type and hundreds of devices, the number of
required tuples grew proportionally with the fleet size, reaching thousands of entries for
even a low sized deployment. Debugging also became impractical, as determining why
a specific device lacked a permission required scanning a large number of tuples.

To address this, the capability model was revised to use _attributes_ instead of relations, since Permify supports also ABAC permissions.
In the updated schema, each `device_type` entity carries a set of boolean attributes,
such as `can_pub_data` or `can_sub_cmd`, that define what devices of that type are
allowed to do. Permissions on the `device` entity then inherit these values by following
the `type` relation, so that a single attribute definition applies uniformly to all devices
of a given type. The practical effect of this change was substantial: registering a new
device now requires only one tuple (the assignment of its type), rather than one per
capability. Verifying why a device lacks a permission reduces to two lookups rather than a search through hundreds of tuples. This redesign improved both the maintainability and the clarity of its semantics. This was only possible because of the flexibility of the ReBAC model.


== Multi-Tenancy and Data Isolation <sec:multi-tenancy>
To achieve multi-tenancy and data isolation, a requirement described in @sec:arch_requirements, the architecture must ensure that each tenant's data and resources are separated and protected from unauthorized access by other tenants. There are three primary strategies for implementing tenant isolation:

- _Logical isolation_: relies on software level mechanisms to separate tenant data within shared infrastructure. All tenants use the same service instances, database, and message brokers, but separation is achieved through access control policies, tenant identifiers embedded in data structures such as the topics and authorization checks. This approach maximizes resource utilization and minimizes operational overhead and costs, as a single infrastructure serves all tenants.

- _Physical isolation_: provisions separate infrastructure for each tenant, including dedicated service instances, databases and message brokers. Each tenant operates in a completely isolated environment with no shared resources. While this provides the strongest security guarantees and eliminates the risk of data leakage among tenants, it significantly increases infrastructure costs, complexity and resource consumption, as each tenant requires a full deployment of the entire stack.

- _Hybrid isolation_: combines both approaches by physically separating critical components, such as databases containing sensitive data, while logically isolating less critical services, such as message brokers or gateways, which are shared across tenants with strict access control. This strategy balances security and cost, dedicating resources where isolation is most critical while sharing infrastructure where logical separation is sufficient.
\

For this project, we chose to implement logical isolation for the following reasons. 
First, the scope and constraints of the project make physical isolation impractical, as it would require deploying separate instances of all services for each tenant, significantly increasing infrastructure complexity and resource requirements beyond the available time and budget. Second, physical isolation incurs substantially higher costs in terms of maintenance, monitoring and scalability, as each tenant would need independent updates, backups and capacity planning. Third, physical isolation is usually applied in scenarios with very strict security, such as life-critical applications, financial systems or highly sensitive data handling. Logical isolation, when properly implemented with robust authentication, authorization and data partitioning mechanisms, provides sufficient security and isolation for multi-tenant IoT platforms, making it the most pragmatic and cost-effective choice for this work.

Moreover, during the design and implementation process, we decided not to use the built in multi-tenancy features of the services we chose. Instead, we implemented multi-tenancy at the application level, by embedding tenant identifiers in the topic structure, as described above, and enforcing access control policies based on these identifiers using the _Permify_ service. This approach, while requiring more custom development and seeming counterintuitive at first, provides greater flexibility and control over the multi-tenancy implementation, allowing us to tailor the isolation mechanisms. Also, if in the future we decide to switch to a different service that does not support multi-tenancy natively, we can easily adapt the existing implementation without needing to redesign the entire system.

== MQTT implementation <sec:mqtt_implementation>
For the implementation of the communication we decided to start with MQTT, as it is the most widely adopted protocol in the IoT domain and is particularly well-suited for the greenhouse use case scenario. Moreover, we chose to develop initially the MQTT communication from the device layer to the cloud infrastructure, to provide a solid foundation for the communication architecture and later extend it to support CoAP devices. From a first analysis, MQTT is more simple to implement, as it relies on a wide range of mature open-source brokers and client libraries.

In this section, we will discuss the design and implementation of the MQTT communication layer, which is responsible for handling the communication between MQTT devices and the rest of the infrastructure. 

=== Gateway: Problem Statement and Design Choices <sec:gateway_problem_statement>
One of the first design choices we had to make was regarding the role of the gateway,
which is the core of a publish-subscribe architecture, as described in @sec:pub_sub.
The question was: is it better to use a single gateway that translates CoAP requests
to MQTT or to have two separate gateways, one for MQTT and one for CoAP, that both
interact with the cloud infrastructure independently? @fig:gateway_design_choices illustrates the two options.
#v(1em)
#align(center)[
    #figure(image("../images/single_vs_double.png", width: 18em),
      caption: "Gateway design choices")
      <fig:gateway_design_choices>
]
#v(1em)
As described in @sec:central_message_broker, NATS was selected as the central message broker for the platform. Its model based on _subject_ abstracts the concept of topics, making it a natural fit for a system that must handle messages from multiple protocols. The goal was therefore to have all messages, regardless of their origin, eventually reach NATS, where downstream services could consume them uniformly.

However, before reaching the broker, each protocol requires its own ingestion layer.
MQTT and CoAP differ fundamentally in their communication model. MQTT is asynchronous:
a device maintains a persistent connection and listens continuously for messages on its
subscribed topics. CoAP, by contrast, is synchronous and request-response oriented: a
device sends a request and expects a reply within a certain time, after which it closes the connection.

This asymmetry has direct consequences on how the two protocols handle the two main
message flows in the system: telemetry and commands. For telemetry, both protocols can
publish data to the gateway, which forwards it to NATS for consumption by downstream
services. The difference is that an MQTT device maintains its connection passively,
while a CoAP device sends data as an explicit request and expects an acknowledgement
in return. For commands, the divergence is more significant: an MQTT device can receive
a command at any time, as long as it is connected and subscribed to the relevant topic.
A CoAP device, on the other hand, is not always reachable, so the gateway must be able
to hold a pending command and deliver it when the device reconnects.

The initial choice was to adopt a single solution for both protocols for easier maintainability. EMQX was selected as a strong candidate, since it is a widely adopted
MQTT broker that also support CoAP, for a seamless integration of both protocols under a single service and reducing  operational complexity and maintenance. However, after a first implementation, two critical limitations emerged. First, the open-source version of EMQX only supports single node deployments, meaning that high availability is not available without a commercial license. Second, CoAP support in EMQX is only available in the paid tier. For the project requirements, EMQX has been discarded.

This led to the decision to adopt two separate gateways. For MQTT, VerneMQ (@sec:mqtt_broker) was chosen. Although VerneMQ is distributed under the commercial EULA licence, by compiling the binary from source the resulting build is fully open and usable
without licensing costs. 

For CoAP, a custom gateway was developed, tailored to the specific command and telemetry semantics described above. Both gateways are responsible for translating their respective protocol messages into NATS subjects, where the rest of the platform consumes them uniformly. 

The first concept of the gateway architecture is depicted in @fig:gateway_architecture.
#v(1em)
#align(center)[
    #figure(image("../images/first_concept.png", width: 30em),
      caption: "Gateway architecture")
      <fig:gateway_architecture>
]

=== VerneMQ <sec:vernemq>
VerneMQ was configured

=== JWT Issuing and Validation <sec:jwt_issuing_validation>
When a device connects for the first time, it must first obtain a JWT token from Zitadel to authenticate itself to the MQTT broker. Initially, we assume that it 

=== Bridging NATS and VerneMQ <sec:nats_vernemq>
The next step was to implement the integration between VerneMQ and NATS, to ensure that
messages published by MQTT devices are correctly forwarded to the central message broker.

Since VerneMQ natively speaks only the MQTT protocol and has no nativesupport for the
NATS protocol, a direct integration between the two systems is not possible without an
intermediate component. For this reason, a dedicated bridge service was implemented as a Go microservice. The bridge connects to VerneMQ as a regular MQTT client,
subscribes to the topics of interest, and for each received message computes the
corresponding NATS subject according to the hierarchical naming conventions of the
platform, optionally enriches the payload with metadata such as tenant and device
identifiers, and publishes the event to the appropriate JetStream stream.

This design keeps the routing and transformation logic outside both VerneMQ and NATS, so that both can evolve or be replaced with limited impact on the rest of the system. The bridge is the only component in the architecture that understands both MQTT topic semantics and NATS subject conventions, acting as a translation layer between the two services. 

A second bridge service was subsequently introduced to handle the reverse flow, that is,
commands originating from the backend and directed toward MQTT devices. This service
subscribes to the relevant NATS subjects and publishes the corresponding messages to
VerneMQ, which then delivers them to the target devices. The two bridges together form a complete bidirectional channel between the MQTT layer and the internal messaging backbone, as depicted in @fig:bridge_architecture. 

#align()[
    #figure(image("../images/bridges.png", width: 40em),
      caption: "Bridge services architecture")
      <fig:bridge_architecture>
]
#v(1em)
High availability for both services was considered during the design phase,
and the architecture supports running multiple replicas to avoid a single point of
failure on the pipeline. However, this configuration was not implemented in the current
deployment and the bridges run as single instances for the time being.

Regarding authentication, the bridge services are treated as special clients of the infrastructure. 
Specifically, they are modeled as `service` entities in the authorization schema and
follow the same JWT authentication process described for standard MQTT devices.
Each bridge obtains a JWT through Zitadel and presents it when connecting
to VerneMQ, so that the broker and the authorization layer can apply the same access
control policies uniformly, regardless of whether the client is a physical device or an
internal bridge.


=== NATS: Subject Mapping and Message Persistence <sec:nats_subject_mapping>
- come funziona
- jetstream implementation
- high availability
- incoming vs outcoming messages
 

=== DB worker and Persistence <sec:db_worker>
- how messages are persisted in the database
- schema design for telemetry and commands
- handling of historical data and time series

== CoAP implementation <sec:coap_implementation>

== Load Balancing and High Availability <sec:load_balancing>

== Local Gateway Role <sec:local_gateway_role>