# Use the official Node.js image from the Docker Hub
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install necessary packages and dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Create a volume named "clientvol" and mount it at "/clientdata" in the container
VOLUME ["clientvol:/clientdata"]

# Define the command to run the client application
CMD ["node", "client.js"]
