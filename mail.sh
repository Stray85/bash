#!/bin/bash
if [ -f report.txt ]
then
echo "Скрипт ещё выполняется."
else
function line { echo -----------------------------------------------------;}
log=access-4560-644067.log
exec 1>report.txt
echo "Временной диапазон": 
echo С|tr '\n' ' ' 
cat $log|awk '{print $4}' |head -n 1  |tr [ ' '|  tr '\n' ' '  
echo По| tr '\n' ' ' 
cat $log|awk '{print $4}' |tail -n 1  |tr [ ' ' 
line 
echo "Список IP адресов: (5 с максимальными запросами)" 
cat $log|awk '{print $1}'|sort|uniq -c|sort -rn|head -n 5 
line 
echo "Список запрашиваемых URL (5 самых популярных):" 
cat $log|awk '{print $7}'|sort|uniq -c|sort -rn|head -n 5 
line 
echo "Список ошибок (4xx и 5xx):" 
cat $log|awk '{print $9}'|grep [4-5][0-9][0-9]|sort|uniq -c|sort -rn 
line 
echo "Список всех кодов HTTP ответа:" 
cat $log|awk '{print $9}'|grep -v -|sort|uniq -c|sort -rn 
mailx root@localhost < report.txt
rm report.txt
fi
exec>&-