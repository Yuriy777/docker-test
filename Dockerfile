FROM node:18-alpine as build

RUN apk update && \
    apk upgrade && \
    apk add git

WORKDIR /usr/src/app

#RUN git config --global user.name "Vivien Gite"
#RUN git config --global user.email "webmaster@testcyberciti.biz"
RUN git clone https://github.com/Yuriy777/docker-test.git .


RUN npm ci && npm run build

FROM build

ARG user=appuser
ARG group=appuser
ARG homeDir=/usr/src/app

RUN addgroup ${group} && adduser -G ${group} -D ${user}
COPY --from=0 /usr/src/app/dist ${homeDir}
WORKDIR ${homeDir}
EXPOSE 3000
USER ${user}

CMD [ "node", "dist/main.js" ]


