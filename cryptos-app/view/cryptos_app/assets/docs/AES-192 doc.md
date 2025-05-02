# AES-192 Encryption and Decryption

This implementation provides a Python-based solution for encrypting and decrypting strings using the **AES-192** algorithm. AES (Advanced Encryption Standard) is a symmetric block cipher standardized by NIST and used worldwide for secure data encryption.

---

## How It Works

**AES-192** operates on 128-bit blocks of data and uses a 192-bit (24-byte) key. It performs **12 rounds** of encryption or decryption transformations. This implementation supports Base64 encoding and PKCS#7 padding, making it practical for real-world usage.

---

## Features

- 🔐 **Supports AES-192 (24-byte key)**
- 🔄 **Encrypt & Decrypt** using `encode` / `decode` commands
- 📦 **Block-wise processing**
- 🧾 **Base64 output encoding**
- ⚠️ **Key length warnings**
- ✔️ **PKCS#7 padding/unpadding**
- 🧪 **Includes full AES round transformations**

---

## Encryption

### Steps:

1. **Key Normalization**
   - Pads or truncates the key to exactly 24 bytes.

2. **Input Preparation**
   - Converts plaintext to bytes.
   - Applies PKCS#7 padding to align to 16-byte blocks.

3. **Block Encryption**
   - Splits the padded plaintext into 16-byte blocks.
   - Encrypts each block using AES-192.

4. **Output**
   - Encodes the result using Base64 for safe transmission.

---

## Decryption

### Steps:

1. **Key Normalization**
   - Pads or truncates the key to 24 bytes.

2. **Base64 Decoding**
   - Decodes the Base64-encoded ciphertext.

3. **Block Decryption**
   - Splits the ciphertext into 16-byte blocks.
   - Decrypts each block using AES-192.

4. **Unpadding**
   - Removes PKCS#7 padding to return the original plaintext.

---

## Core Components

### 🔁 AES Round Functions

- `sub_bytes()` / `inv_sub_bytes()`: Substitution via S-box.
- `shift_rows()` / `inv_shift_rows()`: Shifts rows for diffusion.
- `mix_columns()` / `inv_mix_columns()`: Mixes columns using Galois field multiplication.
- `add_round_key()`: XORs state with round key.

### 🔧 Key Expansion

- `expand_key()`: Produces 208-byte key schedule for 13 round keys.
- Uses `rotate()` and `core()` with Rcon values.

### 🔢 Padding

- `pad()` and `unpad()` implement PKCS#7 for block alignment.

### 📦 Encoding

- Encrypted bytes are Base64-encoded for transmission.
- Base64-decoding is applied before decryption.

---

## Usage (Command Line)

```bash
python aes192.py encode "Hello World" "mysecurekey123456789012"
python aes192.py decode "Base64EncryptedText==" "mysecurekey123456789012"
