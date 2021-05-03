# Pour générer le document PDF

## Utilisation de Visual Code pour éditer et générer avec l'extension LaTex

`Ouvrir Essai-Vincent_Le_Falher_1.5.tex > Commands > Build LaTeX project > Recipe: pdflatex -> bibtex > pdflatex x 2`

## utilisation de texworks aussi pour voir les changement plus dynamiquement

`Ouvrir Essai-Vincent_Le_Falher_1.5.tex > PdfLatex > MakeIndex > BibTeX`

# Ligne de commande pour générer le document Word docx

`pandoc -s "GAE723 - Travail 4.3 Comptes-rendus des suivis individuels - Vincent Le Falher - v1.0.tex" -o "GAE723 - Travail 4.3 Comptes-rendus des suivis individuels - Vincent Le Falher - v1.0.tex.docx"`