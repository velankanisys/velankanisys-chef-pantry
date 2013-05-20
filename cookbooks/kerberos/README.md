Simple kerberos chef recipe
===========================

This will be extended over time to support more options.

Usage example (client)
----------------------

```ruby
default_attributes "kerberos" => {
    "realms" => {
        "MYREALM.COM" => {
            "kdc" => ["kerberos1.myrealm.com", "kerberos2.myrealm.com"],
            "admin_server" => ["kerberos2.myrealm.com"]
        }
        "MYREALM2.COM" => {
            "kdc" => ["kerberos1.myrealm2.com", "kerberos2.myrealm2.com"],
            "admin_server" => ["kerberos2.myrealm2.com"]
        }
    },
    "default_realm" => "MYREALM.COM",
    "pam" => true,
    "machine_admins" => ["jimdoe/admin"]
}
```

This configures the client to authenticate against
`kerberos1.myrealm.com` and `kerberos2.myrealm.com`. It also enables
PAM authentication against Kerberos and lets `jimdoe/admin` login as
`root` on the client.

Usage example (server)
----------------------

```ruby
default_attributes "kerberos" => {
    "default_realm" => "MYREALM.COM",
    "kerberos_admins" => ["janedoe/admin", "johndoe/admin"],
}
```

This configures the server as a Kerberos admin server and KDC and
gives administrative privileges to `janedoe/admin` and
`johndoe/admin`.

Note that you still have to create a new Kerberos realm by
running `krb5_newrealm` after running the server recipe.

Troubleshooting
---------------

If you have any problems with Kerberos, please always make sure to
double-check your DNS and rDNS resolution and your current hostname
(`hostname -f`).
