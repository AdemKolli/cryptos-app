# Columnar Transposition Cipher

The **Columnar Transposition Cipher** is a classical encryption method that rearranges the characters of the plaintext into columns based on a keyword. The letters are then read column by column in a specific order defined by the key to produce the ciphertext.

It is a type of transposition cipher, meaning it hides the message by changing the position of characters without altering the characters themselves.

---

## How It Works

The cipher works by placing the plaintext into a grid of rows and columns determined by the length of a keyword. The columns are then reordered according to the alphabetical order of the keyword letters, and the message is read out column by column.

---

### Encryption

- Arranges the plaintext into a grid with columns determined by the keyword.
- The characters are written into the grid row by row.
- The columns are reordered based on the alphabetical order of the key.
- The ciphertext is formed by reading the grid column by column in that new order.
- Padding characters (such as `'X'`) may be added to fill incomplete rows.

---

### Decryption

- Requires the same key used for encryption.
- Calculates the number of rows using the ciphertext length and key length.
- Fills the grid column by column in the sorted order of the key.
- Reads the grid row by row to reconstruct the plaintext.
- Removes any padding characters added during encryption.

---

### Notes

- The security of the cipher depends on the secrecy of the keyword.
- It is relatively easy to break with frequency analysis or brute-force if the key is short.
- It's mainly used as an educational example in classical cryptography.

