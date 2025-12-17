# Workflow for Deploying Project to Live Domain with SSL

This guide explains how to deploy a web application (a Vite/React frontend and a backend API) from local development to production using GitHub, Docker, Cloudflare, and Let's Encrypt SSL certificates. It includes step-by-step instructions, commands, and troubleshooting tips for common issues encountered along the way.


## Table of Contents

| S.NO | Section                                                                  | Description                                                       |
|------|--------------------------------------------------------------------------|-------------------------------------------------------------------|
| 1    | [Prerequisites](#prerequisites)                                          | Tools, accounts, and server prerequisites                         |
| 2    | [Local Development Setup](#local-development-setup)                      | Setting up your local environment                                 |
| 3    | [Configuring Cloudflare DNS](#configuring-cloudflare-dns)                  | Setting up Cloudflare DNS records                                 |
| 4    | [Setting Up Nginx Reverse Proxy](#setting-up-nginx-reverse-proxy) | Configuring Nginx as your reverse proxy                           |
| 5    | [Generate SSL Certificates](#generate-ssl-certificates) | Using Certbot and Let's Encrypt for SSL                           |
| 6    | [Common Issues and Troubleshooting](#common-issues-and-troubleshooting)    | Tips for troubleshooting common deployment issues                 |


## Prerequisites

1. **Application Must Be Dockerized**    
   - **Verification:** Run the foll command to see running containers:
     ```bash
     docker ps
     ```
     - It should be running on local host on docker
     ```bash
     curl http://127.0.0.1:`DABBA PORT`
     ```

2. **NGINX Installed on Remote Server**    
   - **Verification:** Check the version and test the configuration:
     ```bash
     nginx -v
     sudo nginx -t
     ```

3. **Certbot Installed on the Server**  
   - **Verification:** Check Certbot's version and list your certificates:
     ```bash
     sudo certbot --version
     ```


## Local Development Setup

 **Configure Environment Files:**
   For .env 
   ```bash
   VITE_CLIENT_AUTH_API_URL=http://localhost:7135 ## enter backend endpoint (e.g; 124.12.135.128:7135)
   ```

   Create .env.production 
   ```bash
   VITE_CLIENT_AUTH_API_URL=http://'SUB-DOMAIN-NAME'.quanttiphy.com/api ## SUB-DOMAIN your CloudFlare DNS Name (e.g; 'client' in client.quanttiphy.com)
   ```


## Configuring Cloudflare DNS

1. Request access from TL
2. Create DNS Records:
    - Go to dns records 
    - Add a record for `SUB-DOMAIN` (e.g; client in client.quanttiphy.com)
    - TYPE: `A` NAME: `SUB-DOMAIN` IP: `YOUR DABBA IP` PROXY MODE: `DNS ONLY`


## Setting Up Nginx Reverse Proxy

1. Open nginx in SSH:
    ```bash
    code /etc/nginx
    ```
2. Create a Custome file for serving:
     - Go to `/etc/nginx/sites_available/quanttiphy.com`

3. Configure the file: 
   - Copy below code and make changes with `DABBA PORT` and `proxy_pass` under `location /api`
    ```bash
        server {
        listen 80;
        server_name `SUB-DOMAIN`.quanttiphy.com www.`SUB-DOMAIN`.quanttiphy.com;
        # Redirect HTTP to HTTPS
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        listen [::]:443 ssl;
        server_name `SUB-DOMAIN`.quanttiphy.com www.`SUB-DOMAIN`.quanttiphy.com;
        
        location / {
            proxy_pass http://127.0.0.1:8156/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        ## if endpoint does not contain /api then use /api/ below
        location /api {
            ## enter backend endpoint
            proxy_pass http://127.0.0.1:7135/api; 
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
    ```

4. Symlinked Your above file:
    ```bash
    sudo ln -s /etc/nginx/sites_available/quanttiphy.com /etc/nginx/sites_enabled/quanttiphy.com
    ```
    
    `This will enable nginx to serve your project/files over domain`



## Generate SSL Certificates:

1. Request Certificate:
    ```bash
    sudo certbot --nginx -d `SUB-DOMAIN`.quanttiphy.com -d www.`SUB-DOMAIN`.quanttiphy.com
    ```
    `It will then ask for some info email enter them.`
    `If any error occures consider the prequisites above.`

2. Verify Certificate Created: 
    - List Certificates Issued by Certbort
    ```bash
    sudo certbot certificates
    ```
    `This command lists all the certificates managed by Certbot, along with their paths and expiration dates.`

3. Make Changes into `etc/nginx/sites_available/quanttiphy.com`:
    - Open the file and paste below code inside server

    ```bash
    server {
        ## Make changes into that server which starts with
        ## listen 443 ssl;

        ssl_certificate /etc/letsencrypt/live/`SUB-DOMAIN`.quanttiphy.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/`SUB-DOMAIN`.quanttiphy.com/privkey.pem;
        
    }
    ```

4. Test & Reload NGINX
    ```bash
    sudo nginx -t
    sudo systemctl reload nginx
    ```



## Common Issues and Troubleshooting

### Mixed Content Errors
    
- Issue: Frontend loaded over HTTPS calls Backend API over HTTP (e.g., hard-coded http://164.52.195.138:PORT or http://127.0.0.1:PORT).

- Solution: Change ENPOINT in your `.env.production` or `.env` if you have only .env. API_URL=`https://`SUB-DOMAIN`.quanttiphy.com/api`

### 403 Forbidden Erros

- Solution: Remove the default file configuration from `/etc/nginx/sites_enabled` Run below cmd:
    ```bash
    sudo rm /etc/nginx/sites_enabled/default
    ```

### Duplicate Server Name Warnings

- Solution: Keep your custom configuration in `/etc/nginx/ sites_available/` and disable the default configuration in `/etc/nginx/sites_enabled/`.

---

| Home | Next |
|:-----:|----------|
| [Main Menu](README.md) | [Soon Coming](Docker-To-Domain-SSL.md) | 
