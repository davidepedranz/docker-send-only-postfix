# docker-send-only-postfix
Docker container with Postfix configured in send-only mode and OpenDKIM.
Postfix will accept emails from all private IP addresses on all network interfaces.
All emails send from Postfix to other email servers are encrypted using standard TLS.

## Setup
In order to use this container, you will need to setup OpenDKIM.

Generate a pair of private-public key:
```bash
mkdir keys
cd keys
opendkim-genkey -s mail -d example.com
```
The command will generate 2 files `mail.private`, your private key, and `mail.txt`, with the DNS record you need to setup.
```txt
TXT mail._domainkey.example.com "v=DKIM1; k=rsa; p=...private key..."
```

## Usage
Make sure the container is not directly exposed on the Internet, since it will accept emails from every network interface. The typical setup is to connect it to other Docker containers using some private network.
```bash
docker run -d \
    -p 127.0.0.1:25:25 \
    -e DOMAIN=example.com \
    -v /path/to/mail.private:/etc/opendkim/domainkeys/mail.private
    davidepedranz/postfix
```

## Optional
Setup SPF to limit who can send emails on behave of your domain. See the references.
Example (limit only the IP that maps to domain example.com to send emails):
```txt
TXT example.com "v=spf1 a -all"
```

## References
- https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy
- https://www.digitalocean.com/community/tutorials/how-to-use-an-spf-record-to-prevent-spoofing-improve-e-mail-reliability

## License
See [LICENSE](LICENSE) file.
