#----------outputs.tf-----------------

output "Jenkins-Master-public-IP" {
  value = "http://${module.compute.master_ip}:8080"
}

output "Jenkins-Python-Node-Public-IP" {
  value = module.compute.python_node_public_ip
}

output "Jenkins-Python-Node-Private-IP" {
  value = "ssh-keyscan -H ${module.compute.python_node_private_ip} >>/var/lib/jenkins/.ssh/known_hosts"
}