#!/bin/bash

battery_info=$(acpi -b)
percentage=$(echo $battery_info | grep -oP '\d+(?=%)')
status=$(echo $battery_info | grep -oP '(?<=: )\w+')

if [ "$status" = "Charging" ]; then
    echo "#[fg=green]🔌 $percentage%"
elif [ "$status" = "Discharging" ]; then
    if [ $percentage -le 20 ]; then
        echo "#[fg=red]🔋 $percentage%"
    else
        echo "#[fg=yellow]🔋 $percentage%"
    fi
else
    echo "#[fg=cyan]🔋 $percentage%"
fi
