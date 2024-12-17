#!/bin/bash

# Cores
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Função para exibir cabeçalho estilizado
cabeçalho() {
    clear
    echo -e "${MAGENTA}"
    echo "===================================================" | lolcat
    figlet -c "Painel V5" | lolcat
    echo "===================================================" | lolcat
    echo -e "${WHITE}Criado por: ${CYAN}Místico${RESET}" | lolcat
    echo -e "${MAGENTA}===================================================${RESET}\n" | lolcat
}

# Função de carregamento com animação
carregamento() {
    clear
    echo -e "${CYAN}Iniciando sistema...${RESET}" | lolcat
    barra=("[                    ]" "[#####               ]" "[##########          ]" "[###############     ]" "[####################]")
    for b in "${barra[@]}"; do
        echo -ne "${MAGENTA}${b}${RESET}\r"
        sleep 0.5
    done
    echo -e "\n${GREEN}Sistema iniciado com sucesso!${RESET}\n" | lolcat
    sleep 1
}

# Tela de Login estilizada
login() {
    cabeçalho
    echo -e "${YELLOW}Bem-vindo ao Painel de Instalação V5!${RESET}" | lolcat
    echo -e "${WHITE}Por favor, insira suas credenciais:${RESET}\n" | lolcat
    echo -n "Usuário: "
    read usuario
    echo -n "Senha: "
    read -s senha
    echo

    if [[ "$usuario" == "123" && "$senha" == "123" ]]; then
        echo -e "\n${GREEN}Login bem-sucedido!${RESET}\n" | lolcat
        sleep 1
    else
        echo -e "\n${RED}Usuário ou senha incorretos! Tente novamente.${RESET}\n" | lolcat
        sleep 2
        login
    fi
}

# Função para instalar pacotes
instalar_pacotes() {
    cabeçalho
    echo -e "${YELLOW}Atualizando pacotes e instalando dependências...${RESET}\n" | lolcat
    sleep 1
    pkg update -y && pkg upgrade -y
    pkg install ruby -y
    gem install lolcat
    pkg install jq curl wget figlet -y
    echo -e "\n${GREEN}Todos os pacotes foram instalados com sucesso!${RESET}" | lolcat
    sleep 1
}

# Função para testar pacotes
testar_instalacao() {
    cabeçalho
    echo -e "${CYAN}Executando testes dos pacotes instalados...${RESET}\n" | lolcat
    sleep 1
    echo "Teste de Exibição" | lolcat
    figlet "Tudo Funcionando!" | lolcat
    jq --version
    echo -e "\n${GREEN}Testes concluídos com sucesso!${RESET}" | lolcat
    sleep 1
}

# Sistema de rastreamento (IP e CEP)
rastrear() {
    cabeçalho
    echo -e "${YELLOW}Selecione o tipo de rastreamento:${RESET}\n" | lolcat
    echo -e "${GREEN}1.${RESET} Rastreamento de IP"
    echo -e "${GREEN}2.${RESET} Rastreamento de CEP"
    echo -e "${GREEN}3.${RESET} Voltar ao Menu"
    echo -n -e "${CYAN}Escolha uma opção: ${RESET}"
    read opcao_rastrear

    case $opcao_rastrear in
        1)
            echo -n -e "${YELLOW}Digite o IP para rastrear: ${RESET}"
            read ip
            curl -s "http://ip-api.com/json/$ip" | jq
            ;;
        2)
            echo -n -e "${YELLOW}Digite o CEP para rastrear: ${RESET}"
            read cep
            curl -s "https://viacep.com.br/ws/$cep/json/" | jq
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}Opção inválida. Tente novamente.${RESET}" | lolcat
            ;;
    esac
    echo -e "${CYAN}Pressione Enter para voltar ao menu...${RESET}"
    read
}

# Menu Principal estilizado
menu() {
    cabeçalho
    echo -e "${MAGENTA}==================== MENU PRINCIPAL ====================${RESET}" | lolcat
    echo -e "${GREEN}1.${RESET} Instalar Pacotes"
    echo -e "${GREEN}2.${RESET} Testar Instalação"
    echo -e "${GREEN}3.${RESET} Rastreamento (IP/CEP)"
    echo -e "${GREEN}4.${RESET} Sair"
    echo -e "${MAGENTA}========================================================${RESET}\n" | lolcat
    echo -n -e "${YELLOW}Escolha uma opção: ${RESET}"
    read opcao

    case $opcao in
        1)
            instalar_pacotes
            ;;
        2)
            testar_instalacao
            ;;
        3)
            rastrear
            ;;
        4)
            echo -e "${GREEN}Saindo...${RESET}" | lolcat
            sleep 1
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida. Tente novamente.${RESET}" | lolcat
            sleep 1
            ;;
    esac
}

# Exibir créditos ao final
creditos() {
    echo -e "\n${MAGENTA}===================================================${RESET}" | lolcat
    echo -e "${WHITE}Painel V5 desenvolvido por: ${CYAN}Místico${RESET}" | lolcat
    echo -e "${MAGENTA}===================================================${RESET}\n" | lolcat
}

# Iniciar o sistema
login
while true; do
    menu
    creditos
    echo -n -e "${CYAN}Pressione Enter para continuar...${RESET}"
    read
done
