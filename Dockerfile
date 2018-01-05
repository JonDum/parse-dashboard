FROM node:9-alpine

# set our node environment, either development or production
# defaults to production
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

RUN apk update
RUN apk add tini su-exec

ENV NPM_CONFIG_LOGLEVEL error

WORKDIR /home/node

ADD package.json .

RUN npm install

ADD Parse-Dashboard/* ./Parse-Dashboard/*

# BE SURE TO `npm run build` FIRST
# BEFORE BUILDING DOCKER IMAGE
ADD production/bundles/ .

RUN echo '#!/bin/sh' >> entrypoint.sh && \
  echo 'su-exec node "$@"' >> entrypoint.sh && \
  chmod +x entrypoint.sh

ENTRYPOINT ["tini", "--", "/home/node/entrypoint.sh"]

CMD ["npm", "start"]
