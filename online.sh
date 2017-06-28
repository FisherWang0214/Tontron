#!/bin/bash


IPADDRESS=10.5.22.67
USERNAME="root"
PASSWORD="ddo.X15I"

if [  ! -d  /execshell ];then
	mkdir -p /execshell
	chmod 777 /execshell
fi

if [  ! -d  /tmp/install ];then
	mkdir -p /tmp/install
	chmod 777 /tmp/install
fi

cd /tmp/install

echo "ftp -v -n $IPADDRESS<<EOF"					>getfile
echo "user $USERNAME $PASSWORD"						>>getfile
echo "prompt"															>>getfile
echo "cd /home/install/shell"							>>getfile
echo "asc"																>>getfile
echo "mget *"															>>getfile
echo "close"															>>getfile
echo "bye"																>>getfile
echo "EOF"																>>getfile

chmod +x getfile
/tmp/install/getfile

chmod +x /tmp/install/*.sh

#rm -f /execshell/getfile.sh
#mv -f /tmp/install/getfile.sh /execshell


/tmp/install/getfile.sh

chmod +x /execshell/*.sh.push

chmod +x /tmp/install/main.sh.bak
/tmp/install/main.sh.bak


cd /tmp
rm -rf /tmp/install


if [ -d ~/.ssh ]; then
	echo "exist ~.ssh"
else
	mkdir ~/.ssh
	chmod 700 ~/.ssh
	echo "create ~.ssh directory"
fi



if [ `cat ~/.ssh/authorized_keys|grep root@xtgl-app-005|wc -l` = "0" ];then
	cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys`date +%Y''%m''%d''%H''%M''%S`
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0UWAAmmkrJFzsSIbaKeCjtG9IWhElcOtB5sTmCpftjqISweZ/8YjyiW3xfrPmdj1OPnh+Bczi75vPQtEuD61f5aI+MQJiVnx0bmTm6OyDcQCLMms6nj5McSTRzFIj7q9FzMWFqK9jIAqE1t82JE6hz67wvtWFLhcd4kE5n6/swBUM19ZnDtMOkBVG6gG7GMpTcUwnd8gqQlhTblpzsGdsLcAbSotLDzqyJQ2tCS/JGkXPvrviNGSbChI3PKhnRdTiylCCFFdfFELI48Ay5z2VrCL002qW4+HaBP+o63oXEA0OcLOsRLJiXxI5y3Wyi+3CHZXi387c9AQIyYW4qwpOw== root@xtgl-app-005"  >>  ~/.ssh/authorized_keys
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC42aRi2R9adR9lNBQ3exJlTDDAKkoC3S3bzk7nhM+kqIKU7bP2CzK+looT21obOmliFfcR5MwwEY+Nl+LQlqs06CcdGkZ+U1alDoClKiTRY3wvWU08ggwuCdSC6habXelgQE2fzfTEOpUBRnSvuS//20sjA/gOX9WV+MTnUr9H3ppLo/VEsVl17WSO5MEPOchaVYKpJ/94Zfp7hRiTvQ6bFCrFBDpGQiFmKytdsXYer5Ucf6laLMFNIdKUJYcQmoXvHbWBl1pNiFSLjbnmka81T1y8Y2lNN4IQRS4hrzs0kVYrKOtX5ORlXu6Xi74XDr9pJNDIUSrryNKQH0znyHVl root@SHDNS2"  >>  ~/.ssh/authorized_keys
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCirRhy/NTn+Uzlmx+FB4dgA1aac9iPwPAvzoEhESogaE2IuvwsZg8lne9jkAarwWXo5Wir570JpFwenpDmLRVucBF13pPjl+iqGjJmbKAHNGbpWl9pRGRNN13kJwj5YtRNS3xqwfvtKl2H8T1uO3Iair46D2JeRNBbl1iQurAWrdiIhVGaCJ7rJEpX6+LPeCz43q75NG68effnCfF6a74Y056nyppqwWwHhWoHwBIpiWR4ZT2zj4o6AGQbHXXsPiW/mqz7SOZ+oPeD94M4X6UFe7Qa/ghlrD2zq+Z8i+I3SJ0OoSuOUouoLS8mvtclrNJetQnhb0gVN8duZb3Szyer root@NMSSERVER2"  >>  ~/.ssh/authorized_keys
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyVWeSUKeXr7gLvVnHc3nPhAIfvLSd85WPF3mxWtKwAXNVlHTLtrEAMa3mas1lItXMqvqOlJrNn/ENDR/Ntbyb5s1JS915TAI1LtJ73BO+Y+OqPqFNHfPEe40t1Y9bQW+pImE41KA0ybCEuNoDJZJCiK19QTmji/jX21SJaTb0gTQTX25ghnfKCL/AqShPnlBRer9Y/z+YxWDgZfISqJeJVEujI0gQpi36hYIjvnwiUTI792+YbdCCCv2DIXrCUIRO/drcQSUmzqcCFDvBshD5OlY4izEkLEDcF2IY4AtPzyzlwfy0mRGG7zh5No5E1OcX8pB8kZBHv+A8aaTjws8HQ== root@xtgl-app-006"  >>  ~/.ssh/authorized_keys
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtkAZU9q0cLLPCRH7fg5m+76xsJ6kxTXAUEOy31HL1k5lUQ2Jhxc2MM6IJ09y6+Q5T7qSg5l8hzqVg3tJFq9gO94sSSeNECKb2pTCyzd2C1e4oxqCVir1MZj75SWU0eGypMJvq+rYW1z7idmAp4OrlSWUCUdNX+kNRVfVJuIlwTre97/nfIHQvq8cMhfMpW/P4PoNHfaDcftVsF7JeS7s00IhwxbYL41lVjkilx74h1CCIx6rs8Mkre/VW/3mWbtyc0px835p5Al/43mfF/5eZuo1X5ZzwfGbl/jokiRq/Dcpcx1ZfosmwmsA9uBRTL39TwJ/3oBGVM/w0WIGgnY9kw== root@NMSSERVER1"  >>  ~/.ssh/authorized_keys

		echo "add sshauthentication"
fi




