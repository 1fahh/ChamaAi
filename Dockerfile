# ---------- Etapa 1: compila o app Flutter para web ----------
FROM ghcr.io/cirruslabs/flutter:3.44.0 AS build

WORKDIR /app
COPY pubspec.yaml ./
RUN flutter pub get

COPY . .
# --no-web-resources-cdn: o app não depende de baixar arquivos do Google ao abrir
RUN flutter build web --release --no-web-resources-cdn

# ---------- Etapa 2: serve os arquivos com nginx ----------
FROM nginx:1.27-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
