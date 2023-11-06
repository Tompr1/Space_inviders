#####################################################################  QUESTION 1 ##############################################################################

.data
# Définir les variables globales pour la largeur et la hauteur de l'image en pixels
image_width_pixels:   .word 512  # Largeur de l'image en pixels
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

# Charger les valeurs des variables
lw s0, image_width_pixels    # Charger la largeur de l'image en pixels dans t0
lw s1, image_height_pixels   # Charger la hauteur de l'image en pixels dans t1
lw s2, unit_width_pixels    # Charger la largeur des Units en pixels dans t2
lw s3, unit_height_pixels   # Charger la hauteur des Units en pixels dans t3
lw s4, I_largeur
lw s5, I_hauteur

# Calculer I_largeur (largeur de l'image en nombre de Units)
div s4, s0, s2   # Diviser la largeur de l'image en pixels par la largeur des Units en pixels et stocke le quotient dans t4 (I_largeur)
sw s4, I_largeur,s6   # Enregistrer I_largeur dans la variable globale

# Calculer I_hauteur (hauteur de l'image en nombre de Units)
div s5, s1, s3   # Diviser la hauteur de l'image en pixels par la hauteur des Units en pixels et stocke le quotient dans t5 (I_hauteur)
sw s5, I_hauteur,s6   # Enregistrer I_hauteur dans la variable globale

################################################################## QUESTON 3 #######################################################################################

I_creer : 
#prologue 
  addi sp, sp, -20 # allocation de 5 registres dans le tas
  sw s0, 0(sp)
  sw s1, 4(sp)
  sw s2, 8(sp)
  sw s3, 12(sp)
  sw s4, 16(sp)
  lw s0, I_largeur # chargement de I_largeur dans s0
  lw s1, I_hauteur# chargement de I_hauteur dans s0
  li s2, 0
  li s3, 0

# Calculer la taille de la mémoire image (en octets)
  mul s2,s0, s1 	# Multiplication de I_largeur et I_hauteur
  slli s3,s2,2		# Multiplication par 4
  sw s2,I_dim,s4	# stockage de s2 dans I_dim
  sw s3,I_dimtaille,s4	#stockage de s3 dans I_dimtaille
  
# Appel système pour allouer de la mémoire
  li a7, 9          # Appel système pour sbrk (9)
  mv a0, s3         # Taille de mémoire à allouer
  ecall             # Appel système
  
  
  
# epilogue

    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp,sp,20
    # libération de la mémoire pour s0 à s4
    

    jr ra
    
    
################################################################## QUESTON 4 #######################################################################################
    
#Fonction I_xy_to_addr

I_xy_to_addr:


# prologue 
addi sp, sp, -16 # allocation de 4 registres dans le tas
  sw s0, 0(sp)
  sw s1, 4(sp)
  sw s2, 8(sp)
  sw s3, 12(sp)
  # chargement de la largeur et de la hauteur de l'image
  lw s0, I_largeur # chargement de I_largeur dans s0
  
# ########coeur de la focntion

# chargement des adresses 
mv s2, a0 #abscisse
mv s3, a1 #ordonnée

mul s3,s3,s0 # Multiplication de l'ordonnée par I_largeur
add a0,s2,s3 # Résultat :  Ajoute l'abscisse à l'ordonnée pour obtenir l'adresse

# Epilogue 

# libération de la mémoire pour s0 à s3


lw s3, 12(sp)
lw s2, 8(sp)
lw s1, 4(sp)
lw s0, 0(sp)
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

# prologue
addi sp, sp, -20 	# allocation de 4 registres dans le tas + le registre ra
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)
sw s3, 16(sp)

# chargement des arguments dans les registres 
 mv s0, a0  		# Abscisse x
 mv s1, a1  		# Ordonnée y

# coeur de la fonction
jal ra, I_xy_to_addr	# appel de la I_xy_to_addr et stock le resultat dans ra 
mv s2, a2 		# chargement de la couleur dans t2
sw s2, 0(ra)		# Stocker la couleur à l'adresse obtenue

#prologue 
lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
lw s3, 16(sp)
addi sp, sp, -20

jr ra

# Dans cette fonction, j'ai fait le choix de représenter un pixel par son abscisse et son ordonnée car je trouve plus simple de
# manipulation que l'adresse. j'arrive mieux à me situer en utilisant des valeurs pour abscisse et ordonnée plutot qu'une adresse mémoire
# qu'il faudra que je traduise par la suite. Enfin je peux me représenter plus facilement mon choix sur un papier plutot qu'une adresse.




 ################################################################## QUESTON 6 #######################################################################################
 	
 
 
 
