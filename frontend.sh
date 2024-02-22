
script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "install nginx"
yum install nginx -y &>>$log_file
func_status_check $?

func_print_head "copy config file "
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
func_status_check $?

func_print_head "remove previous nginx content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?

func_print_head "Download app content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

cd /usr/share/nginx/html
func_print_head "unzip app content"
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

func_print_head "Start Frontend service"
systemctl restart nginx &>>$log_file
systemctl enable nginx &>>$log_file
func_status_check $?
