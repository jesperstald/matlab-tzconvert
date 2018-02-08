# matlab-tzconvert
convert between IANA and Windows time zone names in MATLAB

Uses unicodes list of windows time zones (http://unicode.org/repos/cldr/trunk/common/supplemental/windowsZones.xml) to convert between IANA and Windows time zones.

Usage:
`tz = tzconvert.IANA2Windows(IANA_timezone)`
`tz = tzconvert.Windows2IANA(Windows_timezone)`
