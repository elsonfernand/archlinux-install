#!/bin/bash

cor="#8b8b8b"

cpu=$(sensors | grep 'Package id 0:' | awk '{print $4}')
gpu=$(sensors | grep -m1 'edge:' | awk '{print $2}')
mb=$(sensors | grep 'CPUTIN:' | awk '{print $2}')
nvme=$(sensors | grep 'Composite:' | awk '{print $2}')

echo "<span color='$cor'> CPU:</span> $cpu | <span color='$cor'>󰍛 MB:</span> $mb | <span color='$cor'> SSD:</span> $nvme | <span color='$cor'>󰒋 GPU:</span> $gpu"
