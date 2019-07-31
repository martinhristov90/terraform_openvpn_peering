### Secure VPC project using VPC peering, OpenVPN AS and Let's Encrypt

#### Purpose:

This repository is created with learning purposes for Terraform, AWS and ACME. It consists of two VPCs, one of them(customer-vpc) which is completely private, has no internet gateway, the other one(openvpn-vpc) is connected to the internet, and the OpenVPN connection can be used to reach resources inside the customer_vpc. VPC peering is used for inter-VPC communication.
The VPN part is implemented using OpenVPN AS server, it's web interface uses Let's Encrypt issued certificates.

![diagram](https://www.lucidchart.com/publicSegments/view/b7eb9edb-b3a6-49cc-a953-e81940318614/image.png)

#### Used sources :

- This setup is inspired by article publish: [here](https://dev.to/setevoy/openvpn-openvpn-access-server-set-up-and-aws-vpc-peering-configuration-5fpg)
- Module used as basis for vpc_peering: [here](https://registry.terraform.io/modules/grem11n/vpc-peering/aws/2.1.0)

#### To DO
- [x] Add DNS record to use for accessing OpenVPN AS server
- [x] Let's encrypt for Web of the OpenVPN
- [ ] Fine tuning of the OpenVPN
- [x] Generating the pub and priv keys for the instances dynamically.
- [ ] Refactor everything, needs to be less bulky.