# Use an official Node.js runtime as the base image
FROM node:18 as builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY . .


# Install dependencies
RUN npm ci 

# Copy the entire React app to the container
COPY . .

# Build the React app for production
RUN npm run build

# Set up a lightweight web server to serve the built app
# RUN npm install -g serve
FROM nginx:1.21.0-alpine as production

# Set the command to run when the container starts
# CMD ["serve", "-s", "build"]
ENV NODE_ENV production

COPY --from=builder /app/build /usr/share/nginx/html
# Expose the port on which the web server will run
EXPOSE 80

CMD [ "nginx","-g","daemon off;" ]

