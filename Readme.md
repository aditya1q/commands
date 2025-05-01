🔁 Create Docker setup files in the root of your project:

Dockerfile
nginx.conf
docker-compose.yml

🔁 Initialize Git and commit your project:

git init
git add .
git commit -m "Initial commit"
git remote add origin <your-repo-url>
git push -u origin main

🌐 Deploy to Remote Server
SSH into the remote server:

ssh user@your-server-ip
Clone your project repository:

git clone <your-repo-url>
cd <your-project-folder>

🔁 Build and run your Docker containers:
docker compose up -d --build

🔁 Verify containers are running:
docker ps         # Only running containers
docker ps -a      # All containers including stopped ones

🔁 Update When New Commits Are Made
Stop running containers:
docker compose down

🔁 Pull the latest changes from Git:
git pull

🔁 Rebuild and start containers:
docker compose up -d --build
