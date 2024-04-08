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
        # Dessiner la grille pointillée avec des cases sélectionnées
        for i in 0:grille_dim
            # Ligne horizontale en pointillés
            println("+" * join(repeat(["--+"], grille_dim)))
            
            # Contenu de la grille et ligne verticale en pointillés si i < grille_dim
            if i < grille_dim
                for j in 1:grille_dim
                    fill_char = value(x[i+1, j]) > 0.5 ? " ◼️" : "  "
                    print("|" * fill_char)
                end
                println("|")
            end
        end
    else
        println("Aucune solution optimale trouvée.")
    end
end


# Dimensions de la grille et contraintes
grille_dim = 5
contraintes_lignes = [5, 3, 3, 5, 2]  # Exemple de contraintes pour les lignes
contraintes_colonnes = [5, 5, 2, 2, 4]  # Exemple de contraintes pour les colonnes

# Appel de la fonction pour dessiner une grille pointillee
resoudre_et_dessiner_grille_pointillee(grille_dim, contraintes_lignes, contraintes_colonnes)
