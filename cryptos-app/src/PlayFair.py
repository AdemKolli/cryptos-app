import argparse
import json
import re

def preprocess_text(text):
    return re.sub(r'[^A-Z]', '', text.upper())

def prepare_key(key):
    key = key.upper()
    unique_key = ""
    for char in key:
        if char not in unique_key:
            unique_key += char
    return unique_key

def create_matrix(key):
    key = prepare_key(key)
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVXYZ"
    matrix = []
    
    for char in key:
        if char not in matrix and char.isalpha() and char != "W":
            matrix.append(char)
    
    for char in alphabet:
        if char not in matrix:
            matrix.append(char)
    
    return [matrix[i:i+5] for i in range(0, 25, 5)]

def find_char_position(matrix, char):
    for row in range(5):
        for col in range(5):
            if matrix[row][col] == char:
                return row, col
    return None

def playfair_encrypt(plaintext, key):
    matrix = create_matrix(key)
    plaintext = plaintext.upper().replace(" ", "")
    plaintext = preprocess_text(plaintext)
    processed_text = []
    i = 0
    
    while i < len(plaintext):
        if i == len(plaintext) - 1:
            processed_text.append(plaintext[i] + "X")
            break
        
        if plaintext[i] == plaintext[i + 1]:
            processed_text.append(plaintext[i] + "X")
            i += 1
        else:
            processed_text.append(plaintext[i:i+2])
            i += 2
    
    ciphertext = ""
    for pair in processed_text:
        row1, col1 = find_char_position(matrix, pair[0])
        row2, col2 = find_char_position(matrix, pair[1])
        
        if row1 == row2:
            ciphertext += matrix[row1][(col1 + 1) % 5] + matrix[row2][(col2 + 1) % 5]
        elif col1 == col2:
            ciphertext += matrix[(row1 + 1) % 5][col1] + matrix[(row2 + 1) % 5][col2]
        else:
            ciphertext += matrix[row1][col2] + matrix[row2][col1]
    
    return ciphertext

def playfair_decrypt(ciphertext, key):
    matrix = create_matrix(key)
    ciphertext = ciphertext.upper().replace(" ", "")
    ciphertext = preprocess_text(ciphertext)
    plaintext = ""
    
    for i in range(0, len(ciphertext), 2):
        row1, col1 = find_char_position(matrix, ciphertext[i])
        row2, col2 = find_char_position(matrix, ciphertext[i+1])
        
        if row1 == row2:
            plaintext += matrix[row1][(col1 - 1) % 5] + matrix[row2][(col2 - 1) % 5]
        elif col1 == col2:
            plaintext += matrix[(row1 - 1) % 5][col1] + matrix[(row2 - 1) % 5][col2]
        else:
            plaintext += matrix[row1][col2] + matrix[row2][col1]
    
    return plaintext

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--operation", type=str, required=True, choices=["encrypt", "decrypt"], help="Choose the operation: encrypt or decrypt")
    parser.add_argument("--input", type=str, required=True, help="Input text")
    parser.add_argument("--key", type=str, required=True, help="Encryption key")
    
    args = parser.parse_args()
    
    try:
        if args.operation == "encrypt":
            result = playfair_encrypt(args.input, args.key)
        else:
            result = playfair_decrypt(args.input, args.key)
        
        print(json.dumps({"status": "success", "result": result}))
    except Exception as e:
        print(json.dumps({"status": "error", "message": str(e)}))
