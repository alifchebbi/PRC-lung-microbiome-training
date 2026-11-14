###############################################################################
#  SETUP.R - Atelier microbiome 16S, PRC "Microbiote et cancer du poumon"
#  ISBST, vendredi 13 novembre 2026 - Dr. Alif Chebbi
#
#  A QUOI SERT CE FICHIER ?
#  Il prépare votre ordinateur pour l'atelier : il installe tous les "packages"
#  R nécessaires, puis il vérifie que tout fonctionne.
#
#  C'est quoi un package ? Imaginez R comme une cuisine vide. Un package, c'est
#  un appareil qu'on ajoute : un mixeur (dada2), un four (phyloseq), une balance
#  (DESeq2)... Sans ces appareils, on ne peut pas préparer la recette.
#
#  COMMENT LE LANCER ?
#    1. Ouvrez RStudio.
#    2. Menu File > Open File...  puis choisissez SETUP.R
#    3. Cliquez sur le bouton "Source" (en haut à droite de ce panneau).
#    4. Attendez le message "TOUT EST PRET" dans la Console (panneau du bas).
#
#  Vous n'avez rien à modifier dans ce fichier.
###############################################################################


# ---------------------------------------------------------------------------
# 0. Deux petites fonctions pour afficher des messages lisibles
# ---------------------------------------------------------------------------
# say()  : écrit une phrase dans la Console (comme un message SMS).
# line() : trace une ligne de tirets pour séparer les étapes,
#          comme les intercalaires dans un classeur.
say  <- function(...) cat(..., "\n", sep = "")
line <- function() say(strrep("-", 70))


# ---------------------------------------------------------------------------
# 1. Où se trouve le dossier de l'atelier sur VOTRE ordinateur ?
# ---------------------------------------------------------------------------
# Chaque étudiant a copié le dossier à un endroit différent (Bureau,
# Documents, clé USB...). C'est comme chercher sa voiture dans un parking :
# on part de l'endroit où l'on se trouve (le fichier SETUP.R) pour retrouver
# le reste. Le script essaie plusieurs méthodes, et en dernier recours il
# vous demande de cliquer sur SETUP.R dans une fenêtre.
find_root <- function() {
  f <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)   # lancé avec "Source"
  if (is.null(f)) {                                               # lancé avec Rscript
    a <- grep("^--file=", commandArgs(FALSE), value = TRUE)
    if (length(a)) f <- sub("^--file=", "", a[1])
  }
  if (!is.null(f)) return(dirname(normalizePath(f, winslash = "/")))
  if (file.exists("SETUP.R")) return(normalizePath(".", winslash = "/"))
  say("Merci de sélectionner le fichier SETUP.R dans la fenêtre qui s'ouvre...")
  dirname(normalizePath(file.choose(), winslash = "/"))
}
root    <- find_root()                               # le dossier de l'atelier
pkg_dir <- file.path(root, "packages")               # le "carton" de packages
top     <- readLines(file.path(root, "packages_list.txt"))  # la liste de courses
line(); say("Dossier de l'atelier : ", root); line()


# ---------------------------------------------------------------------------
# 2. Avez-vous la bonne version de R ? Quel ordinateur avez-vous ?
# ---------------------------------------------------------------------------
# Les packages sont préparés pour R 4.5, comme une pièce de rechange faite
# pour un modèle précis de voiture : elle ne rentre pas dans un autre modèle.
# Si vous avez R 4.4 ou R 4.6, le script s'arrête et vous explique quoi faire.
rv <- getRversion()          # exemple : 4.5.2
if (rv < "4.5.0" || rv >= "4.6.0") {
  stop("Vous avez R ", as.character(rv), ". L'atelier demande R 4.5 (R 4.5.2 conseillé, voir le README).\n",
       "Installez-le, redémarrez RStudio, puis relancez SETUP.R.", call. = FALSE)
}
rv <- as.character(rv)        # en texte, pour pouvoir l'afficher

# On regarde le système : Windows, Mac avec puce Apple (M1 à M4) ou Mac Intel.
# C'est comme une prise électrique : Tunisie, Royaume-Uni ou USA, chaque pays
# a sa forme. Les packages existent en 3 "formes", une par type d'ordinateur.
os   <- Sys.info()[["sysname"]]
arch <- R.version$arch
type <- if (os == "Windows") "win.binary" else
        if (os == "Darwin" && arch %in% c("aarch64", "arm64")) "mac.binary.big-sur-arm64" else
        if (os == "Darwin") "mac.binary.big-sur-x86_64" else "source"
say("R ", rv, " sur ", os, " (", arch, ")")


# ---------------------------------------------------------------------------
# 3. Une bibliothèque personnelle : pas besoin des droits administrateur
# ---------------------------------------------------------------------------
# On range les packages dans VOTRE dossier personnel, comme ranger ses
# affaires dans son propre casier plutôt que dans le bureau du directeur :
# pas besoin de demander la clé (le mot de passe administrateur).
lib <- Sys.getenv("R_LIBS_USER")
dir.create(lib, recursive = TRUE, showWarnings = FALSE)
.libPaths(c(lib, .libPaths()))
say("Les packages seront rangés ici : ", lib)


