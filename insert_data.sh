#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WIN OP WIN_G OP_G
do
     #top row, dont need that
     if [[ $YEAR != 'year' ]]
     then       
        
          # get opponenet id
          OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")

          # if not found
          if [[ -z $OP_ID ]]
          then
               #insert
      INSERT_OP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OP')")
      if [[ $INSERT_OP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OP
      fi
      #get new id
        OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")
       fi


        # get winner id
        WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")

          # if not found
        if [[ -z $WIN_ID ]]
        then
         # insert 
      INSERT_WIN_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
      if [[ $INSERT_WIN_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WIN
      fi

              # get new winner id
              WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
          fi

          # inserting games
        INSERT_GAMES_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
          VALUES($YEAR, '$ROUND', $WIN_ID, $OP_ID, $WIN_G, $OP_G)")"
           if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR, $ROUND, $WIN_ID, $OP_ID, $WIN_G, $OP_G
      fi
     fi
done
