#! /usr/bin/csh

#source ${APL_R_PRAM}/wjftpadd.parm
#source /usr2/APL/debug/WLA/DB/parm/wjtftpadd.parm

set JOBID=`basename $0 .csh`
set FTPLOG=${APL_D_LOG}/${JOBID}
set FTPBATCH=${APL_D_LOG}/${JOBID}.bat

set param="${APL_R_PARM}/wjtftpadd2.parm"

#cat "${param}"

foreach lineparam(`cat $param`)
#echo "$lineparam"
    set paramarray=(`echo "${lineparam}" | awk -F ."'{print $2 " " $3 " " $4 " " $5 " " $6 " " $8}'"`)
    #echo ${paramarray[1]}
    #ftp -n -v $paramarray[1] >>& $FTPLOG
    #user $paramarray[2] $paramarray[3]
    if(${paramarray[5]}==2) then
        set transmode="binary"
    else
        set transmode="ascii"
    endif
    foreach file(`ls "${APL_D_SEND}/"`)
        #echo "${file}"
        
        set lastfiled=`echo "${file}" | awk -F "/"'{ print $NF}'`
        #set lastfiled=`echo "${file}" | awk -F "." 'print $NF'`
        #echo "${lastfiled} ラストフィールド"
        
        if(!($lastfiled=~ "*.s" || $lastfiled=~ "*.dat" || $lastfiled=~"*.e"))then
            continue
        endif
        
        set lastfiled=`echo "${file}" | awk -F "." '{print $1}'`
        echo "${lastfiled} ラストフィールド"
        
        echo "$paramarray[1] 引数1"
        echo "$paramarray[2] 引数2"
        echo "$paramarray[3] 引数3"
        echo "$paramarray[4] 引数4"
        echo "$paramarray[5] 引数5"
        echo "$paramarray[6] 引数6"
        echo "$paramarray[7] 引数7"
        
        echo "open $paramarray[1]" >>& $FTPBATCH
        echo "user $paramarray[2] $paramarray[3]" >>& $FTPBATCH
        echo "${transmode}"  >>& $FTPBATCH
        echo "cd $paramarray[5]/"    >>& $FTPBATCH
        echo "mget *.s"  >>& $FTPBATCH
        
        echo "open $paramarray[1]"   >>& $FTPBATCH
        echo "user $paramarray[2] $paramarray[3]"    >>& $FTPBATCH
        echo "${transmode}"  >>& $FTPBATCH
        echo "cd $paramarray[5]/"    >>& $FTPBATCH
        echo "mget *.dat"    >>& $FTPBATCH
        
        echo "open $paramarray[1]"   >>& $FTPBATCH
        echo "user $paramarray[2] $paramarray[3]"    >>& $FTPBATCH
        echo "${transmode}"  >>& $FTPBATCH
        echo "cd $paramarray[5]/"    >>& $FTPBATCH
        echo "mget *.e"    >>& $FTPBATCH
    end
end

echo "quit\n"    >>& $FTPBATCH

ftp -n -v < $FTPBATCH    >>& $FTPLOG

exit(0)
        
        
        