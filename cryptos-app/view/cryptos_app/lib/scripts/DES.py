import binascii
import sys

IP = [57, 49, 41, 33, 25, 17, 9, 1, 59, 51, 43, 35, 27, 19, 11, 3,
      61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7,
      56, 48, 40, 32, 24, 16, 8, 0, 58, 50, 42, 34, 26, 18, 10, 2,
      60, 52, 44, 36, 28, 20, 12, 4, 62, 54, 46, 38, 30, 22, 14, 6]

IP_INV = [39, 7, 47, 15, 55, 23, 63, 31, 38, 6, 46, 14, 54, 22, 62, 30,
          37, 5, 45, 13, 53, 21, 61, 29, 36, 4, 44, 12, 52, 20, 60, 28,
          35, 3, 43, 11, 51, 19, 59, 27, 34, 2, 42, 10, 50, 18, 58, 26,
          33, 1, 41, 9, 49, 17, 57, 25, 32, 0, 40, 8, 48, 16, 56, 24]

E = [31, 0, 1, 2, 3, 4, 3, 4, 5, 6, 7, 8, 7, 8, 9, 10,
     11, 12, 11, 12, 13, 14, 15, 16, 15, 16, 17, 18, 19, 20, 19, 20,
     21, 22, 23, 24, 23, 24, 25, 26, 27, 28, 27, 28, 29, 30, 31, 0]

P = [15, 6, 19, 20, 28, 11, 27, 16, 0, 14, 22, 25, 4, 17, 30, 9,
     1, 7, 23, 13, 31, 26, 2, 8, 18, 12, 29, 5, 21, 10, 3, 24]

S_BOX = [
    [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
    [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8]
]

def permute(block, table):
    return [block[x] for x in table]

def xor(bits1, bits2):
    return [b1 ^ b2 for b1, b2 in zip(bits1, bits2)]

def f_function(R, K):
    expanded = permute(R, E)
    xored = xor(expanded, K)
    S_output = [S_BOX[i % 2][x % 16] for i, x in enumerate(xored)]
    return permute(S_output, P)

def des_encrypt(plain_text, key_str):
    key = [int(k) for k in key_str]
    block = list(map(int, format(int(binascii.hexlify(plain_text.encode()), 16), '064b')))
    permuted_block = permute(block, IP)
    L, R = permuted_block[:32], permuted_block[32:]
    for _ in range(16):
        newR = xor(L, f_function(R, key))
        L, R = R, newR
    cipher_block = permute(L + R, IP_INV)
    return ''.join(map(str, cipher_block))

def des_decrypt(cipher_text, key_str):
    key = [int(k) for k in key_str]
    block = list(map(int, cipher_text))
    permuted_block = permute(block, IP)
    L, R = permuted_block[:32], permuted_block[32:]
    for _ in range(16):
        newL = xor(R, f_function(L, key))
        R, L = L, newL
    plain_block = permute(L + R, IP_INV)
    hex_text = format(int(''.join(map(str, plain_block)), 2), 'x')
    # Corriger les erreurs liées à un padding impair
    if len(hex_text) % 2 != 0:
        hex_text = "0" + hex_text
    return binascii.unhexlify(hex_text).decode(errors='ignore')

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python des.py [encode|decode] [text] [key]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]
    key = sys.argv[3]

    if not all(c in '01' for c in key) or len(key) != 48:
        print("Key must be a 48-bit binary string", file=sys.stderr)
        sys.exit(1)

    try:
        if operation == "encode":
            print(des_encrypt(text, key))
        elif operation == "decode":
            print(des_decrypt(text, key))
        else:
            print("Invalid operation. Use 'encode' or 'decode'.", file=sys.stderr)
            sys.exit(1)
    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)
