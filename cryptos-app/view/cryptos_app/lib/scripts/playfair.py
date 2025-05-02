import sys

def prepare_key_matrix(key):
    key = key.upper().replace('J', 'I')
    seen = set()
    matrix = []

    for char in key:
        if char.isalpha() and char not in seen:
            seen.add(char)
            matrix.append(char)

    for char in 'ABCDEFGHIKLMNOPQRSTUVWXYZ':
        if char not in seen:
            seen.add(char)
            matrix.append(char)

    return [matrix[i:i+5] for i in range(0, 25, 5)]

def find_position(matrix, char):
    for i in range(5):
        for j in range(5):
            if matrix[i][j] == char:
                return i, j
    return None

def process_text(text):
    text = text.upper().replace("J", "I").replace(" ", "")
    i = 0
    processed = []

    while i < len(text):
        a = text[i]
        b = ''
        if i + 1 < len(text):
            b = text[i + 1]
        if a == b:
            b = 'X'
            i += 1
        else:
            i += 2
        processed.append(a + (b if b else 'X'))
    return processed

def encode(text, matrix):
    result = ''
    pairs = process_text(text)
    for pair in pairs:
        a, b = pair[0], pair[1]
        row1, col1 = find_position(matrix, a)
        row2, col2 = find_position(matrix, b)
        if row1 == row2:
            result += matrix[row1][(col1 + 1) % 5]
            result += matrix[row2][(col2 + 1) % 5]
        elif col1 == col2:
            result += matrix[(row1 + 1) % 5][col1]
            result += matrix[(row2 + 1) % 5][col2]
        else:
            result += matrix[row1][col2]
            result += matrix[row2][col1]
    return result

def decode(text, matrix):
    result = ''
    pairs = process_text(text)
    for pair in pairs:
        a, b = pair[0], pair[1]
        row1, col1 = find_position(matrix, a)
        row2, col2 = find_position(matrix, b)
        if row1 == row2:
            result += matrix[row1][(col1 - 1) % 5]
            result += matrix[row2][(col2 - 1) % 5]
        elif col1 == col2:
            result += matrix[(row1 - 1) % 5][col1]
            result += matrix[(row2 - 1) % 5][col2]
        else:
            result += matrix[row1][col2]
            result += matrix[row2][col1]
    return result

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python playfair.py <encode|decode> <text> <key>")
        sys.exit(1)

    mode = sys.argv[1]
    text = sys.argv[2]
    key = sys.argv[3]

    matrix = prepare_key_matrix(key)

    if mode == 'encode':
        print(encode(text, matrix))
    elif mode == 'decode':
        print(decode(text, matrix))
    else:
        print("Invalid mode. Use 'encode' or 'decode'.")
        sys.exit(1)
