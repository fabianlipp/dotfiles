#!/bin/bash

DOTFILE_DIR=~/.dotfiles
BACKUP_DIR=$DOTFILE_DIR/backup/   # with / at end
FILES=".bashrc .dircolors"

if [ ! -e $BACKUP_DIR ]; then
	mkdir $BACKUP_DIR
fi

for file in $FILES; do
	ORIG_FILE=~/$file
	REPO_FILE=$DOTFILE_DIR/$file
	BACKUP_FILE=$BACKUP_DIR$file
	if [ -e $ORIG_FILE -a ! -L $ORIG_FILE ]; then
		# Symlink for this file is not installed yet
		if ! diff $ORIG_FILE $REPO_FILE > /dev/null; then
			echo "File $file in repository differs from local file"
			echo "Moving original file to $BACKUP_FILE"
		fi
		# Write backup
		SRC_DIR=$(dirname $file)
		REL_SRC_DIR=${DIRNAME#~/}
		if [ -n $REL_SRC_DIR ]; then
			mkdir -p $BACKUP_DIR$REL_SRC_DIR
		fi
		mv $ORIG_FILE $BACKUP_DIR$REL_SRC_DIR
	fi

	if [ ! -e $ORIG_FILE ]; then
		echo "Installing symlink for $file"
		ln -s $REPO_FILE $ORIG_FILE
	fi
done

