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
sw s4, I_largeur   # Enregistrer I_largeur dans la variable globale

# Calculer I_hauteur (hauteur de l'image en nombre de Units)
div s5, s1, s3   # Diviser la hauteur de l'image en pixels par la hauteur des Units en pixels et stocke le quotient dans t5 (I_hauteur)
sw s5, I_hauteur   # Enregistrer I_hauteur dans la variable globale

################################################################## QUESTON 3 #######################################################################################

I_creer : 
#prologue
  addi sp, sp, -20
  sw s0, 0(sp)
  sw s1, 4(sp)
  sw s2, 8(sp)
  sw s3, 12(sp)
  sw s4, 16(sp)
  lw s0, I_largeur
  lw s1, I_hauteur
  li s2, 0
  li s3, 0

# Calculer la taille de la mémoire image (en octets)
  mul s2,s0, s1 	# Multiplication de I_largeur et I_hauteur
  slli s3,s2,2
  sw s2,I_dim,s4
  sw s3,I_dimtaille,s4
  
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

    jr ra
    




  
