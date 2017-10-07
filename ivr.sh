#!/bin/bash

CURRENT_STATUS=0
VOLTAGE_STATUS=0
RESISTANCE_STATUS=0

#sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $2'} | sed -r 's/[a-z]/& /' ;

Current_Func() {
  echo -n "Insert I (current)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  I_VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  I_PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $2'})
}

Voltage_Func() {
  echo -n "Insert V (voltage)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  V_VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  V_PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $2'})
}

Resistance_Func() {
  echo -n "Insert R (Resistance)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  R_VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  R_PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $2'})
}

if Current_Func; then
  CURRENT_STATUS=1
fi

if Voltage_Func; then
  VOLTAGE_STATUS=1
fi

if Resistance_Func; then
  RESISTANCE_STATUS=1
fi


if [[ $CURRENT_STATUS == $VOLTAGE_STATUS ]]; then
  echo $(($V_VALUE/$I_VALUE))
fi

if [[ $CURRENT_STATUS == $RESISTANCE_STATUS ]]; then
  echo $(($I_VALUE*$R_VALUE))
fi

if [[ $VOLTAGE_STATUS == $RESISTANCE_STATUS ]]; then
  echo $(($V_VALUE/$R_VALUE))
fi
