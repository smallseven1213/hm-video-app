# Builder stage
FROM cirrusci/flutter:3.7.5 AS builder
ARG env
ENV ENV=${env}
WORKDIR /app
COPY . /app

# Install Melos
RUN flutter pub global activate melos

# Set PATH for melos executable
ENV PATH="/root/.pub-cache/bin:$PATH"

# Run Melos bootstrap
RUN melos bootstrap

# Build web app using Melos with a specific scope
# RUN DATE_VERSION=$(date +"%Y_%m_%d_%H_%M") && \
#     melos exec --scope="app_gp" -- \
#     flutter build web --web-renderer html --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env}

# # Production stage
# FROM nginx:stable-alpine
# RUN apk add bash && \
#     ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
#     echo Asia/Taipei > /etc/timezone
# COPY --from=builder /app/packages/app_gp/build/web /usr/share/nginx/html
# ENTRYPOINT nginx -g "daemon off;"
