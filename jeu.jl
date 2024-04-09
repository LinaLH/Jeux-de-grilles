using JuMP
using Cbc

function resoudre_et_dessiner_grille_pointillee(grille_dim, contraintes_lignes, contraintes_colonnes)
    model = Model(Cbc.Optimizer)
    @variable(model, x[1:grille_dim, 1:grille_dim], Bin)

    # Ajout des contraintes de lignes et colonnes
    for i in 1:grille_dim
        @constraint(model, sum(x[i, j] for j in 1:grille_dim) == contraintes_lignes[i])
    end
    for j in 1:grille_dim
        @constraint(model, sum(x[i, j] for i in 1:grille_dim) == contraintes_colonnes[j])
    end

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        # Afficher les contraintes des colonnes au-dessus de la grille
        print("   ")  # Espace pour aligner avec les colonnes de la grille
        for j in 1:grille_dim
            print("  $(contraintes_colonnes[j]) ")
        end
        println()

        # Dessiner la grille pointillée avec des cases sélectionnées
        for i in 0:grille_dim
            if i > 0
                # Afficher les contraintes des lignes à gauche de la grille
                print("$(contraintes_lignes[i]) ")
            else
                print("  ")
            end
            
            if i == 0
                println("+" * join(repeat(["---+"], grille_dim)))
            else
                # Contenu de la grille et ligne verticale en pointillés
                for j in 1:grille_dim
                    fill_char = value(x[i, j]) > 0.5 ? " ◼️ " : "   "
                    print("|" * fill_char)
                end
                println("|")
                println("  +" * join(repeat(["---+"], grille_dim)))  # Ligne horizontale en pointillés
            end
        end
    else
        println("Aucune solution optimale trouvée.")
    end
end

# Dimensions de la grille et contraintes

#Exemple
grille_dim = 5
contraintes_lignes = [5, 3, 3, 5, 2]  # Exemple de contraintes pour les lignes
contraintes_colonnes = [5, 5, 2, 2, 4]  # Exemple de contraintes pour les colonnes

#Jeu 1
#grille_dim = 5
#contraintes_lignes = [4, 5, 3, 3, 3] 
#contraintes_colonnes = [3, 4, 3, 3, 5]

#Jeu 2
#grille_dim = 5
#contraintes_lignes = [3, 5, 2, 5, 3]
#contraintes_colonnes = [3, 2, 4, 5, 4]

#Jeu 3
#grille_dim = 5
#contraintes_lignes = [3, 4, 5, 4, 2]
#contraintes_colonnes = [4, 4, 3, 3, 4] 

#Jeu 4
#grille_dim = 6
#contraintes_lignes = [3, 4, 3, 2, 6, 2]
#contraintes_colonnes = [4, 4, 2, 3, 2, 5]

#Jeu 5
#grille_dim = 6
#contraintes_lignes = [4, 5, 5, 2, 5, 5]
#contraintes_colonnes = [4, 5, 4, 5, 5, 3]

# Appel de la fonction pour dessiner une grille pointillée
resoudre_et_dessiner_grille_pointillee(grille_dim, contraintes_lignes, contraintes_colonnes)
