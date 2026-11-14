# Package atelier16S - Atelier microbiome 16S, PRC "Microbiote et cancer du poumon", ISBST.
# Installer ce package installe automatiquement tous les packages de l'atelier
# (ils sont listes dans le champ Imports du fichier DESCRIPTION).

#' Liste des packages utilises dans l'atelier
#'
#' @return Un vecteur de noms de packages.
#' @export
packages_atelier <- function() {
  c("dada2", "phyloseq", "DESeq2", "Biostrings", "ShortRead", "decontam",
    "microbiome", "vegan", "ggplot2", "dplyr", "tidyr", "readr", "patchwork",
    "here", "ape", "scales", "rmarkdown", "knitr", "BiocManager")
}

#' Verifier que tout est installe
#'
#' Charge chaque package de l'atelier et affiche OK ou MANQUANT,
#' puis le verdict final : TOUT EST PRET ou PROBLEME.
#'
#' @return TRUE si tout est pret (invisible).
#' @export
verifier <- function() {
  ligne <- function() cat(strrep("-", 60), "\n")
  ligne()
  cat("Atelier microbiome 16S - verification de l'installation\n")
  cat("R :", R.version.string, "\n")
  ligne()
  pk <- packages_atelier()
  ok <- vapply(pk, function(p) {
    res <- suppressWarnings(suppressMessages(requireNamespace(p, quietly = TRUE)))
    cat(sprintf("  %-12s %s\n", p,
                if (res) paste0("OK (version ", utils::packageVersion(p), ")") else "MANQUANT"))
    res
  }, logical(1))
  ligne()
  if (all(ok)) {
    cat("   TOUT EST PRET - tous les packages de l'atelier sont installes.\n")
    cat("   Etape suivante : telecharger_atelier() pour obtenir les donnees et les scripts.\n")
  } else {
    cat("   PROBLEME - packages manquants :", paste(pk[!ok], collapse = ", "), "\n")
    cat("   Solution : BiocManager::install(c(\"", paste(pk[!ok], collapse = "\", \""), "\"))\n", sep = "")
  }
  ligne()
  invisible(all(ok))
}

#' Telecharger le materiel de l'atelier
#'
#' Telecharge depuis GitHub les dossiers 1_Atelier (a lancer) et 2_Corrige
#' (resultats attendus), avec les donnees FASTQ, et les decompresse.
#'
#' @param dossier Le dossier ou ranger l'atelier (par defaut : le Bureau).
#' @return Le chemin du dossier de l'atelier (invisible).
#' @export
telecharger_atelier <- function(dossier = file.path(path.expand("~"), "Desktop")) {
  if (!dir.exists(dossier)) dossier <- path.expand("~")
  url  <- "https://github.com/alifchebbi/PRC-lung-microbiome-training/archive/refs/heads/main.zip"
  zip  <- file.path(tempdir(), "PRC_atelier.zip")
  cat("Telechargement en cours (environ 60 Mo)...\n")
  old <- options(timeout = max(600, getOption("timeout"))); on.exit(options(old))
  utils::download.file(url, zip, mode = "wb", quiet = TRUE)
  utils::unzip(zip, exdir = dossier)
  src  <- file.path(dossier, "PRC-lung-microbiome-training-main")
  dest <- file.path(dossier, "PRC_atelier")
  if (dir.exists(dest)) {
    dest <- file.path(dossier, paste0("PRC_atelier_", format(Sys.time(), "%Y%m%d_%H%M%S")))
  }
  file.rename(src, dest)
  rproj <- file.path(dest, "1_Atelier", "Atelier_16S_cancer_poumon.Rproj")
  cat("C'est fait ! L'atelier est ici :\n  ", normalizePath(dest), "\n")
  cat("Pour commencer, double-cliquez sur :\n  ", normalizePath(rproj), "\n")
  cat("Les resultats attendus sont dans 2_Corrige/.\n")
  invisible(dest)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("atelier16S : tapez verifier() pour controler l'installation, ",
                        "puis telecharger_atelier() pour obtenir l'atelier.")
}
