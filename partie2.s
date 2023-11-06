.text  
boucle : 
    mv t0,a1 #Dans t0, le retour des fonctions dim ou aug (0 par défaut)
    mv a0,t0
    li a7, 1   # Appel système pour afficher
    ecall
    
    
    # Attente de 500 ms (0.5 seconde)
    li a7, 32  # Appel système pour sleep
    li a0, 500  # 500 millisecondes (0.5 seconde)
    ecall
    
    lw t2,0xffff0000 #t2 : valeur du RCR (0 ou 1)
    lw t3,0xffff0004 #t3 : valeur du RDR (entree clavier)
    
    beqz t2,boucle #Si pas d'entrée, affiche le même t0
    
    #Test pour quel touche est pressée : 
    mv a1,t0
    li t4,105
    beq t3,t4,dim
    
    li t4,112
    beq t3,t4,aug
    
    li t4,111
    beq t3,t4,arret
    
    j boucle   
dim : 
    addi a1,a1,-1 
    j boucle

aug : 
    addi a1,a1,1
    j boucle
    
arret : 
    li a7, 10  # Appel système pour exit
    ecall