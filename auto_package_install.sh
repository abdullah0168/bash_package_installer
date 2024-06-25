#!/bin/bash
#version 1.0

#-----------------------function to check if install-----------------------------
is_install() {

	rpm -q "$1" &> /dev/null

}

#-----------------------check if package exists----------------------------------

package_exists() {

	yum list available "$1" &> /dev/null || dfn list available "$1" &> /dev/null

}

#-----------------------install package------------------------------------------

install_package() {

	sudo yum install  -y "$1" || dfn install -y "$1"

}


#-----------------------create repo if the function is not in the repo------------

create_repo() {

	read -p "Enter your repository file name (NO .repo extention is needed): " REPO_NAME
	read -p "Enter what you want to identify this repo as: " REPO_ID
	read -p "Enter repo name: " REPO_DESCRIPTION
	read -p "Enter BaseURL: " REPO_BASEURL
	read -p "Will this repo be enabled? 1- yes, 2- No :" REPO_ENABLED
	read -p "Do you want to check the GPG key? 1- yes, 2- No" REPO_GPGCHECK
	read -p "Enter your GPG key url: " REPO_GPGKEY

	#repo file locating 
	REPO_FILE="/etc/yum.repos.d/${REPO_NAME}.repo"

	#Create Repo file
	cat <<EOF > ${REPO_FILE}
[${REPO_ID}]
name=$REPO_DESCRIPTION
baseurl=$REPO_BASEURL
enabled=$REPO_ENABLED
gpgcheck=$REPO_GPGCHECK
gpgkey=$REPO_GPGKEY
EOF

	echo "Repository file ${REPO_FILE} created successfully"

}

read -p "Enter your package name: " package_name


if is_install "$package_name" ;then

	echo "$package_name already exist."
else
	if package_exists $package_name; then
		
		install_package $package_name
	else
		echo "Need to create repository"
		read -p "Do you want to create repository? Y/N " usr
		if [[ "$usr" == "Y" ]]; then
			create_repo	
		fi
	fi

fi



