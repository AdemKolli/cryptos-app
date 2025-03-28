import random

def is_prime(num):
    if num < 2:
        return False
    for i in range(2, int(num ** 0.5) + 1):
        if num % i == 0:
            return False
    return True

def generate_prime():
    while True:
        num = random.randint(10, 500)  
        if is_prime(num):
            return num

def diffie_hellman():
    global N, G, x, y, shared_key_x, shared_key_y, secret_key
    N = G = 0  
    x = y = shared_key_x = shared_key_y = secret_key = None  

    print("\n==== Diffie-Hellman Key Exchange ====")
    print("Enter the values you know : ")
    print("1. N (Prime number)")
    print("2. G (G < N)")
    print("3. x")
    print("4. y")
    print("5. Shared key for x")
    print("6. Shared key for y")
    print("7. Generate random N")
    print("8. Generate random G")
    print("9. Calculate missing values")

    choice = []
    
    while '9' not in choice:
        user_input = input("Enter your choice: ")
        choice.append(user_input)
        
        if G > N and N != 0:
            print("G should be less than N, exiting...")
            exit()

        if user_input == '1':
            while True:
                N = int(input("Enter N (prime number): "))
                if is_prime(N):
                    break
                print("N must be a prime number. Please enter a valid prime.")
        elif user_input == '2':
            G = int(input("Enter G (G < N): "))
        elif user_input == '3':
            x = int(input("Enter x: "))
        elif user_input == '4':
            y = int(input("Enter y: "))
        elif user_input == '5':    
            shared_key_x = int(input("Enter shared key for x: "))
        elif user_input == '6':
            shared_key_y = int(input("Enter shared key for y: "))
        elif user_input == '7':
            N = generate_prime()
            print(f"Generated prime N: {N}")
        elif user_input == '8':
            G = random.randint(2, N - 1) if N > 2 else 2
            print(f"Generated G: {G}")
        elif user_input == '9':
            if ('1' in choice or '7' in choice) and ('2' in choice or '8' in choice):
                
                if '3' not in choice and '5' in choice:  # Calculate x if missing
                    for possible_x in range(N):  
                        if (G ** possible_x) % N == shared_key_x:
                            x = possible_x
                            print(f"Calculated x: {x}")
                            break
                    else:
                        print("Invalid shared key for x. Exiting...")
                        exit()

                if '4' not in choice and '6' in choice:  # Calculate y if missing
                    for possible_y in range(N):  
                        if (G ** possible_y) % N == shared_key_y:
                            y = possible_y
                            print(f"Calculated y: {y}")
                            break
                    else:
                        print("Invalid shared key for y. Exiting...")
                        exit()

                if '5' not in choice:
                    shared_key_x = (G ** x) % N
                if '6' not in choice:
                    shared_key_y = (G ** y) % N
                
                print(f"Shared key for x: {shared_key_x}")
                print(f"Shared key for y: {shared_key_y}")

                temp1 = (shared_key_y ** x) % N
                temp2 = (shared_key_x ** y) % N
                    
                if temp1 == temp2:
                    secret_key = temp1
                    print(f"All Values: \nN: {N}\nG: {G}\nx: {x}\ny: {y}\nShared key for x: {shared_key_x}\nShared key for y: {shared_key_y}\nSecret key: {secret_key}")
                else:
                    print("Error in calculation. The provided/shared values are inconsistent. Exiting...")
                    exit()
            else:
                print("Missing values, exiting...")
                exit()
        else:
            print("Invalid choice, exiting...")
            exit()

diffie_hellman()
