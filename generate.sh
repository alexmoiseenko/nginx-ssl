#!/bin/sh

rm -rf certs
mkdir certs

## Certificate Authority

## You will be prompted to set a passphrase. Make sure to set it to something you’ll remember.
openssl genrsa -des3 -out certs/ca.key -passout pass:12345 4096

## Makes the signing CA valid for 10 years. Change as requirements dictate.
## You will be asked to fill in attributes for your CA.
openssl req -new -x509 -days 3650 -key certs/ca.key -passin pass:12345 -subj /C=RU/ST=Moscow/L=Moscow/O=dlg.im.dev/OU=calls/CN=sbrf-calls.transmit.im/emailAddress=imd@dlg.im -out certs/ca.crt

## User certificate

## You will be prompted for a passphrase which will be distributed to your user with the certificate. Do NOT ever distribute the passphrase set above for your root CA’s private key. Make sure you understand this distinction!
openssl genrsa -des3 -out certs/user.key -passout pass:123456 4096
openssl req -new -key certs/user.key -passin pass:123456 -subj /C=RU/ST=Moscow/L=Moscow/O=dev.dlg.im/OU=calls/CN=sbrf-calls.transmit.im/emailAddress=imd@dlg.im -out certs/user.csr

## Sign with our certificate-signing CA
## This certificate will be valid for one year. Change as per your requirements.
## You can increment the serial if you have to reissue the CERT
openssl x509 -req -days 1 -in certs/user.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -passin pass:12345 -out certs/user.crt

## To enable us to use the certificate from a web browser, we would need to create the certificate in the PFX file format.
openssl pkcs12 -export -passin pass:123456 -password pass:1234567 -out certs/user.pfx -inkey certs/user.key -in certs/user.crt -certfile certs/ca.crt

## You can verify if the generated certificate can be decrypted using the CA certificate by the following command
openssl verify -verbose -CAfile certs/ca.crt certs/user.crt

## Server

## Generate an RSA Private Key (You will be prompted to set a passphrase and fill out attributes)
openssl genrsa -out certs/server.key 4096

## Use it to create a CSR to send us
openssl req -new -key certs/server.key -subj /C=RU/ST=Moscow/L=Moscow/O=dev.dlg.im/OU=calls/CN=sbrf-calls.transmit.im/emailAddress=imd@dlg.im -out certs/server.csr

# Create a config file for the extensions
cat << EOF > certs/server.ext
  authorityKeyIdentifier=keyid,issuer
  basicConstraints=CA:FALSE
  keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
  subjectAltName = @alt_names

  [alt_names]
  DNS.1 = local
  IP.1 = 127.0.0.1
EOF

## Create a server certificate
openssl x509 -req -days 365 -sha256 -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -passin pass:12345 -out certs/server.crt -extfile certs/server.ext

## Test nginx
# curl -v --cacert ca.crt --cert user.crt --key user.key https://127.0.0.1:8443/
