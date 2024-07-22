#!/bin/bash

# Configuração do xrandr para dois monitores
# Monitor secundário à esquerda
xrandr --output HDMI-1 --primary --auto --output HDMI-2 --auto --left-of HDMI-1
