alphabet = [chr(i) for i in range(65, 91)]  

def create_array(key: str, omit_letter: str):
    global array
    omit_letter = omit_letter.upper()
    key = key.upper().replace(omit_letter, '') 
    seen = []
    ordered_chars = []
    
    for char in key:  
        if char.isalpha() and char not in seen and char != omit_letter:
            seen.append(char)
            ordered_chars.append(char)
    
    for char in alphabet:  
        if char not in seen and char != omit_letter:
            seen.append(char)
            ordered_chars.append(char)
    
    array = []
    index = 0
    for i in range(5):
        row = []
        for j in range(5):
            row.append(ordered_chars[index])
            index += 1
        array.append(row)

def display_array():
    for row in array:
        for element in row:
            print(element, end=' ')
        print()

def encode(sentence: str):
    sentence = sentence.replace(' ', '').upper()
    for char in sentence:
        found = False
        for row in range(len(array)):
            for col in range(len(array[row])):
                if char == array[row][col]:
                    print(row + 1, col + 1, end='  ')
                    found = True
                    break
            if found:
                break

def valide_numbers(message):
    message = message.replace(' ', '')  
    if not message.isdigit() or len(message) % 2 != 0:
        return False  
    for char in message:
        if int(char) < 1 or int(char) > 5:
            return False  
    return True

def decode(message: str):
    message = message.replace(' ', '')
    if not valide_numbers(message):
        print("Invalid message")
        return
    for i in range(0, len(message), 2):
        row = int(message[i]) - 1
        col = int(message[i + 1]) - 1
        print(array[row][col], end=' ')
    print()

def polybe():
    global key, omit_letter, message
    
    print("\n==== Polybius Square Cipher Menu ====")
    print("1. Use default settings (no key, 'W' omitted)")
    print("2. Enter a custom key")
    print("3. Choose a letter to omit")
    
    choice = input("Enter your choice: ")
    
    if choice == '1':
        key = ""
        omit_letter = 'W'
        print("\nUsing default settings: No key, 'W' omitted.")
        print("1. Encode a message")
        print("2. Decode a message")
        print("3. Exit")
        
        sub_choice = input("Enter your choice: ")
        if sub_choice == '1' or sub_choice == '2':
            message = input("Enter a message: ")
            
            if sub_choice == '1':
                print("Encoding message...")
                create_array(key, omit_letter)
                display_array()
                encode(message)
            elif sub_choice == '2':
                print("Decoding message...")
                create_array(key, omit_letter)
                display_array()
                decode(message)
        elif sub_choice == '3':
            print("Exiting...")
            return
        else:
            print("Invalid choice. Please try again.")
            polybe()
    
    elif choice == '2':
        key = input("Enter a key: ")
        print("\n1. Choose a letter to omit")
        print("2. Use default omitted letter ('W')")
        print("3. Exit")
        
        sub_choice = input("Enter your choice: ")
        if sub_choice == '1':
            omit_letter = input("Enter a letter to omit: ")
            print("\n1. Encode a message")
            print("2. Decode a message")
            print("3. Exit")
            
            sub_sub_choice = input("Enter your choice: ")
            if sub_sub_choice == '1' or sub_sub_choice == '2':
                message = input("Enter a message: ")
                
                if sub_sub_choice == '1':
                    print("Encoding message...")
                    create_array(key, omit_letter)
                    display_array()
                    encode(message)
                elif sub_sub_choice == '2':
                    print("Decoding message...")
                    create_array(key, omit_letter)
                    display_array()
                    decode(message)
            elif sub_sub_choice == '3':
                print("Exiting...")
                return
            else:
                print("Invalid choice. Please try again.")
                polybe()
        
        elif sub_choice == '2':
            omit_letter = 'W'
            print("\nUsing default omitted letter: 'W'")
            print("1. Encode a message")
            print("2. Decode a message")
            print("3. Exit")
            
            sub_sub_choice = input("Enter your choice: ")
            if sub_sub_choice == '1' or sub_sub_choice == '2':
                message = input("Enter a message: ")
            
                if sub_sub_choice == '1':
                    print("Encoding message...")
                    create_array(key, omit_letter)
                    display_array()
                    encode(message)
                elif sub_sub_choice == '2':
                    print("Decoding message...")
                    create_array(key, omit_letter)
                    display_array()
                    decode(message)
            elif sub_sub_choice == '3':
                print("Exiting...")
                return
            else:
                print("Invalid choice. Please try again.")
                polybe()
        
        elif sub_choice == '3':
            print("Exiting...")
            return
        else:
            print("Invalid choice. Please try again.")
            polybe()
    
    elif choice == '3':
        omit_letter = input("Enter a letter to omit: ")
        print("\n1. Use default key (no key)")
        print("2. Enter a custom key")
        
        key_choice = input("Enter your choice: ")
        if key_choice == '1':
            key = ""
        elif key_choice == '2':
            key = input("Enter a key: ")
        else:
            print("Invalid choice. Please try again.")
            polybe()
        
        print("\n1. Encode a message")
        print("2. Decode a message")
        print("3. Exit")
        
        sub_choice = input("Enter your choice: ")
        if sub_choice == '1' or sub_choice == '2':
            message = input("Enter a message: ")
            if sub_choice == '1':
                print("Encoding message...")
                create_array(key, omit_letter)
                display_array()
                encode(message)
            elif sub_choice == '2':
                print("Decoding message...")
                create_array(key, omit_letter)
                display_array()
                decode(message)
        elif sub_choice == '3':
            print("Exiting...")
            return
        else:
            print("Invalid choice. Please try again.")
            polybe()
    
    else:
        print("Invalid choice. Please try again.")
        polybe()


polybe()