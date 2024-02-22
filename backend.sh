script=$(realpath "$0")
script_path=$(dirname "script")
source ${script_path}/common.sh
component=backend
mysql_root_password=$1
schema_setup=mysql

if [ -z "$mysql_root_password" ]; then
  echo Input Mysql root password Missing
  exit
fi

func_nodejs


