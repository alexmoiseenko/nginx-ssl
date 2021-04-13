#!/bin/bash
rm -rf certs
mkdir certs

openssl req -new -newkey rsa:2048 -nodes -keyout certs/ca.key -x509 -days 500 -subj /C=RU/ST=Moscow/L=Moscow/O=dlg.im.dev/OU=calls/CN=sbrf-calls.transmit.im/emailAddress=imd@dlg.im -out certs/ca.crt

openssl genrsa -des3 -out certs/server.key -passout pass:12345 2048
openssl rsa -in certs/server.key -passin pass:12345 -out certs/server.nopass.key

openssl req -new -key certs/server.key -subj /C=RU/ST=Moscow/L=Moscow/O=dev.dlg.im/OU=calls/CN=sbrf-calls.transmit.im/emailAddress=imd@dlg.im -passin pass:12345 -out certs/server.csr 
openssl x509 -req -days 365 -sha256 -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key -set_serial 01 -out certs/server.crt

openssl req -new -newkey rsa:2048 -nodes -keyout certs/client.key -subj /C=RU/ST=Moscow/L=Moscow/O=dlg.im.dev/OU=calls/CN=sbrf-calls.transmit.im/emailAddress=imd@dlg.m -out certs/client.csr

openssl x509 -req -days 1 -in certs/client.csr -CA certs/ca.crt -CAkey certs/ca.key -set_serial 02 -out certs/client.crt

openssl pkcs12 -export -in certs/client.crt -inkey certs/client.key -out certs/client.p12 -certfile certs/ca.crt -passout pass:12345

