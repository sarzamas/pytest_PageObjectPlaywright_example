## Installation Steps
#### Required Linux environment on local PC:
- ubuntu LTS
- python 3.12.x
- python3-pip
- docker
- docker compose (plug-in)
#### Install IDE PyCharm CE on local PC
- Community Edition is enough
#### Download or clone autotests repository:
- via HTTPS
- via SSH
#### Set branch `dev` as default for merge requests:
```bash
git push --set-upstream origin dev
```
#### Create a virtual environment for this project
PyCharm:
- Type of environment: New Virtualenv Environment
- Base interpreter: Python 3.12
#### Upgrade pip within (.venv):
```bash
pip install --upgrade pip
```
#### Install the project requirements     
```
make init
```
#### Run the tests:
- from `PROJECT-ROOT` folder:
```
cd <PROJECT-ROOT>
make tests
```
- from `PACKAGE-DIR` folder:
```
cd <PACKAGE-DIR>
pytest
```
or
```
poetry run pytest
```
#### Install Java for Allure report
Notice:
`$JAVA_HOME` must be declared to launch an Allure report server
- install java first:
```bash
sudo apt install default-jdk # or default-jre to save docker image size
```
If you do not know the `JAVA_HOME` path, you can type:
```bash
update-alternatives --config java
```` 
And you should find the full java path from output but use it without `/bin/java` posix as `<PATH>` in next example
- Set the `JAVA_HOME` variable in file `/etc/environment` by command:
```bash
sudoedit /etc/environment
```
Add single new line at the bottom of the file:
```code
 JAVA_HOME="<PATH>"
 ```` 
Example (generic): `JAVA_HOME="/lib/jvm/default-java"`

Notice there's no space when declaring the variable, double quotes and NO `/bin/java` at the end of `<PATH>`

Save changes in file `/etc/environment` (In case `nano` editor: CTRL+X -> Yes -> Enter)

Restart your `shell`  + `.venv` for changes to take effect in all future sessions:
- option 1 (preferable) - close PyCharm and logoff/logon Ubuntu
- option 2 (fuzzy and not really clear how it works with PyCharm):
- - reset `shell` environment - this only works for the current bash session where you run it, not the .venv inside this session
```bash
. /etc/environment
```
- - check if the variable is stored, type to verify:
```bash
echo $JAVA_HOME
```
- - reset `.venv`:
```bash
sudo su - $USER
cd <PROJECT-ROOT>
source .venv/bin/activate
```
- - close/reopen current project in PyCharm (due to ambiguous behaviour of .venv's cache in PyCharm)
- - rerun install:
```bash
make init
```
#### Run the tests + allure report
from `PROJECT-ROOT`
- option 1:
```
cd <PROJECT-ROOT>
make tests_allure
```
- option 2:
```bash
sh scripts/start_tests_allure.sh
```
## Docker
Build options:
- use the Docker CLI (for manual test):

In the command, the -t flag tags your image with a name and the `.` lets Docker knows where it can find the Dockerfile
```bash
docker build -t page_object_playwright:1.0.1 . # create image from Dockerfile
docker run --name manual_run page_object_playwright:1.0 # create container from image
docker start manual_run -i # rerun existing container (interactive)
```
- build & run containers in a CI pipeline:
```bash
docker compose up -d 
docker run page_object_playwright-autotest:latest
docker start manual_run -i # rerun existing container (interactive)
```
Docker images operations:
```bash
docker images -a # list all images
docker rmi -f <image ID_or_NAME> # remove image(s list) by ID or name
docker rmi -f $(docker images -f dangling=true -qa) # remove all untagged images
docker save -o <backup_name>.tar <image ID_or_NAME> # create an image backup archive that can later be used with docker load
ls -sh <filename>.tar # check size of file
```
Docker container operations:
```bash
docker ps -a # list all containers
docker rm -f <container ID_or_NAME> # remove container by ID or name
docker run  -it -d <image ID_or_NAME:TAG> /bin/bash # force leave container running
docker exec -it <container_ID_or_NAME> /bin/bash # enter container shell
pytest # start tests inside container
exit # exit container
```
Prune docker system:
```bash
docker container stop <container ID_or_NAME> # stop running containers
docker system prune -a # clear all docker subsystem (except running containers)
```

### Known issues during installation:

- Allure server warning at launch time:
`MESA-INTEL: warning: Performance support disabled, consider sysctl dev.i915.perf_stream_paranoid=0`
- - Solution:
https://forum.manjaro.org/t/cant-change-dev-i915-perf-stream-paranoid-to-0/66339/9
- - Check actual status with command:
```bash
sysctl -n dev.i915.perf_stream_paranoid
```
- - Change parameter:
```bash
sudo sysctl dev.i915.perf_stream_paranoid=0
```
