# lib/scripts/polybius.py

import sys
import json

# Alphabet A-Z
alphabet = [chr(i) for i in range(65, 91)]

def create_array(key: str, omit_letter: str):
    omit = omit_letter.upper()
    seen = []
    arr = []
    # d’abord la clé
    for c in key.upper().replace(omit, ""):
        if c.isalpha() and c not in seen:
            seen.append(c)
            arr.append(c)
    # puis le reste de l’alphabet
    for c in alphabet:
        if c not in seen and c != omit:
            seen.append(c)
            arr.append(c)
    # transformer en grille 5×5
    return [arr[i*5:(i+1)*5] for i in range(5)]

def encode(grid, text: str):
    txt = text.replace(" ", "").upper()
    out = []
    for ch in txt:
        for r in range(5):
            for c in range(5):
                if grid[r][c] == ch:
                    out.append(f"{r+1}{c+1}")
    return " ".join(out)

def valide_numbers(msg: str):
    m = msg.replace(" ", "")
    if not m.isdigit() or len(m)%2!=0:
        return False
    return all('1' <= d <= '5' for d in m)

def decode(grid, msg: str):
    m = msg.replace(" ", "")
    if not valide_numbers(m):
        return None
    out = []
    for i in range(0, len(m), 2):
        r = int(m[i]) - 1
        c = int(m[i+1]) - 1
        out.append(grid[r][c])
    return "".join(out)

if __name__ == "__main__":
    # usage: python polybius.py encode|decode "text" "key" "omitLetter"
    if len(sys.argv) != 5:
        print(json.dumps({"status":"error","message":"Usage: polybius.py [encode|decode] text key omit"}))
        sys.exit(1)

    op, text, key, omit = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
    try:
        grid = create_array(key, omit)
        if op == "encode":
            res = encode(grid, text)
            print(res)
        elif op == "decode":
            res = decode(grid, text)
            if res is None:
                print(json.dumps({"status":"error","message":"Invalid message"}))
            else:
                print(res)
        else:
            print(json.dumps({"status":"error","message":"Invalid operation"}))
    except Exception as e:
        print(json.dumps({"status":"error","message":str(e)}))
        sys.exit(1)
