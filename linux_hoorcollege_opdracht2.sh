
#!/bin/bash

MYINTARRAY=(1 4 8 16 32)
echo "Printing position 4 from the array"
echo ${MYINTARRAY[4]}

MYINTARRAY[5]=64
echo "Printing position 5 from the array"
echo ${MYINTARRAY[5]}

echo

echo "Looping and printing all values inside the array"
for x in ${MYINTARRAY[@]}
do
        echo $x 
done

echo
echo
