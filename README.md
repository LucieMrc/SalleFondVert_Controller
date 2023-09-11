# SalleFondVert_Controller

**Ou comment utiliser plus ou moins en autonomie le controleur light de la salle fond vert qui fait tablette (OSC) > ordinateur (Chataigne) > lights (DMX).**

<!-- Le patch sur Chataigne : modifier les variables dans Chataigne pour les renvoyer en OSC ? et notamment pouvoir rallumer après un blackout ?
Blackout c'est un toggle ?

L'interface Android sur PureData puis Processing.

Faire une explication de l'interface et de ce qui controle quoi,  + photo
-->

![Plan de fire'](./images/planFeu.png)

Le patch DMX complet de l'installation actuelle de la salle fond vert, avec l'adresse DMX de chaque paramètre de chaque fixture, se trouve dans le pdf `Patch complet salle fond vert`.

<details> <summary> Utilisation de la tablette de contrôle lumière </summary>

### A. Interface

Les réglages de connexion :

- Le bouton `Scan` cherche les clients OSC (qui envoit le message /id), 
- Le bouton `Connect` se connecte quand on trouve un client,
- Le bouton `Broadcast` envoit les messages OSC à tous les clients du réseau.

Le plus simple est de cliquer juste sur `Scan` puis `Broadcast`.

![Plan de fire'](./images/screen1.jpg)

Les contrôles des lyres avant (101 et 121), milieu (141 et 161) et arrière (181 et 201) :

- Le sélecteur de couleurs qui envoit les messages R, G et B,
- Le slider du blanc,
- Le slider du zoom qui permet de choisir le focus/zoom de la lyre,
- Le pad du pan/tilt qui permet d'orienter la lyre,
- Le slider du dimmer pour choisir la luminosité.

![Plan de fire'](./images/screen2.jpg)

Les contrôles des PAR à l'avant (51, 61, 71 et 81) et des PAR du milieu (11, 21, 31 et 41) :

Les PAR de l'avant sont des Warm White (blanc chaud) dont on ne contrôle que le dimmer (luminosité), une par une ou toutes en même temps avec le master, avec des sliders.

Les PAR du milieu sont des RGBW (Red Green Blue White) dont on contrôle la luminosité de tous avec le slider master, et les paramètres :
- Le sélecteur de couleurs qui envoit les messages R, G et B,
- Le slider du dimmer pour choisir la luminosité,
- Le slider du blanc.

![Plan de fire'](./images/screen5.jpg)

Les presets :

- Le Blackout pour tout éteindre,
- Les PAR milieu : un réglage Warm pour une lumière harmonieuse chaude et un Cold pour une lumière harmonieuse froide.
- Le Greenscreen pour une lumière uniforme sur le fond vert pour faire du chromakey.

![Plan de fire'](./images/screen6.jpg)

### B. Mise en route

Ouvrir l'application `osc_controller_fondvert_android` sur la tablette.

Allumer l'ordinateur, ouvrir le patch Chataigne, et vérifier la connexion de la tablette à Chataigne.

L'ordinateur de la salle fond vert doit être connecté sur le même réseau wifi que la tablette afin qu'ils puissent communiquer en OSC, le plus simple est d'utiliser le réseau du HUAWEI.

Il n'y a normalement pas besoin de modifier les paramètres OSC dans Chataigne, mais on peux vérifier qu'on détecte bien une adresse IP en 192.168.x.x (ici : 192.168.8.107) dans la partie OSC Input.

![Plan de fire'](./images/screen7.png)

On peux aussi vérifier qu'on reçoit bien des messages OSC dans la partie Logger en bas à droite de l'interface Chataigne. Ici on reçoit le message /id du bouton `Scan` de la première interface.

![Plan de fire'](./images/screen8.png)

## Utilisation de l'interface desktop

### A. Interface

Même principe que pour l'interface tablette.

Une première interface avec les réglages de connexion :

![Plan de fire'](./images/screen9.png)

Une seconde interface avec les contrôles de 6 lyres :

![Plan de fire'](./images/screen10.png)

Une dernière interface avec les controles des 8 PAR, les 4 WW qui éclairent le fond vert et les 4 RGBW du milieu, ainsi que les presets :

![Plan de fire'](./images/screen11.png)

### B. Mise en route

Ouvrir le programme Processing `osc_controller_interface`, ainsi que le patch Chataigne.

Pas besoin de se poser des questions de réseau wifi étant donné que Chataigne et Processing communiquent directement en local en OSC.

Il n'y a normalement pas besoin de modifier les paramètres OSC dans Chataigne, qui sont en adéquation avec ceux écrit dans le code Processing.

On peux vérifier qu'on reçoit bien des messages OSC dans la partie Logger en bas à droite de l'interface Chataigne. Ici on reçoit le message /id du bouton `Scan` de la première interface.

![Plan de fire'](./images/screen8.png)

</details>

## Créer une automation de contrôle dans Chataigne

## Le midi-learn dans Chataigne

Pour contrôler certains paramètres avec un controleur MIDI, en faisant automatiquement l'attribution de la valeur midi au paramètre à modifier.

### La mise en place

J'utilise ici un Midimix, avec 24 potards, 9 sliders et 20 boutons.

Pour utiliser un controleur midi, on ajoute un module MIDI dans la partie Modules à gauche de l'interface de Madmapper.

![Plan de fire'](./images/screen12.png)

Dans l'inspecteur du module, on peux alors choisir notre controleur midi.

![Plan de fire'](./images/screen13.png)

Lorsque que `Auto Add` est coché, et `Is Connected` est activé, on voit les valeurs changer en temps réel dans la partie Values de l'inspecteur.

![Plan de fire'](./images/screen14.png)

### Ajouter le contrôle

Pour assigner une valeur midi à un channel DMX/paramètre, il suffit de cliquer sur le mapping du paramètre. Ici, le dimmmer du projecteur PAR WW face :

![Plan de fire'](./images/screen15.png)

Dans la partie Inputs de l'inspecteur, on a déjà l'input d'OSC qui récupère les valeurs de l'interface Processing.

Il suffit de créer un nouvel input en cliquant sur le bouton ➕ en haut à droite de la partie Inputs.

![Plan de fire'](./images/screen16.png)

En cliquant sur le carré `Learn` à droite puis en touchant le controleur midi pour modifier une valeur, la valeur midi s'attribue automatiquement à la valeur du mapping et donc du paramètre (ici la valeur de CC19).

![Plan de fire'](./images/screen17.png)

Néanmoins, le controleur midi envoit des valeurs de 0 à 127, et le DMX reçoit des valeurs de 0 à 255. 

<!--Si on ne remapppe pas la valeur reçue en midi pour qu'elle aille de 0 à 255, -->

Il faut donc remapper les valeurs de l'input pour qu'elle sorte en output en allant de 0 à 255.
Pour cela, on ajoute un filtre en cliquant sur le bouton ➕ de la partie Filters, Remap > Remap.

![Plan de fire'](./images/screen18.png)

On assigne la plage d'entrée allant de 0 à 127 et la plage de sortie allant de 0 à 255.

![Plan de fire'](./images/screen19.png)

Attention, en ajoutant le contrôle MIDI en input par dessus le contrôle OSC, le contrôle MIDI prend la priorité et la modification de la valeur OSC ne changera plus le paramètre en sortie.

De la même façon, le fait d'ajouter un filtre de remappage va modifier la valeur OSC si on veux l'utiliser, étant donné qu'elle arrive déjà en 0 à 255. On peux désactiver le filtre en cliquant sur le bouton éteindre rouge en haut à droite de la partie `Filters`.

## Pour aller + loin

Le [tuto introduction à Chataigne](https://github.com/LucieMrc/Chataigne_2spi).