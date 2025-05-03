import sys

def vigenere_encrypt(plain_text, key):
    encrypted_text = ""
    key_index = 0
    key = key.upper()

    for char in plain_text:
        if char.isalpha():
            shift = ord(key[key_index]) - ord('A')
            if char.isupper():
                encrypted_text += chr((ord(char) - ord('A') + shift) % 26 + ord('A'))
            else:
                encrypted_text += chr((ord(char) - ord('a') + shift) % 26 + ord('a'))

            key_index = (key_index + 1) % len(key)
        else:
            encrypted_text += char

    return encrypted_text

def vigenere_decrypt(encrypted_text, key):
    decrypted_text = ""
    key_index = 0
    key = key.upper()

    for char in encrypted_text:
        if char.isalpha():
            shift = ord(key[key_index]) - ord('A')
            if char.isupper():
                decrypted_text += chr((ord(char) - ord('A') - shift) % 26 + ord('A'))
            else:
                decrypted_text += chr((ord(char) - ord('a') - shift) % 26 + ord('a'))

            key_index = (key_index + 1) % len(key)
        else:
            decrypted_text += char

    return decrypted_text

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python vigenere.py [encode|decode] [text] [key]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]
    key = sys.argv[3]

    if operation == "encode":
        print(vigenere_encrypt(text, key))
    elif operation == "decode":
        print(vigenere_decrypt(text, key))
    else:
        print("Invalid operation. Use 'encode' or 'decode'.", file=sys.stderr)
        sys.exit(1)
