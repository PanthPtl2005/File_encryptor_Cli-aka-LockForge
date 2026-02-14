#!/bin/bash

echo "=============================="
figlet Lock Forge
echo "=============================="

echo "1. Encrypt File"
echo "2. Decrypt File"
read -p "Choose option: " choice

encrypt_file() {
    read -p "Enter file path to encrypt: " file
    
    if [ ! -f "$file" ]; then
        echo "File not found."
        exit 1
    fi

    read -s -p "Enter password: " password
    echo
    read -s -p "Confirm password: " password2
    echo

    if [ "$password" != "$password2" ]; then
        echo "Passwords do not match."
        exit 1
    fi

    output="$file.enc"

    openssl enc -aes-256-gcm -salt -pbkdf2 \
    -in "$file" -out "$output" -pass pass:"$password"

    echo "Encrypted file saved as $output"
}

decrypt_file() {
    read -p "Enter file path to decrypt: " file

    if [ ! -f "$file" ]; then
        echo "File not found."
        exit 1
    fi

    read -s -p "Enter password: " password
    echo

    output="${file%.enc}"

    openssl enc -d -aes-256-gcm -pbkdf2 \
    -in "$file" -out "$output" -pass pass:"$password"

    if [ $? -eq 0 ]; then
        echo "Decrypted file saved as $output"
    else
        echo "Wrong password or corrupted file."
    fi
}

if [ "$choice" -eq 1 ]; then
    encrypt_file
elif [ "$choice" -eq 2 ]; then
    decrypt_file
else
    echo "Invalid option"
fi
