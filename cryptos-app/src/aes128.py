import argparse  
import json  
import base64
import sys  

class ErrorCode:
    SUCCESS = 0
    ERROR_MEMORY_ALLOCATION_FAILED = 1


sbox = [
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
    0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
    0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
    0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
    0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
    0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
    0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
    0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
    0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
    0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
    0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
    0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
    0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
    0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
    0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
]


rsbox = [
    0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
    0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
    0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
    0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
    0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
    0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
    0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
    0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
    0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
    0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
    0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
    0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
    0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
    0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
    0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
    0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
]

Rcon = [
    0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
]

def get_sbox_value(num):
    return sbox[num]

def get_sbox_invert(num):
    return rsbox[num]

def rotate(word):
    return word[1:] + word[:1]

def get_rcon_value(num):
    return Rcon[num]

def core(word, iteration):
    word = rotate(word)
    for i in range(4):
        word[i] = get_sbox_value(word[i])
    word[0] = word[0] ^ get_rcon_value(iteration)
    return word

def expand_key(key):
    key_size = 16  
    expanded_key_size = 176  
    expanded_key = [0] * expanded_key_size
    current_size = 0
    rcon_iteration = 1
    
    for i in range(key_size):
        expanded_key[i] = key[i]
    current_size += key_size
        
    while current_size < expanded_key_size:
        t = [expanded_key[current_size - 4 + i] for i in range(4)]
        
        if current_size % key_size == 0:
            t = core(t, rcon_iteration)
            rcon_iteration += 1
            
        for i in range(4):
            expanded_key[current_size] = expanded_key[current_size - key_size] ^ t[i]
            current_size += 1
            
    return expanded_key

def sub_bytes(state):
    for i in range(16):
        state[i] = get_sbox_value(state[i])
    return state

def shift_rows(state):
    for i in range(4):
        shift_row(state, i)
    return state

def shift_row(state, row):
    row_data = [state[row + 4 * i] for i in range(4)]
    row_data = row_data[row:] + row_data[:row]
    for i in range(4):
        state[row + 4 * i] = row_data[i]
    return state

def add_round_key(state, round_key):
    for i in range(16):
        state[i] ^= round_key[i]
    return state

def galois_multiplication(a, b):
    p = 0
    for counter in range(8):
        if (b & 1) != 0:
            p ^= a
        hi_bit_set = (a & 0x80)
        a <<= 1
        a &= 0xFF
        if hi_bit_set != 0:
            a ^= 0x1b
        b >>= 1
    return p

def mix_columns(state):
    for i in range(4):
        column = [state[j * 4 + i] for j in range(4)]
        column = mix_column(column)
        for j in range(4):
            state[j * 4 + i] = column[j]
    return state

def mix_column(column):
    copy = column.copy()
    column[0] = galois_multiplication(copy[0], 2) ^ galois_multiplication(copy[3], 1) ^ galois_multiplication(copy[2], 1) ^ galois_multiplication(copy[1], 3)
    column[1] = galois_multiplication(copy[1], 2) ^ galois_multiplication(copy[0], 1) ^ galois_multiplication(copy[3], 1) ^ galois_multiplication(copy[2], 3)
    column[2] = galois_multiplication(copy[2], 2) ^ galois_multiplication(copy[1], 1) ^ galois_multiplication(copy[0], 1) ^ galois_multiplication(copy[3], 3)
    column[3] = galois_multiplication(copy[3], 2) ^ galois_multiplication(copy[2], 1) ^ galois_multiplication(copy[1], 1) ^ galois_multiplication(copy[0], 3)
    return column

def aes_round(state, round_key):
    state = sub_bytes(state)
    state = shift_rows(state)
    state = mix_columns(state)
    state = add_round_key(state, round_key)
    return state

def create_round_key(expanded_key, round_key_pos):
    round_key = [0] * 16
    for i in range(4):
        for j in range(4):
            round_key[i + (j * 4)] = expanded_key[round_key_pos + (i * 4) + j]
    return round_key

def aes_main(state, expanded_key):
    nbr_rounds = 10  
    
    round_key = create_round_key(expanded_key, 0)
    state = add_round_key(state, round_key)
    
    for i in range(1, nbr_rounds):
        round_key = create_round_key(expanded_key, 16 * i)
        state = aes_round(state, round_key)
    
    round_key = create_round_key(expanded_key, 16 * nbr_rounds)
    state = sub_bytes(state)
    state = shift_rows(state)
    state = add_round_key(state, round_key)
    
    return state

def aes_encrypt_block(input_data, key):
    block = [0] * 16
    for i in range(4):
        for j in range(4):
            block[i + (j * 4)] = input_data[(i * 4) + j]
            
    expanded_key = expand_key(key)
    block = aes_main(block, expanded_key)
    
    output = [0] * 16
    for i in range(4):
        for j in range(4):
            output[(i * 4) + j] = block[i + (j * 4)]
            
    return output

def inv_sub_bytes(state):
    for i in range(16):
        state[i] = get_sbox_invert(state[i])
    return state

def inv_shift_rows(state):
    for i in range(4):
        inv_shift_row(state, i)
    return state

def inv_shift_row(state, row):
    row_data = [state[row + 4 * i] for i in range(4)]
    row_data = row_data[-row:] + row_data[:-row] if row else row_data
    for i in range(4):
        state[row + 4 * i] = row_data[i]
    return state

