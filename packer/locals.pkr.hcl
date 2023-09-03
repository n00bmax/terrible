locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  data_source_content = {
    "/meta-data" = file("./data/meta-data")
    "/user-data" = templatefile("./data/user-data.pkrtpl.hcl", {
      ssh_key = file("~/.ssh/id_rsa.pub")
    })
  }
}