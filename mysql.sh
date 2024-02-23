script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ];then
  echo Input mysql_root_password password missing
  exit 1
fi

func_print_head "Disable mysql old version"
dnf module disable mysql -y
#dnf module disable mysql -y &>>$log_file
func_status_check $?


func_print_head "copy mysql repo file"
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

func_print_head "install mysql"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

func_print_head "start mysql"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>> set mysql password<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}
func_status_check $?
