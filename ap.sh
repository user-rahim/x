#!/bin/bash


header(){
CY='\e[36m'
GR='\e[34m'
OG='\e[92m'
WH='\e[37m'
RD='\e[31m'
YL='\e[33m'
BF='\e[34m'
DF='\e[39m'
OR='\e[33m'
PP='\e[35m'
B='\e[1m'
CC='\e[0m'
cat << "EOF"

              - VALIDATOR AppleID -
           [+]ad.android@yahoo.com[+]
     [+]www.facebook.com/my.profile.co.id[+]
        
===================================================
   Email AppleID Validator By : X-Mr.R4h1M
===================================================                             
              
EOF
printf "\n"
}

UA=$(cat ua.txt | sort -R  | head -1)

ngecek_email(){ # CHECK VALID
	local jsessionid=$(curl -s --head https://ams.apple.com/pages/SignUp.jsf | grep -Po "(?<=Set-Cookie: JSESSIONID=)[^;]*")
	local used=$(curl -s -D - "https://ams.apple.com/pages/SignUp.jsf;jsessionid=$JSESSIONID" \
	-H "Cookie: JSESSIONID=$jsessionid;" \
	-H "User-Agent: $5" \
	-d "SignUpForm=SignUpForm&SignUpForm%3AemailField=$1&SignUpForm%3AblueCenter=Continue&javax.faces.ViewState=j_id1")
	if [[ $used =~ "200 OK" ]]; then
		if [[ $used =~ "This email address is already registered as an Apple ID, please sign in." ]]; then
			printf "${B}${OG}[LIVE]${CC} ${1} => ${PP}(Checked At $(date))${DF} - ${CY}${B}AppleValid | RICFTR\/AUTHENTIC ${CC} \n"
			echo $1 >> $2	
		else
			printf "${B}${RD}[DIE]${CC} ${1} => ${PP}(Checked At $(date))${DF} - ${CY}${B}AppleValid | RICFTR\/AUTHENTICS ${CC} \n"
			echo $1 >> $3	
		fi
	else
		printf "${B}${OR}[UNKNOWN]${CC} ${1} => ${PP}(Checked At $(date))${DF} - ${CY}${B}AppleValid | RICFTR\/AUTHENTICS ${CC} \n"
		echo $1 >> $4
	fi
}

# CHECK SPECIAL VAR FOR MAILIST
if [[ -z $1 ]]; then
	header
	printf "Cara Pakai Gini Asoo $0 mailistmu.txt \n"
	exit 1
fi

# CALL HEADER
header
# CHECK OUTPUT FOLDER
Output='Output' # Change Output Folder
if [[ ! -d $Output ]]; then
	printf "${RD}[?]${DF} ${B}No output Folder${CC}\n"
	printf "${BF}[+]${DF} ${B}Create Output Folder${CC}\n"
	mkdir $Output
	if [[ -d $Output ]]; then
		printf "${OG}[+]${DF} ${B}Output Folder Created${CC}\n\n"
	else
		printf "${RD}[-]${DF} ${B}Output Folder Failed To Created${CC}\n"
	fi
else
	printf "${OG}[+]${DF} ${B}Output Folder Found${CC}\n"
	printf "${OG}[+]${DF} ${B}Use Output Folder${CC}\n\n"
fi

# TOUCH OUTPUT FILE
VALID="${Output}/valid.txt"
INVALID="${Output}/invalid.txt"
UNKNOWN="${Output}/unknown.txt"
touch $VALID
printf "$OG[+]${DF}${B} $VALID Created${CC}\n"
touch $INVALID
printf "$OG[+]${DF}${B} $INVALID Created${CC}\n"
touch $UNKNOWN
printf "$OG[+]${DF}${B} $UNKNOWN Created${CC}\n\n"

# CHECK LINES IN MAILIST
lines=$(wc -l $1 | cut -f1 -d' ')
printf "${OG}[+]${DF}${B} ${lines} Email Found In ${1}${CC}\n\n"

# OPTIONAL
persend=2
setleep=3

# MAIN
IFS=$'\r\n' GLOBIGNORE='*' command eval 'mailist=($(cat $1))'
itung=1
STARTTIME=$(date +%s)
for (( i = 0; i < "${#mailist[@]}"; i++ )); do
username="${mailist[$i]}"
set_kirik=$(expr $itung % $persend)
        if [[ $set_kirik == 0 && $itung > 0 ]]; then
                sleep $setleep
        fi
        ngecek_email $username $VALID $INVALID $UNKNOWN $UA &
        grep -v -- "$username" $1 > temp && mv temp $1
        itung=$[$itung+1]
done
wait
ENDTIME=$(date +%s)

# RESULT
printf "\n${PP}Done ! $[$ENDTIME - $STARTTIME] Second For Check ${lines} Email ${CC}\n"

#READ LINES OUTPUT
T_VALID=$(wc -l $VALID | cut -f1 -d' ')
T_INVALID=$(wc -l $INVALID | cut -f1 -d' ')
T_UNKNOWN=$(wc -l $UNKNOWN | cut -f1 -d' ')

printf "LIVES : $T_VALID | DIE : $T_INVALID | UNKNOWN : $T_UNKNOWN\n$CC"
printf "${B}${BF}-===AppleID Valid===-${CC}\n\n"
