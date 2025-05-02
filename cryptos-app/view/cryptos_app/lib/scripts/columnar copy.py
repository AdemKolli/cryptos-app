# lib/scripts/columnar.py
import sys
import json

def columnar_transposition_decrypt(ciphertext, key):
    num_columns = len(key)
    num_rows = len(ciphertext) // num_columns
    key_order = sorted(range(len(key)), key=lambda k: key[k])

    grid = [['' for _ in range(num_columns)] for _ in range(num_rows)]
    idx = 0
    for col in key_order:
        for row in range(num_rows):
            if idx < len(ciphertext):
                grid[row][col] = ciphertext[idx]
                idx += 1

    plaintext = "".join("".join(row) for row in grid)
    plaintext = plaintext.rstrip('X')
    return plaintext

def columnar_transposition_encrypt(plaintext, key):
    num_columns = len(key)
    num_rows = -(-len(plaintext) // num_columns)  # ceil
    key_order = sorted(range(len(key)), key=lambda k: key[k])

    grid = [['X'] * num_columns for _ in range(num_rows)]
    idx = 0
    for r in range(num_rows):
        for c in range(num_columns):
            if idx < len(plaintext):
                grid[r][c] = plaintext[idx]
                idx += 1

    ciphertext = ""
    for col in key_order:
        for row in range(num_rows):
            ciphertext += grid[row][col]
    return ciphertext

if __name__ == "__main__":
    # Usage: python columnar.py encode|decode text key
    if len(sys.argv) != 4:
        print(json.dumps({"status":"error","message":"Usage: columnar.py [encode|decode] text key"}))
        sys.exit(1)

    op, text, key = sys.argv[1], sys.argv[2], sys.argv[3]
    text, key = text.upper().replace(" ", ""), key.upper().replace(" ", "")

    try:
        if op == "encode":
            res = columnar_transposition_encrypt(text, key)
        elif op == "decode":
            res = columnar_transposition_decrypt(text, key)
        else:
            raise ValueError("Invalid operation")
        print(json.dumps({"status":"success","result":res}))
    except Exception as e:
        print(json.dumps({"status":"error","message":str(e)}))
        sys.exit(1)
