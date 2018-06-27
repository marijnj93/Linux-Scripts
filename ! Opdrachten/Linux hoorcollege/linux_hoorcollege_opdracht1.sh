
#!bin/bash

VAR1=48
VAR2=73

((VAR3=$VAR1*$VAR2))
((VAR4=$VAR1+$VAR2))
((VAR5=$VAR1-$VAR2))
((VAR6=$VAR1%$VAR2))

echo $VAR3
echo $VAR4
echo $VAR5
echo $VAR6





VAR10=$(ls -l)
echo $VAR10

