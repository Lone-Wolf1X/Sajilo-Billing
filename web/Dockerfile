# Stage 1: Build Flutter Web application
FROM ghcr.io/cirruslabs/flutter:3.19.6 AS build-env

WORKDIR /app
COPY . .

# Fetch dependencies & build web with CanvasKit renderer
RUN flutter pub get
ARG GOOGLE_CLIENT_ID_WEB
ARG SYNC_BASE_URL
RUN flutter build web --release --web-renderer canvaskit \
    --dart-define=GOOGLE_CLIENT_ID_WEB=${GOOGLE_CLIENT_ID_WEB} \
    --dart-define=SYNC_BASE_URL=${SYNC_BASE_URL}

# Stage 2: Serve with lightweight Nginx
FROM nginx:alpine

COPY web/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
