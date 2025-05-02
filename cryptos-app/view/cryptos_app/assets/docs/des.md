# Simplified DES Encryption and Decryption

This Python implementation demonstrates a simplified version of the **DES (Data Encryption Standard)** algorithm. It applies block-wise permutations, XOR-based key mixing, and substitution using a mini S-box.

---

## Overview

- 📦 **Block size**: 64 bits (converted from text)
- 🔐 **Key**: 48-bit binary string (custom requirement)
- 🔁 **Rounds**: 16 Feistel-style rounds
- 🔄 **Operation**: Text is transformed into a 64-bit block, permuted, split into halves, then processed round-by-round before final permutation

---

## Features

- Custom **Initial Permutation (IP)** and **Inverse Permutation (IP_INV)**
- Uses a **48-bit binary key** passed as a string (e.g. `"101010...0101"`)
- Simplified **S-Box** logic using modulo and two rows
- **Feistel network** structure with swapping of L and R after each round

---

## Encryption Flow

1. **Input Conversion**  
   - Converts text into a 64-bit binary representation.

2. **Initial Permutation**  
   - Applies `IP` table to rearrange the bits.

3. **Feistel Rounds (×16)**  
   - Each round uses:
     - `f_function()` → expands and mixes the right half with the key.
     - XOR with the left half to compute new right half.
     - Left and right are swapped.

4. **Final Permutation**  
   - Concatenates final halves (R + L) and applies `IP_INV`.

5. **Output**  
   - Final ciphertext is a string of 64 bits (e.g., `"11010101..."`)

---

## Decryption Flow

1. **Input**  
   - Binary string of 64 bits is used as input ciphertext.

2. **Initial Permutation**  
   - Applies `IP` to the input block.

3. **Feistel Rounds (×16)**  
   - Similar to encryption but swapping is reversed: newL = R XOR f(L, K)

4. **Final Permutation**  
   - Applies `IP_INV` to L + R.

5. **Output**  
   - Converts the 64-bit binary result back to ASCII text.

---

## f_function(R, K)

- **Expansion (E-table)**: Expands 32-bit R to 48 bits.
- **XOR with key**: Mixes expanded R with the 48-bit key.
- **S-Box substitution**: Applies two-row S-box on each 6-bit chunk.
- **Permutation (P)**: Final reshuffling to produce 32-bit output.

---

## CLI Usage

```bash
python des.py encode "HELLO" "101010101010101010101010101010101010101010101010"
python des.py decode "1100010101..." "101010101010101010101010101010101010101010101010"
