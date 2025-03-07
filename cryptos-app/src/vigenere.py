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


