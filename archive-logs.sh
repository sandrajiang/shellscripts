
#!/bin/sh
WD1=/appdata/logs/a2p-odr-transporter # odr transporter logs directory
WD2=/appdata/logs/a2p-odr-dedup #odr dedup logs directory
flag=1 #non-error condition
ARCHIVE=/appdata/logs/archive


  for dir in $WD1 $WD2
  do 
    cd $dir
        #compressing logs older than 1 day on local drive
        find . -type f -mtime +1 \( -name \*.gz -prune -o -print \) | xargs gzip -9f; status=$?;
        if [ $status -ne 0 ]; then
                echo "Compressing logs in ${dir} had bad exit status $status"
                flag=0
        fi
	
 done	

       mv $WD1/*.gz $ARCHIVE/
       mv $WD2/*.gz $ARCHIVE/	   


 cd $ARCHIVE
           #deleting logs older than 90 days
        find . -type f -mtime +90 -name "*.gz" | xargs rm -f;


#mail if there was an error
if [ $flag -eq 0 ]; then
        echo "$0 on `hostname` has encountered problem cleaning up the logs. Please check." | mail -s "`hostname`:/appdata/logs/ space cleanup issue" sandrajiang89@yahoo.com
fi
