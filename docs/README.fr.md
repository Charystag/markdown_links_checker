# Markdown Links Checker

Un outil pour vérifier la validité des url http dans vos documents markdown

# Table des matières

1.	[Comment utiliser ce script ?](#comment-utiliser-ce-script-)
2.	[Pourquoi ce script ?](#pourquoi-ce-script-)
3.	[Fonctionnement](#fonctionnement)
4.	[Vidéo de démonstration](#vidéo-de-démonstration)

# Comment utiliser ce script ?

Il existe deux façons d'exécuter ce script

## Invocation

En le lançant directement depuis ce répertoire sur Github. Vous pouvez lancer la commande :
```bash
curl --connect-timeout 10 -fsSL https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links.sh | bash -s -- doc1.md doc2.md ... docN.md
```
Où doc1..docN sont les documents markdown que vous voulez vérifier

## Installation

Si vous utilisez `bash` ou `zsh` comme loggin shell, vous pouvez installer le script en lançant :
```
if [ ! -f "$HOME/.local/bin/check_links" ]
	then curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/Charystag/markdown_links_checker/master/check_links -o "$HOME/.local/bin/check_links" \
	&& { if { echo "$PATH" | grep "$HOME/.local/bin" ; }
		then echo "PATH=\"$HOME/.local/bin:$PATH\"" >> "$HOME/.$(basename $SHELL)rc"; echo "Path : \`$HOME/.local/bin added to path'" ; . "$HOME/.$(basename $SHELL)rc" ; fi ; } \
	&& echo "Script installed at : $HOME/.local/bin/check_links"
else
	echo "Script already installed at : $HOME/.local/bin/check_links"
fi
```

Vous pouvez ensuite l'utiliser en lançant la commande :
```
check_links doc1.md doc2.md ... docN.md
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

# Vidéo de démonstration
À venir
