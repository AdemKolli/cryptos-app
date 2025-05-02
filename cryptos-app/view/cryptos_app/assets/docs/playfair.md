# Playfair Cipher

The Playfair Cipher is a classical encryption technique that uses a 5x5 matrix of letters to encrypt or decrypt messages. It was the first digraph substitution cipher, encrypting pairs of letters rather than single letters. This method provides a simple yet effective approach to secure communication.

---

## How It Works

The Playfair Cipher operates by creating a 5x5 grid of letters based on a keyword. The grid includes the letters A–Z (excluding W). The encryption and decryption processes involve substituting pairs of letters according to their positions in the grid.

---

### Encryption

1. **Preprocessing the Plaintext**:
   - Converts the plaintext to uppercase.
   - Replaces the letter `W` with `V`.
   - Removes all non-alphabetic characters.

2. **Handling Pairs**:
   - Splits the plaintext into pairs of letters.
   - Inserts the filler letter `X` between repeated letters in a pair.
   - Adds `X` to the final letter if the plaintext length is odd.

3. **Encrypting the Pairs**:
   - For each pair of letters:
     - If they are in the same row, replace them with the letters to their immediate right.
     - If they are in the same column, replace them with the letters directly below.
     - Otherwise, replace them with the letters at the intersection of their respective rows and columns.

---

### Decryption

1. **Preprocessing the Ciphertext**:
   - Converts the ciphertext to uppercase.
   - Replaces the letter `W` with `V`.
   - Removes all non-alphabetic characters.

2. **Decrypting the Pairs**:
   - For each pair of letters:
     - If they are in the same row, replace them with the letters to their immediate left.
     - If they are in the same column, replace them with the letters directly above.
     - Otherwise, replace them with the letters at the intersection of their respective rows and columns.

3. **Post-Processing**:
   - Checks if the plaintext contains the letter `V` and suggests replacing it with `W` for a more accurate result.
