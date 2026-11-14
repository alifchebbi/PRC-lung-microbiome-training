# Corrigé de l'atelier

Ce dossier est le **projet complet, déjà lancé** : les mêmes scripts, FASTQ et métadonnées que
`1_Atelier/`, plus **tous les résultats** produits avec les réglages de l'atelier.
Travaillez d'abord dans `1_Atelier/`, puis comparez avec ce dossier.

Pour l'ouvrir dans RStudio : double-cliquez sur `Corrige_Atelier_16S.Rproj`.
Pour lire les résultats sans R : ouvrez les rapports HTML de `reports/` dans un navigateur.

| Dossier | Contenu | Produit par |
|---|---|---|
| `reports/` | les 2 rapports HTML complets (texte + code + résultats) | Parties 1 et 2 |
| `outputs/01_upstream/` | table d'ASV, séquences, taxonomie, suivi des lectures, réglages utilisés | Partie 1 |
| `outputs/02_downstream/` | diversité alpha, résultats DESeq2, objet phyloseq | Partie 2 |
| `figures/01_upstream/` | suivi des lectures à chaque étape | Partie 1 |
| `figures/02_downstream/` | composition, diversité alpha et bêta, DESeq2, contaminants | Partie 2 |
| `scripts/`, `data/`, `metadata/` | identiques à `1_Atelier/` | - |

**Vos chiffres sont un peu différents ?** C'est normal si vous avez changé un réglage
(exercices). Avec les réglages d'origine, les résultats sont identiques
(les étapes "au hasard" utilisent `set.seed(123)`).
