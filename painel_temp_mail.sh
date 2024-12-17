#!/bin/bash

# Limpa a tela
clear

# Função para exibir o banner
banner() {
    figlet "Temp Mail Panel" | lolcat
    echo "Painel de Gerenciamento de E-mails Temporários" | lolcat
    echo "=================================================" | lolcat
    echo "Criado por: Místico" | lolcat
    echo "=================================================" | lolcat
}

# Função para criar um e-mail temporário
criar_email() {
    echo "[*] Criando um e-mail temporário..." | lolcat
    response=$(curl -s "https://www.1secmail.com/api/v1/?action=genRandomMailbox&count=1")
    email=$(echo "$response" | jq -r '.[0]')
    echo "E-mail temporário criado: $email" | lolcat
    echo "$email" > email_temp.txt
}

# Função para verificar mensagens recebidas
verificar_mensagens() {
    if [ ! -f email_temp.txt ]; then
        echo "[!] Nenhum e-mail foi criado ainda. Crie um primeiro!" | lolcat
        return
    fi

    email=$(cat email_temp.txt)
    username=$(echo "$email" | cut -d '@' -f 1)
    domain=$(echo "$email" | cut -d '@' -f 2)

    echo "[*] Verificando mensagens para $email..." | lolcat
    response=$(curl -s "https://www.1secmail.com/api/v1/?action=getMessages&login=$username&domain=$domain")

    messages=$(echo "$response" | jq -r '. | length')
    if [ "$messages" -eq 0 ]; then
        echo "Nenhuma mensagem encontrada para $email." | lolcat
    else
        echo "[$messages] Mensagens encontradas para $email:" | lolcat
        echo "$response" | jq -r '.[] | "\nDe: \(.from)\nAssunto: \(.subject)\nID da Mensagem: \(.id)"' | lolcat
    fi
}

# Função para ler o conteúdo de uma mensagem
ler_mensagem() {
    if [ ! -f email_temp.txt ]; then
        echo "[!] Nenhum e-mail foi criado ainda. Crie um primeiro!" | lolcat
        return
    fi

    email=$(cat email_temp.txt)
    username=$(echo "$email" | cut -d '@' -f 1)
    domain=$(echo "$email" | cut -d '@' -f 2)

    echo -n "Digite o ID da mensagem que deseja ler: " | lolcat
    read msg_id

    echo "[*] Buscando conteúdo da mensagem ID $msg_id..." | lolcat
    response=$(curl -s "https://www.1secmail.com/api/v1/?action=readMessage&login=$username&domain=$domain&id=$msg_id")

    if [[ "$response" == "null" ]]; then
        echo "[!] Mensagem não encontrada ou ID inválido." | lolcat
    else
        echo "Conteúdo da mensagem:" | lolcat
        echo "----------------------------------------" | lolcat
        echo "De: $(echo "$response" | jq -r '.from')" | lolcat
        echo "Assunto: $(echo "$response" | jq -r '.subject')" | lolcat
        echo "Data: $(echo "$response" | jq -r '.date')" | lolcat
        echo "Mensagem:" | lolcat
        echo "$(echo "$response" | jq -r '.textBody')" | lolcat
        echo "----------------------------------------" | lolcat
    fi
}

# Função para exibir informações do criador
sobre_criador() {
    clear
    echo "=================================================" | lolcat
    figlet "Sobre o Criador" | lolcat
    echo "=================================================" | lolcat
    echo "Este painel foi desenvolvido por Místico." | lolcat
    echo "Contato: misticovurus@gmail.com" | lolcat
    echo "GitHub: https://github.com/Investigador-Mistico?tab=repositories" | lolcat
    echo "=================================================" | lolcat
    echo -n "Pressione Enter para voltar ao menu..." | lolcat
    read
    clear
}

# Menu principal
menu() {
    while true; do
        banner
        echo "1. Criar e-mail temporário" | lolcat
        echo "2. Verificar mensagens recebidas" | lolcat
        echo "3. Ler conteúdo de uma mensagem" | lolcat
        echo "4. Sobre o Criador" | lolcat
        echo "5. Sair" | lolcat
        echo -n "Escolha uma opção: " | lolcat
        read opcao

        case $opcao in
            1) criar_email ;;
            2) verificar_mensagens ;;
            3) ler_mensagem ;;
            4) sobre_criador ;;
            5) echo "Saindo..."; exit 0 ;;
            *) echo "[!] Opção inválida!" | lolcat ;;
        esac

        echo -n "Pressione Enter para continuar..." | lolcat
        read
        clear
    done
}

# Inicia o menu
menu
