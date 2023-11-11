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
I_visu : .word 0

# définir le rectangle pour l'animation de gauche à droite : 
rect_ABSDEB : .word 0
rect_ABSFIN : .word 3
rect_ORDDEB : .word 12
rect_ORDFIN : .word 15

saut_Anim : .word 0

.text

#####################################################################  QUESTION 2 ##############################################################################
j main


################################################################## QUESTON 3 #######################################################################################

I_creer:
##################
## entree : variables globales, 
## sortie : allocation de la mémoire image 
###############

    # prologue
    addi sp, sp, -20  # Allocation de 5 registres dans le tas
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

#Entree : a0 adresse 
#Sorties : a0 : abscisse a1 : ordonnée 

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
#Sortie : a0 : adresse su pixel avec une couleur 

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
 	
 I_effacer : 
 
 #Entree : rien 
 #sortie : a0 adresse de l'image avec des pixels noirs 
 
 # prologue 
 
addi sp, sp, -24	# allocation de 5 registres dans le tas + le registre ra
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)
sw s3, 16(sp)
sw s4, 20(sp)

# coeur de la fonction 

li s0,0			#abscisse 
li s1,0			#ordonnée
li s2,0x00000000	#couleur noir
boucle_effacer : 
# Appel I_plot pour colorier le pixel avec la couleur noire
    
    mv a0, s0  		# Coordonnée abscisse
    mv a1, s1  		# Coordonnée ordonnée
    mv a2, s2  		# Couleur noire
    jal I_plot
    
    # Incrémententation abscisse
    addi s0, s0, 1
    # Vérifier si on est au bout de la ligne
    lw s3,I_largeur   # Largeur d'une Unit en pixels
    bne s0, s3, boucle_effacer  # Si abscisse n'a pas atteint la largeur d'une Unit, continuer
    # Réinitialisation pour si on a atteint le bout et ajout colonne
    li s0, 0
    addi s1, s1, 1
    # Vérifier si toutes les lignes ont été effacées
    lw s4, I_hauteur   # Hauteur d'une Unit en pixels
    bne s1, s4, boucle_effacer  # Si ordonnée n'a pas atteint la hauteur d'une Unit, continuer
    
    
 # epilogue 
lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
lw s3, 16(sp)
lw s4, 20(sp)
addi sp, sp, 24
jr ra

 ################################################################## QUESTON 8 #######################################################################################

 I_rectangle : 
#Entrees : a0 : abscisse du coin gauche, a1: ordonnée du coin gauche, 
#a2 : largeur du rectangle, a3 : hauteur du rectangle, a4 : couleur du rectangle
#Sortie : --

#prologue
addi sp, sp, -36	# allocation de 5 registres dans le tas + le registre ra
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)
sw s3, 16(sp)
sw s4, 20(sp)
sw s5, 24(sp)
sw s6,28(sp)
sw s7,32(sp)

# coeur de la fonction 

## Récupérer les paramètres a0 à a4
mv s0, a0  # t0 : abscisse du coin supérieur gauche
mv s1, a1  # t1 : ordonnée du coin supérieur gauche
mv s2, a2  # t2 : largeur du rectangle
mv s3, a3  # t3 : hauteur du rectangle
mv s4, a4  # t4 : couleur du rectangle
mv s5,s0	#s5 : sauvergarde abscisse
add s6,s0,s2	#s6 : indice fin boucle colonne
add s7,s1,s3	#s7 : indice fin boucle ligne

    
dessiner_ligne:
    
mv a0, s0  # Coordonnée abscisse
mv a1, s1  # Coordonnée ordonnée
mv a2, s4  # Couleur du rectangle
jal I_plot
    
# Incrémenter l'abscisse pour passer à la colonne suivante
addi s0, s0, 1

# Vérifier si toutes les lignes du rectangle ont été dessinées

bge s0, s6, reinitialiser_abscisse  # Si la ligne a été dessinées, réinitialiser l'abscisse et passer à la ligne suivante
j dessiner_ligne


reinitialiser_abscisse:
mv s0,s5
addi s1,s1,1
# Vérifier si toutes les lignes du rectangle ont été dessinées
bge s1, s7, fin_dessin  # Si toutes les lignes ont été dessinées, terminer
j dessiner_ligne



fin_dessin:
lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
lw s3, 16(sp)
lw s4, 20(sp)
lw s5, 24(sp)
lw s6,28(sp)
lw s7,32(sp)
addi sp, sp, 36
jr ra
 
 ################################################################## QUESTON 9 #######################################################################################
 



 I_rectangleAnim: #horizontal
 
#Entrees : a0 : abscisse du coin gauche, a1: ordonnée du coin gauche, 
#a2 : largeur du rectangle, a3 : hauteur du rectangle, a4 : couleur du rectangle
#Sortie : --
 
 # prologue
 addi sp, sp, -28	# allocation de 5 registres dans le tas + le registre ra
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)
sw s3, 16(sp)
sw s4, 20(sp)
sw s6, 24(sp)


# coeur de la fonction 

