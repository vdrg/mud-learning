#!/bin/bash

while true
do
    forge script script/Tick.s.sol:Tick --broadcast --sig "run(address)" "0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B" --rpc-url http://127.0.0.1:8545 -vvvv
    sleep 1
done
