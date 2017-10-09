#!/bin/bash

PATH=/bin:/usr/bin

CURRENT_STATUS=0
VOLTAGE_STATUS=0
RESISTANCE_STATUS=0
RESULT=0

#--------------------------------------------------

#sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $2'} | sed -r 's/[a-z]/& /' ;
Preffix_Operator_DETECTOR() {
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

#--------------------------------------------------

Current_Func() {
  echo -n "Insert I (current)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/&/' | awk -F " " {'print $2'})
  I_VALUE=$(echo "$VALUE * $(Preffix_Operator_DETECTOR)" | bc)
}

Voltage_Func() {
  echo -n "Insert V (voltage)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/&/' | awk -F " " {'print $2'})
  V_VALUE=$(echo "$VALUE * $(Preffix_Operator_DETECTOR)" | bc)
}

Resistance_Func() {
  echo -n "Insert R (Resistance)" ; echo
  read answer
  if [[ -z $answer ]]; then
    return 1
  fi
  VALUE=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/& /' | awk -F " " {'print $1'})
  PREFFIX=$(echo "$answer" | sed -r 's/[0-9]+/& /' | sed -r 's/[a-z]+/&/' | awk -F " " {'print $2'})
  R_VALUE=$(echo "$VALUE * $(Preffix_Operator_DETECTOR)" | bc)
}

#--------------------------------------------------

Preffix_Result_Manager() {
  if [[ $( echo $PRELIMINAR_RESULT | awk -F "" {'print $1'} ) == "." ]]; then
    Decimal
  else
    Integer
  fi
}


Integer(){
  exit
}

Exit_Preffix_Manager(){
  case "$DECIMAL_COUNTER" in
    3)
      EXIT_PREFFIX="m"
      ;;
    6)
      EXIT_PREFFIX="u"
      ;;
    9)
      EXIT_PREFFIX="n"
      ;;
    12)
      EXIT_PREFFIX="p"
      ;;
  esac
}

Decimal(){
  DECIMAL_COUNTER=0
  for (( i=1; i<${#PRELIMINAR_RESULT}; i++ )); do
    if [[ ${PRELIMINAR_RESULT:$i:1} == 0 ]]; then
      (( DECIMAL_COUNTER++ ))
    else
      break
    fi
  done
  BEFORE_POINT=$(( $DECIMAL_COUNTER + 1 ))
  for (( i = 0; i < 10; i++ )); do
    if [[ $(($DECIMAL_COUNTER%3)) == "0" ]]; then
      Exit_Preffix_Manager
      break
    else
      case "$(($DECIMAL_COUNTER%3))" in
        1)
          DECIMAL_COUNTER=$(($DECIMAL_COUNTER+2))
          ;;
        2)
          DECIMAL_COUNTER=$(($DECIMAL_COUNTER+1))
          ;;
      esac
      Exit_Preffix_Manager
      break
    fi
  done


  AFTER_POINT=$(( $BEFORE_POINT + 3 ))
  echo "${PRELIMINAR_RESULT:$BEFORE_POINT:3}.${PRELIMINAR_RESULT:$AFTER_POINT:1}$EXIT_PREFFIX"
#  echo "$PRELIMINAR_RESULT"
}

#--------------------------------------------------

if Current_Func; then
  CURRENT_STATUS=1
fi

if Voltage_Func; then
  VOLTAGE_STATUS=1
fi

if [[ $CURRENT_STATUS == $VOLTAGE_STATUS ]]; then
  PRELIMINAR_RESULT=$(echo "$V_VALUE/$I_VALUE" | bc -l)
  Preffix_Result_Manager
  exit 0
fi

if Resistance_Func; then
  RESISTANCE_STATUS=1
fi

if [[ $CURRENT_STATUS == $RESISTANCE_STATUS ]]; then
  PRELIMINAR_RESULT=$(echo "$V_VALUE/$I_VALUE" | bc -l)
  Preffix_Result_Manager
  exit 0
fi

if [[ $VOLTAGE_STATUS == $RESISTANCE_STATUS ]]; then
  PRELIMINAR_RESULT=$(echo "$V_VALUE/$I_VALUE" | bc -l)
  Preffix_Result_Managers
  exit 0
fi
