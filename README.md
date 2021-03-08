# Contract Magagement

API para cadastro de pessoas físicas, pessoas jurídicas e contratos

## Versões

O projeto foi criado com as seguintes versões de Elixir e Erlang:

- erlang: 22.2.1
- elixir: 1.10.4

## Instalação

- Siga as instruções para de acordo com seu sistema operacional: [elixir-lang.org](https://elixir-lang.org/install.html)

- Caso esteja utilizando o `asdf`como gerenciador de versões do `elixir` e `erlang` apenas execute o comando abaixo:

```sh
asdf install
```

- Crie o arquivo de configurações do ambiente de desenvolvimento, na pasta `/config`, execute o segunte comando:

```sh
cp dev.exs.example dev.exs 
```

- Ajuste as configurações do seu banco local no arquivo `dev.exs`

- Baixe as dependências com o comando:

```sh
mix deps.get
```

## Execução

Para execução do projeto, execute o comando:

```sh
mix phx.server
```

## Testes

Para execução dos testes do projeto, execute o comando:

```sh
mix test
```

## Documentação

A documentação da API se encontra no seguinte link do Postman:
[https://documenter.getpostman.com/view/3927601/Tz5m6yY4](https://documenter.getpostman.com/view/3927601/Tz5m6yY4)