##recuperation des valeurs 
mv s0, a0
mv s1, a1
mv s2, a2
mv s3, a3
mv s4, a4
li s6, 27
sub s6,s6,s0
  


## boucle anim
boucle_anim: 
### init des champs
mv a0, s0 	#abs_g
mv a1, s1	#abs_d
mv a2, s2	#ord_haut
mv a3, s3	#ord_bas
mv a4, s4	#couleur
jal I_rectangle
### wait
li a7, 32
li a0, 50 #wait 500ms
ecall

jal I_effacer 
### calcul du prochain affichage
addi s0, s0,1 	# abs_d + abs_d
bgt s0, s6, animation_ok  # Si le rectangle est sorti de l'écran ou qu'il ne peut pas en dessiner , terminer l'animation

j boucle_anim

#epilogue 
## libération mémoire
animation_ok:
lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
lw s3, 16(sp)
lw s4, 20(sp)
lw s6, 24(sp)
addi sp, sp, 28
jr ra

# l'animation n'est pas fluide du tout 


 ################################################################## QUESTON 10 #######################################################################################

I_buff_to_visu:
 #Entrees : variables globales 
#Sortie : variables globales
    # prologue
    addi sp, sp, -20  # allocation de 2 registres dans le tas
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    # Copier les données de I_buff dans I_visu
    lw s0, I_buff
    lw s1, I_visu
    li s2, 0  # Initialiser l'indice de copie
    lw s3, I_dimtaille

    copie_data:
        lw t0, 0(s0)  # Charger un mot depuis I_buff
        sw t0, 0(s1)  # Stocker le mot dans I_visu
        addi s0, s0, 4  # Avancer à l'adresse suivante dans I_buff
        addi s1, s1, 4  # Avancer à l'adresse suivante dans I_visu
        addi s2, s2, 1  # Incrémenter l'indice de copie

        # Condition de sortie de la boucle
        blt s2, s3, copie_data  # Copier 256 mots (taille de l'image)

    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20  # libération de la mémoire allouée pour les registres
    jr ra

 ################################################################## QUESTON 11 #######################################################################################
 
 I_animer_rectangle_double_buffer:
  #Entrees : a0 : abscisse du coin gauche, a1: ordonnée du coin gauche, 
#a2 : largeur du rectangle, a3 : hauteur du rectangle, a4 : couleur du rectangle
#Sortie : --

    # prologue
    addi sp, sp, -36  # allocation de 3 registres dans le tas
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s6, 24 (sp) 
    sw s7, 28 (sp)  
    sw s8,32(sp)
    
       



    
    ##recuperation des valeurs 
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    lw s6, I_buff
    lw s7, I_visu
    li s8,27

    # Boucle d'animation
    boucle_animation:
        # Effacer le rectangle dans I_buff à sa position actuelle
        jal I_effacer

        # Dessiner le rectangle dans I_buff à sa nouvelle position
        mv a0, s0  # Abscisse
        mv a1, s1  # Ordonnée
        mv a2, s2  # Largeur du rectangle
        mv a3, s3  # Hauteur du rectangle
        mv a4, s4  # Couleur du rectangle
        jal I_rectangle

        # Transférer les données de I_buff dans I_visu
        mv a0, s6
        mv a1, s7
        jal I_buff_to_visu

        # Mettre à jour les coordonnées pour le déplacement
        addi s0, s0, 1

        # Pause ou attente pour la simulation du temps (ajustez selon vos besoins)
        li a7, 32  # Appel système pour sleep
        li a0, 50  # Temps d'attente en microsecondes
        ecall

        # Condition de sortie de la boucle (rectangle arrivé à destination)
        #bne s0, s2, boucle_animation
        #bne s1, s3, boucle_animation
         bgt s0, s8, anim_buff_ok
         j boucle_animation

    # epilogue
anim_buff_ok: 
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s6, 24 (sp) 
    lw s7, 28 (sp)
    lw s8,32(sp)  
    
    addi sp, sp, 36  # libération de la mémoire allouée pour les registres
    jr ra
    
    
#########################################################################################################################################################################################
 
 
# Point d'entrée du programme
main:
    
    jal I_creer
    sw a0,I_visu,s0
    jal I_creer
    sw a0,I_buff,s0
    
    
    

    # Appeler la fonction I_plot pour dessiner un pixel rouge à la position (10, 15)
    #li a0, 1   # Abscisse (x)
    #li a1, 1    # Ordonnée (y)
    #li a2, 0x00ff0000  # Couleur rouge
    #jal I_effacer
    
    li a0,0	#abscisse haut gauche
    li a1,12 	#ordonnée debut 
    li a2,5	#abscisse haut droit
    li a3,5	#ordonnée fin
    li a4, 0x00ff0000	#couleur
    
    

    
    
    #jal I_rectangle
    #jal I_rectangleAnim
    #jal I_buff_to_visu
    jal I_animer_rectangle_double_buffer

    # Fin du programme
    li a7, 10   # Appel système pour terminer le programme
    ecall
