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
   - SHA-256  
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
  - `argparse` (for command-line argument parsing).  
- **Flutter**:  
  - `process_run` package for process management.  

---

## 4. Python Backend Structure  
### File Organization  
- `crypto_scripts/`  
  - `vigenere.py`  
  - `playfair.py`  
  - `aes.py`  
  - `rsa.py`  
  - `hashing.py`  

### Function Requirements  
All Python scripts **MUST** adhere to the following input/output conventions:  

#### **Input Format**  
- Accept arguments via command line using `argparse`.  
- Required arguments:  
  - `--operation` (`encrypt`, `decrypt`, or `hash`).  
  - `--input` (plaintext/ciphertext).  
  - `--key` (if applicable, e.g., AES key or Vigenère keyword).  

#### **Output Format**  
- Return results as a **JSON string** to stdout.  
- Example:  
  ```json
  { "status": "success", "result": "<encrypted_text>" }  

### Example Python code: 
```python
from Crypto.Cipher import AES  
import argparse  
import json  
import base64  

def aes_encrypt(plaintext, key):  
    # Implementation logic here  
    return ciphertext  

if __name__ == "__main__":  
    parser = argparse.ArgumentParser()  
    parser.add_argument("--operation", type=str, required=True)  
    parser.add_argument("--input", type=str, required=True)  
    parser.add_argument("--key", type=str, required=True)  
    args = parser.parse_args()  

    try:  
        if args.operation == "encrypt":  
            result = aes_encrypt(args.input, args.key)  
            print(json.dumps({"status": "success", "result": result}))  
        # Add decrypt logic  
    except Exception as e:  
        print(json.dumps({"status": "error", "message": str(e)}))  
```

## 7. Conclusion
This hybrid architecture leverages Flutter's rich UI capabilities and Python's robust cryptographic libraries, providing a flexible and scalable solution. By standardizing input/output formats and using process-based communication, the system ensures maintainability and ease of extension for new algorithms.