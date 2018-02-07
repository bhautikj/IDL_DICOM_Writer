# DICOM WRITER 0.2.2

[This readme [translated to Serbo-Croatian language](http://science.webhostinggeeks.com/dicom-writer-02) by [Web Geeks](http://webhostinggeeks.com/). - thanks Jovana!]


Once upon a time there was a frustrated and frightened IDL programmer who was finding writing DICOM files akin to trying to squeeze a cabbage out of ones nose. Luckily, a very kind man by the name of [Marc O'Brien](mailto:m.obrien@sghms.ac.uk) prevented vegetable related injury (yes, a cabbage is not a fruit) by giving away some neat C code to write some basic DICOM files. This programmer, no longer frustrated or frightened, converted this to native IDL code and ran with it :) 

The IDL DICOM writer is quite basic but I had a lot of fun writing it and hopefully the IDL community out there will have fun playing with and extending it. Message me if you have any comments, suggestions or queries. 

The IDL DICOM writer is in `dicom_writer.pro`.

Example code to read in and test the generated DICOM files can be found in `dicom_example.pro`. 
The current version is 0.2.2 as of 06-02-2017. 

## Current specs/features:

* Generates implicit VR DICOM files (little endian)
* Handles most VR tags (except for PN and SQ)
* Generates single slice images, from most integer (BYTE, FIX, UINT, LONG, ULONG) data types
* Seems (hehe) to handle endian-ness issues on tested platforms (win32 (little endian) and SPARC (big endian))
* Has a quick & easy mode for generating really simple DICOM files with important tags filled in with dummy values
* Relatively simple program structure means it can be easily extended to write more tags
* In extreme cases, the program is known to cause severe flatulence


##Notes: 

[Marc O'Brien](mailto:m.obrien@sghms.ac.uk) has emailed me with a couple of very important things to note: 

* Although the DICOM writer seems to work with many different programs, to guarantee it will work you need to ensure that the tags you write are correct for the modality (ie MR or CT or whatever) that you are writing for.
* "Cross referencing the different sections of the standard to determine, needed, must be present but can be empty, not needed tags for a particular modality is a pain (takes me at least a day to rediscover which sections the different bits are in, everytime!). But it does mean that you stand a good chance of your image file being accepted by any dicom conforming equipment\software on the planet." (thanks Marc)
* The standards determining which tags go where, along with the DICOM standard in general, can be found at [http://medical.nema.org/dicom/2001.html](http://medical.nema.org/dicom/2001.html).

## Extending `dicom_writer`

`dicom_writer` can be extended by adding extra DICOM tags (as specified in the DICOM data dictionary) to further fill out the generated DICOM file. The `generate_VRtag` function can be used with a variety of VR (Value Represenation) type tags to generate the tags to be written to the DICOM file. A summary of the supported and unsupported tags, along with the expected data type for the function, can be found below: 

```
; generate a tag based on its data and VR (value representation) 
; based on DICOM specs 3.5-1999 (table 6.2-1) 
; 
; usage: generate_VRtag(group, element, 'XX', data) 
; where XX is one of the supported VR types below 
; 
; This is a list of the current VR types supported/not supported 
; and the expected data type for the 'data' variable 
; 
; AE: 
; * Application Entity - normal string tag 
; * 16 bytes max 
; * STRING 
; 
; AS: 
; * Age String - should be nnnX, where X={D,W,M,Y} (days, weeks, months, years), 
; * 4 bytes fixed 
; * STRING 
; 
; AT: 
; * Attribute tag - should be a pair of unsigned integers representing a data 
; element tag eg. ['0018'x,'00FF'x] 
; * 8 bytes fixed 
; * [UINT,UINT] 
; 
; CS: 
; * Code string 
; * 32 bytes maximum 
; * STRING 
; 
; DA: 
; * Date string - 8 bytes fixed, formay yyyymmdd, or 10 bytes fixed 
; yyyy.mm.dd, which is compatible with versions prior dicom v3.0 - 
; so thats what will be used 
; * 10 bytes fixed 
; * STRING 
; 
; DS 
; * Decimal string - convert an float into a string, and store 
; * 16 bytes maximum 
; * FLOAT/DOUBLE 
; 
; DT 
; * Date/time string - 26 byte maximum string of format: 
; YYYMMDDGGMMSS.FFFFFF 
; * 26 bytes max 
; * STRING 
; 
; FL: 
; * Floating point single - 4 byte fp single val 
; * storing as LITTLE ENDIAN - needs to be checked!!!! 
; * 4 bytes fixed 
; * FLOAT 
; 
; FD: 
; * Floating point double - 8 byte fp double val 
; * storing as LITTLE ENDIAN - needs to be checked!!!! 
; * 8 bytes fixed 
; * DOUBLE 
; 
; IS: 
; * Decimal string - convert an int into a string, and store 
; * 12 bytes maximum 
; * FIX 
; 
; LO: 
; * long string - IDL doesn't care about this one 
; * 64 bytes maximum 
; * LONG 
; 
; LT: 
; * long text - IDL doesn't care about this one too much 
; * 10240 bytes maximum 
; * STRING 
; 
; OB 
; * other byte string - padded by 00H 
; * length variable 
; * STRING/BYTE 
; 
; OW 
; * other word string - padded by 00H. not sure if this is working 
; * length variable 
; * STRING/BYTE 
; 
; PN: 
; * person name - not supported! (yet?) 
; 
; SH 
; * short string 
; * 16 bytes maximum 
; * STRING 
; 
; SL: 
; * signed long int 
; * 4 bytes fixed 
; * LONG 
; 
; SQ: 
; * sequence of items - not supported! 
; 
; SS 
; * signed short 
; * 2 bytes fixed 
; * FIX 
; 
; ST: 
; * short text 
; * 1024 bytes maximum 
; * STRING 
; 
; TM: 
; * time - of format hhmmss.frac 
; * 16 bytes maximum 
; * STRING 
; 
; UI: 
; * unique identifier 
; * 64 bytes maximum 
; * STRING 
; 
; UL: 
; * unsigned long 
; * 4 bytes fixed 
; * ULONG 
; 
; UN: 
; * unknown - do whatever you please with this one 
; * variable length 
; * STRING/BYTE 
; 
; US: 
; * unsigned short 
; * 2 bytes fixed 
; * UINT 
; 
; UT: 
; * unlimited text
; could be huge! 
; * variable length 
; * STRING 
; 
```


And from the program header: 

```
; 
; NAME: 
; DICOM_WRITER 
; 
; VERSION: 
;	0.2.2
; 
; PURPOSE: 
;	Generate a dicom file from within RSI IDL 
; 
; AUTHOR: 
;	Bhautik Joshi 
; 
; EMAIL: 
;	bjoshi@gmai..com
; 
; HOMEPAGE: 
;	http://cow.mooh.org 
; 
; USE: 
;	DICOM_WRITER, filename, image, VOXELSIZE = voxelsize, SSAI = ssai, $ 
;	PATIENT = patient, PHYSICIAN = physician 
; 
; INPUT: 
;	filename - string containing name of dicom file to be written to 
;	image - Integer (BYTE, FIX, UINT, LONG or ULONG) image - type and bpp 
;	is now automagically set 
; 
; OPTIONAL PARAMETERS 
;	voxelsize - Array of 3 floating point values representing voxel size 
;	with the format [x,y,z], otherwise set to default of [1.0,1.0,1.0] 
;	ssai - Array of 4 integer values representing studyID, seriesnum, 
; acqnum,imagenum, with the format [studyID,seriesnum,acqnum,imagenum], 
;	otherwise set to default of [0,0,0,0] 
;	patient - patient name, if not defined, set to dummy name 
;	physician - physician name, if not defined, set to dummy name 
; 
; NOTES ON USAGE (READ! IMPORTANT!): 
;	* At the moment the program only writes to a single slice 
;	* Extra dicom tags can be easily added (see body of program, especially 
;	generate_VRtag function) 
;	* There is little to no error-checking at the moment, so be 
;	careful! 
;	* Analyse seems to need a minimum image size of somewhere around 
;	100x100 
;	* IMPORTANT: The DICOM writer tries to write 'Implicit VR' type 
;	DICOM files - see DICOM standard PS 3.5-1999, part 7 
;	* Can write most VR (Value Represenation) tags via new function, 
;	generate_VRtag. Currently supported: 
;	AE, AS, AT, CS, DA, DS, DT, FL, FD, FD, IS, LO, LT, OB, OW, 
;	SH, SL, SS, ST, TM, UI, UL, UN, US, UT 
;	and SQ, PN unsupported (I got away with using UI in place of PN) 
;	* See comments near generate_VRtag function for notes on usage 
;	of the function for adding your own additional tags 
; 
; EXAMPLE: 
;	Create a horrendously boring byte image and store it in a 
;	dicom file, test.dcm, with voxel dimensions of [2.0,3.0,4.0], 
;	and studyid=1,series number=2,acquisiton number=3 and image 
;	number=4: 
; 
;	> rows = 200 
;	> cols = 200 
;	> image = indgen(rows,cols) 
;	> dicom_writer, 'test.dcm', image, voxelsize=[2.0,3.0,4.0], ssai=[1,2,3,4] 
; 
; HISTORY: 
;	Based on Marc O'Briens (m.obrien@sghms.ac.uk) TIFF_to_DICOM.c 
;	version 0.1 08-01-2002 - first working version produced 
;	version 0.11	09-01-2002 - fixed endian-ness issue & added get_lun 
;	functionality 
;	version 0.2	14-01-2002 - many fixes and additions, including: 
;  version 0.2.2 06-02-2018 - fixed ancient email address, moved to github
;	* replaced most generate_* functions with generate_VRtag 
;	* support for many VR (Value representation) types 
;	* Autodetection of little/big endian architecture and 
;	automagic byte ordering as necessary (for tags/image) 
;	* automagically detect image type and set bpp as necessary 
;	* more data in the header can be set manually 
; 
; TODO: 
;	* Allow for more robust dicom writing 
;	* Part 10 compliance (!!!!!!!!!!!) 
;	* Decent error checking
```
