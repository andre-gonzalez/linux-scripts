#!/bin/sh

bluetoothctl remove CC:98:8B:C1:5C:78 && 
bluetoothctl scan on &&
bluetoothctl connect CC:98:8B:C1:5C:78 &&
bluetoothctl pair CC:98:8B:C1:5C:78 &&
bluetoothctl trust CC:98:8B:C1:5C:78 &&
bluetoothctl scan off

