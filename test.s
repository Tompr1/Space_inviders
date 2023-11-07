#####################################################################  QUESTION 1 ##############################################################################

.data
# Définir les variables globales pour la largeur et la hauteur de l'image en pixels
image_width_pixels:   .word 256  # Largeur de l'image en pixels
image_height_pixels:  .word 256  # Hauteur de l'image en pixels

# Définir les variables globales pour la largeur et la hauteur des Units
unit_width_pixels:    .word 8    # Largeur des Units en pixels
unit_height_pixels:   .word 8    # Hauteur des Units en pixels

# Définir les variables globales pour la largeur et la hauteur de l'image en nombre de Units
I_largeur:  .word 0 # largeur de l'image en Units
I_hauteur:  .word 0 # hauteur de l'image en Units
I_dim: .word 0 	    # dimension de la fenetre
I_dimtaille : .word 0

# Définir la variable globale pour l'allocation

I_buff : .word 0

.text

#####################################################################  QUESTION 2 ##############################################################################
j main


################################################################## QUESTON 3 #######################################################################################

I_creer:
    # prologue
    addi sp, sp, -20  # Allocation de 4 registres dans le tas
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    # Calculer la taille de la mémoire image (en octets)
    lw s0,image_width_pixels
    lw s1,unit_width_pixels
    div s0,s0,s1
    sw s0,I_largeur,s1
    
    lw s0,image_height_pixels
    lw s1,unit_height_pixels
    div s0,s0,s1
    sw s0,I_hauteur,s1	#s0 : I_hauteur
    
    lw s1,I_largeur	#s1 : I_largeur
    
    
    mul s2, s0, s1  # Multiplication de I_largeur et I_hauteur
    sw s2,I_dim,s0
    slli s2, s2, 2  # Multiplication par 4 pour obtenir la taille en octets
    sw s2, I_dimtaille,s3  # Stockage de la taille de mémoire dans I_dimtaille

    # Appel système pour allouer de la mémoire
    li a7, 9          # Appel système pour sbrk (9)
    mv a0, s2         # Taille de mémoire à allouer
    ecall             # Appel système

    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20  # Libération de la mémoire allouée pour les registres

    jr ra

    
    
################################################################## QUESTON 4 #######################################################################################
    
#Fonction I_xy_to_addr

I_xy_to_addr:
#Entrees : a0 abscisse ; a1 ordonnee
#Sortie : a0 adresse

# prologue 
addi sp, sp, -16 # allocation de 4 registres dans le tas
  sw s0, 0(sp)
  sw s1, 4(sp)
  sw s2, 8(sp)
  sw ra,12(sp)
  # chargement de la largeur et de la hauteur de l'image
  lw s0, I_largeur # chargement de I_largeur dans s0
  
# ########coeur de la focntion

mul s1,a1,s0 # Multiplication de l'ordonnée par I_largeur
add s1,a0,s1 # Résultat :  Ajoute l'abscisse à l'ordonnée pour obtenir l'adresse
slli s1,s1,2

lw s2,I_buff
add a0,s1,s2

# Epilogue 

# libération de la mémoire pour s0 à s3

lw s2, 8(sp)
lw s1, 4(sp)
lw s0, 0(sp)
lw ra,12(sp)
addi sp,sp,16

jr ra 


################################################################## QUESTON 5 #######################################################################################


# Fonction I_addr_to_xy
I_addr_to_xy:

# prologue 
  addi sp, sp, -16 	# allocation de 4 registres dans le tas
  sw s0, 0(sp)
  sw s1, 4(sp)
  sw s2, 8(sp)
  sw s3, 12(sp)
  lw s1, I_largeur 	# chargement de I_largeur dans s1
  mv s0, a0 		# Charger l'adresse de l'entier en argument
  
 # coeur de la fonction
 li a1,0		# Initialiser l'ordonnée y à zéro
 li s2, 0		# Initialiser le quotient q à zéro
 	    # Calcule de l'abscisse  
 mul s3,a1,s2
 sub a0,s0,s3 		# Résultat : abscisse x
 
 calcul_ord : 
 	sub s0,s0,s1	#soustraction de largeur à image 
 	blt s0,zero,fin_ord	#verif si y est trouvé ou non
 	addi a1,a1,1	#ajout de 1 à ordonnée
 	addi s2,s2,1	#ajout de 1 à quotient
 	j calcul_ord	#boucle pour trouver ord
 	
 fin_ord:
 sub a1,a1,s2		# soustraction du quotient dans l'ordonnée
 
 #epilogue 
 
lw s3, 12(sp)
lw s2, 8(sp)
lw s1, 4(sp)
lw s0, 0(sp)
addi sp,sp,16

jr ra 

################################################################## QUESTON 6 #######################################################################################

I_plot :
#Entrees : a0 abscisse, a1 ordonnee, a2 couleur

# prologue
addi sp, sp, -8 	# allocation de 4 registres dans le tas + le registre ra
sw ra, 0(sp)
sw a0, 4(sp)


# coeur de la fonction
jal I_xy_to_addr	# appel de la I_xy_to_addr et stock le resultat dans ra 
sw a2, 0(a0)		# Stocker la couleur à l'adresse obtenue

#prologue 
lw ra, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8

jr ra

# Dans cette fonction, j'ai fait le choix de représenter un pixel par son abscisse et son ordonnée car je trouve plus simple de
# manipulation que l'adresse. j'arrive mieux à me situer en utilisant des valeurs pour abscisse et ordonnée plutot qu'une adresse mémoire
# qu'il faudra que je traduise par la suite. Enfin je peux me représenter plus facilement mon choix sur un papier plutot qu'une adresse.




 ################################################################## QUESTON 7 #######################################################################################
 	
 
 
 


# Point d'entrée du programme
main:
    
    jal I_creer
    sw a0,I_buff,s0
    

    # Appeler la fonction I_plot pour dessiner un pixel rouge à la position (10, 15)
    li a0, 1   # Abscisse (x)
    li a1, 1    # Ordonnée (y)
    li a2, 0x00ff0000  # Couleur rouge
    jal I_plot

    # Fin du programme
    li a7, 10   # Appel système pour terminer le programme
    ecall
