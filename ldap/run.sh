#!/bin/bash

set -e

if [ ! -f /data/lib/ldap/DB_CONFIG ]; then

    cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    chown ldap. /var/lib/ldap/DB_CONFIG

    service slapd start
    sleep 3

    ldapmodify -Y EXTERNAL -H ldapi:/// -f /root/manager.ldif
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /root/domain.ldif

    ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /root/memberOf.ldif
    ldapadd -x -D cn=admin,ou=admins,dc=yourcompany,dc=com -w Company@123 -f /root/base.ldif

    service slapd stop
    sleep 3

    mkdir /data/lib /data/etc
    cp -ar /var/lib/ldap /data/lib
    cp -ar /etc/openldap /data/etc
fi

rm -rf /var/lib/ldap && ln -s /data/lib/ldap /var/lib/ldap
rm -rf /etc/openldap && ln -s /data/etc/openldap /etc/openldap

exec /usr/sbin/slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap -d $DEBUG_LEVEL
