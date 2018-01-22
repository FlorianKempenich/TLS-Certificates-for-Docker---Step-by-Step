#!/bin/bash

###############################################################
## See at the bottom of that file to get an idea of the flow ##
###############################################################

## Functions ##################################################
function generate_step-1_Generate_RootCA_PrivateKey {
  cat > ./step-1_Generate_RootCA_PrivateKey.sh <<'EndOfStep1'
#!/bin/bash

echo "Running: openssl genrsa \\"
echo "           -aes256 \\"
echo "           -out rootca-privatekey.pem \\"
echo "           4096"
echo
openssl genrsa \
  -aes256 \
  -out rootca-privatekey.pem \
  4096

echo
echo DONE
EndOfStep1

  chmod +x ./step-1_Generate_RootCA_PrivateKey.sh
}
function generate_step-2_Generate_RootCA_Certificate {
  DOMAIN=$1
  echo '#!/bin/bash'       > ./step-2_Generate_RootCA_Certificate.sh
  echo                    >> ./step-2_Generate_RootCA_Certificate.sh
  echo "HOST=\"$DOMAIN\"" >> ./step-2_Generate_RootCA_Certificate.sh
  echo                    >> ./step-2_Generate_RootCA_Certificate.sh
  cat >> ./step-2_Generate_RootCA_Certificate.sh <<-'EndOfStep2'
echo "Running: openssl req \\"
echo "           -new \\"
echo "          -x509 \\"
echo "          -sha256 \\"
echo "          -days 365 \\"
echo "          -subj \"/O=FlorianKempenich Self-signed Certificate Generator/OU=RootCA/CN=$HOST\" \\"
echo "          -key rootca-privatekey.pem \\"
echo "          -out rootca-certificate.pem"
echo
openssl req \
  -new \
  -x509 \
  -sha256 \
  -days 365 \
  -subj "/O=FlorianKempenich Self-signed Certificate Generator/OU=RootCA/CN=$HOST" \
  -key rootca-privatekey.pem \
  -out rootca-certificate.pem

echo
echo DONE
EndOfStep2

  chmod +x ./step-2_Generate_RootCA_Certificate.sh
}
function generate_step-3-A_Generate_Client_PrivateKey {
  cat >> ./client/step-3-A_Generate_Client_PrivateKey.sh <<-'EndOfStep3A'
#!/bin/bash

echo "Running: openssl genrsa \\"
echo "         -out client-privatekey.pem \\"
echo "         4096"
echo
openssl genrsa \
  -out client-privatekey.pem \
  4096

echo
echo DONE
EndOfStep3A

  chmod +x ./client/step-3-A_Generate_Client_PrivateKey.sh
}
function generate_step-4-A_Generate_Client_CSR {
  DOMAIN=$1
  echo '#!/bin/bash'       > ./client/step-4-A_Generate_Client_CSR.sh
  echo                    >> ./client/step-4-A_Generate_Client_CSR.sh
  echo "HOST=\"$DOMAIN\"" >> ./client/step-4-A_Generate_Client_CSR.sh
  echo                    >> ./client/step-4-A_Generate_Client_CSR.sh
  cat >> ./client/step-4-A_Generate_Client_CSR.sh <<-'EndOfStep4A'
# Create directory
echo "Running: mkdir ./csr"
echo
mkdir ./csr


# Generate CSR
echo "Running: openssl req \\"
echo "           -new \\"
echo "           -subj \"/O=FlorianKempenich Self-signed Certificate Generator/OU=Client/CN=$HOST\" \\"
echo "           -key client-privatekey.pem \\"
echo "           -out csr/client-CSR.csr"
echo
openssl req \
  -new \
  -subj "/O=FlorianKempenich Self-signed Certificate Generator/OU=Client/CN=$HOST" \
  -key client-privatekey.pem \
  -out csr/client-CSR.csr


# Generate extension file
echo "Running: echo extendedKeyUsage = clientAuth >> csr/client-extfile.cnf"
echo
echo extendedKeyUsage = clientAuth >> csr/client-extfile.cnf

echo
echo DONE
EndOfStep4A

  chmod +x ./client/step-4-A_Generate_Client_CSR.sh
}

