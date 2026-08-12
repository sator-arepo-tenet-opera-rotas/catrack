typedef struct _IO_COUNTERS { ULONGLONG ReadOperationCount; ULONGLONG WriteOperationCount; ULONGLONG OtherOperationCount; ULONGLONG ReadTransferCount; ULONGLONG WriteTransferCount; ULONGLONG OtherTransferCount;
} IO_COUNTERS, *PIO_COUNTERS;
typedef struct JOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION { JOBOBJECT_BASIC_ACCOUNTING_INFORMATION BasicInfo; IO_COUNTERS IoInfo;
} JOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION, *PJOBOBJECT_BASIC_AND_IO_ACCOU\
NTING_INFORMATION;



' Taken from stbasic09 (to test compatibility ...)

' Test-program "alert.LIS" for stbasic
PRINT "Test ALERT-Box with different texts"
TITLEW 1,"ALERT-BOX-TEST"
CLEARW 1
DEFFILL 2,3,3
PRBOX 40,140,600,190
COLOR get_color(65535,0,0)
BOX 50,200,590,250
DEFFILL 7,4,4
PELLIPSE 320,200,100,150
ALERT 3,"ALERT-TEST 1|text with 4 lines|and 3 buttons|select 2",2,"But1|But2|But3",a%
PRINT "ALERT-BOX 1  return value =";a%
COLOR get_color(0,65535,0)
DEFFILL 5,5,5
PBOX 60,260,580,320
COLOR 5
DEFLINE 0,5
CIRCLE 320,200,190
ALERT 2,"ALERT-Test 2",1,"but1|but2",a%
PRINT "ALERT-BOX 2  return value =";a%
QUIT

// assume hJob is a job handle
JOBOBJECT_BASIC_ACCOUNTING_INFORMATION info;
BOOL success = QueryInformationJobObject(hJob, JobObjectBasicAccountingInformat\ ion, &info, sizeof(info), nullptr);



ziff%()=[0x7b,0x42,0x37,0x67,0x4e,0x6d,0x7d,0x43,0x7f,0x6f]

' classical red design
rot=COLOR_RGB(0.9,0,0)     ! color for segment on
grau=COLOR_RGB(0.237,0,0)  ! color for segment off
schwarz=COLOR_RGB(0,0,0)   ! color for background
' LCD design
rot=COLOR_RGB(0.1,0.1,0.1)  ! color for segment on
grau=COLOR_RGB(0.8,0.6,0.7) ! color for segment off
schwarz=COLOR_RGB(0.6,0.7,0.6)  ! color for background
t$=""

scale=0.7

' italic=-0.2       ! for slight italic

bw=640*scale
bh=400*scale

SIZEW ,bw,bh
COLOR schwarz
PBOX 0,0,bw,bh
DO
  t$=@conv$(STR$(mem,13,13))
  groesse=scale
  @puts7(0,0,t$)
  groesse=0.5*scale
  t$=@conv$(TIME$+"  "+DATE$)
  @puts7(0,100*scale,t$)
  t$=@conv$(STR$(TIMER))
  @puts7(400*scale,100*scale,t$)
  groesse=2*scale
  t$=@conv$(STR$(acu,10,7))
  @puts7(0,200*scale,t$)
  groesse=1*scale
  t$=@conv$(HEX$(mem,13))
  @puts7(0,320*scale,t$)

  SHOWPAGE
  IF EVENT?(1)
    KEYEVENT a,b,c$
    IF left$(c$)>="0" AND LEFT$(c$)<="9"
      IF clearacu
        acu=0
        clearacu=0
      ENDIF
      acu=acu*10+(ASC(LEFT$(c$))-asc("0"))
    ELSE if instr("+-/^*",LEFT$(c$))
      x=acu
      clearacu=true
      mod$=LEFT$(c$)
    ELSE if LEFT$(c$)="~"
      acu=-acu
    ELSE if LEFT$(c$)="p"
      acu=pi
      clearacu=true
    ELSE if LEFT$(c$)="m"
      mem=acu
    ELSE if LEFT$(c$)="="
      IF mod$="+"
        acu=acu+x
      ELSE if mod$="-"
        acu=x-acu
      ELSE if mod$="*"
        acu=x*acu
      ELSE if mod$="/"
        IF acu<>0
          acu=x/acu
        ELSE
          acu=nan
        ENDIF
      ELSE if mod$="^"
        acu=x^acu
      ENDIF
      clearacu=true
    ELSE
      PRINT at(1,1);a,HEX$(b),c$,"   "
    ENDIF
  ELSE
    PAUSE 0.1
  ENDIF
LOOP
END

PROCEDURE puts7(x,y,c$)
  LOCAL i
  FOR i=0 TO LEN(c$)-1
    @put7(x,y,groesse,peek(varptr(c$)+i))
    ADD x,32*groesse
    IF x>640*scale
      x=0
      ADD y,64*groesse
    ENDIF
  NEXT i
RETURN
PROCEDURE put7(x,y,s,c)
  LOCAL i,p1,p2,p3,p4
  ' color schwarz
  ' pbox x,y,x+s*32,y+s*64
  d%()=[3,3,29,3;29,3,29,29;3,32,29,32;3,3,3,29;3,32,3,61;3,61,29,61;29,61,29,32;34,64,35,64]
  FOR i=0 TO 7
    IF btst(c,i)
      COLOR rot
    ELSE
      COLOR grau
    ENDIF
    DEFLINE ,4*s,2
    p1=d%(i,0)*s*0.8
    p2=d%(i,1)*s*0.6
    p3=d%(i,2)*s*0.8
    p4=d%(i,3)*s*0.6
    LINE x+p1+p2*italic,y+p2,x+p3+p4*italic,y+p4
  NEXT i
RETURN

FUNCTION conv$(t$)
  LOCAL i,a$
  a$=""
  FOR i=0 TO LEN(t$)-1
    IF PEEK(VARPTR(t$)+i)=ASC(".")
      IF LEN(a$)
        POKE VARPTR(a$)+LEN(a$)-1,PEEK(VARPTR(a$)+LEN(a$)-1) OR 0x80
      ELSE
        a$=CHR$(ziff%(0) OR 0x80)
      ENDIF
    ELSE IF PEEK(VARPTR(t$)+i)=ASC(" ")
      a$=a$+CHR$(0)
    ELSE if PEEK(VARPTR(t$)+i)=ASC("-")
      a$=a$+CHR$(4)
    ELSE if PEEK(VARPTR(t$)+i)=ASC("e")
      a$=a$+CHR$(0x3d)
    ELSE if PEEK(VARPTR(t$)+i)=ASC("E")
      a$=a$+CHR$(0x3d)
    ELSE if PEEK(VARPTR(t$)+i)=ASC("f")
      a$=a$+CHR$(0x1d)
    ELSE if PEEK(VARPTR(t$)+i)=ASC("a")
      a$=a$+CHR$(0x5f)
    ELSE if PEEK(VARPTR(t$)+i)=ASC(":")
      a$=a$+CHR$(0x04)
    ELSE
      a$=a$+CHR$(ziff%(PEEK(VARPTR(t$)+i)-ASC("0")))
    ENDIF
  NEXT i
  RETURN a$
ENDFUNCTION
