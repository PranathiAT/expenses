app_user=expense
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[36m>>>>>>>  $*  <<<<<<<<<<<\e[0m"

}

func_status_check()
{
   if [ $1 -eq 0 ];then
       echo -e "\e[32mSUCCESS\e[0m"
    else
       echo -e "\e[31mFAILURE\e{0m"
       echo "Refer the log file for more information /tmp/roboshop.log"
       exit 1
    fi
}

func_app_prereq()
{
  func_print_head "Add application user"
    id ${app_user} &>>$log_file
    if [ $? -ne 0 ];then
    useradd ${app_user} &>>$log_file
    fi
    func_status_check $?

    func_print_head " Create app directory"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    func_status_check $?

    func_print_head "Download app content"
    curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    cd /app
    func_status_check $?

    func_print_head " UnZip App Content"
    unzip /tmp/${component}.zip &>>$log_file
    func_status_check $?

}

func_systemd_setup()
{
  func_print_head "copy service file"
    cp $script_path/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_status_check $?

    func_print_head "start" ${component} "service"
    systemctl daemon-reload
    systemctl enable ${component} &>>$log_file
    systemctl start ${component} &>>$log_file
    func_status_check $?

}

func_schema_setup(){
   if [ "$schema_setup" == "mysql" ];then
      func_print_head   "Install mysql "
      yum install mysql -y &>>$log_file
      func_status_check $?

      func_print_head "load schema"
      mysql -h mysql-dev.pdevops.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
      func_status_check $?
    fi
}

func_nodejs() {
  func_print_head "Disable Nodejs repos"
  dnf module disable nodejs -y

  func_print_head "enable required nodejs repos"
  dnf module enable nodejs:18 -y

  func_print_head "install nodejs"
  dnf install nodejs -y

  func_app_prereq

  func_print_head "Install node js dependencies"
  npm install

  func_systemd_setup
  func_schema_setup

}




