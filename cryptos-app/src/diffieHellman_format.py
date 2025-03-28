import random
import argparse
import json

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

def diffie_hellman():
    """
    Diffie-Hellman Key Exchange Algorithm
    
    This implementation allows for partial inputs and calculates missing values.
    All parameters are optional except --operation=key_exchange.
    
    Usage:
        python diffie_hellman.py --operation key_exchange [options]
    
    Options:
        --operation key_exchange  Required (only valid operation)
        --N <prime_number>        Prime modulus (optional)
        --G <number>              Base number (optional, must be < N)
        --x <number>              Alice's private key (optional)
        --y <number>              Bob's private key (optional)
        --shared_key_x <number>   Alice's shared key (optional)
        --shared_key_y <number>   Bob's shared key (optional)
        --generate_N              Generate random prime N (optional)
        --generate_G              Generate random base G (optional)
    
    Examples:
        1. Full manual input:
        python diffieHellman_format.py --operation key_exchange --N 23 --G 5 --x 6 --y 15
        
        2. Automatic generation with some inputs:
        python diffieHellman_format.py --operation key_exchange --generate_N --generate_G --x 6 --y 15
        
        3. Calculate missing private key:
        python diffieHellman_format.py --operation key_exchange --N 23 --G 5 --shared_key_x 8 --y 15
    """
    global N, G, x, y, shared_key_x, shared_key_y, secret_key
    N = G = 0  
    x = y = shared_key_x = shared_key_y = secret_key = None  

    parser = argparse.ArgumentParser(description="Diffie-Hellman Key Exchange Algorithm")
    parser.add_argument("--operation", type=str, required=True)
    parser.add_argument("--N", type=int, required=False)
    parser.add_argument("--G", type=int, required=False)
    parser.add_argument("--x", type=int, required=False)
    parser.add_argument("--y", type=int, required=False)
    parser.add_argument("--shared_key_x", type=int, required=False)
    parser.add_argument("--shared_key_y", type=int, required=False)
    parser.add_argument("--generate_N", action='store_true', required=False)
    parser.add_argument("--generate_G", action='store_true', required=False)
    args = parser.parse_args()

    try:
        if args.operation != "key_exchange":
            raise ValueError("Operation must be 'key_exchange' for Diffie-Hellman")

        if args.generate_N:
            N = generate_prime()
        elif args.N:
            N = args.N
            if not is_prime(N):
                raise ValueError("N must be a prime number")

        if args.generate_G:
            if N == 0:
                raise ValueError("N must be set before generating G")
            G = random.randint(2, N - 1) if N > 2 else 2
        elif args.G:
            G = args.G
            if N > 0 and G >= N:
                raise ValueError("G should be less than N")

        if args.x:
            x = args.x
        if args.y:
            y = args.y
        if args.shared_key_x:
            shared_key_x = args.shared_key_x
        if args.shared_key_y:
            shared_key_y = args.shared_key_y

        # Calculate missing values
        if N > 0 and G > 0:
            if x is None and shared_key_x is not None:  # Calculate x if missing
                for possible_x in range(N):  
                    if pow(G, possible_x, N) == shared_key_x:
                        x = possible_x
                        break
                else:
                    raise ValueError("Invalid shared key for x")

            if y is None and shared_key_y is not None:  # Calculate y if missing
                for possible_y in range(N):  
                    if pow(G, possible_y, N) == shared_key_y:
                        y = possible_y
                        break
                else:
                    raise ValueError("Invalid shared key for y")

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
                    raise ValueError("Inconsistent values - calculation error")
            else:
                raise ValueError("Missing required values for complete key exchange")

            result = {
                "N": N,
                "G": G,
                "x": x,
                "y": y,
                "shared_key_x": shared_key_x,
                "shared_key_y": shared_key_y,
                "secret_key": secret_key
            }
            print(json.dumps({"status": "success", "result": result}))
        else:
            raise ValueError("Missing required prime number (N) and base (G)")

    except Exception as e:
        print(json.dumps({"status": "error", "message": str(e)}))

if __name__ == "__main__":
    diffie_hellman()