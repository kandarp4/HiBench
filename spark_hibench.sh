#!bin/bash
sudo yum install git
git clone https://github.com/Intel-bigdata/HiBench.git
wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
tar xvf apache-maven-3.8.5-bin.tar.gz
sudo mv apache-maven-3.8.5  /usr/local/apache-maven
export M2_HOME=/usr/local/apache-maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH
mvn -Dspark=3.0 -Dscala=2.12 clean package
mvn -Phadoopbench -Psparkbench -Dspark=3.0 -Dscala=2.12 clean package