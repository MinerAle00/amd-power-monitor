#!/bin/bash

while true; do
    package_value=$(sudo rapl | grep 'Package' | awk '{print $7}' | sed 's/W//' | head -n 1)
    echo "# HELP package_value Power consumption of the Package" > ~/node-exporter/power/cron.prom
    echo "# TYPE package_value gauge" >> ~/node-exporter/power/cron.prom
    echo "package ${package_value}" >> ~/node-exporter/power/cron.prom
    sleep 1
done