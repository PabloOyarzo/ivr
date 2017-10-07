#!/bin/bash

PATH=/bin:/usr/bin

CURRENT_STATUS=0
VOLTAGE_STATUS=0
RESISTANCE_STATUS=0

#sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $2'} | sed -r 's/[a-z]/& /' ;
Preffix_Manager() {
  case "$PREFFIX" in
    T)
      echo 1000000000000
      ;;
    G)
      echo 1000000000
      ;;
    M)
      echo 1000000
      ;;
    k)
      echo 1000
      ;;
    "")
      echo 1
      ;;
    m)
      echo 0.001
      ;;
    u)
      echo 0.000001
      ;;
    n)
      echo 0.000000001
      ;;
    p)
      echo 0.000000000001
      ;;
    *)
      echo "Sorry, not available"
      exit 1
  esac
}

Current_Func() {
  echo -n "Insert I (current)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/&/' | awk -F " " {'print $2'})
  I_VALUE=$(echo "$VALUE * $(Preffix_Manager)" | bc)
}

Voltage_Func() {
  echo -n "Insert V (voltage)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/&/' | awk -F " " {'print $2'})
  V_VALUE=$(echo "$VALUE * $(Preffix_Manager)" | bc)
}

Resistance_Func() {
  echo -n "Insert R (Resistance)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/&/' | awk -F " " {'print $2'})
  R_VALUE=$(echo "$VALUE * $(Preffix_Manager)" | bc)
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
  echo "$V_VALUE/$I_VALUE" | bc
fi

if [[ $CURRENT_STATUS == $RESISTANCE_STATUS ]]; then
  echo "$I_VALUE*$R_VALUE" | bc
fi

if [[ $VOLTAGE_STATUS == $RESISTANCE_STATUS ]]; then
  echo "$V_VALUE/$R_VALUE" | bc
fi
