### Under construction

![diagram](https://www.lucidchart.com/publicSegments/view/b7eb9edb-b3a6-49cc-a953-e81940318614/image.png)


#### This setup is inspired by article publish: [here](https://dev.to/setevoy/openvpn-openvpn-access-server-set-up-and-aws-vpc-peering-configuration-5fpg)
#### Module used as basis for vpc_peering: [here](https://registry.terraform.io/modules/grem11n/vpc-peering/aws/2.1.0)

### To DO
- [x] Add DNS record to use for accessing OpenVPN AS server
- [x] Let's encrypt for Web of the OpenVPN
- [ ] Fine tuning of the OpenVPN
- [x] Generating the pub and priv keys for the instances dynamically.
- [ ] Refactor everything, needs to be less bulky.