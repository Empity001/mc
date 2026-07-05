FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

COPY . /app
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
