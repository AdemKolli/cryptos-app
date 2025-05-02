# MD5 Hashing Tool

This implementation provides a Python-based tool for hashing strings using the MD5 algorithm. **MD5** (Message-Digest Algorithm 5) is a widely used cryptographic hash function that produces a 128-bit hash value.

---

## How It Works

MD5 is a cryptographic hash function that takes an input message and converts it into a fixed-length 128-bit (16-byte) hash value. It is commonly used for checksums and data integrity verification.

---

## Usage

### Command-Line Arguments

- `--operation`: Specifies the operation to perform (currently supports only `"hash"`).
- `--input`: The input string to hash.

---

## Internal Components

### MD5 Class

The `MD5` class implements the algorithm and provides:

1. **`update(data)`**
   - Updates the hash object with bytes from the input.
   - Processes input in 64-byte blocks.

2. **`digest()`**
   - Returns the binary (raw) representation of the hash.

3. **`hexdigest()`**
   - Returns the hash as a hexadecimal string.

4. **`copy()`**
   - Returns a deep copy of the current MD5 object.

---

### Helper Functions

- **`_long2bytes(n, blocksize)`**  
  Converts a long integer into bytes.

- **`_bytelist2long(data)`**  
  Converts a byte list into a list of long integers.

- **`_rotateLeft(x, n)`**  
  Performs a left bitwise rotation.

- **`F(x, y, z)`, `G(x, y, z)`, `H(x, y, z)`, `I(x, y, z)`**  
  Non-linear functions used in the MD5 rounds.

- **`XX(func, a, b, c, d, x, s, ac)`**  
  Core transformation function combining bitwise logic, rotation, and modular addition.

---

## MD5 Algorithm Overview

### Initialization

Initializes four 32-bit variables (`A`, `B`, `C`, `D`) with constants derived from the sine function.

### Padding

The message is padded to ensure its length is a multiple of 512 bits:

1. Appends a single `'1'` bit.
2. Adds enough `'0'` bits to reach 64 bits short of a multiple of 512.
3. Appends the original length of the message as a 64-bit binary number.

### Processing

The padded message is split into 512-bit blocks. Each block is processed with the MD5 compression function, updating the hash state.

### Output

The final hash is the concatenation of `A`, `B`, `C`, and `D`, returned as a 32-character hexadecimal string (128 bits total).

---

## Notes

- ⚠️ **Security Warning**: MD5 is considered **broken** and is unsuitable for security-sensitive applications due to known **collision vulnerabilities**.
- ✅ **Recommendation**: Use SHA-256 or a stronger hashing algorithm for cryptographic purposes.

---

## Conclusion

This MD5 hashing tool is a simple and efficient implementation of the MD5 algorithm, suitable for basic integrity checking. For cryptographic or security-critical applications, stronger algorithms like SHA-256 are recommended.
