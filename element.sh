#!/bin/bash

#if staring up again, use DROP <database name> to drop old db and rebuild from the dump previously made

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PRINT_ELEMENT(){
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

  echo -e "The element with atomic number $(echo $ATOMIC_NUMBER) is $(echo $NAME) ($(echo $SYMBOL)). It's a $(echo $TYPE), with a mass of $(echo $MASS) amu. $(echo $NAME) has a melting point of $(echo $MP) celsius and a boiling point of $(echo $BP) celsius."

}

if [[ $1 ]]
then

  RE='^[0-9]+$'
  if [[ $1 =~ $RE ]]
  then 
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      PRINT_ELEMENT
    fi
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$(echo $1)'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        PRINT_ELEMENT
      fi
    else
      PRINT_ELEMENT
    fi
  fi

  
else
  echo "Please provide an element as an argument."
fi
