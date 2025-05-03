import sys
import random

# List of pre-defined prime numbers for better performance
PRIME_NUMBERS = [
    11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 
    83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 
    163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 
    241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 
    337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 
    431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499
]

def is_prime(num):
    """Check if a number is prime (using list lookup for better performance)."""
    return num in PRIME_NUMBERS

def generate_prime():
    """Generate a random prime number from the pre-defined list."""
    return random.choice(PRIME_NUMBERS)

def print_usage():
    print("Diffie-Hellman Key Exchange Algorithm", file=sys.stderr)
    print("", file=sys.stderr)
    print("Usage: python diffie_hellman.py key_exchange [options]", file=sys.stderr)
    print("", file=sys.stderr)
    print("Options (all optional, positional order matters):", file=sys.stderr)
    print("  N               Prime modulus", file=sys.stderr)
    print("  G               Base number (must be < N)", file=sys.stderr)
    print("  x               Alice's private key", file=sys.stderr)
    print("  y               Bob's private key", file=sys.stderr)
    print("  shared_key_x    Alice's shared key", file=sys.stderr)
    print("  shared_key_y    Bob's shared key", file=sys.stderr)
    print("", file=sys.stderr)
    print("Note: Omit any parameter to have it generated automatically", file=sys.stderr)
    print("      Parameters must be provided in order (can't skip earlier ones)", file=sys.stderr)
    print("", file=sys.stderr)
    print("Examples:", file=sys.stderr)
    print("  1. Full manual input:", file=sys.stderr)
    print("     python diffie_hellman.py key_exchange 23 5 6 15", file=sys.stderr)
    print("", file=sys.stderr)
    print("  2. Automatic generation with some inputs:", file=sys.stderr)
    print("     python diffie_hellman.py key_exchange 23 5 6 15", file=sys.stderr)
    print("", file=sys.stderr)
    print("  3. Calculate missing private key:", file=sys.stderr)
    print("     python diffie_hellman.py key_exchange 23 5 None 15 8 None", file=sys.stderr)

def main():
    if len(sys.argv) < 2 or sys.argv[1].lower() != "key_exchange":
        print_usage()
        sys.exit(1)

    try:
        # Parse positional arguments
        args = sys.argv[2:]
        N = int(args[0]) if len(args) > 0 and args[0].lower() != "none" else generate_prime()
        G = int(args[1]) if len(args) > 1 and args[1].lower() != "none" else (random.randint(2, N - 1) if N > 2 else 2)
        x = int(args[2]) if len(args) > 2 and args[2].lower() != "none" else None
        y = int(args[3]) if len(args) > 3 and args[3].lower() != "none" else None
        shared_key_x = int(args[4]) if len(args) > 4 and args[4].lower() != "none" else None
        shared_key_y = int(args[5]) if len(args) > 5 and args[5].lower() != "none" else None

        # Validate inputs
        if N < 11:
            raise ValueError("Prime number N must be at least 11")
        if not is_prime(N):
            raise ValueError("N must be a prime number from the predefined list")
        if G >= N:
            raise ValueError("G should be less than N")

        # Calculate missing values
        if N > 0 and G > 0:
            if x is None and shared_key_x is not None:  # Calculate x if missing
                for possible_x in range(N):  
                    if pow(G, possible_x, N) == shared_key_x:
                        x = possible_x
                        break
                else:
                    raise ValueError("Cannot derive x: shared_key_x is invalid for given G and N")

            if y is None and shared_key_y is not None:  # Calculate y if missing
                for possible_y in range(N):  
                    if pow(G, possible_y, N) == shared_key_y:
                        y = possible_y
                        break
                else:
                    raise ValueError("Cannot derive y: shared_key_y is invalid for given G and N")

            if shared_key_x is None and x is not None:
                shared_key_x = pow(G, x, N)
            if shared_key_y is None and y is not None:
                shared_key_y = pow(G, y, N)

            if x is not None and y is not None:
                temp1 = pow(shared_key_y, x, N)
                temp2 = pow(shared_key_x, y, N)
                    
                if temp1 == temp2:
                    secret_key = temp1
                else:
                    raise ValueError("Key mismatch: Derived keys from x and y do not match")
            else:
                raise ValueError("Missing x and/or y. Provide private keys or valid shared keys for both parties")

            # Print results in the same format as original JSON output but as plain text
            print("status: success")
            print(f"N: {N}")
            print(f"G: {G}")
            print(f"x: {x}")
            print(f"y: {y}")
            print(f"shared_key_x: {shared_key_x}")
            print(f"shared_key_y: {shared_key_y}")
            print(f"secret_key: {secret_key}")
        else:
            raise ValueError("Both prime number N and base G are required. Provide or generate them")

    except Exception as e:
        print("status: error")
        print(f"message: {str(e)}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()