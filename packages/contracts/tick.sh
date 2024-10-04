#!/bin/bash

while true
do
    forge script script/Tick.s.sol:Tick --broadcast --sig "run(address)" "0xc11BB7a7F18ba2fAbCb7aDcAeb5A1520f98729Ff" --rpc-url http://127.0.0.1:8545 -vvvv
    sleep 1
done
