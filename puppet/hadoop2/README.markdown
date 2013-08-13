# Hadoop #

This module was created to assist with the installation and configuration of hadoop. Simply edit the params.pp file and mapreduce your self away!

# Configuration #

* A tar.gz file needs to be placed into ~/modules/hadoop/files. You can download hadoop from here: http://hadoop.apache.org/common/releases.html
* Once downloaded the params.pp file needs to be updated with the version downloaded. 
* The params.pp also requires the java module I have already published. That or the $java_home variable needs to be properly updated.

# SSH Keys #

The ssh keys for the hduser are in ~/files/ssh/ make sure you edit these files and put in your own public and private keys. If you are using this module for multiple hadoop servers the id_rsa.pub and id_rsa keys will be the same for each hduser. Also the authorized_keys file is defined in puppet as the id_rsa.pub file. If you wish to add support for other users you need to change the init.pp so authorized_keys is a differnt file in ~/files/ssh


# Author #

* Brian Carpio
* http://www.thetek.net
* http://www.linkedin.com/in/briancarpio
