FROM python:3.9

RUN apt-get update && apt-get install -y gnupg

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get -y update \
    && apt-get install -y google-chrome-stable

RUN apt-get install -yqq unzip

RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip \
    && apt-get install -yqq unzip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

COPY . . 

RUN pip3 --no-cache-dir install --upgrade awscli

RUN ["pip3", "install", "-r", "requirements.txt"]

# Pass environment variables to the image so that they can be called when the docker is ran.
CMD echo "FPL_USER_NAME = $FPL_USER_NAME" \
    && echo "FPL_PWORD = $FPL_PWORD" \
    && ["python", "./project/fpl_webscraper.py"]