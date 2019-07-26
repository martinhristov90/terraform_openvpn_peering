variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
  type = map(string)
  default = {
    us-east-1 = "ami-07a8d85046c8ecc99" # OpenVPN AS AMI
  }
}

variable "ec2_user" {
  default = "openvpnas"
}
# This key is now insecure, good for testing
variable "private_key" {
  default = <<-EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEA1x6Xz70KdtamAYoRjJ5HK5PtHrxPgBa97V2ODiAkT7rTTtKtM0bg
YCZZtivKSmOLc5nLdRhfmQHUdRwCVHWy8A1YgNc8Ql2nH7bRV1jmmHKAvHk9eH21ZlLzQ5
ds4gq2IIMjel8KXNyXF013HIrnceNcXwHWNvziL2Qe0CNNdzH/YG30oyJR+6eg3F7nTTE9
z7r5jlgLNmKje0ZasHWX9uMqWX39dScUSTZvgxChAK7i1Pk5zKYRY+YpO8Wu1s841pSMsd
9EdrZ6QgUVx8uGjpgSDVIHmn+Uc8cYe6dxjIGn53dsrKRNU5hULzbSW56XPBcSaY/wKBNc
tqeplD9QYwAAA+BaSrhPWkq4TwAAAAdzc2gtcnNhAAABAQDXHpfPvQp21qYBihGMnkcrk+
0evE+AFr3tXY4OICRPutNO0q0zRuBgJlm2K8pKY4tzmct1GF+ZAdR1HAJUdbLwDViA1zxC
XacfttFXWOaYcoC8eT14fbVmUvNDl2ziCrYggyN6Xwpc3JcXTXcciudx41xfAdY2/OIvZB
7QI013Mf9gbfSjIlH7p6DcXudNMT3PuvmOWAs2YqN7RlqwdZf24ypZff11JxRJNm+DEKEA
ruLU+TnMphFj5ik7xa7WzzjWlIyx30R2tnpCBRXHy4aOmBINUgeaf5Rzxxh7p3GMgafnd2
yspE1TmFQvNtJbnpc8FxJpj/AoE1y2p6mUP1BjAAAAAwEAAQAAAQBP5NjVGoyMXmQBJlom
M5KTKLlkNOQB2nBne9uKe32A7w4TtEMHTEeA7j1bXyAeSKI+KNxbfNXkab2SUPi8jYoLha
ldEJMcwtOS/774Bdh+vef6F70wxt9cRWp7q/2QZhIGOS4wAKREoNismuSmASC8N4jS8Eey
3HDU0QZwnuviXEyXPgICDxg4clBWvmH9uafvRNqpcECJzSQHPzNjN8lHzk/E+ChrC60cP1
anP2uqS4clyPPy74fsRvCsbzrizYxciY8IFhMtd7Aqof6zRIhYXeUYYWhDYaR2YQR+k+Vm
m4nMOjC+qofAowW3ZHdYMRfTb7efJkoslyASAagyxXhBAAAAgQDIJQeOSNbTp42a5WF14W
iMxQ0V14S3OONuQ77HyNe3sjKCYtLuh6G3tvqACtpH3fvaeGGZQSgpMHMVbU4vp8Tf84gU
Fg5A6dDuzNrDbSgQlN1TcdH4CoGJPZE94lscXqwwI0TZjyz1v8dj74DYqbJpNjuJm8bkBS
r/3kURj1qpugAAAIEA+1SfzkfGLsJ/mB71XcLJdLoUf/LaH8rNZY2CTXDP6asC/HiwEI+w
3THZqe3pzahh2YfNtIN1++a4AenndWppxOGT/jN1vbH/rJ5NFirrqu8ttLB2UUdI+IMxZv
M+2chILZj31WmxPSfRHJ0A+Nmzl/akhMGo6RQzHkKG36NT7EsAAACBANsdvftGm4Ocqz6J
grAThHXRJqTfve4s4UlTaqp7u5gr6AJCKBw79URYJYCkx7cY83PlC0a6XQcEyTdQL64l7G
HjBI7QJNUxZQAvHkIc/NlB3mwbCI2CGiECUq/P7LHoesRlQj3aM31v8g/1Da9403q+PLZ5
8PFBNucPmmRV/21JAAAAJ21hcnRpbmhyaXN0b3ZATWFydGlucy1NYWNCb29rLVByby5sb2
NhbAECAw==
-----END OPENSSH PRIVATE KEY-----
EOF
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXHpfPvQp21qYBihGMnkcrk+0evE+AFr3tXY4OICRPutNO0q0zRuBgJlm2K8pKY4tzmct1GF+ZAdR1HAJUdbLwDViA1zxCXacfttFXWOaYcoC8eT14fbVmUvNDl2ziCrYggyN6Xwpc3JcXTXcciudx41xfAdY2/OIvZB7QI013Mf9gbfSjIlH7p6DcXudNMT3PuvmOWAs2YqN7RlqwdZf24ypZff11JxRJNm+DEKEAruLU+TnMphFj5ik7xa7WzzjWlIyx30R2tnpCBRXHy4aOmBINUgeaf5Rzxxh7p3GMgafnd2yspE1TmFQvNtJbnpc8FxJpj/AoE1y2p6mUP1Bj martinhristov@Martins-MacBook-Pro.local"
}

variable "ingress_ports" {
  type = list(number)
  description = "list of ingress ports"
  default = [22, 443, 943, 1194]
}

# Misc settings

variable "admin_pass" {
  default = "openvpn123"
}

variable "marti_pass" {
  default = "marti123"
}
#### customer_vpc

