# WARDEN API
I made this as a project so i can finnally access the data on a website, PLS WARDEN USE IT

# How to setup:
## Install depencies
```
npm install
```
## Change .env with your database
```
DATABASE_URL="YOUR_URL"
```
## Migrate Prisma Database
```
npx prisma generate
npx prisma migrate dev --name init
```
OR
```
npx prisma migrate dev --name init
```
## Start server
```
node server.js
```
## Access server
http://localhost:3000 (replace 3000 with your port, it is 3000 by default!)
## Optional
Change server Port at the bottom of `server.js`.

# API ACCESS
badservers are accessible at http://yourdomain:yourport/server?server_id=<your_server_id>
users are accessible at http://yourdomain:yourport/user?user_id=<your_user_id>
