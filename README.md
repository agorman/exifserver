# ExifServer

Exifserver is a light weight HTTP server on top of ExifTool.


# Why ExifServer?

ExifTool is a powerful and widely used tool for reading metadata from media files. However, Perl has a costly startup time when calling it on the command line. By preloading the application and adding an HTTP interface that startup time can be mitigated.


# Usage

The server has a single POST endpoint that takes a JSON request body.

POST /

~~~
{
    "path": "",
    "options": {},
    "tags": [],
    "format_groups": 0
}
~~~

## path

Path is the path to the file you want to analyze with ExifTool.

## options

The [Options](https://metacpan.org/dist/Image-ExifTool/view/lib/Image/ExifTool.pod#Options) object can be used to change how the data from ExifTool is returned. If options is omitted or empty then the default options will be used.

## tags

Tags is a list of tags you'd like ExifTool to return. If tags are specified then they will be the only fields returned. If tags is omitted or empty then all tags will be returned.

## format_groups

Format groups allows the group to be returned with each tag. For example instead of just returning the tag `ISO` it will return the tag `ISO` and the group `EXIF`. format_groups takes the following values.

`0` - No groups are returned.

`1` - Groups are returned appended to the tag (`"EXIF:ISO": 640`)

`2` - Groups are returned as structured objects.

~~~
{
    "EXIF": {
        "ISO": 640
    }
}
~~~


# Example

## Request POST /
~~~
{
	"path": "/media/IMG_3072.JPG",
	"options": {
		"CoordFormat": "%+f",
		"FastScan": 2,
		"PrintConv": 0
	},
	"format_groups": 1
}
~~~

## Response

~~~
{
	"ICC_Profile:ProfileCreator": "appl",
	"EXIF:SceneCaptureType": 0,
	"File:FileName": "IMG_3072.JPG",
	"ICC_Profile:BlueMatrixColumn": "0.1571 0.06657 0.78407",
	"ICC_Profile:CMMFlags": 0,
	"ICC_Profile:RedMatrixColumn": "0.51512 0.2412 -0.00105",
	"ICC_Profile:ProfileCMMType": "appl",
	"ICC_Profile:ProfileClass": "mntr",
	"ICC_Profile:RenderingIntent": 0,
	"EXIF:LensInfo": "1.539999962 6 1.8 2.4",
	"Composite:LightValue": 3.92481250375005,
	"EXIF:ApertureValue": 1.79999999993144,
	"EXIF:ShutterSpeedValue": 0.0333289999111885,
	"EXIF:LensModel": "iPhone 11 Pro Max back triple camera 4.25mm f/1.8",
	"EXIF:YCbCrPositioning": 1,
	"EXIF:XResolution": "72",
	"File:BitsPerSample": 8,
	"EXIF:OffsetTime": "-07:00",
	"Composite:SubSecCreateDate": "2021:09:25 15:53:40.700-07:00",
	"EXIF:ResolutionUnit": 2,
	"ICC_Profile:ColorSpaceData": "RGB ",
	"ICC_Profile:MediaWhitePoint": "0.95045 1 1.08905",
	"Composite:Megapixels": 12.192768,
	"EXIF:FocalLengthIn35mmFormat": 26,
	"EXIF:LensMake": "Apple",
	"File:FileType": "JPEG",
	"File:FileModifyDate": "2024:06:05 12:21:19-07:00",
	"ICC_Profile:GreenTRC": null,
	"EXIF:MeteringMode": 5,
	"EXIF:ComponentsConfiguration": "1 2 3 0",
	"EXIF:Orientation": 6,
	"File:Directory": "/media",
	"EXIF:FlashpixVersion": "0100",
	"ICC_Profile:ProfileDateTime": "2017:07:07 13:22:32",
	"EXIF:Flash": 16,
	"Composite:ImageSize": "4032 3024",
	"ICC_Profile:RedTRC": null,
	"ExifTool:ExifToolVersion": "12.42",
	"Composite:HyperfocalDistance": 2.04314572276293,
	"EXIF:ExifImageWidth": 4032,
	"ICC_Profile:ProfileID": "202 26 149 130 37 127 16 77 56 153 19 213 209 234 21 130",
	"EXIF:CompositeImage": 2,
	"ICC_Profile:ProfileFileSignature": "acsp",
	"EXIF:SubjectArea": "2009 1509 2318 1390",
	"EXIF:DateTimeOriginal": "2021:09:25 15:53:40",
	"Composite:SubSecDateTimeOriginal": "2021:09:25 15:53:40.700-07:00",
	"ICC_Profile:GreenMatrixColumn": "0.29198 0.69225 0.04189",
	"Composite:SubSecModifyDate": "2021:09:25 15:53:40-07:00",
	"EXIF:TileLength": 512,
	"EXIF:Make": "Apple",
	"ICC_Profile:DeviceManufacturer": "APPL",
	"EXIF:OffsetTimeDigitized": "-07:00",
	"EXIF:ISO": 640,
	"Composite:ShutterSpeed": "0.03333333333",
	"EXIF:ExposureMode": 0,
	"EXIF:OffsetTimeOriginal": "-07:00",
	"File:YCbCrSubSampling": "2 2",
	"File:FileTypeExtension": "JPG",
	"EXIF:YResolution": "72",
	"File:FileInodeChangeDate": "2024:06:05 12:21:19-07:00",
	"EXIF:FocalLength": "4.25",
	"EXIF:ModifyDate": "2021:09:25 15:53:40",
	"File:ImageWidth": 4032,
	"ICC_Profile:ChromaticAdaptation": "1.04788 0.02292 -0.0502 0.02959 0.99048 -0.01706 -0.00923 0.01508 0.75168",
	"EXIF:Software": "14.8",
	"EXIF:SensingMethod": 2,
	"ICC_Profile:ProfileVersion": 1024,
	"ICC_Profile:DeviceModel": "",
	"EXIF:ExposureCompensation": "0",
	"Composite:CircleOfConfusion": 0.00491140798741088,
	"File:FileAccessDate": "2025:07:07 09:29:55-07:00",
	"File:ColorComponents": 3,
	"File:ImageHeight": 3024,
	"EXIF:CreateDate": "2021:09:25 15:53:40",
	"EXIF:WhiteBalance": 0,
	"EXIF:TileWidth": 512,
	"File:MIMEType": "image/jpeg",
	"EXIF:BrightnessValue": "-0.3980859279",
	"EXIF:Model": "iPhone 11 Pro Max",
	"ICC_Profile:ProfileDescription": "Display P3",
	"Composite:LensID": "iPhone 11 Pro Max back triple camera 4.25mm f/1.8",
	"Composite:FocalLength35efl": 26,
	"ICC_Profile:PrimaryPlatform": "APPL",
	"EXIF:SubSecTimeOriginal": "700",
	"ICC_Profile:ConnectionSpaceIlluminant": "0.9642 1 0.82491",
	"EXIF:ExifImageHeight": 3024,
	"Composite:Aperture": "1.8",
	"File:FilePermissions": "100777",
	"ICC_Profile:ProfileConnectionSpace": "XYZ ",
	"EXIF:SceneType": 1,
	"EXIF:SubSecTimeDigitized": "700",
	"EXIF:ExposureProgram": 2,
	"Composite:FOV": "69.3903656740024",
	"EXIF:FNumber": "1.8",
	"ICC_Profile:BlueTRC": null,
	"EXIF:ColorSpace": 65535,
	"File:EncodingProcess": 0,
	"ICC_Profile:ProfileCopyright": "Copyright Apple Inc., 2017",
	"Composite:ScaleFactor35efl": 6.11764705882353,
	"ICC_Profile:DeviceAttributes": "0 0",
	"File:ExifByteOrder": "MM",
	"EXIF:HostComputer": "iPhone 11 Pro Max",
	"File:FileSize": 4094728,
	"EXIF:ExposureTime": "0.03333333333",
	"EXIF:ExifVersion": "0232"
}
~~~