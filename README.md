# NGS et microbiome 2026 : analyse 16S rRNA reproductible du cancer du poumon avec R - ISBST-UMA (Day 1)

## Téléchargements

- **Diapositives de l'atelier (PDF)** : [Chebbi_Atelier_PRC_Microbiome_13Nov2026.pdf](https://github.com/alifchebbi/PRC-lung-microbiome-training/raw/main/docs/Chebbi_Atelier_PRC_Microbiome_13Nov2026.pdf)
- **Aide-mémoire R (PDF, 24 pages)** : [R_Cheatsheets_PRC_Training.pdf](https://github.com/alifchebbi/PRC-lung-microbiome-training/raw/main/docs/R_Cheatsheets_PRC_Training.pdf)

---

**PRC "Microbiote et cancer du poumon"** (PI : Pr. Soumaya Kouidhi)
ISBST, Université de la Manouba - **vendredi 13 novembre 2026**
Formateur : Dr. Alif Chebbi (Day 1) 

Cet atelier montre, pas à pas, comment analyser des données de séquençage 16S rRNA
avec R : des fichiers FASTQ bruts jusqu'aux bactéries qui diffèrent entre la bronche atteinte de patients
atteints d'un cancer du poumon et la bronche de témoins sans cancer.

---

## Préparer son ordinateur (à faire AVANT l'atelier, environ 20 minutes)

### Étape 1 - Installer R 4.5.2

Déjà installé ? Dans RStudio, tapez `R.version.string` dans la Console.
Si vous voyez **4.5**, passez à l'étape 2.

| Votre ordinateur | Fichier à télécharger |
|---|---|
| Windows | [R-4.5.2-win.exe](https://cloud.r-project.org/bin/windows/base/old/4.5.2/R-4.5.2-win.exe) |
| Mac avec puce Apple (M1, M2, M3, M4) | [R-4.5.2-arm64.pkg](https://cloud.r-project.org/bin/macosx/big-sur-arm64/base/R-4.5.2-arm64.pkg) |
| Mac Intel | [R-4.5.2-x86_64.pkg](https://cloud.r-project.org/bin/macosx/big-sur-x86_64/base/R-4.5.2-x86_64.pkg) |

Quel Mac ai-je ? Menu Pomme > *À propos de ce Mac* : "Puce Apple M..." ou "Processeur Intel".
Sous Windows, sans droits administrateur : choisissez l'installation dans votre dossier personnel.

### Étape 2 - Installer RStudio

Téléchargez RStudio Desktop (gratuit) : <https://posit.co/download/rstudio-desktop/>

### Étape 3 - Télécharger le dossier de l'atelier (UN seul fichier ZIP)

Choisissez le fichier qui correspond à votre ordinateur. Il contient les données, les
analyses **et tous les packages R déjà prêts** : l'installation se fait ensuite sans Internet.

| Votre ordinateur | Téléchargement (environ 250 Mo) |
|---|---|
| Windows | [PRC_atelier_Windows.zip](https://github.com/alifchebbi/PRC-lung-microbiome-training/releases/latest/download/PRC_atelier_Windows.zip) |
| Mac puce Apple (M1 à M4) | [PRC_atelier_Mac_Apple_Silicon.zip](https://github.com/alifchebbi/PRC-lung-microbiome-training/releases/latest/download/PRC_atelier_Mac_Apple_Silicon.zip) |
| Mac Intel | [PRC_atelier_Mac_Intel.zip](https://github.com/alifchebbi/PRC-lung-microbiome-training/releases/latest/download/PRC_atelier_Mac_Intel.zip) |

**Décompressez** le ZIP (clic droit > *Extraire tout* sous Windows, double-clic sur Mac)
sur votre Bureau. Ne travaillez pas directement dans le ZIP.

### Étape 4 - Lancer SETUP.R

1. Ouvrez RStudio.
2. Menu **File > Open File...** et choisissez **SETUP.R** dans le dossier décompressé.
3. Cliquez sur le bouton **Source** (en haut à droite).
4. Attendez 3 à 8 minutes le message : **TOUT EST PRET**.

En cas de **PROBLEME** : menu *Session > Restart R*, puis *Source* à nouveau.
Si cela ne marche toujours pas, prenez une photo de la Console et apportez-la vendredi.

### Autre méthode : le package R `atelier16S` (avec Internet)

Un seul package installe **tous les packages de l'atelier** (CRAN et Bioconductor : dada2,
phyloseq, DESeq2, vegan...), vérifie l'installation et télécharge le matériel.
Copiez ces lignes dans la Console de RStudio (après les étapes 1 et 2) :

```r
install.packages(c("BiocManager", "remotes"))
remotes::install_github("alifchebbi/PRC-lung-microbiome-training", subdir = "atelier16S",
                        repos = BiocManager::repositories())
library(atelier16S)
verifier()              # doit afficher : TOUT EST PRET
telecharger_atelier()   # copie l'atelier (1_Atelier + 2_Corrige) sur votre Bureau
```

L'installation prend 15 à 40 minutes selon la connexion. Si R demande
« Update all/some/none? », tapez `n` puis Entrée.

### Le jour de l'atelier

Double-cliquez sur
`1_Atelier/Atelier_16S_cancer_poumon.Rproj`.

**Débutant en R ?** Le fichier [`1_Atelier/GUIDE_DEBUTANT.md`](1_Atelier/GUIDE_DEBUTANT.md) explique pas à pas
comment vérifier le dossier de travail (`getwd()`, `setwd()`), lancer une ligne, une case ou tout
le script, créer le rapport HTML, et corriger les erreurs les plus fréquentes.

Travaillez dans **`1_Atelier/`**. Le dossier **`2_Corrige/`** est le même projet déjà lancé, avec tous les résultats :
n'y regardez qu'à la fin, pour comparer, comme un corrigé de TP.

---

## Contenu du dépôt

```
SETUP.R                 installe et vérifie tout (commenté en français)
atelier16S/             le package R qui installe tous les packages de l'atelier
packages_list.txt       les packages R utilisés
1_Atelier/              LE DOSSIER DE TRAVAIL : tout ce qu'il faut pour lancer l'analyse
  Atelier_16S_cancer_poumon.Rproj   double-cliquez ici pour ouvrir le projet dans RStudio
  GUIDE_DEBUTANT.md     ouvrir le projet, dossier de travail, lancer les scripts, erreurs fréquentes
  scripts/              01_upstream_DADA2.Rmd et 02_downstream_analysis.Rmd
  data/raw_fastq/       20 fichiers FASTQ nommés comme les échantillons : TU01_R1.fastq.gz,
                        TU01_R2.fastq.gz... (TU = patient, HC = témoin ; 5 000 paires chacun)
  metadata/             la table des 10 échantillons et la méthode de sélection
  outputs/precomputed/  la taxonomie SILVA déjà calculée (évite de télécharger SILVA)
  outputs/, figures/, reports/   vides au départ : vos résultats s'y rangent
2_Corrige/              LE CORRIGÉ : le même projet, déjà lancé, avec tous les résultats
  Corrige_Atelier_16S.Rproj         pour l'ouvrir dans RStudio
  reports/              les 2 rapports HTML complets, à ouvrir dans un navigateur
  outputs/              tables (ASV, taxonomie, lectures, diversité, DESeq2)
  figures/              toutes les figures (PNG et PDF)
  scripts/, data/, metadata/   identiques à 1_Atelier/
```

Vous pouvez aussi cloner ce dépôt (`git clone`) : SETUP.R installera alors les packages
depuis Internet (15 à 40 minutes).

## Les données

NCBI BioProject **PRJNA586753** : microbiote du cancer du poumon central, Saragosse (Espagne),
Archivos de Bronconeumología 2020. **Biopsies bronchiques**, 16S rRNA régions **V3-V4**
(amorces 341F / 805R), Illumina MiSeq 2 x 300, vrais scores de qualité.

Sélection pour l'atelier : **10 échantillons**, 5 biopsies du bronche atteint chez des patients
(TU01 à TU05) et 5 biopsies bronchiques de témoins **sans cancer** (HC01 à HC05), chacune réduite
à **5 000 paires de lectures** pour aller vite. Les 10 échantillons ont été **choisis pour montrer
une différence nette** (méthode dans `metadata/selection_method.md`) : c'est un choix pédagogique,
les résultats ne sont pas des conclusions scientifiques.

**Télécharger seulement les données** (19 Mo) : [PRC_FASTQ_PRJNA586753_10echantillons.zip](https://github.com/alifchebbi/PRC-lung-microbiome-training/releases/latest/download/PRC_FASTQ_PRJNA586753_10echantillons.zip)
(20 fichiers FASTQ, table des échantillons, méthode de sélection, sommes MD5).

Si vous utilisez ces données, citez l'étude originale : Bello S *et al.* (2021) Core microbiota in
central lung cancer with streptococcal enrichment as a possible diagnostic marker.
*Archivos de Bronconeumología* 57(11):681-689. <https://doi.org/10.1016/j.arbres.2020.05.034>

La base de référence **SILVA 138.1** (environ 220 Mo) n'est pas incluse : la taxonomie est
déjà calculée dans `1_Atelier/outputs/precomputed/`. Pour refaire l'assignation vous-même, téléchargez
les deux fichiers sur <https://zenodo.org/records/4587955> et placez-les dans `data/reference_db/`.

## Quiz (sur téléphone)

- **Avant l'atelier** (10 questions) : <https://alifchebbi.github.io/PRC-lung-microbiome-training/quiz/avant/>
- **Après l'atelier** (20 questions, avec explications) : <https://alifchebbi.github.io/PRC-lung-microbiome-training/quiz/apres/>

Comparez vos deux scores pour mesurer vos progrès.

## Pour aller plus loin : tutoriels recommandés

Des tutoriels de référence, gratuits et en anglais, pour revoir chaque étape de l'atelier.

**Du FASTQ à la table d'ASV**

- [Tutoriel officiel DADA2](https://benjjneb.github.io/dada2/tutorial.html) (Callahan) : le pipeline pas à pas, la base de notre partie 1.
- [Galaxy Training Network - 16S avec DADA2](https://training.galaxyproject.org/training-material/topics/microbiome/tutorials/dada-16S/tutorial.html) : le même pipeline dans le navigateur, sans installation (notre plan B).
- [Tous les tutoriels microbiome de Galaxy](https://training.galaxyproject.org/training-material/topics/microbiome/) : 16S, shotgun, métatranscriptomique.

**Analyse en aval dans R**

- [Bioconductor Workflow for Microbiome Data Analysis](https://f1000research.com/articles/5-1492) (Callahan et al., F1000Research 2016) : du FASTQ aux statistiques, avec DADA2 et phyloseq.
- [Site de phyloseq](https://joey711.github.io/phyloseq/) : composition, diversité alpha et bêta, ordinations.
- [Orchestrating Microbiome Analysis (OMA)](https://microbiome.github.io/OMA/docs/devel/) : un livre en ligne complet, la suite moderne de phyloseq dans Bioconductor.
- [Tutoriels du package microbiome](https://microbiome.github.io/tutorials/) : exemples courts, indices de diversité.
- [vegan](https://vegandevs.github.io/vegan/) : diversité, Bray-Curtis, PERMANOVA (`adonis2`), `betadisper`.
- [Vignette DESeq2](https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html) : l'abondance différentielle expliquée par ses auteurs.
- [Vignette decontam](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html) : retirer les contaminants grâce aux témoins négatifs.
- [Carpentries - Metagenomics](https://carpentries-incubator.github.io/metagenomics/) : une formation complète au format Carpentries.

**Articles à lire**

- Callahan BJ et al. (2016) DADA2: High-resolution sample inference from Illumina amplicon data. *Nature Methods* 13:581-583. <https://doi.org/10.1038/nmeth.3869>
- McMurdie PJ, Holmes S (2013) phyloseq: an R package for reproducible interactive analysis and graphics of microbiome census data. *PLoS ONE* 8:e61217. <https://doi.org/10.1371/journal.pone.0061217>
- Love MI, Huber W, Anders S (2014) Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology* 15:550. <https://doi.org/10.1186/s13059-014-0550-8>
- Salter SJ et al. (2014) Reagent and laboratory contamination can critically impact sequence-based microbiome analyses. *BMC Biology* 12:87. <https://doi.org/10.1186/s12915-014-0087-z>
- Davis NM et al. (2018) Simple statistical identification and removal of contaminant sequences in marker-gene and metagenomics data. *Microbiome* 6:226. <https://doi.org/10.1186/s40168-018-0605-2>
- Eisenhofer R et al. (2019) Contamination in low microbial biomass microbiome studies: issues and recommendations. *Trends in Microbiology* 27:105-117. <https://doi.org/10.1016/j.tim.2018.11.003>

## Environnement

R 4.5.2, Bioconductor 3.22 : dada2, phyloseq, DESeq2, Biostrings, ShortRead, decontam,
microbiome, vegan, ggplot2, dplyr, tidyr, readr, patchwork, ape, here, rmarkdown.

## Remerciements

Un grand merci au **Dr. Houcemeddine Othman**, qui a animé la troisième journée (Day 2) de la formation, pour cette journée remarquable et pour sa précieuse collaboration.
