# Dockerfile for example whisk docker action
FROM openwhisk/dockerskeleton
 
ENV FLASK_PROXY_PORT 8080

RUN apk update && apk add curl jq

RUN curl -L 'https://cli.run.pivotal.io/stable?release=linux64-binary&source=github' | tar -zx && chmod a+rx cf && mv cf /usr/local/bin/cf

#RUN wget -q https://openwhisk.ng.bluemix.net/cli/go/download/linux/amd64/wsk && chmod a+rx wsk && mv wsk /usr/local/bin

#ADD bin/changeWhiskKey.sh /action/changeWhiskKey.sh
ADD bin/getWhiskKey.sh /action/getWhiskKey.sh

### Add source file(s)
ADD login.sh /action/exec

CMD ["/bin/bash", "-c", "cd actionProxy && python -u actionproxy.py"]