# ---------------------------------------------------------------------------
# 4. Installation des packages
# ---------------------------------------------------------------------------
# Deux cas possibles :
#
#  A) Vous avez téléchargé le ZIP complet (avec le dossier "packages") :
#     c'est comme recevoir un carton de courses déjà livré à la maison.
#     On déballe, SANS INTERNET, en 3 à 8 minutes.
#
#  B) Le dossier "packages" n'est pas là (par exemple vous avez seulement
#     cloné le dépôt GitHub) : il faut aller faire les courses soi-même,
#     donc télécharger depuis Internet (CRAN + Bioconductor). 15 à 40 minutes.
local_ok <- FALSE
if (dir.exists(pkg_dir) && type != "source") {
  pp   <- normalizePath(pkg_dir, winslash = "/")
  repo <- if (startsWith(pp, "/")) paste0("file://", pp) else paste0("file:///", pp)
  ap   <- tryCatch(suppressWarnings(available.packages(repos = repo, type = type)),
                   error = function(e) NULL)
  local_ok <- !is.null(ap) && nrow(ap) > 0
}

if (local_ok) {
  # --- Cas A : installation depuis le carton (hors ligne) ---
  options(repos = c(LOCAL = repo))
  # On compare ce qui est déjà installé avec ce qui est dans le carton,
  # comme vérifier le frigo avant de ranger les courses : on ne range que
  # ce qui manque ou ce qui est périmé (une version plus ancienne).
  inst <- installed.packages(); inst <- inst[!duplicated(inst[, "Package"]), , drop = FALSE]
  todo <- rownames(ap)[vapply(rownames(ap), function(p)
            !p %in% rownames(inst) ||
            package_version(inst[p, "Version"]) < package_version(ap[p, "Version"]), logical(1))]
  if (length(todo)) {
    say("Installation HORS LIGNE de ", length(todo), " packages... patientez, ne fermez pas RStudio.")
    install.packages(todo, lib = lib, repos = repo, type = type, dependencies = FALSE, quiet = TRUE)
  } else say("Tous les packages sont déjà installés.")
} else {
  # --- Cas B : installation depuis Internet ---
  say("Pas de dossier 'packages' pour cet ordinateur : installation depuis INTERNET.")
  say("Cela peut prendre 15 à 40 minutes. Gardez RStudio ouvert.")
  options(repos = c(CRAN = "https://cloud.r-project.org"))
  # BiocManager est le "livreur" spécialisé des packages de biologie (Bioconductor).
  if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", lib = lib)
  missing <- top[!vapply(top, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing))
    BiocManager::install(missing, version = "3.22", lib = lib, update = FALSE, ask = FALSE)
}


# ---------------------------------------------------------------------------
# 5. Vérification : chaque package fonctionne-t-il ?
# ---------------------------------------------------------------------------
# Installer ne suffit pas : on teste chaque appareil, comme on appuie sur
# l'interrupteur après avoir changé une ampoule. OK = la lumière s'allume.
line(); say("Vérification des packages..."); line()
ok <- vapply(top, function(p) {
  res <- suppressWarnings(suppressMessages(requireNamespace(p, quietly = TRUE)))
  say(sprintf("  %-12s %s", p, if (res) paste0("OK (version ", packageVersion(p), ")") else "MANQUANT"))
  res
}, logical(1))


# ---------------------------------------------------------------------------
# 6. Vérification : les fichiers de l'atelier sont-ils tous là ?
# ---------------------------------------------------------------------------
# Comme vérifier son sac avant un voyage : passeport, billet, chargeur...
# Ici : le projet RStudio, la table des échantillons, la taxonomie déjà
# calculée, les 2 fichiers d'analyse et les 20 fichiers FASTQ
# (10 échantillons x 2 lectures : R1 et R2).
proj <- file.path(root, "1_Atelier")
need <- c("Atelier_16S_cancer_poumon.Rproj", "metadata/sample_metadata.tsv",
          "outputs/precomputed/taxonomy_SILVA138.1.rds",
          "scripts/01_upstream_DADA2.Rmd", "scripts/02_downstream_analysis.Rmd")
files_ok <- file.exists(file.path(proj, need))
n_fastq  <- length(list.files(file.path(proj, "data", "raw_fastq"), pattern = "fastq.gz$"))
line(); say("Fichiers du projet : ", sum(files_ok), "/", length(need), " - fichiers FASTQ : ", n_fastq, "/20")


# ---------------------------------------------------------------------------
# 7. Le verdict final
# ---------------------------------------------------------------------------
line()
if (all(ok) && all(files_ok) && n_fastq == 20) {
  say("   TOUT EST PRET - votre ordinateur est prêt pour l'atelier.")
  say("   Le jour de l'atelier, double-cliquez sur :")
  say("   1_Atelier/Atelier_16S_cancer_poumon.Rproj")
  say("   (les résultats attendus sont dans 2_Corrige/)")
} else {
  if (!all(ok))       say("   PROBLEME - packages manquants : ", paste(top[!ok], collapse = ", "))
  if (!all(files_ok)) say("   PROBLEME - fichiers manquants : ", paste(need[!files_ok], collapse = ", "))
  if (n_fastq != 20)  say("   PROBLEME - il faut 20 fichiers FASTQ dans 1_Atelier/data/raw_fastq")
  say("   Menu Session > Restart R, puis cliquez de nouveau sur Source.")
  say("   Si le problème continue, prenez une photo de la Console et montrez-la au formateur.")
}
line()
