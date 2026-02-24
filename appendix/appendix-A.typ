#pagebreak(to:"odd")

#import "@preview/codelst:2.0.2": sourcecode

#heading(level: 1, numbering: none, outlined: true)[
  #text()[Appendix A] 
] <sec:appendix_a>

#figure(
sourcecode(
  
```
entity platform {
    relation super_admin @user
    permission manage_tenants = super_admin
}

entity tenant {
    relation admin      @user | @user_group#member
    relation maintainer @user | @user_group#member
    relation member     @user | @user_group#member

    permission is_admin      = admin
    permission is_maintainer = maintainer
    permission is_member     = member

    permission manage_structure = is_admin or is_maintainer
    permission view_structure   = manage_structure or is_member
}

entity macro_section {
    [...]
}

entity section {
  [...]
}

entity device_type {
    attribute can_pub_data  boolean
    attribute can_issue_cmd boolean
    // ... other capability attributes

    permission allowed_pub_data   = can_pub_data
    permission allowed_issue_cmd  = can_issue_cmd
    // ... other permissions derived from attributes
}

entity device {
    relation section    @section
    relation type       @device_type
    relation controller @user | @user_group#member

    permission publish_data = type.can_pub_data
    permission subscribe_cmd = type.can_sub_cmd
    permission receive_cmd  = section.operate_devices or controller
    permission read_data    = section.view_data
}
```
), caption: "Permify schema example"
) <code:permify_schema_example>