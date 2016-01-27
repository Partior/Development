cd %HOMEPATH%
cd Desktop
mkdir Partior
cd Partior
git init
git remote add online -f -m master https://github.com/Partior/Q-1_MATLAB.git
git pull online master
git push -u online master