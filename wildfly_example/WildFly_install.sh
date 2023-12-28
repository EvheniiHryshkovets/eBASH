sudo apt update && sudo apt upgrade -y

sudo apt install default-jre
sudo apt install default-jdk

sudo apt install apache2 -y

sudo mkdir /test

sudo git clone https://github.com/XadmaX/WildFly-Servlet-Example.git /test

sudo /test/WildFly-Servlet-Example/mvnw clean install

sudo mkdir /test/wildfly

sudo cd /wildfly

sudo wget -P /wildfly https://github.com/wildfly/wildfly/releases/download/30.0.0.Final/wildfly-30.0.0.Final.tar.gz && \
sudo tar xf wildfly-30.0.0.Final.tar.gz && \
sudo mv wildfly-30.0.0.Final /opt/wildfly

sudo useradd --system --no-create-home --user-group wildfly
sudo chown -R wildfly:wildfly /opt/wildfly

sudo bash -c 'cat > /etc/systemd/system/wildfly.service << EOF
[Unit]
Description=The WildFly Application Server
After=syslog.target network.target

[Service]
User=wildfly
Group=wildfly
ExecStart=/opt/wildfly/bin/standalone.sh -b=0.0.0.0
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl start wildfly

sudo mv /test/WildFly-Servlet-Example/target/devops-1.0-SNAPSHOT.war app.war
sudo mv /test/WildFly-Servlet-Example/target/app.war /opt/wildfly/standalone/deployments/

sudo systemctl enable wildfly