function generate_step-3-B_Generate_Server_PrivateKey {
  cat >> ./server/step-3-B_Generate_Server_PrivateKey.sh <<-'EndOfStep3B'
#!/bin/bash

echo "Running: openssl genrsa \\"
echo "           -out server-privatekey.pem \\"
echo "           4096"
echo
openssl genrsa \
  -out server-privatekey.pem \
  4096

echo
echo DONE
EndOfStep3B

  chmod +x ./server/step-3-B_Generate_Server_PrivateKey.sh
}
function generate_step-4-B_Generate_Server_CSR {
  DOMAIN=$1
  echo '#!/bin/bash'       > ./server/step-4-B_Generate_Server_CSR.sh
  echo                    >> ./server/step-4-B_Generate_Server_CSR.sh
  echo "HOST=\"$DOMAIN\"" >> ./server/step-4-B_Generate_Server_CSR.sh
  echo                    >> ./server/step-4-B_Generate_Server_CSR.sh
  cat >> ./server/step-4-B_Generate_Server_CSR.sh <<-'EndOfStep4B'
# Create directory
echo "Running: mkdir ./csr"
echo
mkdir ./csr

# Generate CSR
echo "Running: openssl req \\"
echo "           -new \\"
echo "           -subj \"/O=FlorianKempenich Self-signed Certificate Generator/OU=Server/CN=$HOST\" \\"
echo "           -key server-privatekey.pem \\"
echo "           -out csr/server-CSR.csr"
echo
openssl req \
  -new \
  -subj "/O=FlorianKempenich Self-signed Certificate Generator/OU=Server/CN=$HOST" \
  -key server-privatekey.pem \
  -out csr/server-CSR.csr


# Generate extension file with SAN
echo "Running: echo extendedKeyUsage = serverAuth >> csr/server-extfile.cnf"
echo "Running: echo subjectAltName = DNS:$HOST >> csr/server-extfile.cnf"
echo

echo extendedKeyUsage = serverAuth >> csr/server-extfile.cnf
echo subjectAltName = DNS:$HOST >> csr/server-extfile.cnf

echo DONE
EndOfStep4B

  chmod +x ./server/step-4-B_Generate_Server_CSR.sh
}
function generate_step-5-A_Sign_Client_Certificate {
  cat >> ./step-5-A_Sign_Client_Certificate.sh <<-'EndOfStep5A'
#!/bin/bash

echo "Running: openssl x509 \\"
echo "           -req \\"
echo "           -days 360 \\"
echo "           -CAcreateserial \\"
echo "           -CA rootca-certificate.pem \\"
echo "           -CAkey rootca-privatekey.pem \\"
echo "           -in client/csr/client-CSR.csr \\"
echo "           -extfile client/csr/client-extfile.cnf \\"
echo "           -out client/client-certificate.pem"
echo
openssl x509 \
  -req \
  -days 360 \
  -CAcreateserial \
  -CA rootca-certificate.pem \
  -CAkey rootca-privatekey.pem \
  -in client/csr/client-CSR.csr \
  -extfile client/csr/client-extfile.cnf \
  -out client/client-certificate.pem

echo
echo DONE
EndOfStep5A

  chmod +x ./step-5-A_Sign_Client_Certificate.sh
}
function generate_step-5-B_Sign_Server_Certificate {
  cat >> ./step-5-B_Sign_Server_Certificate.sh <<-'EndOfStep5B'
#!/bin/bash

echo "Running: openssl x509 \\"
echo "           -req \\"
echo "           -days 360 \\"
echo "           -CAcreateserial \\"
echo "           -CA rootca-certificate.pem \\"
echo "           -CAkey rootca-privatekey.pem \\"
echo "           -in client/csr/client-CSR.csr \\"
echo "           -extfile client/csr/client-extfile.cnf \\"
echo "           -out client/client-certificate.pem"
echo
openssl x509 \
  -req \
  -days 360 \
  -CAcreateserial \
  -CA rootca-certificate.pem \
  -CAkey rootca-privatekey.pem \
  -in client/csr/client-CSR.csr \
  -extfile client/csr/client-extfile.cnf \
  -out client/client-certificate.pem

echo
echo DONE
EndOfStep5B

  chmod +x ./step-5-B_Sign_Server_Certificate.sh
}
function generate_step-6_Copy_clients_certificates_using_docker_naming_format {
  cat >> ./step-6_Copy_clients_certificates_using_docker_naming_format.sh <<-'EndOfStep6'
#!/bin/bash

mkdir -p ./docker_format
cp ./rootca-certificate.pem ./docker_format/ca.pem
cp ./client/client-certificate.pem ./docker_format/cert.pem
cp ./client/client-privatekey.pem ./docker_format/key.pem
EndOfStep6

  chmod +x ./step-6_Copy_clients_certificates_using_docker_naming_format.sh
}
function generate_activation_deactivation_scripts {
  DOMAIN=$1
  echo '#!/bin/bash'       > ./activate.sh
  echo                    >> ./activate.sh
  echo "HOST=\"$DOMAIN\"" >> ./activate.sh
  echo                    >> ./activate.sh
  cat >> ./activate.sh <<-'EndOfActivate'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo 'export DOCKER_TLS_VERIFY="1"'
echo "export DOCKER_HOST=\"tcp://$HOST:2376\""
echo "export DOCKER_CERT_PATH=\"$SCRIPT_DIR/docker_format\""

echo '# Do not RUN'
echo "# But 'eval \$(./activate.sh)'"
EndOfActivate

  cat > ./deactivate.sh <<-'EndOfDeactivate'
#!/bin/bash

echo 'unset DOCKER_TLS_VERIFY'
echo 'unset DOCKER_HOST'
echo "unset DOCKER_CERT_PATH"

echo '# Do not RUN'
echo "# But 'eval \$(./deactivate.sh)'"
EndOfDeactivate

  chmod +x ./activate.sh
  chmod +x ./deactivate.sh
}
function generate_gitignore {
  cat > ./.gitignore <<'EOF'
docker_format
ansible/roles_deps
EOF
}
function optional_generate_ansible_project {
  mkdir ./ansible
  cat > ./ansible/ansible.cfg <<'EOF'
[defaults]
inventory = inventory
roles_path = roles_deps
retry_files_enabled = False
EOF

  cat > ./ansible/playbook.yml <<'EOF'
- hosts: secure-remote-docker
  tasks:
    - name: Setup the remote machine with a `docker daemon` using the newly created certificates
      include_role:
        name: FlorianKempenich.setup-secure-remote-docker-daemon
      vars:
        rootca_certificate: "{{ lookup('file', '../rootca-certificate.pem') }}"
        server_certificate: "{{ lookup('file', '../server/server-certificate.pem') }}"
        server_privatekey: "{{ lookup('file',  '../server/server-privatekey.pem') }}"
EOF

  cat > ./ansible/requirements.yml <<EOF
- src: FlorianKempenich.setup-secure-remote-docker-daemon
EOF
}

function echo_README {
	echo "done (put readme here from curl)"
}
## END - Functions ############################################



###############
## Main Flow ##
###############
if [ -z "$1" ]; then
  echo 'Please provide a domain name: `docker_tls_certificates_generator.sh DOMAIN_NAME`'
  exit 1
fi
DOMAIN=$1

# Root CA Steps
generate_step-1_Generate_RootCA_PrivateKey
generate_step-2_Generate_RootCA_Certificate $DOMAIN
# Client Steps
mkdir ./client
generate_step-3-A_Generate_Client_PrivateKey
generate_step-4-A_Generate_Client_CSR $DOMAIN
# Server Steps
mkdir ./server
generate_step-3-B_Generate_Server_PrivateKey
generate_step-4-B_Generate_Server_CSR $DOMAIN
# Signing Client/Server certs with Root CA Steps
generate_step-5-A_Sign_Client_Certificate
generate_step-5-B_Sign_Server_Certificate
# Copy to the format expected by the 'docker client'
generate_step-6_Copy_clients_certificates_using_docker_naming_format
# Generate exta scripts
generate_activation_deactivation_scripts $DOMAIN
generate_gitignore
# Generate optional 'ansible' project
optional_generate_ansible_project

# Print instructions
echo_README $DOMAIN

