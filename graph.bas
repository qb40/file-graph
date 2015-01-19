DECLARE SUB setPalette (pal() AS ANY)
DECLARE SUB grpPalette ()
DECLARE SUB getPalette (pal() AS ANY)
'intpixel type
TYPE IntPixel
r AS INTEGER
g AS INTEGER
b AS INTEGER
END TYPE

'function declarations
DECLARE FUNCTION crc (a AS INTEGER)
DECLARE FUNCTION nospc$ (s$)


'config
OPTION BASE 0
DIM SHARED pal(256) AS IntPixel

'start
CLS
COLOR 15
PRINT "File Graph"
COLOR 7
PRINT "----------"
PRINT

'details
COLOR 14
INPUT "File name"; fsrc$
INPUT "Point gap [10]"; xGap%
IF xGap% < 1 THEN xGap% = 1
IF xGap% > 319 THEN xGap% = 319
INPUT "Time gap [.5]"; tGap!
IF tGap! < 0 THEN tGap! = 0

'show
SCREEN 13
getPalette pal()
grpPalette
OPEN "B", #1, fsrc$
length& = LOF(1)
SEEK #1, 1

'prepare
x% = 0
LINE (0, 0)-(0, 0), 1

FOR i& = 1 TO length&

'input
k$ = INKEY$
IF k$ = CHR$(27) THEN EXIT FOR
IF k$ <> "" THEN
CLS
x% = 0
LINE (0, 0)-(0, 0), 1
END IF

'display
byte% = ASC(INPUT$(1, #1))
y% = 5 + INT(.7 * (255 - byte%))
LINE -(x%, y%), byte%
SOUND 21000, tGap!
x% = x% + xGap%

'edge case
IF (x% > 319) THEN
x% = 0
LINE (0, 0)-(0, 0), 1
END IF

NEXT

'end
setPalette pal()
CLOSE #1
SCREEN 1
SYSTEM

FUNCTION crc (a AS INTEGER)
IF (a < 0) THEN crc = 0 ELSE crc = a
END FUNCTION

SUB getPalette (pal() AS IntPixel)

OUT &H3C7, 0
FOR i% = 0 TO 255
pal(i%).r = INP(&H3C9)
pal(i%).g = INP(&H3C9)
pal(i%).b = INP(&H3C9)
NEXT

END SUB

SUB grpPalette

OUT &H3C8, 0
FOR i% = 0 TO 255
OUT &H3C9, (i% \ 64) * 16
OUT &H3C9, ((i% \ 8) AND 7) * 8
OUT &H3C9, (i% AND 7) * 8
NEXT

END SUB

FUNCTION nospc$ (s$)
FOR i = 1 TO LEN(s$)
a$ = MID$(s$, i, 1)
IF (a$ <> " ") THEN b$ = b$ + a$
NEXT
nospc$ = b$
END FUNCTION

SUB setPalette (pal() AS IntPixel)

OUT &H3C8, 0
FOR i% = 0 TO 255
OUT &H3C9, pal(i%).r
OUT &H3C9, pal(i%).g
OUT &H3C9, pal(i%).b
NEXT

END SUB

