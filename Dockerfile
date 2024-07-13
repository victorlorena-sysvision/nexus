# Use uma imagem base do OpenJDK
FROM openjdk:11-jre-slim

# Defina o diretório de trabalho
WORKDIR /app

# Copie o arquivo JAR para o contêiner
COPY nexus-init-8.0.1.jar /app/nexus-init.jar

# Copie o arquivo de propriedades para o contêiner
COPY nexus.properties /app/nexus.properties

# Exponha a porta 8081
EXPOSE 8081

# Comando para iniciar a aplicação e depois executar o nexus.properties
CMD ["sh", "-c", "java -jar nexus-init.jar && java -jar nexus.properties"]
