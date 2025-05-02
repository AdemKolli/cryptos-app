# RSA Algorithm

RSA encryption relies on the use of two keys: a **public key** for encryption and a **private key** for decryption. The RSA algorithm is based on the mathematical difficulty of factoring large prime numbers.

---

## How It Works

---

### 1. Key Generation

The `generate_keys()` function performs the following steps:

- Randomly selects two distinct prime numbers `p` and `q` from a predefined list.
- Computes:
  - `n = p × q`
  - `φ(n) = (p - 1) × (q - 1)` (Euler's totient function)
- Chooses an integer `e` such that:
  - `1 < e < φ(n)`
  - `gcd(e, φ(n)) = 1` (i.e., `e` and `φ(n)` are coprime)
- Computes the modular inverse of `e` modulo `φ(n)` to get `d`, such that:
  - `d ≡ e⁻¹ mod φ(n)`
- Returns:
  - **Public key**: `(e, n)`
  - **Private key**: `(d, n)`

---

### 2. Encryption

- Converts each character of the plaintext into its ASCII code.
- For each code `m`, computes the ciphertext as:
  - `c ≡ m^e mod n`
- The result is a list of encrypted numbers.

---

### 3. Decryption

- For each encrypted number `c`, computes the original message code:
  - `m ≡ c^d mod n`
- Converts each resulting number back to its corresponding character.
- Reconstructs and returns the original message.

---

### Notes

- RSA is secure due to the computational difficulty of factoring very large numbers.
- Key sizes of at least **2048 bits** are recommended for strong security in real-world applications.
- RSA is often used in combination with symmetric encryption (e.g., AES) in hybrid cryptosystems.

