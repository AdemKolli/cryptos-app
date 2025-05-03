import random
from math import gcd
import sys

import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

primes = [101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199]

def generate_keys():
    p = random.choice(primes)
    q = random.choice([prime for prime in primes if prime != p])
    n = p * q
    phi = (p - 1) * (q - 1)
    e = random.choice([i for i in range(2, phi) if gcd(i, phi) == 1])
    d = pow(e, -1, phi)
    return (e, n), (d, n)

def encrypt(message, public_key):
    e, n = public_key
    cipher_text = [pow(ord(char), e, n) for char in message]
    return cipher_text

def decrypt(cipher_text, private_key):
    d, n = private_key
    try:
        message = ''.join([chr(pow(int(char), d, n)) for char in cipher_text])
    except:
        print("Error: Invalid ciphertext or key.", file=sys.stderr)
        sys.exit(1)
    return message

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python rsa.py [encode|decode] [text] [key (for decode)]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]

    if operation == "encode":
        public_key, private_key = generate_keys()
        cipher = encrypt(text, public_key)
        cipher_str = ' '.join(map(str, cipher))
        pub_key_str = f"{public_key[0]},{public_key[1]}"
        priv_key_str = f"{private_key[0]},{private_key[1]}"
        print(cipher_str)
        print(f"PUBLIC_KEY={pub_key_str}")
        print(f"PRIVATE_KEY={priv_key_str}")

    elif operation == "decode":
        if len(sys.argv) != 4:
            print("Usage: python rsa.py decode [ciphertext] [private_key]", file=sys.stderr)
            sys.exit(1)

        key_parts = sys.argv[3].split(',')
        if len(key_parts) != 2:
            print("Invalid key format. Expected d,n", file=sys.stderr)
            sys.exit(1)

        d, n = map(int, key_parts)
        cipher = list(map(int, text.strip().split()))
        message = decrypt(cipher, (d, n))
        print(message)

    else:
        print("Invalid operation. Use 'encode' or 'decode'.", file=sys.stderr)
        sys.exit(1)
