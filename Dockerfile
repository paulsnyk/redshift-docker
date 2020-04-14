FROM nodesource/nsolid:carbon-latest

MAINTAINER Snyk Ltd

ENV NODE_ENV production

RUN mkdir -p /srv/app
WORKDIR /srv/app

# Removing these lines
# RUN useradd --home-dir /srv/app -s /bin/bash snyk
# RUN chown -R snyk:snyk /srv/app
# USER snyk
# Replacing them with the following 2 lines
RUN chgrp -R 0 /srv/app \
  && chmod -R g+rwX /srv/app

# Add package.json and install before adding anything else to take advantage of
# Docker's layer caching
# removing the --chmod snyk from the line below
ADD package.json package-lock.json .snyk ./



ARG NPMJS_TOKEN
RUN echo //registry.npmjs.org/:_authToken=$NPMJS_TOKEN >> ~/.npmrc && \
  npm install && \
  rm ~/.npmrc

# removing the --chmod snyk from the line below
ADD . .



ENTRYPOINT ["./docker-entrypoint.sh"]


EXPOSE 19000
CMD ["npm", "start"]
