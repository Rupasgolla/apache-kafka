# Apache-Kafka

dnf install -y dnf-utils
sudo dnf install -y epel-release
sudo dnf install java-11-openjdk -y

sudo useradd -r -d /opt/kafka -s /usr/sbin/nologin kafka

sudo cd /opt
sudo curl -fsSLo kafka.tgz https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz 
sudo tar -xzf kafka.tgz
sudo tar -xzf kafka.tgz
sudo mv kafka_2.13-3.7.0/ /opt/kafka
sudo chown -R kafka:kafka /opt/kafka

sudo -u kafka mkdir -p /opt/kafka/logs
sudo -u kafka vim /opt/kafka/config/server.properties

	
cat >>/etc/systemd/system/zookeeper.service <<EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target
[Service]
Type=simple
User=kafka
ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal
[Install]
WantedBy=multi-user.target
EOF

cat >>/etc/systemd/system/kafka.service <<EOF
[Unit]
Requires=zookeeper.service
After=zookeeper.service
[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /opt/kafka/logs/start-kafka.log 2>&1'
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start zookeeper
sudo systemctl start kafka
sudo systemctl enable zookeeper
sudo systemctl enable kafka

sudo cd /opt/kafka/bin 
sudo ./kafka-topics.sh --create --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic topic1
sudo ./kafka-topics.sh --list --bootstrap-server localhost:9092


sudo ./kafka-console-producer.sh --broker-list localhost:9092 --topic event1
>Hi, this is my first event

sudo ./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic event1 --from-beginning







