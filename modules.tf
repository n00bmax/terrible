module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name     = "foo"
      new_bits = 8
    },
    {
      name     = "bar"
      new_bits = 8
    },
    {
      name     = "baz"
      new_bits = 4
    },
    {
      name     = "beep"
      new_bits = 8
    },
    {
      name     = "boop"
      new_bits = 8
    },
  ]
}