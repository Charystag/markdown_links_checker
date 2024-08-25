# Markdown Links Checker

Un outil pour vérifier la validité des url http dans vos documents markdown

# Table des matières

1.	[Comment utiliser ce script ?](#comment-utiliser-ce-script-)
2.	[Pourquoi ce script ?](#pourquoi-ce-script-)
3.	[Fonctionnement](#fonctionnement)
4.	[Considérations Techniques](#considérations-techniques)
5.	[Vidéo de démonstration](#vidéo-de-démonstration)

# Comment utiliser ce script ?

Il existe deux façons d'exécuter ce script

## Invocation

En le lançant directement depuis ce répertoire sur Github. Vous pouvez lancer la commande :
```bash
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh | bash -s -- doc1.md doc2.md ... docN.md
```
Où doc1..docN sont les documents markdown que vous voulez vérifier

Vous pouvez aussi lancer:
```bash
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh | bash -s -- -i ignored doc1.md doc2.md ... docN.md
```
Où `ignored` est un fichier qui contient une liste d'urls qui doivent être ignorés par le script.

## Installation

Vous pouvez installer le script en lançant:
```
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_check/master/assets/install.sh | bash -s -- $SHELL
```

Vous pouvez ensuite l'utiliser en lançant la commande :
```
markdown-links-checker doc1.md doc2.md ... docN.md
```

# Pourquoi ce script ?

J'ai dû générer beaucoup de contenu lié à la programmation en utilisant ChatGPT dernièrement et je lui demandais de mettre des liens 
vers de la documentation pour avoir la source de ses affirmations. Certains de ces liens étaient morts et à mesure que je 
continuais, je me suis vite trouvé dans le besoin d'une solution pour vérifier la validité des liens dans un document markdown. 
C'est pourquoi j'ai décidé de créer ce petit script.


# Fonctionnement

Voici un résumé de ce que le script fait :
1.	Il récupère tous les url http(s) qui sont formattés en tant que liens au format markdown
2.	Pour toutes ces url, il exécute une requête en utilisant `curl` pour récupérer la ressource vers laquelle pointe cette url et analyse le code réponse
	1.	Si ce code commence par un 2, la requête est considérée comme valide
	2.	Sinon, elle est invalide
3.	Il affiche le résultat sur `stdout` ou `stderr` en fonction du succès de la requête

# Considérations Techniques

Le script ne peut pas gérer les parenthèses escaped dans les url pour le moment. Si vous en avez dans votre document, vous 
feriez mieux de les rajouter aux liens ignorés par le script.

# Vidéo de démonstration
À venir
