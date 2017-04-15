Be noted that this ldap server is just for testing purposes

# Source
https://github.com/Appdynamics/extensions-docker/tree/master/openldap

# Docker OpenLDAP server
Installs and configures OpenLDAP server with the following credentials

```
Bind DN: cn=admin,ou=admins,dc=yourcompany,dc=com
password: Company@123
```

### LDAP Configuration
##### Connection
```
Bind DN: cn=admin,ou=admins,dc=yourcompany,dc=com
password: Company@123
```
##### Users
```
Base DN: ou=people,dc=yourcompany,dc=com
Attributes: dn, cn, uid, memberOf
```
##### Groups
```
Base DN: ou=groups,dc=yourcompany,dc=com
Attributes: dn, cn, member
```
##### BuiltIn Users and Groups
`Company@123` is the password for all Users
```
phihuynh, phuongle: Administrators
user1, user2: Read Only
user1: Group1
user1, user2, user3: Group2
```

## A very good link here for LDAP
https://gitlab.com/chamunks/docker-ldap (BROKEN)

https://github.com/osixia/docker-openldap

https://docs.gitlab.com/ce/administration/auth/ldap.html

Command to check LDAP is working
username: admin
password: admin
$ docker exec -it ldapserver
$ ldapsearch -x -H ldap://nt-openldap -b dc=yourcompany,dc=com -D "cn=admin,ou=admins,dc=yourcompany,dc=com" -w Company@123
$ ldapsearch -x -H ldap://192.168.1.107 -b dc=appdynamics,dc=com -D "cn=admin,ou=admins,dc=appdynamics,dc=com" -w Company@123

## Login with php server
username: cn=admin,dc=yourcompany,dc=local
password: admin
