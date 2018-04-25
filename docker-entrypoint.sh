#!/usr/bin/env sh
set -e

# read domain from environment
if [ -z "${DOMAIN}" ]; then
    echo "DOMAIN environment variable not found. Please set it before running this Docker container."
    exit 1
fi

# TODO: escape domain!

# replace the placeholders in the configuration files
PATTERN="s/\${DOMAIN}/${DOMAIN}/g"
sed -i ${PATTERN} /etc/postfix/main.cf
sed -i ${PATTERN} /etc/opendkim/SigningTable
sed -i ${PATTERN} /etc/opendkim/KeyTable

# check the presence of the key for opendkim
if [ ! -f /etc/opendkim/domainkeys/mail.private ]; then
    echo "Cannot load the 'mail.private' file from '/etc/opendkim/domainkeys/mail.private'. Please mount it as a Docker volume before starting the container."
    exit 1
fi

# fix permissions on files
chown opendkim:opendkim /etc/opendkim/domainkeys
chown opendkim:opendkim /etc/opendkim/domainkeys/mail.private
chmod 400 /etc/opendkim/domainkeys/mail.private

# launch the processes supervisor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
