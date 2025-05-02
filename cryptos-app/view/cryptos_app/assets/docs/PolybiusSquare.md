# Polybius Square Algorithm

The Polybius Square cipher is a classical encryption technique that replaces each letter with its coordinates in a 5×5 grid. One letter (typically `J` or `W`) is omitted to fit the 25-letter grid.

---

## How It Works

---

### 1. Key Array Construction (`create_array(key, omit_letter)`)

- Constructs a 5×5 Polybius square used for encoding and decoding.
- Processes the custom key by:
  - Converting it to uppercase.
  - Removing duplicate characters.
  - Removing the omitted letter (default is `'W'`).
- Fills the remaining grid cells with the rest of the alphabet (excluding the omitted letter).
- Returns a 5×5 matrix stored globally as `array`.

---

### 2. Encoding

- Removes spaces and converts the message to uppercase.
- Replaces each letter with its (row, column) coordinate in the 5×5 grid:
  - For example, `'A'` becomes `"11"`, `'B'` becomes `"12"`, etc.
- Returns the encoded result as a space-separated string of digit pairs.

---

### 3. Decoding

- Takes a string of digit pairs and converts it back into the original plaintext message.
- Uses the function `valide_numbers()` to validate the input:
  - Only digits are allowed.
  - The input must contain an even number of digits.
  - All digits must be in the range `1–5`.
- Parses the input two digits at a time and finds the corresponding letter in the Polybius square.
- Returns the decoded message as an uppercase string.

---

### Notes

- The letter omitted from the square (usually `'W'` or `'J'`) cannot be encoded directly.
- The algorithm provides a simple and fast method for manually encrypting short messages.
- This cipher is vulnerable to frequency analysis and should only be used for educational or historical purposes.
