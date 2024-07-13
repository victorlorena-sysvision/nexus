Claro! Aqui está um exemplo de um arquivo `README.md` para o seu projeto:

```markdown
# Projeto Nexus Init

Este projeto contém uma aplicação Java que utiliza o arquivo `nexus-init-8.0.1.jar` e configurações especificadas em `nexus.properties`. A aplicação é construída e implantada automaticamente usando GitHub Actions e Docker.

## Estrutura do Projeto

- `nexus-init-8.0.1.jar`: Arquivo JAR principal da aplicação.
- `nexus.properties`: Arquivo de propriedades para configuração da aplicação.
- `Dockerfile`: Define como a aplicação será containerizada.
- `.github/workflows/ci-cd.yml`: Workflow do GitHub Actions para CI/CD.

## Requisitos

- Docker
- Conta no DockerHub
- Servidor para deployment com SSH configurado

## Configuração do Ambiente

### 1. Docker

Instale o Docker seguindo as instruções oficiais: [Docker Install](https://docs.docker.com/get-docker/)

### 2. GitHub Secrets

Configure os seguintes segredos no repositório do GitHub:

- `DOCKER_USERNAME`: Seu nome de usuário do DockerHub.
- `DOCKER_PASSWORD`: Sua senha do DockerHub.
- `SSH_PRIVATE_KEY`: A chave SSH privada para acessar o servidor de deployment.
- `SSH_USER`: O nome de usuário SSH para acessar o servidor de deployment.
- `SSH_HOST`: O endereço do host SSH para acessar o servidor de deployment.

## Build e Deploy

### 1. Docker Build

Para construir a imagem Docker localmente:

```sh
docker build -t my-java-app .
```

### 2. Docker Run

Para executar a imagem Docker:

```sh
docker run -d --name my-java-app-container -p 8080:8080 my-java-app
```

### 3. GitHub Actions

O workflow do GitHub Actions é acionado em cada push para a branch `main`. Ele executa os seguintes passos:

1. Checkout do código.
2. Configuração do JDK 11.
3. Build do projeto com Maven.
4. Build da imagem Docker.
5. Login no DockerHub.
6. Push da imagem Docker para o DockerHub.
7. Deploy da imagem Docker no servidor de produção.

## Dockerfile

O `Dockerfile` está configurado da seguinte maneira:

```dockerfile
# Use uma imagem base do OpenJDK
FROM openjdk:11-jre-slim

# Defina o diretório de trabalho
WORKDIR /app

# Copie o arquivo JAR para o contêiner
COPY nexus-init-8.0.1.jar /app/nexus-init.jar

# Copie o arquivo de propriedades para o contêiner
COPY nexus.properties /app/nexus.properties

# Comando para iniciar a aplicação e depois executar o nexus.properties
CMD ["sh", "-c", "java -jar nexus-init.jar && java -jar nexus.properties"]
```

## GitHub Actions Workflow

O arquivo de workflow do GitHub Actions (`.github/workflows/ci-cd.yml`) está configurado da seguinte maneira:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        java-version: '11'
        distribution: 'adopt'
    
    - name: Build with Maven
      run: mvn clean install

    - name: Build Docker image
      run: docker build -t my-java-app .

    - name: Login to DockerHub
      env:
        DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      run: echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

    - name: Push Docker image
      run: docker push my-java-app

    - name: Deploy to Server
      env:
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
        SSH_USER: ${{ secrets.SSH_USER }}
        SSH_HOST: ${{ secrets.SSH_HOST }}
      run: |
        echo "$SSH_PRIVATE_KEY" | ssh-add -
        ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST << 'EOF'
          docker pull my-java-app
          docker stop my-java-app-container || true
          docker rm my-java-app-container || true
          docker run -d --name my-java-app-container -p 8080:8080 my-java-app
        EOF
```

## Contribuição

1. Faça um fork do repositório.
2. Crie uma nova branch (`git checkout -b feature/nova-feature`).
3. Faça commit das suas mudanças (`git commit -m 'Adiciona nova feature'`).
4. Faça push para a branch (`git push origin feature/nova-feature`).
5. Abra um Pull Request.

## Licença

Este projeto está licenciado sob os termos da licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
```

Este arquivo `README.md` fornece uma visão geral clara do projeto, incluindo a estrutura do projeto, requisitos, configuração do ambiente, instruções de build e deploy, e detalhes sobre contribuição e licença.