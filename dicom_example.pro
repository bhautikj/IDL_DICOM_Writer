PRO Dicom_Example
   
filename=dialog_pickfile()
object = Obj_New('IDLffDicom',/verbose)
ok  = object->Read(filename)   
IF NOT ok THEN BEGIN
	Print, 'File: "' + filename + '" cannot be read. Returning...'
	RETURN
ENDIF     

name = object->GetValue('0010'x, '0010'x) 
IF Ptr_Valid(name[0]) THEN Print, 'name: ', *name[0] 
   
image = object->GetValue('7Fe0'x, '0010'x)
;IF Ptr_Valid(image[0]) THEN tvscl, BytScl(*image[0])

im_type = object->GetValue('0008'x,'0008'x)
IF Ptr_Valid(im_type[0]) THEN PRINT,'im_type: ',*im_type[0]

modality = object->GetValue('0008'x,'0060'x)
IF Ptr_Valid(modality[0]) THEN PRINT,'modality: ',*modality[0]

slice_spacing = object->GetValue('0018'x,'0088'x)
IF Ptr_Valid(slice_spacing[0]) THEN PRINT,'slice_spacing: ',*slice_spacing[0]

image_number = object->GetValue('0020'x,'0013'x)
IF Ptr_Valid(image_number[0]) THEN PRINT, 'image_number: ',*image_number[0]

rows = object->GetValue('0028'x,'0010'x)
IF Ptr_Valid(rows[0]) THEN PRINT, 'rows: ',*rows[0]

cols = object->GetValue('0028'x,'0011'x)
IF Ptr_Valid(cols[0]) THEN PRINT, 'cols: ',*cols[0]

spatial_res = object->GetValue('0018'x,'1050'x)
IF Ptr_Valid(spatial_res[0]) THEN PRINT, 'spatial_res: ',*spatial_res[0]

aspect_ratio = object ->GetValue('0028'x,'0034'x)
IF Ptr_Valid(aspect_ratio[0]) THEN PRINT, 'aspect_ratio: ',*aspect_ratio[0]

rows = object->GetValue('0028'x,'0010'x)
IF Ptr_Valid(rows[0]) THEN PRINT, 'rows: ',*rows[0]

cols = object->GetValue('0028'x,'0011'x)
IF Ptr_Valid(cols[0]) THEN PRINT, 'cols: ',*cols[0]

xys=object->GetValue('0028'x,'0030'x)
IF Ptr_Valid(xys[0]) THEN PRINT, 'xys: ',*xys[0]

zs = object->GetValue('0018'x,'0050'x)
IF Ptr_Valid(zs[0]) THEN PRINT,'zs: ',*zs[0]

xys=*xys[0]
zs=*zs[0]
sp=strpos(xys,'\')
voxelsizes=[FLOAT(strmid(xys,0,sp)), FLOAT(strmid(xys,sp+1)),FLOAT(zs)]

xy=[FLOAT(*rows[0]),FLOAT(*cols[0])]

print, voxelsizes
print, xy
zzzz=*image[0]
   
Obj_Destroy, object
   
Ptr_Free, name
Ptr_Free, image
     
END
