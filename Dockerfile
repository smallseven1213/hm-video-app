FROM cirrusci/flutter:2.10.3 AS builder
ARG env
ENV ENV=${env}
WORKDIR /app
COPY . /app
RUN DATE_VERSION=$(date +"%Y_%m_%d_%H_%M") && \
    flutter build web --web-renderer html --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env}
    

FROM nginx:stable-alpine
RUN apk add bash && \
    ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo Asia/Taipei > /etc/timezone
COPY --from=builder /app/build/web /usr/share/nginx/html
ENTRYPOINT nginx -g "daemon off;"
