# Cryptos-App - Project Documentation 

## 1. Overview  
**Cryptos-App** is a cross-platform desktop application combining a **Flutter-based GUI** with **Python backend logic** for cryptographic operations. The app enables users to encrypt/decrypt data using classical and modern algorithms, with seamless communication between the Flutter interface and Python scripts via the `Process` class.  

---

## 2. Features  
### Supported Cryptographic Methods  
#### **Classical Cryptography**  
1. **Substitution Ciphers**  
   - Vigenère Cipher  
   - Playfair Cipher  
2. **Transposition Ciphers**  
   - Columnar Transposition  

#### **Modern Cryptography**  
1. **Symmetric Key Algorithms**  
   - AES (Advanced Encryption Standard)  
2. **Asymmetric Key Algorithms**  
   - RSA (Key generation, encryption/decryption)  
3. **Hashing**
   - SHA-256, MD5  
4. **Diffie-Hellman Algorithm**  

### Core Functionalities  
- Algorithm selection via Flutter dropdown menu.  
- Text encryption/decryption with real-time results.  
- Key input fields (where applicable).  
- Error handling for invalid inputs.  

---

## 3. Technical Specifications  
### Architecture  
- **Frontend**: Flutter (Desktop compatible) for GUI.  
- **Backend**: Python scripts for cryptographic logic.  
- **Communication**: Flutter `Process` class to execute Python scripts with arguments.  

### Dependencies  
- **Python**:   
  - `sys` (for command-line argument parsing).  
- **Flutter**:  
  - `process_run` package for process management.  

---

## 4. Python Backend Structure  
### File Organization  
- `scripts/`  
  - `vigenere.py`  
  - `playfair.py`  
  - `aes.py`  
  - `rsa.py`  
  - `hashing.py`
  - ...  

### Function Requirements  
All Python scripts **MUST** adhere to the following input/output conventions:  

#### **Input Format**  
- Accept arguments via command line using `sys`.  
- Required arguments:  
  - `encode`, `decode`, or `hash`.  
  - plaintext/ciphertext.  
  - if applicable, e.g., AES key or Vigenère keyword.  

#### **Output Format**  
- Return results as a **Plain text string** to stdout.  
- Example for encryption with a `<key>`:  
  ```
  <encrypted_text>  

### Example Python code: 
```python  
import sys  

def aes_encrypt(plaintext, key):  
    # Implementation logic here  
    return ciphertext  

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python aes128.py [encode|decode] [text] [key]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]
    key = sys.argv[3]

    if operation == "encode":
        print(aes_encrypt_string(text, key))
    elif operation == "decode":
        print(aes_decrypt_string(text, key))
    else:
        print("Invalid operation. Use 'encode' or 'decode'.", file=sys.stderr)
        sys.exit(1)  
```

## 7. Conclusion
This hybrid architecture leverages Flutter's rich UI capabilities and Python's robust cryptographic libraries, providing a flexible and scalable solution. By standardizing input/output formats and using process-based communication, the system ensures maintainability and ease of extension for new algorithms.