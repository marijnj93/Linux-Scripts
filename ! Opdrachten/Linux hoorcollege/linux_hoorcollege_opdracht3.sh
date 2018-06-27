
#!/bin/bash
#######################################Functions###############################

function timeshundred {
(($2=$1*100))
}

function times9999 {
(($2=$1*9999))
}

function timethree {
(($2=$1*3))
}

function sayhi {
printf "hiiiiiiiiiiiiiiiiiiiiiiiiii"
}

##############################################################################



printf "Input a number:"
read NUMBER
times9999 $NUMBER RESULT
echo "Result: $RESULT"
sayhi
echo


