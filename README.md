	DOMAIN=$1
	echo "All steps have been generated for the domain: '$DOMAIN'"
	echo
	echo "To generate the certificates:"
	echo "Simply run each step by 'cd-ing' in their respective folders"
	echo
	echo "    # Generate the Root CA Key & Certificate"
	echo "    ./step-1_Generate_RootCA_PrivateKey.sh"
	echo "    ./step-2_Generate_RootCA_Certificate.sh"
	echo
	echo "    # Generate the Client Key & Certificate Signing Request (CSR)"
	echo "    cd ./client"
	echo "    ./step-3-A_Generate_Client_PrivateKey.sh"
	echo "    ./step-3-B_Generate_Server_PrivateKey.sh"
	echo "    cd .."
	echo
	echo "    # Generate the Server Key & Certificate Signing Request (CSR)"
	echo "    cd ./server"
	echo "    ./step-4-A_Generate_Client_CSR.sh"
	echo "    ./step-4-B_Generate_Server_CSR.sh"
	echo "    cd .."
	echo
	echo "    # Sign the Client & Server Certificates with the Root CA"
	echo "    ./step-5-A_Sign_Client_Certificate.sh"
	echo "    ./step-5-B_Sign_Server_Certificate.sh"
  echo
  echo "    # Copy the certificate in a 'docker_format' directory"
  echo "    #"
  echo "    # This follow the naming convention expected by docker when"
  echo "    # setting the 'DOCKER_CERT_PATH' environment variable"
  echo "    ./step-6_Copy_clients_certificates_using_docker_naming_format.sh"
	echo
	echo "And you're done :)"
	echo
	echo "To make understanding the process easier:"
	echo "When running each step, the command being executed will be displayed"
	echo 'Feel free to inspect the content of each script before running them ;)'
	echo
	echo 
	## Optional: 
	## One click certificate installation on remote docker daemon, with ansible.
	#
	# In the 'ansible' directory you can find a preconfigured 'ansible' 
	# project that allow you to setup in one click the docker daemon on a remote 
	# machine using these certificates.
	#
	# To use simply edit the 'ansible_user' field in the 'inventory' file to 
	# indicate your user account on the remote machine ('root' by default).
	#
	# Ensure:
	#  - You have SSH access with that username on the machine 
	#  - Python 2 is installed on the remote machine
	# 
	# Then run:
	#     cd ./ansible
	#     ansible-galaxy install -r requirements.yaml
	#     ansible-playbook playbook.yaml    # (if using 'root')
	#     OR
	#     ansible-playbook playbook.yaml -K # (if using non-'root')
	#
	# If not installed, docker will be installed on the remote machine,
	# and it will be configured to expose the port '2376' secured with the 
	# newly created certificates
	##

	echo
	echo "Have fun with your new secure docker socket at: '$DOMAIN'"
	echo










# TLS Certificates for `the-sandbox.access.ly`

Contain the certificates, along with the root ca, that allow to create a secure TLS connection via the domain: `the-sandbox.access.ly`

## Setup on remote machine

Use the `docker-sandbox` role from my private ansible configuration project.

## Activation / Deactivation

**Activation:**
```
eval $(./activate.sh)
# (or zsh function, see '~/.zshrc'
```

**Deactivation:**
```
eval $(./deactivate.sh)
# (or zsh function, see '~/.zshrc'
```

## Note on `Common name`

`Common name` represent the domain name through wich the server is accessed.

The only certificate that **really** need to contain the 'domain name' in that `Common name` field  is the one from the server.

It is the only that is remotelly accessed through the 'domain name'.
The other 'Common name' can remain empty

