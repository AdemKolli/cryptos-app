import sys
import random

PRIME_NUMBERS = [
    11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 
    83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 
    163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 
    241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 
    337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 
    431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499
]

def is_prime(n):
    return n in PRIME_NUMBERS

def generate_prime():
    return random.choice(PRIME_NUMBERS)

def to_int(val):
    try:
        return int(val)
    except:
        return None

def print_usage():
    print("Usage: python diffie_hellman.py key_exchange [N] [G] [x] [y] [shared_key_x] [shared_key_y]", file=sys.stderr)

def main():
    if len(sys.argv) < 2:
        print_usage()
        sys.exit(1)

    operation = sys.argv[1].lower()
    if operation != "key_exchange":
        print("Invalid operation. Use 'key_exchange'.", file=sys.stderr)
        sys.exit(1)

    # Read optional parameters
    args = sys.argv[2:]
    N = to_int(args[0]) if len(args) > 0 else generate_prime()
    G = to_int(args[1]) if len(args) > 1 else random.randint(2, N - 1)
    x = to_int(args[2]) if len(args) > 2 else None
    y = to_int(args[3]) if len(args) > 3 else None
    shared_key_x = to_int(args[4]) if len(args) > 4 else None
    shared_key_y = to_int(args[5]) if len(args) > 5 else None

    if not is_prime(N):
        print("N must be a valid predefined prime.", file=sys.stderr)
        sys.exit(1)
    if G >= N:
        print("G must be less than N.", file=sys.stderr)
        sys.exit(1)

    try:
        # Recover private keys from shared keys if needed
        if x is None and shared_key_x is not None:
            for i in range(N):
                if pow(G, i, N) == shared_key_x:
                    x = i
                    break
        if y is None and shared_key_y is not None:
            for i in range(N):
                if pow(G, i, N) == shared_key_y:
                    y = i
                    break

        # Generate shared keys if private keys are available
        if shared_key_x is None and x is not None:
            shared_key_x = pow(G, x, N)
        if shared_key_y is None and y is not None:
            shared_key_y = pow(G, y, N)

        # Final secret key
        if x is not None and shared_key_y is not None:
            secret1 = pow(shared_key_y, x, N)
        else:
            secret1 = None

        if y is not None and shared_key_x is not None:
            secret2 = pow(shared_key_x, y, N)
        else:
            secret2 = None

        if secret1 is not None and secret2 is not None and secret1 != secret2:
            print("Mismatch in computed secrets. Key exchange failed.", file=sys.stderr)
            sys.exit(1)

        print(f"N = {N}")
        print(f"G = {G}")
        if x is not None: print(f"Alice private x = {x}")
        if y is not None: print(f"Bob private y = {y}")
        if shared_key_x is not None: print(f"Alice public key (G^x mod N) = {shared_key_x}")
        if shared_key_y is not None: print(f"Bob public key (G^y mod N) = {shared_key_y}")
        if secret1 is not None: print(f"Shared secret = {secret1}")
        elif secret2 is not None: print(f"Shared secret = {secret2}")
        else: print("Not enough information to compute the shared secret.")

    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
