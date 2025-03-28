def columnar_transposition_encrypt(plaintext, key):
 
    num_columns = len(key) 
    
    
    while len(plaintext) % num_columns != 0:
        plaintext += 'X' 
   
    grid = []
    for i in range(0, len(plaintext), num_columns):
        grid.append(list(plaintext[i:i + num_columns]))
    
    # Déterminer l'ordre des colonnes en fonction de la clé
    key_order = sorted(range(len(key)), key=lambda k: key[k])
    
    # Lire les colonnes dans l'ordre spécifié pour produire le texte chiffré
    ciphertext = ""
    for col in key_order:
        for row in grid:
            ciphertext += row[col]
    
    return ciphertext




def main():
 
    plaintext = input("Entrez le texte clair : ").upper().replace(" ", "")  # Convertir en majuscules et supprimer les espaces
    key = input("Entrez la clé : ").upper().replace(" ", "")  
    
    
    ciphertext = columnar_transposition_encrypt(plaintext, key)
    
   
    print("\nTexte clair :", plaintext)
    print("Texte chiffré :", ciphertext)


if __name__ == "__main__":
    main()