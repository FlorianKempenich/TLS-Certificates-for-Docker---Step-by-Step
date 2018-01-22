# TLS Certificates for Docker - Step-by-Step

> Confused how to create your own self-signed certificates to secure a remote docker socket?
> 
> This project generates a set of instructions, as executable scripts, to guide you in
> that process.

## Usage

### One line installation
In an **emtpy folder** run:
```
bash <(curl -s https://raw.githubusercontent.com/FlorianKempenich/TLS-Certificates-for-Docker---Step-by-Step/master/generate_steps.sh) \
  YOUR_DOMAIN_NAME
```

This will create a set of scripts in the current directory each representing 
a step to generate the following set of certificates / private keys:

```
* RootCA - Private Key 
* RootCA - Self-signed Certificate 
* Client - Private Key 
* Client - Certificate signed by Root CA
  * Used for client authentication with the `docker daemon`
  * The `docker daemon` is set to trust any certificate issued by the Root CA
* Server - Private Key 
* Server - Certificate signed by Root CA
  * Certifies the domain name set by: `YOUR_DOMAIN_NAME`
```


### Generate the certficates

After running the installation command, simply **execute each step** to generate the all the certificates.

    # Generate the Root CA Key & Certificate
    ./step-1_Generate_RootCA_PrivateKey.sh
    ./step-2_Generate_RootCA_Certificate.sh

    # Generate the Client Key & Certificate Signing Request (CSR)
    cd ./client
    ./step-3-A_Generate_Client_PrivateKey.sh
    ./step-3-B_Generate_Server_PrivateKey.sh
    cd ..

    # Generate the Server Key & Certificate Signing Request (CSR)
    cd ./server
    ./step-4-A_Generate_Client_CSR.sh
    ./step-4-B_Generate_Server_CSR.sh
    cd ..

    # Sign the Client & Server Certificates with the Root CA
    ./step-5-A_Sign_Client_Certificate.sh
    ./step-5-B_Sign_Server_Certificate.sh

    # Copy the certificate in a 'docker_format' directory
    #
    # This follow the naming convention expected by docker when
    # setting the 'DOCKER_CERT_PATH' environment variable
    ./step-6_Copy_clients_certificates_using_docker_naming_format.sh

**And you're done :)**

To make understanding the process easier:  
When running each step, **the command being executed will be displayed.**

Feel free to inspect the content of each script before running them ;)

## Activation / Deactivation scripts

Once your `docker` machine is setup to use the certificates, to run `docker` commands
directly on that machine a pair of activation / deactivation scripts is provided.

### Activate the remote machine
```
eval $(./activate.sh)
```
Any `docker` command ran after the activating the machine will be executed **on the remote machine**

### Deactivate the remote machine
```
eval $(./deactivate.sh)
```
`docker` commands are now running locally again.

> ### More details on Activation / Deactivation
> #### Before activation:
> ```
> docker run \
>   --rm \
>   --name=hello-world\
>   -eWORLD=Mundo \
>   -p"80:80" \
>   -d floriankempenich/hello-world
> ```
> Would run a **hello-world** web server on the port `80` of your local machine.
> 
> #### After activation:
> After runnning `eval $(./activate.sh)`, the **same command**:
> ```
> docker run \
>   --rm \
>   --name=hello-world\
>   -eWORLD=Mundo \
>   -p"80:80" \
>   -d floriankempenich/hello-world
> ```
> Will now run a **hello-world** web server on the port `80` of the **remote machine** accessible through `YOUR_DOMAIN_NAME`
 
-------------

## Optional: One click `docker` setup
On top of the step-by-step instructions, a **one click `docker` setup** ansible 
project has been created.

It allows to setup a **working remote `docker` socket** using the generated **certificates** in **one click**.

> **The only requirements are:**
> * `ansible` is installed on the **local** machine
> * You have SSH access with that `username` on the **remote** machine 
> * Python 2 is installed on the **remote** machine

### Usage

> 1. **Enter** the directory: `cd ./ansible`
> 2. **Edit** the `ansible_user` field in the `inventory` file.
>    * To indicate the `username` you use to connect to the remote machine.
>    * Default: `root`
> 3. **Run** the playbook: `ansible-playbook playbook.yaml`
>    * Or `ansible-playbook playbook.yaml -K` if using a **non-root** user

The machine accessible at `YOUR_DOMAIN_NAME` is now a **fully configured, remotely accessible, secured with TLS** `docker` machine.

After you ensure that `YOUR_DOMAIN_NAME` is actually pointing to that machine, 
you can simply activate it by running: `eval $(./activate.sh)`

For more info, see: [Activation / Deactivation](http://)

--- 

## Credits

**Antonio Pires:**  
    For helping me figure out how TLS Certificates work.  
    As well as how they are used in the context of Docker.