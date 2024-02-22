script=$(realpath "$0")
script_path=$(dirname "script")
source ${script_path}/common.sh

mysql_root_password=$1
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
cp ${script_path}/backend.service /etc/systemd/system/backend.service
useradd ${app_user}
rm -rf /app
mkdir /app
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app
unzip /tmp/backend.zip
npm install
systemctl daemon-reload
systemctl enable backend
systemctl start backend

dnf install mysql -y
mysql -h mysql-dev.pdevops.online -uroot -p${mysql_root_password} < /app/schema/backend.sql
