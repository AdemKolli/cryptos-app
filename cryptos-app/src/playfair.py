import sys
import re

def preprocess_text(text):
    return re.sub(r'[^A-Z]', '', text.upper().replace('W', 'V'))

def prepare_key(key):
    key = key.upper().replace('W', 'V')
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

    if 'V' in plaintext:
        suggested_plaintext = plaintext.replace('V', 'W')
        print(f"Note: The decrypted text contains the letter 'V'. Maybe you meant: '{suggested_plaintext}'")
    return plaintext

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python PlayFair2.py encode|decode <input> <key>")
        sys.exit(1)

    operation = sys.argv[1]
    input_text = sys.argv[2]
    key = sys.argv[3]

    try:
        if operation == "encode":
            print(playfair_encrypt(input_text, key))
        elif operation == "decode":
            print(playfair_decrypt(input_text, key))
        else:
            print("Invalid operation. Use 'encrypt' or 'decrypt'.")
    except Exception as e:
        print(f"Error: {e}")
