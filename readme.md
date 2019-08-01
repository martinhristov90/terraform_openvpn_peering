## Secure VPC project using VPC peering, OpenVPN AS and Let's Encrypt

#### Purpose:
&nbsp;&nbsp;&nbsp;This repository is created with learning purposes for Terraform, AWS and ACME. It consists of two VPCs, one of them(customer-vpc) which is completely private, has no internet gateway, the other one(openvpn-vpc) is connected to the internet, and the OpenVPN connection can be used to reach resources inside the customer_vpc. VPC peering is used for inter-VPC communication.
The VPN part is implemented using OpenVPN AS server, it's web interface is set up to use Let's Encrypt issued certificates by fulfilling DNS-01 challenge leveraging AWS Route 53 hosted zones.

![diagram](https://www.lucidchart.com/publicSegments/view/b7eb9edb-b3a6-49cc-a953-e81940318614/image.png)
#### Pre-requisites:

- You need to own a domain name, in my case "martinhristov.xyz", for issuing Let's Encrypt certificate. Mine is registered with GoDaddy and the default name servers provided by them are changed to AWS Route 53 ones. The procedure for changing the NS server for GoDaddy registrar can be found [here](https://uk.godaddy.com/help/set-custom-nameservers-for-domains-registered-with-godaddy-12317),for other registrars, you can look it up in their documentation. One important thing to mention, keep in mind the propagation time for the new NS servers, it might take couple of hours from the moment you change them. One more thing to mention about NS servers, when you enter AWS NS into GoDaddy, do not use FQDN like `ns-844.awsdns-41.net.`(dot at the end), use `ns-844.awsdns-41.net`(no dot at the end).
- Set up Route 53 hosted zone in AWS for your domain,instructions can be found [here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/migrate-dns-domain-in-use.html).
#### How to use it:

- In a directory of your choice, clone the github repository :
    ```
    git clone git@github.com:martinhristov90/terraform_openvpn_peering.git
    ```

- Change into the directory :
    ```
    cd terraform_openvpn_peering
    ```

- Change the values in `variables.tf`.

- Run `terraform init` to download the random provider.

- Run `terraform plan` to see what actions are going to be performed Terraform. Output should look like this :
    ```
    ---SNIP---
    Plan: 36 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------
    ```
- Run `terraform apply` to create all the resources.

- After the creation finishes, you can find a file named `client.ovpn` in your project's root directory, this file has all necessary information to log in to the OpenVPN AS server, you can use OpenVPN client of your choice in my case i use [Tunnelblick](https://tunnelblick.net/index.html).

- After you are connected to the OpenVPN AS server, you should be able to reach the Nginx server running in the private VPC, by using it's private IP address, the IP address is going to be outputed by Terraform after the creation of the resources finishes.
#### Notes:

- Consider changing variable `use_prod = false` to `true` as very last thing in the project, when everyting else is working. By default it is set to `false`, this way it uses the `staging` environment of Let's Encrypt, it does not issues certificates that are trusted by the browsers. `staging` environment is used for not hitting the limits of Let's Encrypt production server when re-running Terraform a number of times.
- All `.tf` contain comments explaining in details the task being performed, go though all of them and review them.
- Treat files in folders `private_keys` and `certs` as sensitive information as well as the `client.ovpn` file.
#### Used sources:

- This setup is inspired by article publish [here](https://dev.to/setevoy/openvpn-openvpn-access-server-set-up-and-aws-vpc-peering-configuration-5fpg).
- Module used as basis for vpc_peering [here](https://registry.terraform.io/modules/grem11n/vpc-peering/aws/2.1.0).
#### To DO:

- [x] Add DNS record to use for accessing OpenVPN AS server
- [x] Let's encrypt for Web of the OpenVPN
- [ ] Fine tuning of the OpenVPN
- [x] Generating the pub and priv keys for the instances dynamically.
- [ ] Refactor everything, needs to be less bulky.