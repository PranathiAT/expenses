dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd expense
mkdir /app
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app
unzip /tmp/backend.zip
npm install
cp backend.service /etc/systemd/system/backend.service
systemctl daemon-reload
systemctl enable backend
systemctl start backend
