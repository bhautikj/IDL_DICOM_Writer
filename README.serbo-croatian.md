# DICOM WRITER 0.2.2

Jednom davno bio jedan frustriran i uplašen IDL programer za koga je pisanje DICOM datoteke bilo vrlo slično pokušaju izvlačenja kupusa iz nečijeg nosa. Srećom, vrlo ljubazan čovek po imenu [Mark O'Brajan](mailto:m.obrien@sghms.ac.uk) sprečio je eventualne povrede izazvane ovim povrćem (da, kupus nije voće) tako što mi je dao uredan kod za pisanje osnovnih DICOM datoteka. Tada je ovaj programer, koji više nije bio ni frustriran, ni uplašen, pretvorio taj kod u prirodni IDL kod i pobegao s njim. :) 

Napisao sam samo osnove IDL DICOM WRITER-a, ali dobro sam se zabavio pišući i nadam se da će IDL društvo uživati u igranju i proširivanju osnova. 
[Pošaljite mi mejl](mailto:bjoshi@gmail.com) ako imate bilo kakve komentare, sugestije ili pitanja. 

IDL DICOM WRITER možete naći `dicom_writer.pro`.

Primer koda za čitanje i testiranje generisanih DICOM fajlova možete naći `dicom_example.pro`. 

Trenutna verzija je 0,2,2 ad 06-02-2017. 

## Karakteristike:

* Stvara implicitne VR DICOM datoteke (little endian)
* Radi s većinom VR oznaka (osim za PN i SQ)
* Generiše pojedinačne listove slika, od većine celih (BYTE, FIX, UINT, LONG, ULONG) tipova podataka
* Izgleda (hehe) da se bavi (endian) problemima na testiranim platformama (win32 (little endian) and SPARC (big endian))
* Ima brz i jednostavan način za generisanje stvarno jednostavnih DICOM fajlova sa važnim oznakama ispunjenim lažnim vrednostima.
* Relativno jednostavna struktura programa znači da se može lako proširiti novim oznakama
* Poznato je da, u ekstremnim slučajevima, ovaj program izaziva ozbiljno nadimanje.


##Napomene: 

[Mark O'Brajan](mailto:m.obrien@sghms.ac.uk) poslao mi je mejl s nekoliko veoma važnih napomena.

* Iako izgleda da DICOM WRITER radi s mnogim različitim programima, da biste garantovali da će raditi, pobrinite se za to da sve oznake koje pišete imaju tačan modalitet (tj. MR ili CT i sl.)
* "Potrebno je unakrsno pozivanje na različite delove standarda koji se utvrđuje; delovi moraju biti prisutni čak i ako su prazni. Izostavljene oznake za različite modalitete predstavljaju bolna mesta (treba mi čitav dan, ako ne i više, da ponovo otkrijem kom delu pripadaju različiti bitovi). Ali, to ne znači da će bilo koja druga oprema/softver na ovoj planeti, iako usaglašen s DICOM-om, prihvatiti vaš fajl sa slikom." (hvala, Mark)
* Standardi određuju koje oznake kuda idu. Na sajtu [http://medical.nema.org/dicom/2001.html](http://medical.nema.org/dicom/2001.html) naći ćete te standarde zajedno s opštim DICOM standardima.

## Extending `dicom_writer`

`Dicom_writer` može se proširiti dodatnim oznakama (kao što je već rečeno u DICOM rečniku podataka) ako treba da popunite već generisan DICOM fajl. `Generate_VRtag` funkcija može da se koristi s različitim tipovima vrednosti (VR). Pregled podržanih i nepodržanih fajlova, zajedno sa očekivanim tipom podataka za određenu funkciju, mogu se naći ispod navedenog

```
; generiši oznaku na osnovu podataka i tipa vrednosti. 
; na osnovu DICOM specs 3.5-1999 (tabele 6.2-1) 

; upotreba: generiši_VRoznaku (grupa, element, XX podatak) 
; gde XX predstavlja jedan od dole navedenih podržanih tipova vrednosti (VR). 
; 
; Ovo je spisak trenutnih podržanih/nepodržanih tipova vrednosti i očekivani tip vrednosti za varijablu “podatak” 
; 
; AE: 
; * Aplikacijski entitet - oznaka s alfanumeričkim nizom 
; * 16 bajtova max 
; * STRING 
; 
; AS: 
; * Age string - treba da bude nnnX, gde je X={D,W,M,Y} (dani, nedelje, meseci, godine) 
; * 4 bajta fiksno 
; * STRING 
; 
; AT: 
; * Attribute tag - trebalo bi da bude par neoznačenih celih brojeva koji predstavljaju podatke; 
; element tag, na primer. ['0018'x,'00FF'x] 
; * 8 bajta fiksno 
; * [UINT,UINT] 
; 
; CS: 
; * Code string - niz koda 
; * 32 bajta maksimum 
; * STRING 
; 
; DA: 
; * Date string - 8 bajtova fiksno, oblik: yyyymmdd, ili 10 bajtova fiksno 
; yyyy.mm.dd, kompatibilno s verzijama prior dicom v3.0 - 
; i tako će se koristiti 
; * 10 bajtova fiksno 
STRING 
; 
; DS 
; * Decimal string - pretvoriti decimalni zapis u niz i sačuvati - 
; * 16 bajtova max 
; * FLOAT/DOUBLE 
; 
; DT 
; * Date/time string - niz datum i vreme, format. max 26 bajtova 
; YYYMMDDGGMMSS.FFFFFF 
; * STRING 
; 
; FL: 
; * Floating point običan - 4 bajta čine jedan običan fp 
; * čuva se kao LITTLE ENDIAN - treba da se proveri!!!! 
; * 4 bajta fiksno 
; * FLOAT 
; 
; FD: 
; * Floating point double - 8 bajtova za dupli fp 
; * čuva se kao LITTLE ENDIAN - treba da se proveri!!!! 
; * 8 bajta fiksno 
; * DOUBLE 
; 
; IS: 
; * Decimal string - konvertuje ceo broj u niz i čuva ga 
; * 12 bajtova max 
; * FIX 
; 
; LO: 
; * long string (dugi niz) - IDL ne obraća pažnju na to 
; * 64 bajta max 
; * DUGAČAK 
; 
; LT: 
; * long text (dug tekst) - IDL ne obraća pažnju ni na ovo 
; * 10240 bajtova max 
; * STRING 
; 
; OB 
; * other byte string (niz ostalih bajtova) - popunjen sa 00H 
; * promenljive dužine 
; * STRING/BYTE; 
; 
OW 
; * other word string (niz ostalih reči) - popunjen sa 00H. nisam siguran da li ovo uopšte radi 
; * promenljive dužine 
; * STRING/BYTE 
; 
; PN: 
; * person name (ime osobe) - ne podržava! (još?) 
; 
; SH 
; * short string/kratak niz 
; * 16 bajtova max 
; * STRING 
; 
; SL: 
; * signed long int/dugačak ceo broj 
; * 4 bajta fiksno ; * LONG 
; 
; SQ: 
; * sequence of items/niz stavki - ne podržava! 
; 
; SS 
; * signed short/kratko potpisan 
; * 2 bajta fiksno 
; * FIXED 
; 
; ST: 
; * short text/kratak tekst 
; * 1024 bajta max 
; * STRING 
; 
; TM: 
; * time/vreme - u formatu hhmmss sat/minut/sekund 
; * 16 bajtova max 
; * STRING 
; 
; UI: 
; * jedinstvena identifikacija 
; * 64 bajta max 
; * STRING 
; 
; UL: 
; * unsigned long/nedodeljeni dugi 
; * 4 bajta fiksno 
; * ULONG 
; 
; UN: 
; * unknown/nepoznat - radite s ovim šta god hoćete 
; * dužina promenljiva 
; * STRING/BYTE 
; 
; US: 
; * unsigned short/nedodeljen kratak 
; * 2 bajta fiksna 
; * UINT 
; 
; UT: 
; * unlimited text/neograničen tekst 
; može biti ogroman! 
; * promenljiva dužina 
; * STRING 
```

Iz zaglavlja programa: 

```
; NAZIV: 
; DICOM_WRITER 
; 
; VERZIJA: 
; 0.2 
; 
; SVRHA: 
; Generisanje dicom datoteke RSI IDL 
; 
; AUTOR: 
; Bhautik Joshi 
; 
; E-MAIL: 
; bjoshi@geocities.com 
; 
; WEB STRANICA: 
; http://cow.mooh.org 
; 
; UPOTREBA: 
; DICOM_WRITER, naziv fajla, slika, VOXELSIZE = veličina voksela, SSAI = ssai, $ 
; PATIENT = pacijent, PHYSICIAN = doktor 
; 
; UNOS: 
; filename - naziv fajla koji sadrži ime dicom datoteke u koju se unose podaci 
; image - slika (BYTE, FIX, UINT, LONG ili ULONG) slika - tip i bpp nisu automatski podešeni 
; 
; OPCIONI PARAMETRI 
; voxelsize - Niz od 3 vrednosti koje nisu fiksne predstavljaju veličinu voksela 
; imaju format [x,y,z], ili su podešene na standard [1.0,1.0,1.0] 
; ssai - Niz od 4 vrednosti cela broja koja predstavljaju identifikaciju, serijski broj, broj unosa, broj slike [studyID,seriesnum,acqnum,imagenum], 
; u suprotnom, podešen je na dati format [0,0,0,0] 
; patient - ime pacijenta, ako nije uneseno, unesite lažno ime 
; physician - ime lekara, ako nije uneseno, unesite lažno ime 
; 
; NAPOMENE O UPOTREBI (PROČITAJ! VAŽNO!): 
; * Program piše samo po jedan list u datom trenutku 
; * Dodatne dicom oznake lako se mogu dodati (pogledajte program, naročito funkciju 
; generate_VRtag function) 
; * U ovom trenutku ima malo ili ni malo automatskih provera grešaka, pa budite pažljivi! 
; * Izgleda da je za analizu dovoljan najmanji format slike oko 
; 100x100 
; * VAŽNO: DICOM writer pokušava da napiše 'Implicitni tip podatka VR' tipovi 
; DICOM datoteka - vidite DICOM standarde PS 3.5-1999, deo 7 
; * Može da napiše većinu VR (Value Represenation) oznaka putem nove funkcije 
; generate_VRtag. Trenutno podržava: 
; AE, AS, AT, CS, DA, DS, DT, FL, FD, FD, IS, LO, LT, OB, OW, 
; SH, SL, SS, ST, TM, UI, UL, UN, US, UT 
; i SQ, PN ne podržava (Pobegao sam koristeći UI umesto PN) 
; * Pogledajte komentare pored funkcije generate_VRtag i vidite napomene o upotrebi ili o funkciji koja vam omogućava da dodate sopstvene oznake 

; PRIMER: 
; Kreirajte ubitačno dosadnu sliku bajtova i sačuvajte je u dicom datoteci 
; dicom file, test.dcm, sa dimenzijama voksela [2.0,3.0,4.0], 
; redni broj=1,serijski broj =2,broj unosa=3 i broj slike=4: 
; 
; > redovi = 200 
; > kolone = 200 
; > slika = niz celih brojeva (redovi, kolone) 
; > dicom_writer, 'test.dcm', image, voxelsize=[2.0,3.0,4.0], ssai=[1,2,3,4] 
; 
; ISTORIJA: 
; Na osnovu rada Marka O'Brajana (m.obrien@sghms.ac.uk) 
TIFF_to_DICOM.c 
; verzija 0.1 08-01-2002 - proizvedena prva radna verzija 
; verzija 0.11 09-01-2002 - rešen endian problem i dodata funkcija get_lun 
; verzija 0.2 14-01-2002 - mnoge popravke i dodaci, između ostalih 
; * većina funkcija generate_* functions zamenjena sa generate_VRtag 
; * podrška za mnoge tipove vrednosti VR 
; * Autodetekcija za little/big endian građenje i automatsko ređanje neophodnih bajtova (za oznake/slike) 
; * automagična detekcija vrste slike i ubacivanje bpp-a ako je potrebno 
; * više podataka u zaglavlju može se uneti ručno 
; 
; URADITI: 
; * Dozvoliti grublje pisanje dicom-a 
; * Deo 10 - usklađenost (!!!!!!!!!!!) 
; * Pristojna proveru grešaka
```
