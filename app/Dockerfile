FROM node:alpine
WORKDIR /usr/app
COPY app.js /usr/app/
RUN npm install pg
RUN npm install express

# Set up a default command
CMD [ "node","app.js" ]
