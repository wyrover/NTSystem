{Portable Network Graphics Delphi Language Info (24 July 2002)}

{Feel free to change the text bellow to adapt to your language}
{Also if you have a translation to other languages and want to}
{share it, send me: gubadaud@terra.com.br                     }
unit pnglang;

interface

{$DEFINE English}
{.$DEFINE Polish}
{.$DEFINE Portuguese}
{.$DEFINE German}
{.$DEFINE French}
{.$DEFINE Slovenian}

{Language strings for english}
resourcestring
  {$IFDEF Polish}
  EPngInvalidCRCText = 'Ten obraz "Portable Network Graphics" jest nieprawidіowy ' +
      'poniewaї zawiera on nieprawidіowe czкњci danych (bі№d crc)';
  EPNGInvalidIHDRText = 'Obraz "Portable Network Graphics" nie moїe zostaж ' +
      'wgrany poniewaї jedna z czкњci danych (ihdr) moїe byж uszkodzona';
  EPNGMissingMultipleIDATText = 'Obraz "Portable Network Graphics" jest ' +
    'nieprawidіowy poniewaї brakuje w nim czкњci obrazu.';
  EPNGZLIBErrorText = 'Nie moїna zdekompresowaж obrazu poniewaї zawiera ' +
    'bікdnie zkompresowane dane.'#13#10 + ' Opis bікdu: ';
  EPNGInvalidPaletteText = 'Obraz "Portable Network Graphics" zawiera ' +
    'niewіaњciw№ paletк.';
  EPNGInvalidFileHeaderText = 'Plik ktуry jest odczytywany jest nieprawidіowym '+
    'obrazem "Portable Network Graphics" poniewaї zawiera nieprawidіowy nagіуwek.' +
    ' Plik moїк byж uszkodzony, sprуbuj pobraж go ponownie.';
  EPNGIHDRNotFirstText = 'Obraz "Portable Network Graphics" nie jest ' +
    'obsіugiwany lub moїe byж niewіaњciwy.'#13#10 + '(stopka IHDR nie jest pierwsza)';
  EPNGNotExistsText = 'Plik png nie moїe zostaж wgrany poniewaї nie ' +
    'istnieje.';
  EPNGSizeExceedsText = 'Obraz "Portable Network Graphics" nie jest ' +
    'obsіugiwany poniewaї jego szerokoњж lub wysokoњж przekracza maksimum ' +
    'rozmiaru, ktуry wynosi 65535 pikseli dіugoњci.';
  EPNGUnknownPalEntryText = 'Nie znaleziono wpisуw palety.';
  EPNGMissingPaletteText = 'Obraz "Portable Network Graphics" nie moїe zostaж ' +
    'wgrany poniewaї uїywa tabeli kolorуw ktуrej brakuje.';
  EPNGUnknownCriticalChunkText = 'Obraz "Portable Network Graphics" ' +
    'zawiera nieznan№ krytyczn№ czкњж ktуra nie moїe zostaж odkodowana.';
  EPNGUnknownCompressionText = 'Obraz "Portable Network Graphics" jest ' +
    'skompresowany nieznanym schemat ktуry nie moїe zostaж odszyfrowany.';
  EPNGUnknownInterlaceText = 'Obraz "Portable Network Graphics" uїywa ' +
    'nie znany schamat przeplatania ktуry nie moїe zostaж odszyfrowany.';
  EPNGCannotAssignChunkText = 'Stopka mysi byж kompatybilna aby zostaіa wyznaczona.';
  EPNGUnexpectedEndText = 'Obraz "Portable Network Graphics" jest nieprawidіowy ' +
    'poniewaї dekoder znalazі niespodziewanie koniec pliku.';
  EPNGNoImageDataText = 'Obraz "Portable Network Graphics" nie zawiera' +
    'danych.';
  EPNGCannotAddChunkText = 'Program prуbuje dodaж krytyczn№ ' +
    'stopkк do aktualnego obrazu co jest niedozwolone.';
  EPNGCannotAddInvalidImageText = 'Nie moїna dodaж nowej stopki ' +
    'poniewaї aktualny obraz jest nieprawidіowy.';
  EPNGCouldNotLoadResourceText = 'Obraz png nie moїe zostaж zaіadowany z' +
    'zasobуw o podanym ID.';
  EPNGOutMemoryText = 'Niektуre operacje nie mog№ zostaж zrealizowane poniewaї ' +
    'systemowi brakuje zasobуw. Zamknij kilka okien i sprуbuj ponownie.';
  EPNGCannotChangeTransparentText = 'Ustawienie bitu przezroczystego koloru jest ' +
    'zabronione dla obrazуw png zawieraj№cych wartoњж alpha dla kaїdego piksela ' +
    '(COLOR_RGBALPHA i COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Ta operacja jest niedozwolona poniewaї ' +
    'aktualny obraz zawiera niewіaњciwy nagіуwek.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}

  {$IFDEF English}
  EPngInvalidCRCText = 'This "Portable Network Graphics" image is not valid ' +
      'because it contains invalid pieces of data (crc error)';
  EPNGInvalidIHDRText = 'The "Portable Network Graphics" image could not be ' +
      'loaded because one of its main piece of data (ihdr) might be corrupted';
  EPNGMissingMultipleIDATText = 'This "Portable Network Graphics" image is ' +
    'invalid because it has missing image parts.';
  EPNGZLIBErrorText = 'Could not decompress the image because it contains ' +
    'invalid compressed data.'#13#10 + ' Description: ';
  EPNGInvalidPaletteText = 'The "Portable Network Graphics" image contains ' +
    'an invalid palette.';
  EPNGInvalidFileHeaderText = 'The file being readed is not a valid '+
    '"Portable Network Graphics" image because it contains an invalid header.' +
    ' This file may be corruped, try obtaining it again.';
  EPNGIHDRNotFirstText = 'This "Portable Network Graphics" image is not ' +
    'supported or it might be invalid.'#13#10 + '(IHDR chunk is not the first)';
  EPNGNotExistsText = 'The png file could not be loaded because it does not ' +
    'exists.';
  EPNGSizeExceedsText = 'This "Portable Network Graphics" image is not ' +
    'supported because either it''s width or height exceeds the maximum ' +
    'size, which is 65535 pixels length.';
  EPNGUnknownPalEntryText = 'There is no such palette entry.';
  EPNGMissingPaletteText = 'This "Portable Network Graphics" could not be ' +
    'loaded because it uses a color table which is missing.';
  EPNGUnknownCriticalChunkText = 'This "Portable Network Graphics" image ' +
    'contains an unknown critical part which could not be decoded.';
  EPNGUnknownCompressionText = 'This "Portable Network Graphics" image is ' +
    'encoded with an unknown compression scheme which could not be decoded.';
  EPNGUnknownInterlaceText = 'This "Portable Network Graphics" image uses ' +
    'an unknown interlace scheme which could not be decoded.';
  EPNGCannotAssignChunkText = 'The chunks must be compatible to be assigned.';
  EPNGUnexpectedEndText = 'This "Portable Network Graphics" image is invalid ' +
    'because the decoder found an unexpected end of the file.';
  EPNGNoImageDataText = 'This "Portable Network Graphics" image contains no ' +
    'data.';
  EPNGCannotAddChunkText = 'The program tried to add a existent critical ' +
    'chunk to the current image which is not allowed.';
  EPNGCannotAddInvalidImageText = 'It''s not allowed to add a new chunk ' +
    'because the current image is invalid.';
  EPNGCouldNotLoadResourceText = 'The png image could not be loaded from the ' +
    'resource ID.';
  EPNGOutMemoryText = 'Some operation could not be performed because the ' +
    'system is out of resources. Close some windows and try again.';
  EPNGCannotChangeTransparentText = 'Setting bit transparency color is not ' +
    'allowed for png images containing alpha value for each pixel ' +
    '(COLOR_RGBALPHA and COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'This operation is not valid because the ' +
    'current image contains no valid header.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}
  {$IFDEF Portuguese}
  EPngInvalidCRCText = 'Essa imagem "Portable Network Graphics" nгo й vбlida ' +
      'porque contйm chunks invбlidos de dados (erro crc)';
  EPNGInvalidIHDRText = 'A imagem "Portable Network Graphics" nгo pode ser ' +
      'carregada porque um dos seus chunks importantes (ihdr) pode estar '+
      'invбlido';
  EPNGMissingMultipleIDATText = 'Essa imagem "Portable Network Graphics" й ' +
    'invбlida porque tem chunks de dados faltando.';
  EPNGZLIBErrorText = 'Nгo foi possнvel descomprimir os dados da imagem ' +
    'porque ela contйm dados invбlidos.'#13#10 + ' Descriзгo: ';
  EPNGInvalidPaletteText = 'A imagem "Portable Network Graphics" contйm ' +
    'uma paleta invбlida.';
  EPNGInvalidFileHeaderText = 'O arquivo sendo lido nгo й uma imagem '+
    '"Portable Network Graphics" vбlida porque contйm um cabeзalho invбlido.' +
    ' O arquivo pode estar corrompida, tente obter ela novamente.';
  EPNGIHDRNotFirstText = 'Essa imagem "Portable Network Graphics" nгo й ' +
    'suportada ou pode ser invбlida.'#13#10 + '(O chunk IHDR nгo й o ' +
    'primeiro)';
  EPNGNotExistsText = 'A imagem png nгo pode ser carregada porque ela nгo ' +
    'existe.';
  EPNGSizeExceedsText = 'Essa imagem "Portable Network Graphics" nгo й ' +
    'suportada porque a largura ou a altura ultrapassam o tamanho mбximo, ' +
    'que й de 65535 pixels de diвmetro.';
  EPNGUnknownPalEntryText = 'Nгo existe essa entrada de paleta.';
  EPNGMissingPaletteText = 'Essa imagem "Portable Network Graphics" nгo pode ' +
    'ser carregada porque usa uma paleta que estб faltando.';
  EPNGUnknownCriticalChunkText = 'Essa imagem "Portable Network Graphics" ' +
    'contйm um chunk crнtico desconheзido que nгo pode ser decodificado.';
  EPNGUnknownCompressionText = 'Essa imagem "Portable Network Graphics" estб ' +
    'codificada com um esquema de compressгo desconheзido e nгo pode ser ' +
    'decodificada.';
  EPNGUnknownInterlaceText = 'Essa imagem "Portable Network Graphics" usa um ' +
    'um esquema de interlace que nгo pode ser decodificado.';
  EPNGCannotAssignChunkText = 'Os chunk devem ser compatнveis para serem ' +
    'copiados.';
  EPNGUnexpectedEndText = 'Essa imagem "Portable Network Graphics" й ' +
    'invбlida porque o decodificador encontrou um fim inesperado.';
  EPNGNoImageDataText = 'Essa imagem "Portable Network Graphics" nгo contйm ' +
    'dados.';
  EPNGCannotAddChunkText = 'O programa tentou adicionar um chunk crнtico ' +
    'jб existente para a imagem atual, oque nгo й permitido.';
  EPNGCannotAddInvalidImageText = 'Nгo й permitido adicionar um chunk novo ' +
    'porque a imagem atual й invбlida.';
  EPNGCouldNotLoadResourceText = 'A imagem png nгo pode ser carregada apartir' +
    ' do resource.';
  EPNGOutMemoryText = 'Uma operaзгo nгo pode ser completada porque o sistema ' +
    'estб sem recursos. Fecha algumas janelas e tente novamente.';
  EPNGCannotChangeTransparentText = 'Definir transparкncia booleana nгo й ' +
    'permitido para imagens png contendo informaзгo alpha para cada pixel ' +
    '(COLOR_RGBALPHA e COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Essa operaзгo nгo й vбlida porque a ' +
    'imagem atual nгo contйm um cabeзalho vбlido.';
  EInvalidNewSize = 'O novo tamanho fornecido para o redimensionamento de ' +
    'imagem й invбlido.';
  EInvalidSpec = 'A imagem "Portable Network Graphics" nгo pode ser criada ' +
    'porque parвmetros de tipo de imagem invбlidos foram usados.';
  {$ENDIF}
  {Language strings for German}
  {$IFDEF German}
  EPngInvalidCRCText = 'Dieses "Portable Network Graphics" Bild ist ' +
      'ungьltig, weil Teile der Daten fehlerhaft sind (CRC-Fehler)';
  EPNGInvalidIHDRText = 'Dieses "Portable Network Graphics" Bild konnte ' +
      'nicht geladen werden, weil wahrscheinlich einer der Hauptdatenbreiche ' +
	  '(IHDR) beschдdigt ist';
  EPNGMissingMultipleIDATText = 'Dieses "Portable Network Graphics" Bild ' +
    'ist ungьltig, weil Grafikdaten fehlen.';
  EPNGZLIBErrorText = 'Die Grafik konnte nicht entpackt werden, weil Teile der ' +
    'komprimierten Daten fehlerhaft sind.'#13#10 + ' Beschreibung: ';
  EPNGInvalidPaletteText = 'Das "Portable Network Graphics" Bild enthдlt ' +
    'eine ungьltige Palette.';
  EPNGInvalidFileHeaderText = 'Die Datei, die gelesen wird, ist kein ' +
    'gьltiges "Portable Network Graphics" Bild, da es keinen gьltigen ' +
    'Header enthдlt. Die Datei kцnnte beschдdigt sein, versuchen Sie, ' +
    'eine neue Kopie zu bekommen.';
  EPNGIHDRNotFirstText = 'Dieses "Portable Network Graphics" Bild wird ' +
    'nicht unterstьtzt oder ist ungьltig.'#13#10 +
    '(Der IHDR-Abschnitt ist nicht der erste Abschnitt in der Datei).';
  EPNGNotExistsText = 'Die PNG Datei konnte nicht geladen werden, da sie ' +
    'nicht existiert.';
  EPNGSizeExceedsText = 'Dieses "Portable Network Graphics" Bild wird nicht ' +
    'unterstьtzt, weil entweder seine Breite oder seine Hцhe das Maximum von ' +
    '65535 Pixeln ьberschreitet.';
  EPNGUnknownPalEntryText = 'Es gibt keinen solchen Palettenwert.';
  EPNGMissingPaletteText = 'Dieses "Portable Network Graphics" Bild konnte ' +
    'nicht geladen werden, weil die benцtigte Farbtabelle fehlt.';
  EPNGUnknownCriticalChunkText = 'Dieses "Portable Network Graphics" Bild ' +
    'enhдlt einen unbekannten aber notwendigen Teil, welcher nicht entschlьsselt ' +
    'werden kann.';
  EPNGUnknownCompressionText = 'Dieses "Portable Network Graphics" Bild ' +
    'wurde mit einem unbekannten Komprimierungsalgorithmus kodiert, welcher ' +
    'nicht entschlьsselt werden kann.';
  EPNGUnknownInterlaceText = 'Dieses "Portable Network Graphics" Bild ' +
    'benutzt ein unbekanntes Interlace-Schema, welches nicht entschlьsselt ' +
    'werden kann.';
  EPNGCannotAssignChunkText = 'Die Abschnitte mьssen kompatibel sein, damit ' +
    'sie zugewiesen werden kцnnen.';
  EPNGUnexpectedEndText = 'Dieses "Portable Network Graphics" Bild ist ' +
    'ungьltig: Der Dekoder ist unerwartete auf das Ende der Datei gestoЯen.';
  EPNGNoImageDataText = 'Dieses "Portable Network Graphics" Bild enthдlt ' +
    'keine Daten.';
  EPNGCannotAddChunkText = 'Das Programm versucht einen existierenden und ' +
    'notwendigen Abschnitt zum aktuellen Bild hinzuzufьgen. Dies ist nicht ' +
    'zulдssig.';
  EPNGCannotAddInvalidImageText = 'Es ist nicht zulдssig, einem ungьltigen ' +
    'Bild einen neuen Abschnitt hinzuzufьgen.';
  EPNGCouldNotLoadResourceText = 'Das PNG Bild konnte nicht aus den ' +
    'Resourcendaten geladen werden.';
  EPNGOutMemoryText = 'Es stehen nicht genьgend Resourcen im System zur ' +
    'Verfьgung, um die Operation auszufьhren. SchlieЯen Sie einige Fenster '+
    'und versuchen Sie es erneut.';
  EPNGCannotChangeTransparentText = 'Das Setzen der Bit-' +
    'Transparent-Farbe ist fьr PNG-Images die Alpha-Werte fьr jedes ' +
    'Pixel enthalten (COLOR_RGBALPHA und COLOR_GRAYSCALEALPHA) nicht ' +
    'zulдssig';
  EPNGHeaderNotPresentText = 'Die Datei, die gelesen wird, ist kein ' +
    'gьltiges "Portable Network Graphics" Bild, da es keinen gьltigen ' +
    'Header enthдlt.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}
  {Language strings for French}
  {$IFDEF French}
  EPngInvalidCRCText = 'Cette image "Portable Network Graphics" n''est pas valide ' +
      'car elle contient des donnйes invalides (erreur crc)';
  EPNGInvalidIHDRText = 'Cette image "Portable Network Graphics" n''a pu кtre ' +
      'chargйe car l''une de ses principale donnйe (ihdr) doit кtre corrompue';
  EPNGMissingMultipleIDATText = 'Cette image "Portable Network Graphics" est ' +
    'invalide car elle contient des parties d''image manquantes.';
  EPNGZLIBErrorText = 'Impossible de dйcompresser l''image car elle contient ' +
    'des donnйes compressйes invalides.'#13#10 + ' Description: ';
  EPNGInvalidPaletteText = 'L''image "Portable Network Graphics" contient ' +
    'une palette invalide.';
  EPNGInvalidFileHeaderText = 'Le fichier actuellement lu est une image '+
    '"Portable Network Graphics" invalide car elle contient un en-tкte invalide.' +
    ' Ce fichier doit кtre corrompu, essayer de l''obtenir а nouveau.';
  EPNGIHDRNotFirstText = 'Cette image "Portable Network Graphics" n''est pas ' +
    'supportйe ou doit кtre invalide.'#13#10 + '(la partie IHDR n''est pas la premiиre)';
  EPNGNotExistsText = 'Le fichier png n''a pu кtre chargй car il n''йxiste pas.';
  EPNGSizeExceedsText = 'Cette image "Portable Network Graphics" n''est pas supportйe ' +
    'car sa longueur ou sa largeur excиde la taille maximale, qui est de 65535 pixels.';
  EPNGUnknownPalEntryText = 'Il n''y a aucune entrйe pour cette palette.';
  EPNGMissingPaletteText = 'Cette image "Portable Network Graphics" n''a pu кtre ' +
    'chargйe car elle utilise une table de couleur manquante.';
  EPNGUnknownCriticalChunkText = 'Cette image "Portable Network Graphics" ' +
    'contient une partie critique inconnue qui n'' pu кtre dйcodйe.';
  EPNGUnknownCompressionText = 'Cette image "Portable Network Graphics" est ' +
    'encodйe а l''aide d''un schйmas de compression inconnu qui ne peut кtre dйcodй.';
  EPNGUnknownInterlaceText = 'Cette image "Portable Network Graphics" utilise ' +
    'un schйmas d''entrelacement inconnu qui ne peut кtre dйcodй.';
  EPNGCannotAssignChunkText = 'Ce morceau doit кtre compatible pour кtre assignй.';
  EPNGUnexpectedEndText = 'Cette image "Portable Network Graphics" est invalide ' +
    'car le decodeur est arrivй а une fin de fichier non attendue.';
  EPNGNoImageDataText = 'Cette image "Portable Network Graphics" ne contient pas de ' +
    'donnйes.';
  EPNGCannotAddChunkText = 'Le programme a essayй d''ajouter un morceau critique existant ' +
    'а l''image actuelle, ce qui n''est pas autorisй.';
  EPNGCannotAddInvalidImageText = 'Il n''est pas permis d''ajouter un nouveau morceau ' +
    'car l''image actuelle est invalide.';
  EPNGCouldNotLoadResourceText = 'L''image png n''a pu кtre chargйe depuis  ' +
    'l''ID ressource.';
  EPNGOutMemoryText = 'Certaines opйrations n''ont pu кtre effectuйe car le ' +
    'systиme n''a plus de ressources. Fermez quelques fenкtres et essayez а nouveau.';
  EPNGCannotChangeTransparentText = 'Dйfinir le bit de transparence n''est pas ' +
    'permis pour des images png qui contiennent une valeur alpha pour chaque pixel ' +
    '(COLOR_RGBALPHA et COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Cette opйration n''est pas valide car l''image ' +
    'actuelle ne contient pas de header valide.';
  EPNGAlphaNotSupportedText = 'Le type de couleur de l''image "Portable Network Graphics" actuelle ' +
    'contient dйjа des informations alpha ou il ne peut кtre converti.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}
  {Language strings for slovenian}
  {$IFDEF Slovenian}
  EPngInvalidCRCText = 'Ta "Portable Network Graphics" slika je neveljavna, ' +
      'ker vsebuje neveljavne dele podatkov (CRC napaka).';
  EPNGInvalidIHDRText = 'Slike "Portable Network Graphics" ni bilo moћno ' +
      'naloћiti, ker je eden od glavnih delov podatkov (IHDR) verjetno pokvarjen.';
  EPNGMissingMultipleIDATText = 'Ta "Portable Network Graphics" slika je ' +
    'naveljavna, ker manjkajo deli slike.';
  EPNGZLIBErrorText = 'Ne morem raztegniti slike, ker vsebuje ' +
    'neveljavne stisnjene podatke.'#13#10 + ' Opis: ';
  EPNGInvalidPaletteText = 'Slika "Portable Network Graphics" vsebuje ' +
    'neveljavno barvno paleto.';
  EPNGInvalidFileHeaderText = 'Datoteka za branje ni veljavna '+
    '"Portable Network Graphics" slika, ker vsebuje neveljavno glavo.' +
    ' Datoteka je verjetno pokvarjena, poskusite jo ponovno naloћiti.';
  EPNGIHDRNotFirstText = 'Ta "Portable Network Graphics" slika ni ' +
    'podprta ali pa je neveljavna.'#13#10 + '(IHDR del datoteke ni prvi).';
  EPNGNotExistsText = 'Ne morem naloћiti png datoteke, ker ta ne ' +
    'obstaja.';
  EPNGSizeExceedsText = 'Ta "Portable Network Graphics" slika ni ' +
    'podprta, ker ali njena љirina ali viљina presega najvecjo moћno vrednost ' +
    '65535 pik.';
  EPNGUnknownPalEntryText = 'Slika nima vneљene take barvne palete.';
  EPNGMissingPaletteText = 'Te "Portable Network Graphics" ne morem ' +
    'naloћiti, ker uporablja manjkajoco barvno paleto.';
  EPNGUnknownCriticalChunkText = 'Ta "Portable Network Graphics" slika ' +
    'vsebuje neznan kriticni del podatkov, ki ga ne morem prebrati.';
  EPNGUnknownCompressionText = 'Ta "Portable Network Graphics" slika je ' +
    'kodirana z neznano kompresijsko shemo, ki je ne morem prebrati.';
  EPNGUnknownInterlaceText = 'Ta "Portable Network Graphics" slika uporablja ' +
    'neznano shemo za preliv, ki je ne morem prebrati.';
  EPNGCannotAssignChunkText = Koљcki morajo biti med seboj kompatibilni za prireditev vrednosti.';
  EPNGUnexpectedEndText = 'Ta "Portable Network Graphics" slika je neveljavna, ' +
    'ker je bralnik priљel do nepricakovanega konca datoteke.';
  EPNGNoImageDataText = 'Ta "Portable Network Graphics" ne vsebuje nobenih ' +
    'podatkov.';
  EPNGCannotAddChunkText = 'Program je poskusil dodati obstojeci kriticni ' +
    'kos podatkov k trenutni sliki, kar ni dovoljeno.';
  EPNGCannotAddInvalidImageText = 'Ni dovoljeno dodati nov kos podatkov, ' +
    'ker trenutna slika ni veljavna.';
  EPNGCouldNotLoadResourceText = 'Ne morem naloћiti png slike iz ' +
    'skladiљca.';
  EPNGOutMemoryText = 'Ne morem izvesti operacije, ker je  ' +
    'sistem ostal brez resorjev. Zaprite nekaj oken in poskusite znova.';
  EPNGCannotChangeTransparentText = 'Ni dovoljeno nastaviti prosojnosti posamezne barve ' +
    'za png slike, ki vsebujejo alfa prosojno vrednost za vsako piko ' +
    '(COLOR_RGBALPHA and COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Ta operacija ni veljavna, ker ' +
    'izbrana slika ne vsebuje veljavne glave.';
  EInvalidNewSize = 'The new size provided for image resizing is invalid.';
  EInvalidSpec = 'The "Portable Network Graphics" could not be created ' +
    'because invalid image type parameters have being provided.';
  {$ENDIF}


implementation

end.
