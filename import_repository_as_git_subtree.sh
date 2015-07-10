#!/bin/bash
#Author - Lemniscate Snickets - 09-July-2015

#Script to import a repo as a git subtree


echo "Script init"

dir='.git'

if [ ! -d "$dir" -a ! -h "$dir" ]
then
echo "|-.git dir could not be found - Are you in the top level dir"
echo " |-If not then you should be - Doesn't look like it though - check with  < ls -all > "

else
#presumably in the top level git dir
#ok now do the thing

#Now to check if there are any commits pending 
gitstatus="$(git status)"
branchupdatestring='Your branch is up-to-date with'
commitstring='nothing to commit, working directory clean'

#check if git status contains the string 

if echo "$gitstatus" | grep -q "$commitstring"; then
	echo "|-It looks like everything is uptodate before subtree import - Continuing Onwards";
else
	echo "|-It looks like there are some commits pending"
	echo "|-It is advisable to commit them"
	echo "|-Do you want to exit to commit (n) or try to continue (y) ?"
	commitcheck='$1'
	read commitcheck

	if [ "$commitcheck" != 'n' ] || [ "$commitcheck" != 'no' ]; then
		exit 0 # exit script they want to commit changes 
	fi

fi


echo "|- Please enter the dir where you would like to make the repo as a subtree"
echo " |- Path to dir  full/relative - if dir does not exist it will be created"
echo " |-No symlinks"

pathdir="$1"

read pathdir

#directory path didnt exist lets make one 
if [ ! -d "$pathdir" -a ! -h "$pathdir" ]
then
echo "|- Making Dir@: " $pathdir
mkdir $pathdir

fi
echo -e "\n"
#ok so the dir should exist now do the git thing
echo "|-Remote Name of repo: - example: triesremote" 
read reponame
echo "|-Please enter the remote path/weburl for the git to be used as a subtree"
read remoteurl


# Actual Subtree creation commands
#-----------------------------------------------------------
git remote add -f $reponame $remoteurl
git merge -s ours --no-commit $reponame/master
git read-tree --prefix=$pathdir/ -u $reponame/master
git commit -m "Added +$reponame+as a subtree"
# -----------------------------------------------------------


# -e flag for interpreting backslash escape characters
# may do something funny on some bash terms 
# consider switching to printf for future.
echo -e "\n\n\n"
echo "***********************"
echo "All done"
echo "For push pull to subtree use the following remotes as from the top level dir"
echo "git pull -s subtree remotename branchname"
git remote -v

fi
