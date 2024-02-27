# Red Hat 

data "aws_ami" "latest_rhel" {
  most_recent = true
  owners      = ["309956199498"]  # Official Red Hat account ID

  filter {
    name   = "name"
    values = ["RHEL-8*_HVM-*-x86_64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_instance" "node-1-server" {
    ami = data.aws_ami.latest_rhel.id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    subnet_id = aws_subnet.main.id
    associate_public_ip_address = true
    key_name = aws_key_pair.my_key_pair.key_name
    root_block_device {
      volume_size = 50
    }

    
    tags = {
      Name = var.node-1-name
    }

    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",  # Update the system using yum (for Amazon Linux)
        "sudo yum install -y wget vim",
        "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
        "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
        "sudo yum upgrade -y",
        # Add required dependencies for the jenkins package
        "sudo yum install fontconfig java-17-openjdk -y",
        "sudo yum install jenkins -y",
        "sudo systemctl daemon-reload",
        "sudo systemctl enable jenkins",
        "sudo systemctl start jenkins",
        "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
        #"echo -e "\e[1;31m$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)\e[0m"",
        # "sleep 10",
        # "jenkins_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)",
        # "echo "Jenkins Initial Admin Password: $jenkins_password"",
        # "sleep 10",
        # "wget http://localhost:8080/jnlpJars/jenkins-cli.jar",
        # "java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$jenkins_password install-plugin $(curl -sSL http://localhost:8080/jnlpJars/jenkins-cli.jar | java -jar -s http://localhost:8080/ -auth admin:$jenkins_password -webSocket list-plugins | awk '{ print $1 }')",
        # # Restart Jenkins after plugin installation
        # "java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$jenkins_password safe-restart",
        #"sudo systemctl status jenkins"
        # For firewall stop
        #"sudo systemctl stop firewalld",
        # "sudo mkdir -p /data/bitbucket-home",
        # "sudo mkdir -p /data/bitbucket-install",
        # "cd /data/bitbucket-install/ && sudo wget https://product-downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-8.17.0.tar.gz",
        # "sudo tar -xvzf atlassian-bitbucket-8.17.0.tar.gz",
        # "cd atlassian-bitbucket-8.17.0",
        # "sudo sed -i 's/JVM_MINIMUM_MEMORY=512m/JVM_MINIMUM_MEMORY=2G/; s/JVM_MAXIMUM_MEMORY=1g/JVM_MAXIMUM_MEMORY=2G/' /data/bitbucket-install/atlassian-bitbucket-8.17.0/bin/_start-webapp.sh",
        # "sudo sed -i '5s/.*/    BITBUCKET_HOME=\\/data\\/bitbucket-home/' /data/bitbucket-install/atlassian-bitbucket-8.17.0/bin/set-bitbucket-home.sh",
        # "cd /opt",
        # "sudo wget https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz",
        # "sudo tar -xvzf openjdk-17.0.1_linux-x64_bin.tar.gz",
        # "sudo wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jre_x64_linux_hotspot_17.0.9_9.tar.gz",
        # "sudo tar -xvzf OpenJDK17U-jre_x64_linux_hotspot_17.0.9_9.tar.gz",
        # "sudo echo -e '\nexport JAVA_HOME=/opt/openjdk-17.0.1\nexport PATH=$PATH:$JAVA_HOME/bin\nexport JRE_HOME=/opt/jdk-17.0.9+9-jre' | sudo tee -a /etc/profile",
        # "sudo chown -R ec2-user:ec2-user /data",
        # "source /etc/profile",  # Use 'source' to execute the commands in the current shell environment
      ]
    }

    connection {
      type        = "ssh"
      user        = "ec2-user"  # The default user for Amazon Linux instances
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
 }
  
