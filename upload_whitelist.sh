MYWALLET="erd1ucyxzr83k0sxn3rmspgd9raw7w85ds45w3xrtgl44zc36k7ce7cqq3u8ep"
PEM_FILE="walletKey.pem"
CONTRACT="erd1qqqqqqqqqqqqqpgqnj7yxccexywxj4rz6t9744ymql0u9eare7cqd75h0a"


h2d(){
	[ -z "$1" -o "$1" = "-h" ] && echo "h2d: Converts HEX to decimal" && return 0
	INPUT=`echo "${@^^}" | sed 's/^0X//'`  # uppercase
	echo "ibase=16; obase=A; $INPUT" | bc
}
h2b(){
	[ -z "$1" -o "$1" = "-h" ] && echo "h2b: Converts HEX to binary" && return 0
	INPUT=`echo "${@^^}" | sed 's/^0X//'`  # uppercase
	LENGTH=`echo $INPUT | wc -c`
	printf "%$(($LENGTH * 4 - 4))s\n" "$(echo "ibase=16; obase=2; $INPUT" | bc)" | sed 's/ /0/g' | sed 's/\([0-9][0-9][0-9][0-9]\)/\1./g' | sed 's/\.$//'
}
h2bit() {
	[ -z "$1" -o "$1" = "-h" ] && echo "h2bit: Converts HEX to bits (each bit set is printed)" && return 0
	BINARY=`h2b $1`
	echo -n "Bits "
	COUNTER=0
	for LETTER in `echo $BINARY | grep -o . | tac` ; do
		if [ "$LETTER" = "1" ] ; then
			echo -n "$COUNTER "
		fi
		if [ "$LETTER" != "." ] ; then
			COUNTER=$(($COUNTER + 1))
		fi
	done
	echo "are set (LSB=0)"
}
h2ip() {
        [ -z "$1" -o "$1" = "-h" ] && echo "h2bit: Converts HEX to IP address (e.g. FB0000E0 to 224.0.0.251, for /proc/net/igmp)" && return 0
        DELIM=""
        for IP in $@ ; do
                for HEX in `echo $IP | grep -o .. | tac` ; do
                        if [ "$HEX" != "0x" ] ; then
                                echo -n "$DELIM$(h2d $HEX)"
                                DELIM="."
                        fi
                done
                if [ "$IP" = "810100E0" -o "$IP" = "0x810100E0" ] ; then
                        echo -n "(=IEEE1588/PTP)"
                fi
                DELIM=" "
        done
        echo
}
o2h(){
    [ -z "$1" -o "$1" = "-h" ] && echo "o2h: Converts octal to HEX" && return 0
    if echo "$@" | grep -q '[ 89a-zA-Z]' ; then
        echo "o2h: '$@' is not an octal number!" && return 1;
    fi
    OUTPUT=`echo "ibase=8; obase=20; $@" | bc`
    echo "0x$OUTPUT"
}
o2d(){
    [ -z "$1" -o "$1" = "-h" ] && echo "o2d: Converts octal to decimal" && return 0
    if echo "$@" | grep -q '[ 89a-zA-Z]' ; then
        echo "o2h: '$@' is not an octal number!" && return 1;
    fi
    echo "ibase=8; obase=12; $@" | bc
}
o2b(){
    [ -z "$1" -o "$1" = "-h" ] && echo "o2b: Converts octal to binary" && return 0
    h2b `o2h $@`
}
o2bit() {
    [ -z "$1" -o "$1" = "-h" ] && echo "o2h: Converts octal to bits (each bit set is printed)" && return 0
    h2bit `o2h $@`
}
d2h(){
	[ -z "$1" -o "$1" = "-h" ] && echo "d2h: Converts decimal to HEX in two's complement" && return 0
	if [ $@ -lt 0 ] ; then
		OUTPUT=`echo "ibase=10; obase=16; 2^32+$@"|bc`
		echo "0x$OUTPUT"
	else
		OUTPUT=`echo "ibase=10; obase=16; $@"|bc`
		echo "0x$OUTPUT"
	fi
}
d2b(){
	[ -z "$1" -o "$1" = "-h" ] && echo "d2b: Converts decimal to binary" && return 0
	h2b `d2h $1`
}
b2d(){
	[ -z "$1" -o "$1" = "-h" ] && echo "b2d: Converts binary to decimal" && return 0
	INPUT=`echo "$@" | sed 's/\.//g'`  # remove dots
	echo "ibase=2; obase=1010; $INPUT" | bc
}
b2h(){
	[ -z "$1" -o "$1" = "-h" ] && echo "b2h: Converts binary to HEX" && return 0
	INPUT=`echo "$@" | sed 's/\.//g'`  # remove dots
	OUTPUT=`echo "ibase=2; obase=10000; $INPUT" | bc`
	echo "0x$OUTPUT"
}
a2d() {
	[ -z "$1" -o "$1" = "-h" ] && echo "a2d: Converts ASCII to decimal" && return 0
	LC_CTYPE=C printf '%d\n' "'$1"
}
a2h() {
	[ -z "$1" -o "$1" = "-h" ] && echo "a2h: Converts ASCII to HEX" && return 0
	d2h `a2d $1`
}
a2b() {
	[ -z "$1" -o "$1" = "-h" ] && echo "a2b: Converts ASCII to binary" && return 0
	d2b `a2d $1`
}
d2a() {
	[ -z "$1" -o "$1" = "-h" ] && echo "d2a: Converts decimal to ASCII" && return 0
	[ "$1" -lt 256 ] || return 1
	printf "\\$(printf '%03o' "$1")\n"
}
h2a() {
	[ -z "$1" -o "$1" = "-h" ] && echo "h2a: Converts HEX to ASCII" && return 0
	d2a `h2d $1`
}
b2a() {
	[ -z "$1" -o "$1" = "-h" ] && echo "b2a: Converts binary to ASCII" && return 0
	d2a `b2d $1`
}
be2le() {
	[ -z "$1" -o "$1" = "-h" ] && echo "be2le: Converts zero-padded big-endian hex numbers to little-endian" && return 0
	echo "$1" | sed 's/^0x//' | grep -o .. | tac | echo "0x$(tr -d '\n')"
}
le2be() {
	[ -z "$1" -o "$1" = "-h" ] && echo "be2le: Converts zero-padded little-endian hex numbers to big-endian" && return 0
	be2le $@
}




declare -a TRANSACTIONS=(
   a2b "erd1qx22s3yyawvfvsn3573r3nkwk6c9efj756ex5cnqk5ul6fz5nggqhaze4y",
   a2b | "erd1qx22s3yyawvfvsn3573r3nkwk6c9efj756ex5cnqk5ul6fz5nggqhaze4y"
)



# DO NOT MODIFY ANYTHING FROM HERE ON

PROXY="https://devnet-gateway.elrond.com"
DENOMINATION="000000000000000000"

# We recall the nonce of the wallet
NONCE=$(erdpy account get --nonce --address="$MYWALLET" --proxy="$PROXY")

 



function upload { 
  for transaction in "${TRANSACTIONS[@]}"; do
    set -- $transaction
 echo $1
    erdpy contract call $CONTRACT --function="addToWhitelist" --pem=$PEM_FILE --proxy=$PROXY --nonce=$NONCE --gas-limit=50000  --arguments= $1
    
  
    echo "Transaction sent with nonce $NONCE and backed up to bon-mission-tx-$NONCE.json."
    (( NONCE++ ))
  done
}





 
