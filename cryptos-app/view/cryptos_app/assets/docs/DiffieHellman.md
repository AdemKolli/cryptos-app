# Diffie-Hellman Algorithm

**Diffie-Hellman** is a key exchange algorithm that allows two parties to securely establish a shared secret over an insecure channel. It is based on the computational difficulty of solving discrete logarithms in modular arithmetic.

---

## How It Works

---

### 1. Key Exchange Function (`diffie_hellman()`)

Performs the secure key exchange between two parties (commonly referred to as Alice and Bob).

---

### Input Parameters

- `N`: A large prime number (the modulus).
- `G`: A base (primitive root modulo `N`).
- `x`: Alice’s private key.
- `y`: Bob’s private key.
- `shared_key_x`: Alice’s public key (optional).
- `shared_key_y`: Bob’s public key (optional).

---

### Key Generation Steps

- If `shared_key_x` is not provided:
  - Alice's public key is computed as:  
    `shared_key_x = G^x mod N`

- If `shared_key_y` is not provided:
  - Bob's public key is computed as:  
    `shared_key_y = G^y mod N`

---

### Shared Secret Derivation

- Alice derives the shared secret using:  
  `secret_key = (shared_key_y)^x mod N`

- Bob derives the same secret using:  
  `secret_key = (shared_key_x)^y mod N`

If both calculations yield the same result, a shared secret key has been successfully established.

---

### Features

- Supports:
  - Manual input of private/public keys and parameters.
  - Automatic generation of prime `N` and base `G` when not supplied.

- Validates and completes missing parameters when possible to ensure consistency.

---

### Output

Returns a JSON object containing:

- `N`, `G`, `x`, `y`
- `shared_key_x`, `shared_key_y`
- `secret_key`

---

### Notes

- The security of Diffie-Hellman relies on the difficulty of the discrete logarithm problem.
- This algorithm is commonly used as part of more complex protocols (e.g., TLS).
- It is vulnerable to **Man-in-the-Middle (MITM)** attacks if not authenticated.

