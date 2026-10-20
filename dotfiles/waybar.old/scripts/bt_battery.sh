#!/bin/bash

MAC="11:22:AB:CE:00:BD"   # coloque o MAC exato do seu fone

BATTERY=$(bluetoothctl info "$MAC" | grep "Battery Percentage" | awk '{print $3}' | tr -d '()')

if [ -z "$BATTERY" ]; then
    echo "{\"text\": \"󰥔 --%\", \"tooltip\": \"Sem dados de bateria\"}"
else
    PERCENT=$((16#$BATTERY))  # converte 0x5a em decimal
    echo "{\"text\": \"󰥔 ${PERCENT}%\", \"tooltip\": \"Bateria do fone: ${PERCENT}%\"}"
fi