def inv_mix_columns(state):
    for i in range(4):
        column = [state[j * 4 + i] for j in range(4)]
        column = inv_mix_column(column)
        for j in range(4):
            state[j * 4 + i] = column[j]
    return state

def inv_mix_column(column):
    copy = column.copy()
    column[0] = galois_multiplication(copy[0], 14) ^ galois_multiplication(copy[3], 9) ^ galois_multiplication(copy[2], 13) ^ galois_multiplication(copy[1], 11)
    column[1] = galois_multiplication(copy[1], 14) ^ galois_multiplication(copy[0], 9) ^ galois_multiplication(copy[3], 13) ^ galois_multiplication(copy[2], 11)
    column[2] = galois_multiplication(copy[2], 14) ^ galois_multiplication(copy[1], 9) ^ galois_multiplication(copy[0], 13) ^ galois_multiplication(copy[3], 11)
    column[3] = galois_multiplication(copy[3], 14) ^ galois_multiplication(copy[2], 9) ^ galois_multiplication(copy[1], 13) ^ galois_multiplication(copy[0], 11)
    return column

def aes_inv_round(state, round_key):
    state = inv_shift_rows(state)
    state = inv_sub_bytes(state)
    state = add_round_key(state, round_key)
    state = inv_mix_columns(state)
    return state

def aes_inv_main(state, expanded_key):
    nbr_rounds = 10  
    
    round_key = create_round_key(expanded_key, 16 * nbr_rounds)
    state = add_round_key(state, round_key)
    
    for i in range(nbr_rounds - 1, 0, -1):
        round_key = create_round_key(expanded_key, 16 * i)
        state = aes_inv_round(state, round_key)
    
    round_key = create_round_key(expanded_key, 0)
    state = inv_shift_rows(state)
    state = inv_sub_bytes(state)
    state = add_round_key(state, round_key)
    
    return state

def aes_decrypt_block(input_data, key):
    block = [0] * 16
    for i in range(4):
        for j in range(4):
            block[i + (j * 4)] = input_data[(i * 4) + j]
            
    expanded_key = expand_key(key)
    block = aes_inv_main(block, expanded_key)
    
    output = [0] * 16
    for i in range(4):
        for j in range(4):
            output[(i * 4) + j] = block[i + (j * 4)]
            
    return output

def pad(text):
    pad_value = 16 - (len(text) % 16)
    padding = bytes([pad_value]) * pad_value
    return text + padding

def unpad(text):
    pad_value = text[-1]
    if isinstance(pad_value, str):
        pad_value = ord(pad_value)
    if pad_value > 16 or pad_value < 1:
        return text  
    for i in range(1, pad_value + 1):
        if text[-i] != pad_value:
            return text  
    return text[:-pad_value]

def aes_encrypt_string(plaintext, key):
    if len(key) > 16:
     print("Warning: The key has been truncated to 16 bytes. This may reduce security. It is recommended to provide a 16-byte key.")
     key = key[:16]
    elif len(key) < 16:
        print("Warning: The key has been padded to 16 bytes. It is recommended to provide a 16-byte key.")
        key = key.ljust(16, '\0')
    
    if isinstance(plaintext, str):
        plaintext = plaintext.encode('utf-8')
    if isinstance(key, str):
        key = key.encode('utf-8')
    
    padded_plaintext = pad(plaintext)
    
    result = b''
    for i in range(0, len(padded_plaintext), 16):
        block = padded_plaintext[i:i+16]
        block_bytes = [b for b in block]
        key_bytes = [b for b in key]
        
        cipher_block = aes_encrypt_block(block_bytes, key_bytes)
        result += bytes(cipher_block)
    
    return base64.b64encode(result).decode('utf-8')

def aes_decrypt_string(ciphertext, key):
    if len(key) > 16:
     print("Warning: The key has been truncated to 16 bytes. This may reduce security. It is recommended to provide a 16-byte key.")
     key = key[:16]
    elif len(key) < 16:
        print("Warning: The key has been padded to 16 bytes. It is recommended to provide a 16-byte key.")
        key = key.ljust(16, '\0')
    
    if isinstance(key, str):
        key = key.encode('utf-8')
    
    try:
        ciphertext_bytes = base64.b64decode(ciphertext)
    except:
        raise ValueError("Invalid base64 encoded ciphertext")
    
    if len(ciphertext_bytes) % 16 != 0:
        raise ValueError("Ciphertext length must be multiple of 16 bytes")
    
    result = b''
    for i in range(0, len(ciphertext_bytes), 16):
        block = ciphertext_bytes[i:i+16]
        block_list = [b for b in block]
        key_bytes = [b for b in key]
        
        plain_block = aes_decrypt_block(block_list, key_bytes)
        result += bytes(plain_block)
    
    return unpad(result).decode('utf-8')


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python aes128.py [encode|decode] [text] [key]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]
    key = sys.argv[3]

    if operation == "encode":
        print(aes_encrypt_string(text, key))
    elif operation == "decode":
        print(aes_decrypt_string(text, key))
    else:
        print("Invalid operation. Use 'encode' or 'decode'.", file=sys.stderr)
        sys.exit(1)
