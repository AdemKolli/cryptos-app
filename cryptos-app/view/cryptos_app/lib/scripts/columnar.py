import sys

def columnar_transposition_encrypt(plaintext, key):
    num_columns = len(key)
    num_rows = -(-len(plaintext) // num_columns)
    key_order = sorted(range(len(key)), key=lambda k: key[k])
    grid = [['X' for _ in range(num_columns)] for _ in range(num_rows)]

    index = 0
    for row in range(num_rows):
        for col in range(num_columns):
            if index < len(plaintext):
                grid[row][col] = plaintext[index]
                index += 1

    ciphertext = ""
    for col in key_order:
        for row in range(num_rows):
            ciphertext += grid[row][col]
    return ciphertext

def columnar_transposition_decrypt(ciphertext, key):
    num_columns = len(key)
    num_rows = len(ciphertext) // num_columns
    key_order = sorted(range(len(key)), key=lambda k: key[k])
    grid = [['' for _ in range(num_columns)] for _ in range(num_rows)]

    index = 0
    for col in key_order:
        for row in range(num_rows):
            if index < len(ciphertext):
                grid[row][col] = ciphertext[index]
                index += 1

    plaintext = ""
    for row in grid:
        plaintext += ''.join(row)
    return plaintext.rstrip('X')

def main():
    action = sys.argv[1]
    text = sys.argv[2]
    key = sys.argv[3]

    if action == 'encode':
        print(columnar_transposition_encrypt(text, key))
    elif action == 'decode':
        print(columnar_transposition_decrypt(text, key))
    else:
        print("Invalid action")

if __name__ == "__main__":
    main()
