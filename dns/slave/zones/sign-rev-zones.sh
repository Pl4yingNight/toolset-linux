#! /bin/bash

rootpath=/etc/bind/zones

#sign_zone <path> <zone>
sign_zone () {
  cd $rootpath/$1/
  cat db.zone > db.keyed-zone
  
  for key in `ls K${2}*.key`
  do
  echo "\$INCLUDE $key">> db.keyed-zone
  done

# crypt pkg missing!
#  head -c 1000 /dev/random | sha1sum | cut -b 1-16 > $rootpath/salt.txt

  local salt=$(cat $rootpath/salt.txt)
  echo salt=$salt
  echo dir=$(pwd)
  dnssec-signzone -A -3 $salt -N INCREMENT -o $2 -t db.keyed-zone

  ls -l
  cd $rootpath/
}


sign_zone 172/16 16.172.in-addr.arpa.
