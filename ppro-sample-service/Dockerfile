FROM node:alpine
WORKDIR /usr/app
COPY app/app.js /usr/app/
RUN npm install pg
RUN npm install express
RUN npm install js-yaml
RUN npm install fs
RUN npm install moment
COPY app/scripts /usr/app/scripts
COPY app/initdb.js /usr/app/

# Set up a default command
CMD [ "node","app.js" ]
