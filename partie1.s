li t1,1

boucle:
    # Affiche la valeur dans a0
    mv a0,t1
    li a7, 1   # Appel système pour afficher
    ecall

    # Attente de 500 ms (0.5 seconde)
    li a7, 32  # Appel système pour sleep
    mv t1, a0
    li a0, 500  # 500 millisecondes (0.5 seconde)
    ecall

    # Incrémente la valeur
    addi t1, t1, 1

    # Vérifie si nous avons atteint 10
    li t0, 11 
    bne t1, t0, boucle

    # Terminaison du programme
    li a7, 10  # Appel système pour exit
    ecall
