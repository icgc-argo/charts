#!/usr/bin/env bash
# Generate the ca cert
my_hostname=$(hostname)
#variable this -
service_name=mongodb-replica-test-mongodb-replicaset-client
ca_crt=/mongo-certs/tls.crt
if [ -f "$ca_crt"  ]; then
    ca_key=/mongo-certs/tls.key
    pem=/mongo-certs/mongo.pem
# Move into /mongo-certs
cd /mongo-certs

cat >openssl.cnf <<EOL
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
#DNS.1 = $(echo -n "$my_hostname" | sed s/-[0-9]*$//)
#DNS.2 = $(echo -n "$my_hostname" | sed s/-[0-9]*$/-client/)
#DNS.3 = $my_hostname
DNS.4 = $service_name
#DNS.5 = localhost
#DNS.6 = 127.0.0.1
EOL

    # Generate the certs
    openssl genrsa -out mongo.key 2048
    openssl req -new -key mongo.key -out mongo.csr -subj "/OU=MongoDB/CN=$my_hostname" -config openssl.cnf
    openssl x509 -req -in mongo.csr \
        -CA "$ca_crt" -CAkey "$ca_key" -CAcreateserial \
        -out mongo.crt -days 3650 -extensions v3_req -extfile openssl.cnf

    rm mongo.csr
    cat mongo.crt mongo.key > $pem
    rm mongo.key mongo.crt
fi