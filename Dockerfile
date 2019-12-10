# The hole purpose of this phase is to install dependencies and build our application
# We use node to install our dependencies
FROM node:alpine as builder
WORKDIR '/app'
#Copy package.json inoto our workdir
#COPY package*.json ./
COPY package.json .
RUN npm install
# Copy all our source code directly into the container /app directory
# We don't need to use our volume system anymore, because we don' need to reflect the changes
# that we did in our project to the image here, like did in our development environment
COPY . .
# The output of this is going to be our "/app/build" folder
# It is going to build our build folder inside our /app directory.
# This is going to be the folder that we want to copy to our "Run Phase"
RUN npm run build

FROM nginx
# AWS is going to check this port for incomming trafic
EXPOSE 80
# It says I want to copy the "build" from the "builder phase" that we just build above
# 3rd parameter specifies the folder where we want to copy this buld folder (/usr/share/nginx/html)
# everything inside here /usr/share/nginx/html is gong to be serve by the nginx server
# the Start nginx is going to be executed by default, so we don't need to do it
# All what we are getting here is the result of this /app/build directory
COPY --from=builder /app/build /usr/share/nginx/html