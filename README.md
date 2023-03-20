# Form3 Platform Interview

Platform engineers at Form3 build highly available distributed systems using infrastructure as code. Our take home test is designed to evaluate real world activities that are involved with this role. We recognise that this may not be as mentally challenging and may take longer to implement than some algorithmic tests that are often seen in interview exercises. Our approach however helps ensure that you will be working with a team of engineers with the necessary practical skills for the role (as well as a diverse range of technical wizardry).


## 🧪 Sample application
The sample application consists of four services:

```
┌─────────────┐     ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│             │     │              │    │              │    │              │
│   payment   │     │   account    │    │   gateway    │    │   frontend   │
│             │     │              │    │              │    │              │
└─────────┬───┘     └──────┬───────┘    └──────┬───────┘    └──────────────┘
          │                │                   │
          │                │                   │
          │                ▼                   │
          │         ┌──────────────┐           │
          │         │              │           │
          └────────►│    vault     │◄──────────┘
                    │              │
                    └──────────────┘
```                    

Three of those services connect to [vault](https://www.vaultproject.io/) to retrieve database credentials. The frontend container serves a static file.

The project structure is as follows:

```
.
├── docker-compose.yml
├── form3.crt
├── README.md
├── run.sh
├── Vagrantfile
├── services
│   ├── account
│   ├── gateway
│   └── payment
└── tf
    └── main.tf
```
1. Refactoring the Terraform code found in the [tf](./tf) directory is the primary focus of this test.
1. `Vagrantfile`, `run.sh` and `docker-compose.yml` are used to bootstrap this sample application; refactoring these files is not part of the test, but these files may be modified if your solution requires it.
1. `form3.crt` is used to ease sandboxed running of the submission by Form3 staff and can be ignored.
1. The `services` code is used to simulate a microservices architecture that connects to vault to retrieve database credentials. The code and method of connecting to vault can be ignored for the purposes of this test.

## Using an M1 Mac?
If you are using an M1 Mac then you need to install some additional tools:
- [Multipass](https://github.com/canonical/multipass/releases) install the latest release for your operating system
- [Multipass provider for vagrant](https://github.com/Fred78290/vagrant-multipass)
    - [Install the plugin](https://github.com/Fred78290/vagrant-multipass#plugin-installation)
    - [Create the multipass vagrant box](https://github.com/Fred78290/vagrant-multipass#create-multipass-fake-box)

## 👟 Running the sample application
- Make sure you have installed the [vagrant prerequisites](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index#prerequisites)
- In a terminal execute `vagrant up`
- Once the vagrant image has started you should see a successful terraform apply:
```
default: vault_audit.audit_dev: Creation complete after 0s [id=file]
    default: vault_generic_endpoint.account_production: Creation complete after 0s [id=auth/userpass/users/account-production]
    default: vault_generic_secret.gateway_development: Creation complete after 0s [id=secret/development/gateway]
    default: vault_generic_endpoint.gateway_production: Creation complete after 0s [id=auth/userpass/users/gateway-production]
    default: vault_generic_endpoint.payment_production: Creation complete after 0s [id=auth/userpass/users/payment-production]
    default: vault_generic_endpoint.gateway_development: Creation complete after 0s [id=auth/userpass/users/gateway-development]
    default: vault_generic_endpoint.account_development: Creation complete after 0s [id=auth/userpass/users/account-development]
    default: vault_generic_endpoint.payment_development: Creation complete after 1s [id=auth/userpass/users/payment-development]
    default: 
    default: Apply complete! Resources: 30 added, 0 changed, 0 destroyed.
    default: 
    default: ~
```
*Verify the services are running*

- `vagrant ssh`
- `docker ps` should show all containers running:

```
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS          PORTS                                       NAMES
6662939321b3   nginx:latest                         "/docker-entrypoint.…"   3 seconds ago    Up 2 seconds    0.0.0.0:4080->80/tcp                        frontend_development
b7e1a54799b0   nginx:1.22.0-alpine                  "/docker-entrypoint.…"   5 seconds ago    Up 4 seconds    0.0.0.0:4081->80/tcp                        frontend_production
4a636fcd2380   form3tech-oss/platformtest-payment   "/go/bin/payment"        16 seconds ago   Up 9 seconds                                                payment_development
3f609757e28e   form3tech-oss/platformtest-account   "/go/bin/account"        16 seconds ago   Up 12 seconds                                               account_production
cc7f27197275   form3tech-oss/platformtest-account   "/go/bin/account"        16 seconds ago   Up 10 seconds                                               account_development
caffcaf61970   form3tech-oss/platformtest-payment   "/go/bin/payment"        16 seconds ago   Up 8 seconds                                                payment_production
c4b7132104ff   form3tech-oss/platformtest-gateway   "/go/bin/gateway"        16 seconds ago   Up 13 seconds                                               gateway_development
2766640654f3   form3tech-oss/platformtest-gateway   "/go/bin/gateway"        16 seconds ago   Up 11 seconds                                               gateway_production
96e629f21d56   vault:1.8.3                          "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:8301->8200/tcp, :::8301->8200/tcp   vagrant-vault-production-1
a7c0b089b10c   vault:1.8.3                          "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:8201->8200/tcp, :::8201->8200/tcp   vagrant-vault-development-1
```

## ⚙️ Task
Imagine the following scenario, your company is growing quickly 🚀 and increasing the number services being deployed and configured.
It's been noticed that the code in `tf/main.tf` is not very easy to maintain 😢.

We would like you to complete the following tasks:

- [ ] Improve the Terraform code to make it easier to add/update/remove services
- [ ] Add a new environment called `staging` that runs each microservice
- [ ] Add a README detailing: 
  - [ ] Your design decisions, if you are new to Terraform let us know
  - [ ] How your code would fit into a CI/CD pipeline
  - [ ] Anything beyond the scope of this task that you would consider when running this code in a real production environment


## 📝 Candidate instructions
1. Create a private [GitHub](https://help.github.com/en/articles/create-a-repo) repository containing the content of this repository
2. Complete the [Task](#task) :tada:
3. [Invite](https://help.github.com/en/articles/inviting-collaborators-to-a-personal-repository) [@form3tech-interviewer-1](https://github.com/form3tech-interviewer-1) to your private repo
4. Let us know you've completed the exercise using the link provided at the bottom of the email from our recruitment team


## Submission Guidance

### Shoulds
- Only use plain Terraform in your solution
- Only modify files in the `tf/` directory, `run.sh`, and `docker-compose.yml`
- Keep the current versions of the services running in `development` and `production` environments
- Structure your code in a way that will segregate environments
- 🚨 All environments (including staging) should be created when you run `vagrant up` and the apps should print `service started` and the secret data in their logs 🚨
- Structure your code in a way that allows engineers to run different versions of services in different environments

### Should Nots
- Use tools that extend Terraform such as Terragrunt


## My approach

Initially, I developed two separate modules for my project - one for configuring vaults and the other for managing docker containers for services. This approach enables better control over different environments.

The vault module allows users to create numerous configurations and secrets for services, while the docker_containers module enables the deployment of multiple services. The configuration of the vault environment can be specified through this module.

I acknowledge that this may seem like a cumbersome process that requires a lot of configuration for each service/vault environment. However, this approach offers high customization for each environment, as opposed to using mandatory default values.

As per the request, I have successfully deployed another environment, called 'staging,' and its corresponding services for the vault.

To mitigate timeout errors caused by the containers not starting up in time for the Terraform application, I have added a sleep command to the run.sh script.

## Result

```=bash
vagrant@f3-interview:~$ for i in $(docker ps --format '{{.Names}}' | grep -E 'account|gateway|payment'); do docker logs ${i}; done
account service initializing....
{"data":{"db_password":"396e73e7-34d5-4b0a-ae1b-b128aa7f9977","db_user":"account"},"metadata":{"created_time":"2023-03-20T13:37:36.597229688Z","deletion_time":"","destroyed":false,"version":1}}
account service started....
gateway service initializing....
{"data":{"db_password":"965d3c27-9e20-4d41-91c9-61e6631870e7","db_user":"gateway"},"metadata":{"created_time":"2023-03-20T13:37:36.585629593Z","deletion_time":"","destroyed":false,"version":1}}
gateway service started....
account service initializing....
{"data":{"db_password":"396e73e7-34d5-4b0a-ae1b-b128aa7f9977","db_user":"account"},"metadata":{"created_time":"2023-03-20T13:37:36.524453999Z","deletion_time":"","destroyed":false,"version":1}}
account service started....
gateway service initializing....
{"data":{"db_password":"965d3c27-9e20-4d41-91c9-61e6631870e7","db_user":"gateway"},"metadata":{"created_time":"2023-03-20T13:37:36.532752304Z","deletion_time":"","destroyed":false,"version":1}}
gateway service started....
payment service initializing....
{"data":{"db_password":"a63e8938-6d49-49ea-905d-e03a683059e7","db_user":"payment"},"metadata":{"created_time":"2023-03-20T13:37:36.533968051Z","deletion_time":"","destroyed":false,"version":1}}
payment service started....
payment service initializing....
{"data":{"db_password":"a63e8938-6d49-49ea-905d-e03a683059e7","db_user":"payment"},"metadata":{"created_time":"2023-03-20T13:37:36.596220682Z","deletion_time":"","destroyed":false,"version":1}}
payment service started....
account service initializing....
{"data":{"db_password":"396e73e7-34d5-4b0a-ae1b-b128aa7f9977","db_user":"account"},"metadata":{"created_time":"2023-03-20T13:37:36.606726528Z","deletion_time":"","destroyed":false,"version":1}}
account service started....
gateway service initializing....
{"data":{"db_password":"965d3c27-9e20-4d41-91c9-61e6631870e7","db_user":"gateway"},"metadata":{"created_time":"2023-03-20T13:37:36.589903591Z","deletion_time":"","destroyed":false,"version":1}}
gateway service started....
payment service initializing....
{"data":{"db_password":"a63e8938-6d49-49ea-905d-e03a683059e7","db_user":"payment"},"metadata":{"created_time":"2023-03-20T13:37:36.604036761Z","deletion_time":"","destroyed":false,"version":1}}
payment service started....
```
