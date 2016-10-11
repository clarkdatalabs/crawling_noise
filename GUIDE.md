# Git Initial Guide for this repo

### Clone the repo

 - 1.
Went to the local folder you want this repo be cloned into in the terminal, and type following command line to clone the repo

````
git clone https://github.com/clarkdatalabs/crawling_noise.git  
````

 - 2.
 For team crawling, you could type the following command into the terminal
````
git checkout crawling
````
then you should see the following lines printing out in your terminal, that means you created a local brach named 'crawling', and it is automatically updated with the remote branch 'crawling'
````
Branch crawling set up to track remote branch crawling from origin.
Switched to a new branch 'crawling'
````
 For team sound, you could type the following command into the terminal
````
git checkuot sound
````
you should see this message pops up
````
Branch sound set up to track remote branch sound from origin.
Switched to a new branch 'sound'
````

 - 3.
  Now each team should have two local branches, the master branch and the branch you would work on(branch sound or branch crawling)
  For this project, we are all going to work on our team branch(branch crawling or sound), you could use the following command to check whether you are on the right branch.
````
git status
````  

### Commit & Push

 - 1. After editing files locally, use following command to add these changes and push them to the origin team branch(crawling or sound branch)
````
git add .
git commit -m"commit message"
git push origin [branch name]

````
### Pull & Update your branch
 - Remember to update your branch with the latest master branch every time before you start working on your team branch
````
git checkout master
git pull
git checkout [branch name]
git merge master

````
