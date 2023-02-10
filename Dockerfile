FROM heroku/heroku:22-build

RUN apt-get update && apt-get install -y devscripts equivs awscli

ADD ./ /home/work/sffmpeg
WORKDIR /home/work/sffmpeg

RUN mk-build-deps -t "apt-get --no-install-recommends -y" -r -i debian/control

CMD make && make deb
