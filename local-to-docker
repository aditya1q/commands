# Dockerizing the Application 

## Prerequisites
 - `DABBA PORT`
 - `REMOTE SSH ACCESS`

### Create files at root of project: `docker-compose.yaml`, `Dockerfile`, `nginx.conf` 

- docker-compose.yaml
    ```bash
    version: "3.8"

    services:
    vite-react-app:
        container_name: client-dashboard-container
        build:
        context: .
        dockerfile: Dockerfile
        ports:
        - "DABBA PORT:80"
        environment:
        - .env
    ```
    
- Dockerfile
    ```bash
    # Use an official Node.js image as a base
    FROM node:20-alpine AS build

    # Set the working directory inside the container
    WORKDIR /app

    # Copy package.json and package-lock.json (or yarn.lock) to the working directory
    COPY package*.json ./

    # Install dependencies
    RUN npm install

    # Copy the rest of the application code
    COPY . .

    # Build the application
    RUN npm run build

    # Create a production image
    FROM nginx:alpine AS production

    # Copy the built app from the previous stage to the NGINX web server directory
    COPY --from=build /app/dist /usr/share/nginx/html

    #copy the nginx configuration file
    COPY nginx.conf /etc/nginx/conf.d/default.conf

    # Expose port 80 for the NGINX server
    EXPOSE 80

    # Set the timezone of the container to match the host machine's timezone
    RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

    # Start NGINX when the container starts
    CMD ["nginx", "-g", "daemon off;"]
    ```

- nginx.conf
    ```bash
        server {
        listen 80 default_server;
        server_name _;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }
       }
    ```

    `NOTE: During development, use .env; in production, the build process will use .env.production (make sure these files are in your build context).`


## Deploying on a Public IP

1. Open SSH and Clone project repo:
    ```bash
    git clone https://github.com/yourusername/yourproject.git
    cd yourproject
    ```
2. Run Docker Compose: 
    ```bash
    docker-compose up -d
    ```
    `Verify: Your frontend app should now be accessible locally on the server (e.g., via http://127.0.0.1:DABBA-PORT)`

3. Verify:
    ```bash
    curl http://127.0.0.1:`DABBA PORT`
    ```

## Common Troubleshooting Steps:
 - Build Failures: Check for errors during `npm install` or `npm run build` in the build stage.

 - Port Conflicts: Ensure that the `port` (8156 in this example) is not in use by another application.

 - Environment Variables: Verify that your `.env` file is correctly configured and available in the Docker build context.

 - File Copy Issues: Confirm that the built files are properly copied to `/usr/share/nginx/html` inside the production image.


---

| Home | Next |
|:-----:|----------|
| [Main Menu](README.md) | [Docker to Domain](Docker-To-Domain-SSL.md) |
