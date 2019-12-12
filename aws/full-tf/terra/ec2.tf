resource "aws_instance" "jenkins-app" {
  ami           = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "jenkins-app"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  seq 20 | xargs -Iz echo "Adding repository and installing docker-ce"
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update && sudo apt-get install -y docker-ce
  sudo docker run hello-world
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo systemctl enable docker
  seq 20 | xargs -Iz echo "installing docker-compose"
  sudo wget --output-document=/usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.24.0/run.sh && sudo chmod +x /usr/local/bin/docker-compose && sudo wget --output-document=/etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose" && seq 20 | xargs -Iz printf '\nDocker Compose installed successfully\n\n'
HEREDOC
}
