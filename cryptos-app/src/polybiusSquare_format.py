"""
Polybius Square Cipher Implementation

This script implements the Polybius Square cipher, a classical encryption technique that 
replaces each letter with its coordinates in a 5x5 grid (typically omitting 'J' or 'W').

Usage:
    python polybius.py --operation [encode|decode] --input "message" [--key "KEY"] [--omit-letter "X"]

Functions:
    create_array(key, omit_letter): 
        Creates the 5x5 Polybius square using the provided key and omitted letter.
        - key: Custom key to initialize the square (optional)
        - omit_letter: Letter to exclude from the square (default 'W')

    encode(sentence):
        Encodes plaintext into coordinate pairs.
        - sentence: Input text to encode
        Returns: Space-separated coordinate strings (e.g., "11 23 34")

    decode(message):
        Decodes coordinate pairs back to plaintext.
        - message: Encoded coordinate string (e.g., "11 23 34")
        Returns: Decoded text or "Invalid message" if input is malformed

    valide_numbers(message):
        Validates encoded message format.
        - message: Input to validate
        Returns: True if valid coordinate string, False otherwise

The script uses a global 'array' variable to store the Polybius square and a predefined 
'alphabet' list (A-Z). During encoding/decoding:
1. The square is generated based on key and omitted letter
2. Letters are replaced with their row/column coordinates (encode)
3. Coordinates are converted back to letters (decode)

Example JSON outputs:
    Success: {"status": "success", "result": "encoded/decoded text"}
    Error: {"status": "error", "message": "error description"}
"""

import argparse
import json
# Standard alphabet (A-Z) used as basis for Polybius square
alphabet = [chr(i) for i in range(65, 91)]  

def create_array(key: str, omit_letter: str):
    """
    Constructs the Polybius square array according to the given parameters:
    1. Processes the key (removes duplicates and omitted letter)
    2. Fills remaining spaces with alphabet (excluding omitted letter)
    3. Creates 5x5 grid from processed characters
    """
    global array
    omit_letter = omit_letter.upper()
    key = key.upper().replace(omit_letter, '') 
    seen = []
    ordered_chars = []
    
    # Process key characters first
    for char in key:  
        if char.isalpha() and char not in seen and char != omit_letter:
            seen.append(char)
            ordered_chars.append(char)
    
    # Fill with remaining alphabet characters
    for char in alphabet:  
        if char not in seen and char != omit_letter:
            seen.append(char)
            ordered_chars.append(char)
    
    # Create 5x5 grid
    array = []
    index = 0
    for i in range(5):
        row = []
        for j in range(5):
            row.append(ordered_chars[index])
            index += 1
        array.append(row)

def encode(sentence: str):
    """
    Encodes plaintext by replacing each letter with its grid coordinates.
    Handles:
    - Whitespace removal
    - Case insensitivity
    - Returns coordinates as space-separated string
    """
    sentence = sentence.replace(' ', '').upper()
    result = []
    for char in sentence:
        found = False
        # Search through grid for character
        for row in range(len(array)):
            for col in range(len(array[row])):
                if char == array[row][col]:
                    result.append(f"{row + 1}{col + 1}")
                    found = True
                    break
            if found:
                break
    return ' '.join(result)

def valide_numbers(message):
    """
    Validates encoded message format:
    - Must contain only digits
    - Even number of digits
    - Each digit between 1-5
    """
    message = message.replace(' ', '')  
    if not message.isdigit() or len(message) % 2 != 0:
        return False  
    for char in message:
        if int(char) < 1 or int(char) > 5:
            return False  
    return True

def decode(message: str):
    """
    Decodes coordinate pairs back to original letters.
    Performs validation before decoding.
    Returns error message if input is invalid.
    """
    message = message.replace(' ', '')
    if not valide_numbers(message):
        return "Invalid message"
    result = []
    # Process coordinates two digits at a time
    for i in range(0, len(message), 2):
        row = int(message[i]) - 1
        col = int(message[i + 1]) - 1
        result.append(array[row][col])
    return ' '.join(result)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Polybius Square Cipher')
    parser.add_argument('--operation', type=str, required=True, choices=['encode', 'decode'], help='Operation to perform: encode or decode')
    parser.add_argument('--input', type=str, required=True, help='Input message to process')
    parser.add_argument('--key', type=str, default='', help='Custom key (optional)')
    parser.add_argument('--omit-letter', type=str, default='W', help='Letter to omit (default: W)')
    
    args = parser.parse_args()
    
    try:
        create_array(args.key, args.omit_letter)
        
        if args.operation == 'encode':
            result = encode(args.input)
            print(json.dumps({"status": "success", "result": result}))
        elif args.operation == 'decode':
            result = decode(args.input)
            if result == "Invalid message":
                print(json.dumps({"status": "error", "message": result}))
            else:
                print(json.dumps({"status": "success", "result": result}))
    except Exception as e:
        print(json.dumps({"status": "error", "message": str(e)}))