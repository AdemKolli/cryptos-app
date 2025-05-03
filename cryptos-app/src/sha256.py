import math
import argparse
import json
import sys

# step1: string to binary: each letter becomes 8 bits
#        ord: gives the ascii value of a character
#        format: converts the ascii value to binary
#        join: joins the binary values of each character
def string_to_binary_list(s):
    binary_str = ''.join(format(ord(char), '08b') for char in s)  
    return [binary_str[i:i+32] for i in range(0, len(binary_str), 32)]  

# step2: define what length we're going to use: multiple of 512 depending on the length of the input
def multipleof512(lst):
    size = (len(lst) - 1) * 32 + len(lst[-1])  
    n = 512
    while size > (n - 65):
        n *= 2
    return n

# step3: add 1 at the end of the binary list
# step4: add zeros until we reach the multiple of 512
def append1(lst, max_val):
    if len(lst[-1]) < 32:
        lst[-1] += '1'
    else:
        lst.append('1' + '0' * 31)  

    while len(lst[-1]) % 32 != 0:
        lst[-1] += '0'

    while len(lst) * 32 < max_val - 64:
        lst.append('0' * 32)

    return lst


# step5: append the size of the message in binary (64-bit representation)
def append_size(lst, original_size):
    size_bin = format(original_size, '064b')  
    lst.extend([size_bin[i:i+32] for i in range(0, 64, 32)])  
    return lst

# step5: split input into blocks of 512 bits:
def split(lst):
    return [lst[i:i+16] for i in range(0, len(lst), 16)]  # 16 elements = 512 bits

# step6: setting the initial hash values: 8 first num b3d lfasla ta3 jidr 3 3aded premier
def initialize_constants():
    primes = [
        2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
        59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131,
        137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223,
        227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311
    ]
    constants = [int((p ** (1/3) % 1) * (2**32)) for p in primes[:64]]
    hex_constants = [f"{c:08x}" for c in constants]  
    return hex_constants

def rotr(x, n):
    binary = format(x, '032b')  # Convert to 32-bit binary string
    return int(binary[-n:] + binary[:-n], 2)  # Rotate right by n

def sigma0(x):
    return rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3)

def sigma1(x):
    return rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10)

#step8: computation of the W values: the first 16 are the first 16 elemnts of the block
# the rest are computed using the sigma functions

def computation(blocks):
    W = []
    for block in blocks:
        W_block = [0] * 64  
        for j in range(16):
            W_block[j] = int(block[j], 2)  # Convert binary string to integer
        for j in range(16, 64):
            W_block[j] = (sigma1(W_block[j-2]) + W_block[j-7] + sigma0(W_block[j-15]) + W_block[j-16]) % (2**32)  
        W.append(W_block)
    return W

global a, b, c, d, e, f, g, h # Declare global variables for hash values
# Step 9: Initialize a to h values from constants list
def a_to_h_values(constants_list):
    # These are the first 8 fractional parts of the square roots of the first 8 primes
    initial_values = [
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    ]
    return initial_values

# Step 10: Compute the SHA-like transformations
def sigma0_(x):
    return (rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22)) % (2**32)

def sigma1_(x):
    return (rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25)) % (2**32)

def ch(e, f, g):# if e=1 we take the bit from f else we take the bit from g
    return (e & f) ^ (~e & g)

def maj(a, b, c):# if there are to 1 or more we take 1 , or else we take 0
    return (a & b) ^ (a & c) ^ (b & c)

def update_H_values(H, a, b, c, d, e, f, g, h):
    return [
        (H[0] + a) % (2**32),
        (H[1] + b) % (2**32),
        (H[2] + c) % (2**32),
        (H[3] + d) % (2**32),
        (H[4] + e) % (2**32),
        (H[5] + f) % (2**32),
        (H[6] + g) % (2**32),
        (H[7] + h) % (2**32)
    ]

def computation2(blocks, H, constants_list, W):
    for block_index, block in enumerate(blocks):
        a, b, c, d, e, f, g, h = H

        for i in range(64):
            t1 = (h + sigma1_(e) + ch(e, f, g) + int(constants_list[i], 16) + W[block_index][i]) % (2**32)
            t2 = (sigma0_(a) + maj(a, b, c)) % (2**32)
            h, g, f, e, d, c, b, a = g, f, e, (d + t1) % (2**32), c, b, a, (t1 + t2) % (2**32)

        H = update_H_values(H, a, b, c, d, e, f, g, h)

    return H

def apply_salt(input_text, salt=None, salt_position=None):
    """
    Apply salt to input text if provided
    salt_position: 1 for prefix, 2 for suffix
    """
    if salt and salt_position:
        if salt_position == 1:
            return salt+input_text
        elif salt_position == 2:
            return input_text+salt
    return input_text

def compute_hash(input_text):
    """Compute hash for the given input text"""
    binary_list = string_to_binary_list(input_text)
    max_val = multipleof512(binary_list)
    binary_list = append1(binary_list, max_val)
    binary_list = append_size(binary_list, len(input_text) * 8)  # Message size in bits
    blocks = split(binary_list)
    constants_list = initialize_constants()
    W = computation(blocks)
    H = a_to_h_values(constants_list)
    final_hash = computation2(blocks, H, constants_list, W)
    return ''.join(f"{value:08x}" for value in final_hash)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python sha256.py [encode] [text] [salt] [position]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]
    salt = None
    position = None

    if len(sys.argv) >= 4:
        salt = sys.argv[3]
    if len(sys.argv) == 5:
        try:
            position = int(sys.argv[4])
        except ValueError:
            print("Salt position must be 1 (prefix) or 2 (suffix).", file=sys.stderr)
            sys.exit(1)

    if salt and position:
        text = apply_salt(text, salt, position)

    if operation == "encode":
        print(compute_hash(text))
    else:
        print("Invalid operation. Only 'encode' is supported.", file=sys.stderr)
        sys.exit(1)
