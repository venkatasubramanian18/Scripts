sudo apt update
sudo apt-get install openjdk-8-jdk openjdk-8-doc
java -version
sudo apt install wget software-properties-common
wget -qO - https://api.bintray.com/orgs/jfrog/keys/gpg/public.key | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://jfrog.bintray.com/artifactory-debs $(lsb_release -cs) main"
sudo apt update
sudo apt install jfrog-artifactory-oss
systemctl stop artifactory.service
systemctl start artifactory.service
systemctl enable artifactory.service
systemctl status artifactory.service
echo "Access Atrifactory @ http://localhost:8081/artifactory/"
echo "Username:  admin and Password: password"
