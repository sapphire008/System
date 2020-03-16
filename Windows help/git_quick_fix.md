# How to set up git: https://help.github.com/articles/
1. Install git
```
sudo apt-get install git
```
2. Set profile
  * User name:
  Sets the default name for git to use when you commit
  ```
  git config --global user.name "Your Name here in the quote"
  ```
  * Email
  Sets the default email for git to use when you commit
  ```
  git config --global user.email "YourEmailHereInTheQuote@example.com"
  ```
3. Cache username and password temporarily so that it is not going to ask you for them every time
  Set git to use the credential memory cache
```
git config --global credential.helper cache
```
  If want to change the duration of cache
  Set the cache to timeout after 1 hour (setting is in seconds)
  ```
  git config --global credential.helper 'cache --timeout=3600'
  ```

4. Initialize
```
git init
```
5. Add files
```
git add FILENAME
```
OR
```
git add folder/*  #to add all files in a folder
```
To ignore removed files (no longer updating the deleted files)
```
git add -u
```
6. Check status of files to be committed
```
git status
```

6. Make commitment
```
git commit -m "first commit" # commit the files with message "first commit"
```
To commit everything not included in the `git status`
`git commit -a -m "message`

7. Push the commit
```
git remote add origin https://github.com/username/repository_name.git
git push origin master
```
 *To force pushing*
```
git push -f origin master
```

8. Remove a duplicate directory
```
git rm -r /duplicated/directory
git commit -m "remove duplication"
git push origin master
```

9. Remove a file
```
git rm /path/to/file.ext
git rm --cache /path/to/file.ext
git commit -m "removed file"
git push origin master
```

10. List a file
```
git ls-files
```

Or to search for a pattern
```
git ls-files | grep pattern
```



10. Recover deleted files
If the files are deleted via
```
git rm -r /duplicated/directory
```
Do the following:
```
git reset --hard HEAD
```
OR if the file names are known
```
git checkout deleted_file
```
10. Clone a repository
```
git clone https://github.com/username/repository.git
```

11. Correct CRLF to LF
To convert all CRLF to LF
```
git config --global core.autocrlf true
```
To convert CRLF to LF on Lunix/Unix and repository, but keep CRLF on Windows
```
git config --global core.autocrlf input
```
To stop converting any CRLF to LF
```
git config --global core.autocrlf false
```

12. Revert a single file
# finding the right commit
`git log path/to/file`
# get the version of the file from the given commit
`git checkout <commit> path/to/file`
# and commit this modification
`git commit`

13. Set up github page
* Make a repository on github.com first. Name this repository exactly in the format `username.github.io`
* Make a local folder with the same name `username.github.io`
* Add files in this local folder. Must have an `index.html` file. This will be the main page of the website https://username.github.io
  - In the following example, let's create a index page to link to other files in the subfolders

  ```html
  <p>Notebook list</p>

  <p>* <a href="benefits/">Benefits</a></p> <!-- pointing to some subfolder-->
  <p>* <a href="factors/">Factors</a></p>
  <p>* <a href="society/">Society</a></p>
  <p>* <a href="scatters/">Scatters</a></p>
  ```
* Commit the added files
* Now it is ready to visit https://username.github.io/

14. Branching
* Add new branch
`git checkout -b new_branch`
* Push branch to remote
`git push origin new_branch`
* Delete new branch
`git branch -d new_branch`
* Delete remotely
`git push origin --delete new_branch`
* Current branch you are working on
`git branch`
or
`git status`

15. Ignore some files
* Add a `.gitignore` file to the directory
* In the `.gitignore` file, specify the files to be ignored
  - Ignore extensions: `*.ext`, e.g. `*.png`, `*.docx`
  - Ignore a specific file: `filename.ext`, e.g. `add1.py`
  - Ignore directory: `directory/`, e.g. `/home/user/path1/`
