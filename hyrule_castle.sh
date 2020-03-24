#!/bin/bash

ROUND=1
FLOOR_COUNT=1 #Etage
ACTION=1
##########CSV's VARIABLES###########
PLAYERS_CSV=$(echo -e ./csv/players.csv)
ENEMYS_CSV=$(echo -e ./csv/enemies.csv)
#----------------------------------#
########"COLOR'S VARIABLES"#########
LIGHT_RED="\e[91m"
LIGHT_GRAY="\e[37m"
LIGHT_GREEN="\e[92m"
LIGHT_BLUE="\e[94m"
WHITE="\e[39m"
#----------------------------------#
#########ENTITY'S VARIABLES#########
RANDOM_PLAYER=$((RANDOM % 3 + 2))
RANDOM_ENEMY=$((RANDOM % 10 + 2))

PLAYER_RARITY=$(sed -n "${RANDOM_PLAYER} p" $PLAYERS_CSV | cut -d "," -f13) #Player Rarity
ENEMY_RARITY=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f13) #Enemy Rarity

PLAYER_NAME=$(sed -n "${RANDOM_PLAYER} p" $PLAYERS_CSV | cut -d "," -f2) #Player Name.
PLAYER_HP_LEFT=$(sed -n "${RANDOM_PLAYER} p" $PLAYERS_CSV | cut -d "," -f3) #Player HP LEFT.
PLAYER_STR=$(sed -n "${RANDOM_PLAYER} p" $PLAYERS_CSV | cut -d "," -f5) #Player Damage (STR Value).
MAX_PLAYER_HP=$(sed -n "${RANDOM_PLAYER} p" $PLAYERS_CSV | cut -d "," -f3) #Max Player HP.

ENEMY_NAME=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f2) #Enemy Name.
ENEMY_HP_LEFT=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f3) #Enemy HP LEFT.
ENEMY_STR=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f5) #Enemy Player Damage (STR Value).
MAX_ENEMY_HP=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f3) #Max Enemy HP.
#----------------------------------#
clear
    while [ $ACTION != 0 ]; do
	if [ $ENEMY_HP_LEFT -gt 0 ]; then
	    if [ $PLAYER_HP_LEFT -gt 0 ]; then
		clear
		echo -e ""
		echo -e "${LIGHT_BLUE}------------------------------------------------------------"
		echo -e "${LIGHT_GRAY}########## ${WHITE}FIGHT ${LIGHT_BLUE}${FLOOR_COUNT} ${LIGHT_GRAY}##########"
		echo -e "${LIGHT_RED}$ENEMY_NAME"
		echo -e "${WHITE}HP: ${LIGHT_BLUE}${ENEMY_HP_LEFT}${LIGHT_GRAY}/${LIGHT_GREEN}${MAX_ENEMY_HP}"

		echo -e ""

		echo -e "${LIGHT_BLUE}$PLAYER_NAME"
		echo -e "${WHITE}HP:${LIGHT_BLUE}${PLAYER_HP_LEFT}${LIGHT_GRAY}/${LIGHT_GREEN}${MAX_PLAYER_HP}"

		echo -e ""

		echo -e "${WHITE}##### Options #####"
		echo -e "${WHITE}1.${LIGHT_RED} Attack ${LIGHT_GRAY}|${WHITE} 2.${LIGHT_RED} Heal"
		if [ $ENEMY_HP_LEFT -eq $MAX_ENEMY_HP ]; then
		    echo -e ""
		    echo -e "${WHITE}You encounter a ${LIGHT_RED}${ENEMY_NAME}${WHITE}, there is the mob ${LIGHT_BLUE}#${FLOOR_COUNT}${WHITE}."
		fi

		echo -e ""
		echo -e "${WHITE}Make a choice between 1 and 2."
		read -r ACTION
		echo -e ""
		if [ $ACTION = 1 ]; then
		    ENEMY_HP_LEFT=$(($ENEMY_HP_LEFT - $PLAYER_STR))
                    PLAYER_HP_LEFT=$(($PLAYER_HP_LEFT - $ENEMY_STR))
		    echo -e "${WHITE}You attacked and dealt ${LIGHT_RED}${ENEMY_STR}${WHITE} HP!"
		elif [ $ACTION = 2 ]; then
		    PLAYER_HP_LEFT=$(($PLAYER_HP_LEFT - $ENEMY_STR))
		    PLAYER_HP_LEFT=$(echo -e "$PLAYER_HP_LEFT + ($MAX_PLAYER_HP) / 2" | bc)
		    if [ $PLAYER_HP_LEFT -gt $MAX_PLAYER_HP ]; then
			PLAYER_HP_LEFT=$MAX_PLAYER_HP
		    fi
		fi
	    else
		echo -e ""
		echo -e "${LIGHT_RED}You lost ! Try again :^)"
		ACTION=0
	    fi
	fi
	if [ $ENEMY_HP_LEFT -le 0 ]; then
	    FLOOR_COUNT=$(($FLOOR_COUNT + 1))
	    RANDOM_ENEMY=$(($RANDOM % 10 + 2))
	    ENEMY_NAME=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f2) #Enemy Name.
	    ENEMY_HP_LEFT=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f3) #Enemy HP LEFT.
	    ENEMY_STR=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f5) #Enemy Damage (STR Value).
	    MAX_ENEMY_HP=$(sed -n "${RANDOM_ENEMY} p" $ENEMYS_CSV | cut -d "," -f3) #Max Enemy HP.
	    if [ $FLOOR_COUNT -ge 10 ]; then
		ACTION=0
		clear
		figlet "GG, YOU WON !"
	    fi
	fi
 done
