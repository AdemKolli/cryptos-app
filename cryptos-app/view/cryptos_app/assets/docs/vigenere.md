# Vigenère Cipher

The Vigenère Cipher is a classical method of encrypting alphabetic text using a polyalphabetic substitution technique. It employs a keyword to determine the shift for each letter in the plaintext, offering stronger encryption than monoalphabetic ciphers like Caesar.

---

## How It Works

The Vigenère Cipher uses a repeating keyword to determine the shift for each character in the plaintext. Each letter in the key defines a Caesar shift, and the key repeats as necessary to match the length of the message.

---

### Encryption

1. **Preprocessing the Plaintext and Key**:
   - Converts both the plaintext and key to uppercase.
   - Removes all non-alphabetic characters.
   - If the key is shorter than the plaintext, it is repeated or truncated to match the plaintext length.

2. **Encrypting Each Letter**:
   - For each letter in the plaintext:
     - Convert the plaintext and corresponding key letter to 0-based indices (A=0, B=1, ..., Z=25).
     - Add the key index to the plaintext index and take the result modulo 26.
     - Convert the resulting index back to a letter and append it to the ciphertext.

---

### Decryption

1. **Preprocessing the Ciphertext and Key**:
   - Converts both the ciphertext and key to uppercase.
   - Removes all non-alphabetic characters.
   - Repeats or truncates the key to match the ciphertext length.

2. **Decrypting Each Letter**:
   - For each letter in the ciphertext:
     - Convert the ciphertext and corresponding key letter to 0-based indices.
     - Subtract the key index from the ciphertext index. If the result is negative, add 26.
     - Take the result modulo 26 and convert it back to a letter.
     - Append the letter to the decrypted plaintext.

---

### Example

- **Plaintext**: `HELLO`
- **Key**: `KEY`
- **Key Expanded**: `KEYKE`
- **Ciphertext**: `RIJVS`

---

### Notes

- The Vigenère Cipher is vulnerable to frequency analysis if the key is short and reused.
- Using a long, random key (equal in length to the plaintext) turns it into a **one-time pad**, which is theoretically unbreakable.

