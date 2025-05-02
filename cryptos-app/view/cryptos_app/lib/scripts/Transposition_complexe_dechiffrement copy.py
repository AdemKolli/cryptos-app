

def columnar_transposition_decrypt(ciphertext, key):
    # Déterminer le nombre de colonnes
    num_columns = len(key)
    
    # Déterminer le nombre de lignes
    num_rows = len(ciphertext) // num_columns
    
    # Déterminer l'ordre des colonnes en fonction de la clé
    key_order = sorted(range(len(key)), key=lambda k: key[k])
    
    # Reconstruire la grille
    grid = [['' for _ in range(num_columns)] for _ in range(num_rows)]
    
    # Remplir la grille avec le texte chiffré
    index = 0
    for col in key_order:
        for row in range(num_rows):
            if index < len(ciphertext):
                grid[row][col] = ciphertext[index]
                index += 1
    
    # Lire la grille ligne par ligne pour retrouver le texte en clair
    plaintext = ""
    for row in grid:
        plaintext += ''.join(row)
    
    # Supprimer les caractères de remplissage (par exemple 'X')
    plaintext = plaintext.rstrip('X')
    
    return plaintext

def main():
    
    ciphertext = input("Entrez le texte chiffré : ").upper().replace(" ", "") 
    key = input("Entrez la clé : ").upper().replace(" ", "")  

    
    print("\nTexte chiffré :", ciphertext)
    print("Clé :", key)

 
    plaintext = columnar_transposition_decrypt(ciphertext, key)

   
    print("Texte déchiffré :", plaintext)


if __name__ == "__main__":
    main()