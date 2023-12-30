sudo apt update && sudo apt upgrade -y

sudo apt install openjdk-11-jdk -y

sudo apt install apache2 -y

sudo mkdir /test

sudo git clone https://github.com/XadmaX/WildFly-Servlet-Example.git /test

cd /test/WildFly-Servlet-Example/
sudo ./mvnw clean install

sudo mkdir /test/wildfly

sudo cd /wildfly

sudo wget -P /opt/wildfly https://github.com/wildfly/wildfly/releases/download/30.0.0.Final/wildfly-30.0.0.Final.tar.gz && \
sudo tar xf /opt/wildfly/wildfly-30.0.0.Final.tar.gz -C /opt/wildfly --strip-components=1

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

sudo mv /test/WildFly-Servlet-Example/target/devops-1.0-SNAPSHOT.war /test/WildFly-Servlet-Example/target/app.war
sudo mv /test/WildFly-Servlet-Example/target/app.war /opt/wildfly/standalone/deployments/


sudo systemctl enable wildfly