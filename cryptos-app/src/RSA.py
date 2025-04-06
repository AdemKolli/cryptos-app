import random
from math import gcd

# Tab de nombres premiers
primes = [101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199]

def generate_keys():
    # Choisir deux nombres premiers distincts p et q dans le tableau
    p = random.choice(primes)
    q = random.choice([prime for prime in primes if prime != p])
    
    print(f"Valeurs utilisées pour p et q : p = {p}, q = {q}")
    
    n = p * q
    

    phi = (p - 1) * (q - 1)
    
    # Choisir un entier e tel que 1 < e < phi(n) et gcd(e, phi(n)) = 1
    e = random.choice([i for i in range(2, phi) if gcd(i, phi) == 1])
    
    # Calculer d, l'inverse modulaire de e modulo phi(n)
    d = pow(e, -1, phi)
    
    # Retourner la clé publique (e, n) et la clé privée (d, n)
    return (e, n), (d, n)

def encrypt(message, public_key):
    e, n = public_key
    # Chiffrer le message en utilisant la clé publique
    cipher_text = [pow(ord(char), e, n) for char in message]
    return cipher_text

def decrypt(cipher_text, private_key):
    d, n = private_key
    # Déchiffrer le message en utilisant la clé privée
    message = ''.join([chr(pow(char, d, n)) for char in cipher_text])
    return message



if __name__ == "__main__":
    # Générer les clés
    public_key, private_key = generate_keys()
    print(f"Clé publique (e, n): {public_key}")
    print(f"Clé privée (d, n): {private_key}")
    

    message = input("Entrez un message à chiffrer : ")
    print(f"Message original: {message}")
    

    cipher_text = encrypt(message, public_key)
    print(f"Message chiffré: {cipher_text}")
    

    decrypted_message = decrypt(cipher_text, private_key)
    print(f"Message déchiffré: {decrypted_message}")