MYWALLET="erd1ucyxzr83k0sxn3rmspgd9raw7w85ds45w3xrtgl44zc36k7ce7cqq3u8ep"
PEM_FILE="walletKey.pem"
CONTRACT="erd1qqqqqqqqqqqqqpgqnj7yxccexywxj4rz6t9744ymql0u9eare7cqd75h0a"




declare -a TRANSACTIONS=(
    "erd1qx22s3yyawvfvsn3573r3nkwk6c9efj756ex5cnqk5ul6fz5nggqhaze4y" ,
    "erd1qx22s3yyawvfvsn3573r3nkwk6c9efj756ex5cnqk5ul6fz5nggqhaze4y" 
)



# DO NOT MODIFY ANYTHING FROM HERE ON

PROXY="https://devnet-gateway.elrond.com"
DENOMINATION="000000000000000000"

# We recall the nonce of the wallet
NONCE=$(erdpy account get --nonce --address="$MYWALLET" --proxy="$PROXY")

 



function upload { 
  for transaction in "${TRANSACTIONS[@]}"; do
    set -- $transaction
 echo  
    erdpy contract call $CONTRACT --function="addToWhitelist" --pem=$PEM_FILE --proxy=$PROXY --nonce=$NONCE --gas-limit=50000  --arguments=  echo $1 | perl -lpe '$_=join " ", unpack"(B8)*"'
    
    echo "Transaction sent with nonce $NONCE and backed up to bon-mission-tx-$NONCE.json."
    (( NONCE++ ))
  done
}




upload
 
