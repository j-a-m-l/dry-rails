#!/bin/bash

WEB_PATH='./data/ruby/web'
WEB_INCLUDES_PATH='./data/ruby/includes'

mount_web_folder() {
	echo " » Mounting '$1' into '$2'."
	echo "sudo mount -o bind $1 $2"
	# sudo mount -o bind $1 $2

	if [[ $3 = 1 ]]; then
		echo " » Remounting as read-only."
		echo "sudo mount -o remount,ro $2"
		# sudo mount -o remount,ro $2
	fi
}

# TODO remove ro?
# TODO after reboot / running more than once without options?

while getopts ":p:n:e:i:rd" OPT
do
  case $OPT in
    p) WEB_PROJECT=$OPTARG;;
    n) WEB_NAME=$OPTARG;;
    e) WEB_ENVIRONMENT=$OPTARG;;
	i) WEB_INCLUDES+=("$OPTARG");;
	r) WEB_MOUNT_RO=1;;
    d) WEB_DAEMON=1;;

	:) echo "Option -$OPTARG requires an argument" >&2
	   exit 1;;
    *) echo "Unknown option" >&2
       exit 1;;
  esac
done

if [[ -z $WEB_PROJECT ]]; then
  echo "Project path is required" >&2
  exit 2
fi

if [[ -z $WEB_ENVIRONMENT ]]; then
  WEB_ENVIRONMENT=development
fi

if [[ -z $WEB_NAME ]]; then
  WEB_NAME=rails-$WEB_ENVIRONMENT
fi

if [[ ! -d "./environments/$WEB_ENVIRONMENT" ]]; then

  echo "Environment '$WEB_ENVIRONMENT' does not exist" >&2
  exit 3
else

  if [[ ! -e "./environments/$WEB_ENVIRONMENT/docker-compose.yml" ]]; then
    echo "Environment '$WEB_ENVIRONMENT' does not contain a 'docker-compose.yml' file" >&2
    exit 3
  fi
fi

if [[ ! -z `mount | grep $WEB_PROJECT".*"$WEB_PATH" .*bind"` ]]; then
	echo " » '$WEB_PROJECT' is already mounted on '$WEB_PATH'."

else
  IS_WEB_MOUNTED=`mount | grep .*$WEB_PATH" .*bind"`

  if [[ ! -z $IS_WEB_MOUNTED ]]; then
	echo " » Something different than '$WEB_PROJECT' is mounted on $WEB_PATH:"
	echo -e "\n\t$IS_WEB_MOUNTED\n"
	echo " » It is possible to umount it, but I, a humble shell script, I am not going to mess with you:"
	echo -e "\n\tsudo umount $WEB_PATH\n"
	exit 4

  else
  	  mount_web_folder $WEB_PROJECT $WEB_PATH $WEB_MOUNT_RO
  fi
fi

if [[ ! -z $WEB_INCLUDES ]]; then
  for WEB_INCLUDE in "${WEB_INCLUDES[@]}"; do
    WEB_INCLUDE_FOLDER=${WEB_INCLUDE##*/}
    mount_web_folder $WEB_INCLUDE $WEB_INCLUDES_PATH/$WEB_INCLUDE_FOLDER $WEB_MOUNT_RO
  done
fi

echo -e "\n » Running Docker Compose"

DOCKER_COMPOSE_COMMAND="docker-compose -p $WEB_NAME -f ./environments/$WEB_ENVIRONMENT/docker-compose.yml up"

if [[ $WEB_DAEMON = 1 ]]; then
	DOCKER_COMPOSE_COMMAND+=' -d'
fi

echo  $DOCKER_COMPOSE_COMMAND
