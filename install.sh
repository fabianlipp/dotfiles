#!/bin/bash

DOTFILE_DIR=~/.dotfiles
BACKUP_DIR=$DOTFILE_DIR/backup/   # with / at end
FILES=".bashrc .dircolors"

if [ ! -e $BACKUP_DIR ]; then
	mkdir $BACKUP_DIR
fi

for file in $FILES; do
	if [ -e ~/$file -a ! -L ~/$file ]; then
		echo "Moving original file to $BACKUP_DIR$file"
		SRC_DIR=$(dirname $file)
		REL_DIR=${DIRNAME#~/}
		if [ -n $REL_DIR ]; then
			mkdir -p $BACKUP_DIR$REL_DIR
		fi
		mv ~/$file $BACKUP_DIR$REL_DIR
	fi

	if [ ! -e ~/$file ]; then
		echo "Installing symlink for $file"
		ln -s $DOTFILE_DIR/$file ~/$file 
	fi
done

