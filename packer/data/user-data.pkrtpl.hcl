#cloud-config
autoinstall:
  version: 1
  locale: en_US.UTF-8
  # keyboard:
  #   layout: en
  #   variant: us
  refresh-installer:
    update: false
  ssh:
    install-server: true
    allow-pw: true
    disable_root: true
    ssh_quiet_keygen: true
    allow_public_ssh_keys: true
  packages:
    - qemu-guest-agent
    - sudo
  late-commands:
    - curtin in-target --target=/target -- systemctl start qemu-guest-agent
    - curtin in-target --target=/target -- systemctl enable qemu-guest-agent
  storage:
    layout:
      name: direct
    swap:
      size: 0
  user-data:
    package_upgrade: false
    disable_root: false
    timezone: UTC
    users:
      - name: udit
        groups: [adm, sudo]
        lock-passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
        - ${ssh_key}


        #//   - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaKlKSYNavBIB/+g5S/bjXI2Muee7i2d5L6yv9uPRojJc3F7rUxqsfvHVUXT628rfERprm2noF+iBHR3EBR/5LyLf5eha/X+XVQJk5QHffZx7kYH2tK10JaRW6y6r6NU4zwSoaxqE0fy2p4Hlk5GfT1gY5V/7uHrTs06dOmsVQTvy5Qdu2NqI0mYXa7QfYP69wkUwyHD8OKX3Ckn+Iub8NlrNUadoQ0Cyjbn7y32yr3VBPjuJ1dbLZd636Ie+knMH8h+lbegdctVlqbZ3nnBdIcje538E1OLewoN32FEvNjU3EOaJ/oX+zWNpyL4ooMxynMwbJR/uKkKKkjE+Xc2rg/NVIcoylmBrxCiRmsPVcBHHslh6MIIvkZIYRygM23TWs3bJZLbJUTWzINPB0SF3pmk5FbtSY2ZmS3/f+zzlqrjfpu+Bj+NZOxmmLNBLWSvsqpbUtXlvFQ7LzGhaoNsF5pcMspR2HB9/5gT8bdkRrwvdT8rWN8ead9ymjUg86ZIs= udit@Udits-Desktop"
