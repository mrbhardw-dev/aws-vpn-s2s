resource "null_resource" "copy_script" {
  triggers = {
    instance_ids = module.ec2_instance_vpn_gw_frr.id
  }

  provisioner "file" {
    source = "${path.module}/ipsec-vti.sh"
    destination = "/home/ubuntu/ipsec-vti.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/ipsec-vti.sh /etc/",
      "sudo chown root:root /etc/ipsec-vti.sh",
      "sudo chmod +x /etc/ipsec-vti.sh",
      "sudo sysctl -w net.ipv4.ip_forward=1 &&",
      "sudo sysctl -w net.ipv4.conf.ens5.disable_xfrm=1 &&",
      "sudo sysctl -w net.ipv4.conf.ens5.disable_policy=1",
      "sudo reboot"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/key_pair.pem")
    host        = aws_eip.vpn_gw_eip.public_ip
  }
}