## Run this app
- chmod +x start.sh && ./start.sh
- chmod +x stop.sh && ./stop.sh

# E-commerce Microservice app

### Typescript applicaiotn initialize package

```
npm i -D typescript tsc ts-node-dev tsc-alias tsconfig-paths
npm i -D @types/express @types/node @types/cors
```

### Databases

```
1: practical-ms-db
2
```

### Docker internel connection with db

- docker-compose up -d
- host: host.docker.internal
- npx prisma init --datasource-provider postgresql

