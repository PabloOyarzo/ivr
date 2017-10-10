#!/bin/bash

PATH=/bin:/usr/bin

CURRENT_STATUS=0
VOLTAGE_STATUS=0
RESISTANCE_STATUS=0
RESULT=0

DOES_DECIMAL=0
DOES_INTEGER=0
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
#Fix Pending detect decimals
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

Exit_Preffix_Manager(){
  if [[ $DOES_DECIMAL == "1" ]]; then
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
  elif [[ $DOES_INTEGER == "1" ]]; then
    case "$DECIMAL_COUNTER" in
      3)
        EXIT_PREFFIX="k"
        ;;
      6)
        EXIT_PREFFIX="M"
        ;;
      9)
        EXIT_PREFFIX="G"
        ;;
      12)
        EXIT_PREFFIX="T"
        ;;
    esac
  fi
}

Integer(){
  DOES_INTEGER=1
  DECIMAL_COUNTER=0
  for (( i=0; i<${#PRELIMINAR_RESULT}; i++ )); do
    if [[ ${PRELIMINAR_RESULT:$i:1} == "." ]]; then
      break
    else
      (( DECIMAL_COUNTER++ ))
    fi
  done

#  echo "Decimal Counter $DECIMAL_COUNTER"

  for (( i = 0; i < 10; i++ )); do
    if [[ $DECIMAL_COUNTER -lt "3"  ]]; then
      case "$(($DECIMAL_COUNTER%3))" in
        1)
          BEFORE_LENGTH=1
          DECIMAL_COUNTER=0
          break
          ;;
        2)
          BEFORE_LENGTH=2
          DECIMAL_COUNTER=0
          break
          ;;
      esac
    elif [[ $DECIMAL_COUNTER -eq "3" ]]; then
      BEFORE_LENGTH=3
      DECIMAL_COUNTER=0
      break
    elif [[ $DECIMAL_COUNTER -gt "3" ]]; then
      case "$(($DECIMAL_COUNTER%3))" in
        1)
          BEFORE_LENGTH=1
          DECIMAL_COUNTER=$(($DECIMAL_COUNTER-1))
          break
          ;;
        2)
          BEFORE_LENGTH=2
          DECIMAL_COUNTER=$(($DECIMAL_COUNTER-2))
          break
          ;;
        0)
          BEFORE_LENGTH=3
          DECIMAL_COUNTER=$(($DECIMAL_COUNTER-3))
          break
          ;;
      esac
      break
    fi
  done

  AFTER_POINT=$(($BEFORE_LENGTH + 1))
  Exit_Preffix_Manager
  echo "${PRELIMINAR_RESULT:0:$BEFORE_LENGTH}.${PRELIMINAR_RESULT:$AFTER_POINT:2}$EXIT_PREFFIX"
  echo "$PRELIMINAR_RESULT"
  exit 0

}

Decimal(){
  DOES_DECIMAL=1
  DECIMAL_COUNTER=0
  DEC_LENGTH=0

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
          DEC_LENGTH=2
          ;;
        2)
          DECIMAL_COUNTER=$(($DECIMAL_COUNTER+1))
          DEC_LENGTH=1
          ;;
      esac
      Exit_Preffix_Manager
      break
    fi
  done

  AFTER_POINT=$(($BEFORE_POINT+$DEC_LENGTH))
  echo "${PRELIMINAR_RESULT:$BEFORE_POINT:$DEC_LENGTH}.${PRELIMINAR_RESULT:$AFTER_POINT:2}$EXIT_PREFFIX"
  echo "$PRELIMINAR_RESULT"
  exit 0
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
  Preffix_Result_Manager
  exit 0
fi
