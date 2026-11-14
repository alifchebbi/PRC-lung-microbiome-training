# Comment les 10 échantillons ont été choisis (choix pédagogique)

Source : NCBI BioProject PRJNA586753 (biopsies bronchiques, cancer du poumon central, Saragosse, Espagne ;
Archivos de Bronconeumología 2020). 16S V3-V4 (341F/805R), Illumina MiSeq 2 x 300.

1. Candidats : biopsies du bronche atteint (patients) et biopsies bronchiques des témoins sans cancer
   téléchargées complètement (16 patients, 14 témoins sur 25 + 16).
2. Chaque échantillon a été réduit au hasard à 5 000 paires de lectures (graine 123, R1 et R2 gardés ensemble).
3. Pipeline DADA2 identique à la partie 1 + SILVA 138.1, puis profils au niveau du genre.
4. Score de séparation = distance Bray-Curtis moyenne au groupe opposé - distance moyenne à son propre groupe.
5. Gardés : les 5 patients au score le plus haut, et les 5 témoins au score le plus haut parmi ceux
   ayant au moins 450 lectures bactériennes finales.

ATTENTION : ce choix exagère volontairement la différence entre les groupes. Les résultats de l'atelier
servent à apprendre les méthodes et ne sont pas des résultats scientifiques sur le cancer du poumon.
