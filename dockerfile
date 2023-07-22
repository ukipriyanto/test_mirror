FROM node:19-alpine

RUN apk update && apk upgrade --no-cache && apk add libcrypto3 libssl3 curl


ENV PORT 8080
ENV HOST 0.0.0.0

RUN npm i -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

# COPY .env ./.env
COPY prisma ./prisma

# COPY tsconfig.json file
COPY tsconfig.json ./

RUN pnpm prisma generate
RUN pnpm prisma:dw:generate
# RUN pnpm prisma migrate deploy
# RUN pnpm prisma db seed

COPY . ./

RUN pnpm build

RUN ["chmod", "+x", "./entrypoint.sh"]
ENTRYPOINT ["/app/entrypoint.sh"]

CMD [ "node", "dist/main" ]
