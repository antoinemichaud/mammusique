#!/bin/bash
ftp_password=$1

curl --ftp-create-dirs -T blank_file -u mammusique@mammusique.eu:$ftp_password ftp://ftp.mammusique.eu/blank_file
if [ $? -ne 0 ]
then
	echo
	echo
	echo "Le password FTP indiqué est incorrect. Veuillez réessayer."
	exit -1
else
	echo "password correct, on continue"
fi

cd mammusique.com
files_to_upload=`git ls-files --others --modified --exclude-from=.gitignore`
for file_to_upload in $files_to_upload
do
	echo "ce fichier va être mis à jour : $file_to_upload"
	git add $file_to_upload
	curl --ftp-create-dirs -T $file_to_upload -u mammusique@mammusique.eu:$ftp_password ftp://ftp.mammusique.eu/$file_to_upload
done

git commit -m "save"
git pull -r
git push
