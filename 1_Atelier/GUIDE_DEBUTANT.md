# Guide pour débutants : ouvrir le projet et lancer les scripts

Pas besoin de savoir programmer. Suivez les étapes dans l'ordre.
Sur **Mac**, remplacez **Ctrl** par **Cmd** et **Alt** par **Option**.

---

## Étape 1 - Ouvrir le projet (le plus important)

1. Ouvrez le dossier `1_Atelier`.
2. **Double-cliquez sur `Atelier_16S_cancer_poumon.Rproj`.** RStudio s'ouvre.
3. Vérifiez en haut à droite de RStudio : le nom **Atelier_16S_cancer_poumon** doit être écrit
   à côté de la petite icône bleue en forme de cube.

Pourquoi ? R doit savoir **dans quel dossier** il travaille : c'est le **dossier de travail**
(en anglais *working directory*). C'est comme dire au chauffeur de taxi de quelle ville on part :
sans cela, il ne trouve pas les rues. En ouvrant le fichier `.Rproj`, RStudio place R
**automatiquement** dans le bon dossier. Vous n'avez rien d'autre à faire.

**Ne double-cliquez pas** directement sur un fichier `.Rmd` pour commencer : R risque alors de
travailler dans un autre dossier et de ne pas trouver les FASTQ.

---

## Étape 2 - Vérifier le dossier de travail

Dans la **Console** (le panneau en bas à gauche), tapez ces lignes, puis **Entrée** :

```r
getwd()
```

Le résultat doit **finir par `1_Atelier`**, par exemple :

```
[1] "C:/Users/Amira/Desktop/PRC_atelier/1_Atelier"      (Windows)
[1] "/Users/amira/Desktop/PRC_atelier/1_Atelier"        (Mac)
```

Puis :

```r
file.exists("Atelier_16S_cancer_poumon.Rproj")
```

Le résultat doit être **`TRUE`**. Si c'est le cas, passez à l'étape 3.

### Si `getwd()` ne finit pas par `1_Atelier`

**Solution 1 (la meilleure) :** menu **File > Open Project...**, choisissez
`Atelier_16S_cancer_poumon.Rproj`, puis recommencez l'étape 2.

**Solution 2 (avec la souris) :** menu **Session > Set Working Directory > Choose Directory...**,
choisissez le dossier `1_Atelier`, puis menu **Session > Restart R**.

**Solution 3 (avec une commande) :** tapez `setwd()` avec le chemin de **votre** dossier.
Attention : utilisez des barres **/** (pas \\), et des guillemets.

```r
setwd("C:/Users/Amira/Desktop/PRC_atelier/1_Atelier")   # Windows : adaptez le nom
setwd("~/Desktop/PRC_atelier/1_Atelier")                # Mac : ~ veut dire "mon dossier personnel"
```

Astuce pour ne pas faire de faute de frappe : tapez `setwd("")`, placez le curseur entre les
guillemets et appuyez sur **Tab** : RStudio propose les dossiers, il suffit de choisir.
Après un `setwd()`, faites toujours **Session > Restart R**, puis vérifiez avec `getwd()`.

---

## Étape 3 - Ouvrir un script

Dans le panneau **Files** (en bas à droite), cliquez sur le dossier `scripts`, puis sur
**`01_upstream_DADA2.Rmd`**. Le fichier s'ouvre en haut à gauche.

Un fichier `.Rmd` est un **cahier de TP** : du texte (les explications), des **cases grises**
(le code) et, sous chaque case, le **résultat**. Lancez toujours la **partie 1** avant la
**partie 2** : la partie 2 utilise les résultats de la partie 1.

---

## Étape 4 - Lancer le code

Trois façons, de la plus lente (pour apprendre) à la plus rapide :

| Ce que je veux faire | Comment | Raccourci |
|---|---|---|
| Lancer **une ligne** | cliquez sur la ligne, puis le bouton **Run** | **Ctrl + Entrée** |
| Lancer **une case grise** entière | la petite **flèche verte** ▶ en haut à droite de la case | **Ctrl + Maj + Entrée** |
| Lancer **toutes les cases** | menu **Run > Run All** | **Ctrl + Alt + R** |
| Créer le **rapport HTML** complet | le bouton **Knit** (pelote de laine bleue) | **Ctrl + Maj + K** |

**Conseil pour l'atelier :** lancez les cases **une par une, dans l'ordre, de haut en bas**,
et lisez le résultat sous chaque case avant de passer à la suivante. Comme une recette :
on ne met pas le couscous au four avant de l'avoir roulé.

Pendant qu'une case tourne, un petit **carré rouge (Stop)** apparaît en haut de la Console.
Attendez qu'il disparaisse. L'étape la plus longue (apprentissage des erreurs) prend environ
1 minute.

Le rapport HTML créé par **Knit** est rangé dans `1_Atelier/reports/`. Ouvrez-le avec votre
navigateur (Chrome, Firefox, Edge, Safari).

---

## Étape 5 - Comparer avec le corrigé

Vos résultats se rangent dans `1_Atelier/outputs/`, `1_Atelier/figures/` et `1_Atelier/reports/`.
Les résultats attendus sont dans le dossier **`2_Corrige/`**, au même niveau que `1_Atelier`.
Avec les réglages d'origine, les chiffres doivent être identiques.

---

## Les erreurs les plus fréquentes

| Message ou problème | Ce que cela veut dire | Que faire |
|---|---|---|
| `cannot open file` ou `No such file or directory` | R ne trouve pas un fichier : mauvais dossier de travail | Étape 2 |
| `could not find function "..."` | une case du début n'a pas été lancée (les `library()`) | relancez les cases depuis le début (**Run > Run All Chunks Above**) |
| `object '...' not found` | une case précédente n'a pas été lancée | lancez les cases dans l'ordre |
| `there is no package called '...'` | un package manque | relancez **SETUP.R** jusqu'à « TOUT EST PRET » |
| la partie 2 dit qu'un fichier `.rds` manque | la partie 1 n'a pas été lancée jusqu'au bout | lancez d'abord toute la partie 1 |
| R ne répond plus, le carré rouge reste longtemps | calcul long ou bloqué | attendez 2 minutes, puis cliquez sur **Stop** et **Session > Restart R** |
| un `+` s'affiche dans la Console au lieu de `>` | une parenthèse ou un guillemet n'est pas fermé | appuyez sur **Échap**, puis corrigez la ligne |

En cas de doute : **Session > Restart R**, rouvrez le projet (étape 1), et relancez les cases
dans l'ordre. Si le problème continue, prenez une photo de l'écran et montrez-la au formateur.
