#-----compute/outputs.tf--------

#output for jenkins master
output "master_id" {
  value = aws_instance.jenkins-master.id
}

output "master_ip" {
  value = aws_instance.jenkins-master.public_ip
}

#output for python node
output "python_node_id" {
  value = aws_instance.jenkins-python-node.id
}

output "python_node_public_ip" {
  value = aws_instance.jenkins-python-node.public_ip
}

output "python_node_private_ip" {
  value = aws_instance.jenkins-python-node.private_ip
}