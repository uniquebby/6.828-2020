
obj/user/faultio.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 ae 22 80 00       	push   $0x8022ae
  800053:	e8 0c 01 00 00       	call   800164 <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 a0 22 80 00       	push   $0x8022a0
  800065:	e8 fa 00 00 00       	call   800164 <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007a:	e8 75 0a 00 00       	call   800af4 <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 db                	test   %ebx,%ebx
  800093:	7e 07                	jle    80009c <libmain+0x2d>
		binaryname = argv[0];
  800095:	8b 06                	mov    (%esi),%eax
  800097:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0a 00 00 00       	call   8000b5 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5d                   	pop    %ebp
  8000b4:	c3                   	ret    

008000b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bb:	e8 5a 0e 00 00       	call   800f1a <close_all>
	sys_env_destroy(0);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	6a 00                	push   $0x0
  8000c5:	e8 e9 09 00 00       	call   800ab3 <sys_env_destroy>
}
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	c9                   	leave  
  8000ce:	c3                   	ret    

008000cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d9:	8b 13                	mov    (%ebx),%edx
  8000db:	8d 42 01             	lea    0x1(%edx),%eax
  8000de:	89 03                	mov    %eax,(%ebx)
  8000e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ec:	74 09                	je     8000f7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ee:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	68 ff 00 00 00       	push   $0xff
  8000ff:	8d 43 08             	lea    0x8(%ebx),%eax
  800102:	50                   	push   %eax
  800103:	e8 6e 09 00 00       	call   800a76 <sys_cputs>
		b->idx = 0;
  800108:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	eb db                	jmp    8000ee <putch+0x1f>

00800113 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800123:	00 00 00 
	b.cnt = 0;
  800126:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80012d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800130:	ff 75 0c             	pushl  0xc(%ebp)
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013c:	50                   	push   %eax
  80013d:	68 cf 00 80 00       	push   $0x8000cf
  800142:	e8 19 01 00 00       	call   800260 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800147:	83 c4 08             	add    $0x8,%esp
  80014a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800150:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 1a 09 00 00       	call   800a76 <sys_cputs>

	return b.cnt;
}
  80015c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016d:	50                   	push   %eax
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	e8 9d ff ff ff       	call   800113 <vcprintf>
	va_end(ap);

	return cnt;
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	57                   	push   %edi
  80017c:	56                   	push   %esi
  80017d:	53                   	push   %ebx
  80017e:	83 ec 1c             	sub    $0x1c,%esp
  800181:	89 c7                	mov    %eax,%edi
  800183:	89 d6                	mov    %edx,%esi
  800185:	8b 45 08             	mov    0x8(%ebp),%eax
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800191:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800194:	bb 00 00 00 00       	mov    $0x0,%ebx
  800199:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80019c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80019f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001a2:	89 d0                	mov    %edx,%eax
  8001a4:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001aa:	73 15                	jae    8001c1 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001ac:	83 eb 01             	sub    $0x1,%ebx
  8001af:	85 db                	test   %ebx,%ebx
  8001b1:	7e 43                	jle    8001f6 <printnum+0x7e>
			putch(padc, putdat);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	56                   	push   %esi
  8001b7:	ff 75 18             	pushl  0x18(%ebp)
  8001ba:	ff d7                	call   *%edi
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	eb eb                	jmp    8001ac <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	ff 75 18             	pushl  0x18(%ebp)
  8001c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8001ca:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001cd:	53                   	push   %ebx
  8001ce:	ff 75 10             	pushl  0x10(%ebp)
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001da:	ff 75 dc             	pushl  -0x24(%ebp)
  8001dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e0:	e8 5b 1e 00 00       	call   802040 <__udivdi3>
  8001e5:	83 c4 18             	add    $0x18,%esp
  8001e8:	52                   	push   %edx
  8001e9:	50                   	push   %eax
  8001ea:	89 f2                	mov    %esi,%edx
  8001ec:	89 f8                	mov    %edi,%eax
  8001ee:	e8 85 ff ff ff       	call   800178 <printnum>
  8001f3:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	56                   	push   %esi
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800200:	ff 75 e0             	pushl  -0x20(%ebp)
  800203:	ff 75 dc             	pushl  -0x24(%ebp)
  800206:	ff 75 d8             	pushl  -0x28(%ebp)
  800209:	e8 42 1f 00 00       	call   802150 <__umoddi3>
  80020e:	83 c4 14             	add    $0x14,%esp
  800211:	0f be 80 d2 22 80 00 	movsbl 0x8022d2(%eax),%eax
  800218:	50                   	push   %eax
  800219:	ff d7                	call   *%edi
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5f                   	pop    %edi
  800224:	5d                   	pop    %ebp
  800225:	c3                   	ret    

00800226 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80022c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800230:	8b 10                	mov    (%eax),%edx
  800232:	3b 50 04             	cmp    0x4(%eax),%edx
  800235:	73 0a                	jae    800241 <sprintputch+0x1b>
		*b->buf++ = ch;
  800237:	8d 4a 01             	lea    0x1(%edx),%ecx
  80023a:	89 08                	mov    %ecx,(%eax)
  80023c:	8b 45 08             	mov    0x8(%ebp),%eax
  80023f:	88 02                	mov    %al,(%edx)
}
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    

00800243 <printfmt>:
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800249:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80024c:	50                   	push   %eax
  80024d:	ff 75 10             	pushl  0x10(%ebp)
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	e8 05 00 00 00       	call   800260 <vprintfmt>
}
  80025b:	83 c4 10             	add    $0x10,%esp
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <vprintfmt>:
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 3c             	sub    $0x3c,%esp
  800269:	8b 75 08             	mov    0x8(%ebp),%esi
  80026c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80026f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800272:	eb 0a                	jmp    80027e <vprintfmt+0x1e>
			putch(ch, putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	53                   	push   %ebx
  800278:	50                   	push   %eax
  800279:	ff d6                	call   *%esi
  80027b:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80027e:	83 c7 01             	add    $0x1,%edi
  800281:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800285:	83 f8 25             	cmp    $0x25,%eax
  800288:	74 0c                	je     800296 <vprintfmt+0x36>
			if (ch == '\0')
  80028a:	85 c0                	test   %eax,%eax
  80028c:	75 e6                	jne    800274 <vprintfmt+0x14>
}
  80028e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    
		padc = ' ';
  800296:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80029a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002a8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b4:	8d 47 01             	lea    0x1(%edi),%eax
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ba:	0f b6 17             	movzbl (%edi),%edx
  8002bd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c0:	3c 55                	cmp    $0x55,%al
  8002c2:	0f 87 ba 03 00 00    	ja     800682 <vprintfmt+0x422>
  8002c8:	0f b6 c0             	movzbl %al,%eax
  8002cb:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
  8002d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002d9:	eb d9                	jmp    8002b4 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002de:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002e2:	eb d0                	jmp    8002b4 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002e4:	0f b6 d2             	movzbl %dl,%edx
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002f2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002f5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002f9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002fc:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ff:	83 f9 09             	cmp    $0x9,%ecx
  800302:	77 55                	ja     800359 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800304:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800307:	eb e9                	jmp    8002f2 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800309:	8b 45 14             	mov    0x14(%ebp),%eax
  80030c:	8b 00                	mov    (%eax),%eax
  80030e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800311:	8b 45 14             	mov    0x14(%ebp),%eax
  800314:	8d 40 04             	lea    0x4(%eax),%eax
  800317:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80031d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800321:	79 91                	jns    8002b4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800323:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800326:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800329:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800330:	eb 82                	jmp    8002b4 <vprintfmt+0x54>
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	85 c0                	test   %eax,%eax
  800337:	ba 00 00 00 00       	mov    $0x0,%edx
  80033c:	0f 49 d0             	cmovns %eax,%edx
  80033f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800345:	e9 6a ff ff ff       	jmp    8002b4 <vprintfmt+0x54>
  80034a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80034d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800354:	e9 5b ff ff ff       	jmp    8002b4 <vprintfmt+0x54>
  800359:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80035c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035f:	eb bc                	jmp    80031d <vprintfmt+0xbd>
			lflag++;
  800361:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800367:	e9 48 ff ff ff       	jmp    8002b4 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80036c:	8b 45 14             	mov    0x14(%ebp),%eax
  80036f:	8d 78 04             	lea    0x4(%eax),%edi
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	53                   	push   %ebx
  800376:	ff 30                	pushl  (%eax)
  800378:	ff d6                	call   *%esi
			break;
  80037a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80037d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800380:	e9 9c 02 00 00       	jmp    800621 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8d 78 04             	lea    0x4(%eax),%edi
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	99                   	cltd   
  80038e:	31 d0                	xor    %edx,%eax
  800390:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800392:	83 f8 0f             	cmp    $0xf,%eax
  800395:	7f 23                	jg     8003ba <vprintfmt+0x15a>
  800397:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  80039e:	85 d2                	test   %edx,%edx
  8003a0:	74 18                	je     8003ba <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003a2:	52                   	push   %edx
  8003a3:	68 ba 26 80 00       	push   $0x8026ba
  8003a8:	53                   	push   %ebx
  8003a9:	56                   	push   %esi
  8003aa:	e8 94 fe ff ff       	call   800243 <printfmt>
  8003af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b5:	e9 67 02 00 00       	jmp    800621 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8003ba:	50                   	push   %eax
  8003bb:	68 ea 22 80 00       	push   $0x8022ea
  8003c0:	53                   	push   %ebx
  8003c1:	56                   	push   %esi
  8003c2:	e8 7c fe ff ff       	call   800243 <printfmt>
  8003c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ca:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003cd:	e9 4f 02 00 00       	jmp    800621 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d5:	83 c0 04             	add    $0x4,%eax
  8003d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003e0:	85 d2                	test   %edx,%edx
  8003e2:	b8 e3 22 80 00       	mov    $0x8022e3,%eax
  8003e7:	0f 45 c2             	cmovne %edx,%eax
  8003ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f1:	7e 06                	jle    8003f9 <vprintfmt+0x199>
  8003f3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003f7:	75 0d                	jne    800406 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003fc:	89 c7                	mov    %eax,%edi
  8003fe:	03 45 e0             	add    -0x20(%ebp),%eax
  800401:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800404:	eb 3f                	jmp    800445 <vprintfmt+0x1e5>
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 d8             	pushl  -0x28(%ebp)
  80040c:	50                   	push   %eax
  80040d:	e8 0d 03 00 00       	call   80071f <strnlen>
  800412:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800415:	29 c2                	sub    %eax,%edx
  800417:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80041f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800423:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800426:	85 ff                	test   %edi,%edi
  800428:	7e 58                	jle    800482 <vprintfmt+0x222>
					putch(padc, putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	53                   	push   %ebx
  80042e:	ff 75 e0             	pushl  -0x20(%ebp)
  800431:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800433:	83 ef 01             	sub    $0x1,%edi
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	eb eb                	jmp    800426 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	53                   	push   %ebx
  80043f:	52                   	push   %edx
  800440:	ff d6                	call   *%esi
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800448:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80044a:	83 c7 01             	add    $0x1,%edi
  80044d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800451:	0f be d0             	movsbl %al,%edx
  800454:	85 d2                	test   %edx,%edx
  800456:	74 45                	je     80049d <vprintfmt+0x23d>
  800458:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80045c:	78 06                	js     800464 <vprintfmt+0x204>
  80045e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800462:	78 35                	js     800499 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800464:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800468:	74 d1                	je     80043b <vprintfmt+0x1db>
  80046a:	0f be c0             	movsbl %al,%eax
  80046d:	83 e8 20             	sub    $0x20,%eax
  800470:	83 f8 5e             	cmp    $0x5e,%eax
  800473:	76 c6                	jbe    80043b <vprintfmt+0x1db>
					putch('?', putdat);
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	53                   	push   %ebx
  800479:	6a 3f                	push   $0x3f
  80047b:	ff d6                	call   *%esi
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	eb c3                	jmp    800445 <vprintfmt+0x1e5>
  800482:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800485:	85 d2                	test   %edx,%edx
  800487:	b8 00 00 00 00       	mov    $0x0,%eax
  80048c:	0f 49 c2             	cmovns %edx,%eax
  80048f:	29 c2                	sub    %eax,%edx
  800491:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800494:	e9 60 ff ff ff       	jmp    8003f9 <vprintfmt+0x199>
  800499:	89 cf                	mov    %ecx,%edi
  80049b:	eb 02                	jmp    80049f <vprintfmt+0x23f>
  80049d:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80049f:	85 ff                	test   %edi,%edi
  8004a1:	7e 10                	jle    8004b3 <vprintfmt+0x253>
				putch(' ', putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	6a 20                	push   $0x20
  8004a9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ab:	83 ef 01             	sub    $0x1,%edi
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	eb ec                	jmp    80049f <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b9:	e9 63 01 00 00       	jmp    800621 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8004be:	83 f9 01             	cmp    $0x1,%ecx
  8004c1:	7f 1b                	jg     8004de <vprintfmt+0x27e>
	else if (lflag)
  8004c3:	85 c9                	test   %ecx,%ecx
  8004c5:	74 63                	je     80052a <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004cf:	99                   	cltd   
  8004d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8d 40 04             	lea    0x4(%eax),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	eb 17                	jmp    8004f5 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 08             	lea    0x8(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004fb:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800500:	85 c9                	test   %ecx,%ecx
  800502:	0f 89 ff 00 00 00    	jns    800607 <vprintfmt+0x3a7>
				putch('-', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 2d                	push   $0x2d
  80050e:	ff d6                	call   *%esi
				num = -(long long) num;
  800510:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800513:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800516:	f7 da                	neg    %edx
  800518:	83 d1 00             	adc    $0x0,%ecx
  80051b:	f7 d9                	neg    %ecx
  80051d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800520:	b8 0a 00 00 00       	mov    $0xa,%eax
  800525:	e9 dd 00 00 00       	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800532:	99                   	cltd   
  800533:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 40 04             	lea    0x4(%eax),%eax
  80053c:	89 45 14             	mov    %eax,0x14(%ebp)
  80053f:	eb b4                	jmp    8004f5 <vprintfmt+0x295>
	if (lflag >= 2)
  800541:	83 f9 01             	cmp    $0x1,%ecx
  800544:	7f 1e                	jg     800564 <vprintfmt+0x304>
	else if (lflag)
  800546:	85 c9                	test   %ecx,%ecx
  800548:	74 32                	je     80057c <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 10                	mov    (%eax),%edx
  80054f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80055a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055f:	e9 a3 00 00 00       	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 10                	mov    (%eax),%edx
  800569:	8b 48 04             	mov    0x4(%eax),%ecx
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
  800577:	e9 8b 00 00 00       	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800591:	eb 74                	jmp    800607 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1b                	jg     8005b3 <vprintfmt+0x353>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 2c                	je     8005c8 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b1:	eb 54                	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 10                	mov    (%eax),%edx
  8005b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bb:	8d 40 08             	lea    0x8(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c6:	eb 3f                	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8005dd:	eb 28                	jmp    800607 <vprintfmt+0x3a7>
			putch('0', putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	6a 30                	push   $0x30
  8005e5:	ff d6                	call   *%esi
			putch('x', putdat);
  8005e7:	83 c4 08             	add    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 78                	push   $0x78
  8005ed:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005f9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800602:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800607:	83 ec 0c             	sub    $0xc,%esp
  80060a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80060e:	57                   	push   %edi
  80060f:	ff 75 e0             	pushl  -0x20(%ebp)
  800612:	50                   	push   %eax
  800613:	51                   	push   %ecx
  800614:	52                   	push   %edx
  800615:	89 da                	mov    %ebx,%edx
  800617:	89 f0                	mov    %esi,%eax
  800619:	e8 5a fb ff ff       	call   800178 <printnum>
			break;
  80061e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800621:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800624:	e9 55 fc ff ff       	jmp    80027e <vprintfmt+0x1e>
	if (lflag >= 2)
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <vprintfmt+0x3e9>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	74 2c                	je     80065e <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800642:	b8 10 00 00 00       	mov    $0x10,%eax
  800647:	eb be                	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	8b 48 04             	mov    0x4(%eax),%ecx
  800651:	8d 40 08             	lea    0x8(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800657:	b8 10 00 00 00       	mov    $0x10,%eax
  80065c:	eb a9                	jmp    800607 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	b9 00 00 00 00       	mov    $0x0,%ecx
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066e:	b8 10 00 00 00       	mov    $0x10,%eax
  800673:	eb 92                	jmp    800607 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	53                   	push   %ebx
  800679:	6a 25                	push   $0x25
  80067b:	ff d6                	call   *%esi
			break;
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	eb 9f                	jmp    800621 <vprintfmt+0x3c1>
			putch('%', putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	6a 25                	push   $0x25
  800688:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	89 f8                	mov    %edi,%eax
  80068f:	eb 03                	jmp    800694 <vprintfmt+0x434>
  800691:	83 e8 01             	sub    $0x1,%eax
  800694:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800698:	75 f7                	jne    800691 <vprintfmt+0x431>
  80069a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80069d:	eb 82                	jmp    800621 <vprintfmt+0x3c1>

0080069f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	83 ec 18             	sub    $0x18,%esp
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ae:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006b2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006bc:	85 c0                	test   %eax,%eax
  8006be:	74 26                	je     8006e6 <vsnprintf+0x47>
  8006c0:	85 d2                	test   %edx,%edx
  8006c2:	7e 22                	jle    8006e6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c4:	ff 75 14             	pushl  0x14(%ebp)
  8006c7:	ff 75 10             	pushl  0x10(%ebp)
  8006ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006cd:	50                   	push   %eax
  8006ce:	68 26 02 80 00       	push   $0x800226
  8006d3:	e8 88 fb ff ff       	call   800260 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e1:	83 c4 10             	add    $0x10,%esp
}
  8006e4:	c9                   	leave  
  8006e5:	c3                   	ret    
		return -E_INVAL;
  8006e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006eb:	eb f7                	jmp    8006e4 <vsnprintf+0x45>

008006ed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006f6:	50                   	push   %eax
  8006f7:	ff 75 10             	pushl  0x10(%ebp)
  8006fa:	ff 75 0c             	pushl  0xc(%ebp)
  8006fd:	ff 75 08             	pushl  0x8(%ebp)
  800700:	e8 9a ff ff ff       	call   80069f <vsnprintf>
	va_end(ap);

	return rc;
}
  800705:	c9                   	leave  
  800706:	c3                   	ret    

00800707 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
  80070a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80070d:	b8 00 00 00 00       	mov    $0x0,%eax
  800712:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800716:	74 05                	je     80071d <strlen+0x16>
		n++;
  800718:	83 c0 01             	add    $0x1,%eax
  80071b:	eb f5                	jmp    800712 <strlen+0xb>
	return n;
}
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	39 c2                	cmp    %eax,%edx
  80072f:	74 0d                	je     80073e <strnlen+0x1f>
  800731:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800735:	74 05                	je     80073c <strnlen+0x1d>
		n++;
  800737:	83 c2 01             	add    $0x1,%edx
  80073a:	eb f1                	jmp    80072d <strnlen+0xe>
  80073c:	89 d0                	mov    %edx,%eax
	return n;
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	53                   	push   %ebx
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800753:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800756:	83 c2 01             	add    $0x1,%edx
  800759:	84 c9                	test   %cl,%cl
  80075b:	75 f2                	jne    80074f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80075d:	5b                   	pop    %ebx
  80075e:	5d                   	pop    %ebp
  80075f:	c3                   	ret    

00800760 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	53                   	push   %ebx
  800764:	83 ec 10             	sub    $0x10,%esp
  800767:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80076a:	53                   	push   %ebx
  80076b:	e8 97 ff ff ff       	call   800707 <strlen>
  800770:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800773:	ff 75 0c             	pushl  0xc(%ebp)
  800776:	01 d8                	add    %ebx,%eax
  800778:	50                   	push   %eax
  800779:	e8 c2 ff ff ff       	call   800740 <strcpy>
	return dst;
}
  80077e:	89 d8                	mov    %ebx,%eax
  800780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	56                   	push   %esi
  800789:	53                   	push   %ebx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800790:	89 c6                	mov    %eax,%esi
  800792:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800795:	89 c2                	mov    %eax,%edx
  800797:	39 f2                	cmp    %esi,%edx
  800799:	74 11                	je     8007ac <strncpy+0x27>
		*dst++ = *src;
  80079b:	83 c2 01             	add    $0x1,%edx
  80079e:	0f b6 19             	movzbl (%ecx),%ebx
  8007a1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007a4:	80 fb 01             	cmp    $0x1,%bl
  8007a7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007aa:	eb eb                	jmp    800797 <strncpy+0x12>
	}
	return ret;
}
  8007ac:	5b                   	pop    %ebx
  8007ad:	5e                   	pop    %esi
  8007ae:	5d                   	pop    %ebp
  8007af:	c3                   	ret    

008007b0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	56                   	push   %esi
  8007b4:	53                   	push   %ebx
  8007b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007bb:	8b 55 10             	mov    0x10(%ebp),%edx
  8007be:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007c0:	85 d2                	test   %edx,%edx
  8007c2:	74 21                	je     8007e5 <strlcpy+0x35>
  8007c4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007c8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007ca:	39 c2                	cmp    %eax,%edx
  8007cc:	74 14                	je     8007e2 <strlcpy+0x32>
  8007ce:	0f b6 19             	movzbl (%ecx),%ebx
  8007d1:	84 db                	test   %bl,%bl
  8007d3:	74 0b                	je     8007e0 <strlcpy+0x30>
			*dst++ = *src++;
  8007d5:	83 c1 01             	add    $0x1,%ecx
  8007d8:	83 c2 01             	add    $0x1,%edx
  8007db:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007de:	eb ea                	jmp    8007ca <strlcpy+0x1a>
  8007e0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007e2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007e5:	29 f0                	sub    %esi,%eax
}
  8007e7:	5b                   	pop    %ebx
  8007e8:	5e                   	pop    %esi
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007f4:	0f b6 01             	movzbl (%ecx),%eax
  8007f7:	84 c0                	test   %al,%al
  8007f9:	74 0c                	je     800807 <strcmp+0x1c>
  8007fb:	3a 02                	cmp    (%edx),%al
  8007fd:	75 08                	jne    800807 <strcmp+0x1c>
		p++, q++;
  8007ff:	83 c1 01             	add    $0x1,%ecx
  800802:	83 c2 01             	add    $0x1,%edx
  800805:	eb ed                	jmp    8007f4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800807:	0f b6 c0             	movzbl %al,%eax
  80080a:	0f b6 12             	movzbl (%edx),%edx
  80080d:	29 d0                	sub    %edx,%eax
}
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081b:	89 c3                	mov    %eax,%ebx
  80081d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800820:	eb 06                	jmp    800828 <strncmp+0x17>
		n--, p++, q++;
  800822:	83 c0 01             	add    $0x1,%eax
  800825:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800828:	39 d8                	cmp    %ebx,%eax
  80082a:	74 16                	je     800842 <strncmp+0x31>
  80082c:	0f b6 08             	movzbl (%eax),%ecx
  80082f:	84 c9                	test   %cl,%cl
  800831:	74 04                	je     800837 <strncmp+0x26>
  800833:	3a 0a                	cmp    (%edx),%cl
  800835:	74 eb                	je     800822 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800837:	0f b6 00             	movzbl (%eax),%eax
  80083a:	0f b6 12             	movzbl (%edx),%edx
  80083d:	29 d0                	sub    %edx,%eax
}
  80083f:	5b                   	pop    %ebx
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    
		return 0;
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	eb f6                	jmp    80083f <strncmp+0x2e>

00800849 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800853:	0f b6 10             	movzbl (%eax),%edx
  800856:	84 d2                	test   %dl,%dl
  800858:	74 09                	je     800863 <strchr+0x1a>
		if (*s == c)
  80085a:	38 ca                	cmp    %cl,%dl
  80085c:	74 0a                	je     800868 <strchr+0x1f>
	for (; *s; s++)
  80085e:	83 c0 01             	add    $0x1,%eax
  800861:	eb f0                	jmp    800853 <strchr+0xa>
			return (char *) s;
	return 0;
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800874:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800877:	38 ca                	cmp    %cl,%dl
  800879:	74 09                	je     800884 <strfind+0x1a>
  80087b:	84 d2                	test   %dl,%dl
  80087d:	74 05                	je     800884 <strfind+0x1a>
	for (; *s; s++)
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	eb f0                	jmp    800874 <strfind+0xa>
			break;
	return (char *) s;
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	57                   	push   %edi
  80088a:	56                   	push   %esi
  80088b:	53                   	push   %ebx
  80088c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80088f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800892:	85 c9                	test   %ecx,%ecx
  800894:	74 31                	je     8008c7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800896:	89 f8                	mov    %edi,%eax
  800898:	09 c8                	or     %ecx,%eax
  80089a:	a8 03                	test   $0x3,%al
  80089c:	75 23                	jne    8008c1 <memset+0x3b>
		c &= 0xFF;
  80089e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008a2:	89 d3                	mov    %edx,%ebx
  8008a4:	c1 e3 08             	shl    $0x8,%ebx
  8008a7:	89 d0                	mov    %edx,%eax
  8008a9:	c1 e0 18             	shl    $0x18,%eax
  8008ac:	89 d6                	mov    %edx,%esi
  8008ae:	c1 e6 10             	shl    $0x10,%esi
  8008b1:	09 f0                	or     %esi,%eax
  8008b3:	09 c2                	or     %eax,%edx
  8008b5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008b7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008ba:	89 d0                	mov    %edx,%eax
  8008bc:	fc                   	cld    
  8008bd:	f3 ab                	rep stos %eax,%es:(%edi)
  8008bf:	eb 06                	jmp    8008c7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	fc                   	cld    
  8008c5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008c7:	89 f8                	mov    %edi,%eax
  8008c9:	5b                   	pop    %ebx
  8008ca:	5e                   	pop    %esi
  8008cb:	5f                   	pop    %edi
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	57                   	push   %edi
  8008d2:	56                   	push   %esi
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008dc:	39 c6                	cmp    %eax,%esi
  8008de:	73 32                	jae    800912 <memmove+0x44>
  8008e0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	76 2b                	jbe    800912 <memmove+0x44>
		s += n;
		d += n;
  8008e7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008ea:	89 fe                	mov    %edi,%esi
  8008ec:	09 ce                	or     %ecx,%esi
  8008ee:	09 d6                	or     %edx,%esi
  8008f0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008f6:	75 0e                	jne    800906 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008f8:	83 ef 04             	sub    $0x4,%edi
  8008fb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008fe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800901:	fd                   	std    
  800902:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800904:	eb 09                	jmp    80090f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800906:	83 ef 01             	sub    $0x1,%edi
  800909:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80090c:	fd                   	std    
  80090d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80090f:	fc                   	cld    
  800910:	eb 1a                	jmp    80092c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800912:	89 c2                	mov    %eax,%edx
  800914:	09 ca                	or     %ecx,%edx
  800916:	09 f2                	or     %esi,%edx
  800918:	f6 c2 03             	test   $0x3,%dl
  80091b:	75 0a                	jne    800927 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80091d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800920:	89 c7                	mov    %eax,%edi
  800922:	fc                   	cld    
  800923:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800925:	eb 05                	jmp    80092c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800927:	89 c7                	mov    %eax,%edi
  800929:	fc                   	cld    
  80092a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80092c:	5e                   	pop    %esi
  80092d:	5f                   	pop    %edi
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800936:	ff 75 10             	pushl  0x10(%ebp)
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 08             	pushl  0x8(%ebp)
  80093f:	e8 8a ff ff ff       	call   8008ce <memmove>
}
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800951:	89 c6                	mov    %eax,%esi
  800953:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800956:	39 f0                	cmp    %esi,%eax
  800958:	74 1c                	je     800976 <memcmp+0x30>
		if (*s1 != *s2)
  80095a:	0f b6 08             	movzbl (%eax),%ecx
  80095d:	0f b6 1a             	movzbl (%edx),%ebx
  800960:	38 d9                	cmp    %bl,%cl
  800962:	75 08                	jne    80096c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	eb ea                	jmp    800956 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80096c:	0f b6 c1             	movzbl %cl,%eax
  80096f:	0f b6 db             	movzbl %bl,%ebx
  800972:	29 d8                	sub    %ebx,%eax
  800974:	eb 05                	jmp    80097b <memcmp+0x35>
	}

	return 0;
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800988:	89 c2                	mov    %eax,%edx
  80098a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80098d:	39 d0                	cmp    %edx,%eax
  80098f:	73 09                	jae    80099a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800991:	38 08                	cmp    %cl,(%eax)
  800993:	74 05                	je     80099a <memfind+0x1b>
	for (; s < ends; s++)
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	eb f3                	jmp    80098d <memfind+0xe>
			break;
	return (void *) s;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	57                   	push   %edi
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a8:	eb 03                	jmp    8009ad <strtol+0x11>
		s++;
  8009aa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	3c 20                	cmp    $0x20,%al
  8009b2:	74 f6                	je     8009aa <strtol+0xe>
  8009b4:	3c 09                	cmp    $0x9,%al
  8009b6:	74 f2                	je     8009aa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009b8:	3c 2b                	cmp    $0x2b,%al
  8009ba:	74 2a                	je     8009e6 <strtol+0x4a>
	int neg = 0;
  8009bc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009c1:	3c 2d                	cmp    $0x2d,%al
  8009c3:	74 2b                	je     8009f0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009c5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009cb:	75 0f                	jne    8009dc <strtol+0x40>
  8009cd:	80 39 30             	cmpb   $0x30,(%ecx)
  8009d0:	74 28                	je     8009fa <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d9:	0f 44 d8             	cmove  %eax,%ebx
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009e4:	eb 50                	jmp    800a36 <strtol+0x9a>
		s++;
  8009e6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ee:	eb d5                	jmp    8009c5 <strtol+0x29>
		s++, neg = 1;
  8009f0:	83 c1 01             	add    $0x1,%ecx
  8009f3:	bf 01 00 00 00       	mov    $0x1,%edi
  8009f8:	eb cb                	jmp    8009c5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009fa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009fe:	74 0e                	je     800a0e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a00:	85 db                	test   %ebx,%ebx
  800a02:	75 d8                	jne    8009dc <strtol+0x40>
		s++, base = 8;
  800a04:	83 c1 01             	add    $0x1,%ecx
  800a07:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a0c:	eb ce                	jmp    8009dc <strtol+0x40>
		s += 2, base = 16;
  800a0e:	83 c1 02             	add    $0x2,%ecx
  800a11:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a16:	eb c4                	jmp    8009dc <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a18:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a1b:	89 f3                	mov    %esi,%ebx
  800a1d:	80 fb 19             	cmp    $0x19,%bl
  800a20:	77 29                	ja     800a4b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a22:	0f be d2             	movsbl %dl,%edx
  800a25:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a28:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a2b:	7d 30                	jge    800a5d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a2d:	83 c1 01             	add    $0x1,%ecx
  800a30:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a34:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a36:	0f b6 11             	movzbl (%ecx),%edx
  800a39:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a3c:	89 f3                	mov    %esi,%ebx
  800a3e:	80 fb 09             	cmp    $0x9,%bl
  800a41:	77 d5                	ja     800a18 <strtol+0x7c>
			dig = *s - '0';
  800a43:	0f be d2             	movsbl %dl,%edx
  800a46:	83 ea 30             	sub    $0x30,%edx
  800a49:	eb dd                	jmp    800a28 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a4b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a4e:	89 f3                	mov    %esi,%ebx
  800a50:	80 fb 19             	cmp    $0x19,%bl
  800a53:	77 08                	ja     800a5d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a55:	0f be d2             	movsbl %dl,%edx
  800a58:	83 ea 37             	sub    $0x37,%edx
  800a5b:	eb cb                	jmp    800a28 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a61:	74 05                	je     800a68 <strtol+0xcc>
		*endptr = (char *) s;
  800a63:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a66:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	f7 da                	neg    %edx
  800a6c:	85 ff                	test   %edi,%edi
  800a6e:	0f 45 c2             	cmovne %edx,%eax
}
  800a71:	5b                   	pop    %ebx
  800a72:	5e                   	pop    %esi
  800a73:	5f                   	pop    %edi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a81:	8b 55 08             	mov    0x8(%ebp),%edx
  800a84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a87:	89 c3                	mov    %eax,%ebx
  800a89:	89 c7                	mov    %eax,%edi
  800a8b:	89 c6                	mov    %eax,%esi
  800a8d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5f                   	pop    %edi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	57                   	push   %edi
  800a98:	56                   	push   %esi
  800a99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa4:	89 d1                	mov    %edx,%ecx
  800aa6:	89 d3                	mov    %edx,%ebx
  800aa8:	89 d7                	mov    %edx,%edi
  800aaa:	89 d6                	mov    %edx,%esi
  800aac:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5f                   	pop    %edi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	57                   	push   %edi
  800ab7:	56                   	push   %esi
  800ab8:	53                   	push   %ebx
  800ab9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800abc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac9:	89 cb                	mov    %ecx,%ebx
  800acb:	89 cf                	mov    %ecx,%edi
  800acd:	89 ce                	mov    %ecx,%esi
  800acf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ad1:	85 c0                	test   %eax,%eax
  800ad3:	7f 08                	jg     800add <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800add:	83 ec 0c             	sub    $0xc,%esp
  800ae0:	50                   	push   %eax
  800ae1:	6a 03                	push   $0x3
  800ae3:	68 df 25 80 00       	push   $0x8025df
  800ae8:	6a 23                	push   $0x23
  800aea:	68 fc 25 80 00       	push   $0x8025fc
  800aef:	e8 b1 13 00 00       	call   801ea5 <_panic>

00800af4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aff:	b8 02 00 00 00       	mov    $0x2,%eax
  800b04:	89 d1                	mov    %edx,%ecx
  800b06:	89 d3                	mov    %edx,%ebx
  800b08:	89 d7                	mov    %edx,%edi
  800b0a:	89 d6                	mov    %edx,%esi
  800b0c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5f                   	pop    %edi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <sys_yield>:

void
sys_yield(void)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b23:	89 d1                	mov    %edx,%ecx
  800b25:	89 d3                	mov    %edx,%ebx
  800b27:	89 d7                	mov    %edx,%edi
  800b29:	89 d6                	mov    %edx,%esi
  800b2b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5f                   	pop    %edi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
  800b38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b3b:	be 00 00 00 00       	mov    $0x0,%esi
  800b40:	8b 55 08             	mov    0x8(%ebp),%edx
  800b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b46:	b8 04 00 00 00       	mov    $0x4,%eax
  800b4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b4e:	89 f7                	mov    %esi,%edi
  800b50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b52:	85 c0                	test   %eax,%eax
  800b54:	7f 08                	jg     800b5e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b59:	5b                   	pop    %ebx
  800b5a:	5e                   	pop    %esi
  800b5b:	5f                   	pop    %edi
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b5e:	83 ec 0c             	sub    $0xc,%esp
  800b61:	50                   	push   %eax
  800b62:	6a 04                	push   $0x4
  800b64:	68 df 25 80 00       	push   $0x8025df
  800b69:	6a 23                	push   $0x23
  800b6b:	68 fc 25 80 00       	push   $0x8025fc
  800b70:	e8 30 13 00 00       	call   801ea5 <_panic>

00800b75 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b84:	b8 05 00 00 00       	mov    $0x5,%eax
  800b89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b8f:	8b 75 18             	mov    0x18(%ebp),%esi
  800b92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b94:	85 c0                	test   %eax,%eax
  800b96:	7f 08                	jg     800ba0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba0:	83 ec 0c             	sub    $0xc,%esp
  800ba3:	50                   	push   %eax
  800ba4:	6a 05                	push   $0x5
  800ba6:	68 df 25 80 00       	push   $0x8025df
  800bab:	6a 23                	push   $0x23
  800bad:	68 fc 25 80 00       	push   $0x8025fc
  800bb2:	e8 ee 12 00 00       	call   801ea5 <_panic>

00800bb7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcb:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd0:	89 df                	mov    %ebx,%edi
  800bd2:	89 de                	mov    %ebx,%esi
  800bd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd6:	85 c0                	test   %eax,%eax
  800bd8:	7f 08                	jg     800be2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	50                   	push   %eax
  800be6:	6a 06                	push   $0x6
  800be8:	68 df 25 80 00       	push   $0x8025df
  800bed:	6a 23                	push   $0x23
  800bef:	68 fc 25 80 00       	push   $0x8025fc
  800bf4:	e8 ac 12 00 00       	call   801ea5 <_panic>

00800bf9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c12:	89 df                	mov    %ebx,%edi
  800c14:	89 de                	mov    %ebx,%esi
  800c16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c18:	85 c0                	test   %eax,%eax
  800c1a:	7f 08                	jg     800c24 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c24:	83 ec 0c             	sub    $0xc,%esp
  800c27:	50                   	push   %eax
  800c28:	6a 08                	push   $0x8
  800c2a:	68 df 25 80 00       	push   $0x8025df
  800c2f:	6a 23                	push   $0x23
  800c31:	68 fc 25 80 00       	push   $0x8025fc
  800c36:	e8 6a 12 00 00       	call   801ea5 <_panic>

00800c3b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4f:	b8 09 00 00 00       	mov    $0x9,%eax
  800c54:	89 df                	mov    %ebx,%edi
  800c56:	89 de                	mov    %ebx,%esi
  800c58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5a:	85 c0                	test   %eax,%eax
  800c5c:	7f 08                	jg     800c66 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	50                   	push   %eax
  800c6a:	6a 09                	push   $0x9
  800c6c:	68 df 25 80 00       	push   $0x8025df
  800c71:	6a 23                	push   $0x23
  800c73:	68 fc 25 80 00       	push   $0x8025fc
  800c78:	e8 28 12 00 00       	call   801ea5 <_panic>

00800c7d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	57                   	push   %edi
  800c81:	56                   	push   %esi
  800c82:	53                   	push   %ebx
  800c83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c96:	89 df                	mov    %ebx,%edi
  800c98:	89 de                	mov    %ebx,%esi
  800c9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9c:	85 c0                	test   %eax,%eax
  800c9e:	7f 08                	jg     800ca8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca8:	83 ec 0c             	sub    $0xc,%esp
  800cab:	50                   	push   %eax
  800cac:	6a 0a                	push   $0xa
  800cae:	68 df 25 80 00       	push   $0x8025df
  800cb3:	6a 23                	push   $0x23
  800cb5:	68 fc 25 80 00       	push   $0x8025fc
  800cba:	e8 e6 11 00 00       	call   801ea5 <_panic>

00800cbf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd0:	be 00 00 00 00       	mov    $0x0,%esi
  800cd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cdb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cf8:	89 cb                	mov    %ecx,%ebx
  800cfa:	89 cf                	mov    %ecx,%edi
  800cfc:	89 ce                	mov    %ecx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 0d                	push   $0xd
  800d12:	68 df 25 80 00       	push   $0x8025df
  800d17:	6a 23                	push   $0x23
  800d19:	68 fc 25 80 00       	push   $0x8025fc
  800d1e:	e8 82 11 00 00       	call   801ea5 <_panic>

00800d23 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d33:	89 d1                	mov    %edx,%ecx
  800d35:	89 d3                	mov    %edx,%ebx
  800d37:	89 d7                	mov    %edx,%edi
  800d39:	89 d6                	mov    %edx,%esi
  800d3b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	05 00 00 00 30       	add    $0x30000000,%eax
  800d4d:	c1 e8 0c             	shr    $0xc,%eax
}
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d62:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d71:	89 c2                	mov    %eax,%edx
  800d73:	c1 ea 16             	shr    $0x16,%edx
  800d76:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d7d:	f6 c2 01             	test   $0x1,%dl
  800d80:	74 2d                	je     800daf <fd_alloc+0x46>
  800d82:	89 c2                	mov    %eax,%edx
  800d84:	c1 ea 0c             	shr    $0xc,%edx
  800d87:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d8e:	f6 c2 01             	test   $0x1,%dl
  800d91:	74 1c                	je     800daf <fd_alloc+0x46>
  800d93:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d98:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d9d:	75 d2                	jne    800d71 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800da8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800dad:	eb 0a                	jmp    800db9 <fd_alloc+0x50>
			*fd_store = fd;
  800daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800dc1:	83 f8 1f             	cmp    $0x1f,%eax
  800dc4:	77 30                	ja     800df6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dc6:	c1 e0 0c             	shl    $0xc,%eax
  800dc9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dce:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800dd4:	f6 c2 01             	test   $0x1,%dl
  800dd7:	74 24                	je     800dfd <fd_lookup+0x42>
  800dd9:	89 c2                	mov    %eax,%edx
  800ddb:	c1 ea 0c             	shr    $0xc,%edx
  800dde:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800de5:	f6 c2 01             	test   $0x1,%dl
  800de8:	74 1a                	je     800e04 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ded:	89 02                	mov    %eax,(%edx)
	return 0;
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		return -E_INVAL;
  800df6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfb:	eb f7                	jmp    800df4 <fd_lookup+0x39>
		return -E_INVAL;
  800dfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e02:	eb f0                	jmp    800df4 <fd_lookup+0x39>
  800e04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e09:	eb e9                	jmp    800df4 <fd_lookup+0x39>

00800e0b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 08             	sub    $0x8,%esp
  800e11:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800e14:	ba 00 00 00 00       	mov    $0x0,%edx
  800e19:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e1e:	39 08                	cmp    %ecx,(%eax)
  800e20:	74 38                	je     800e5a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800e22:	83 c2 01             	add    $0x1,%edx
  800e25:	8b 04 95 88 26 80 00 	mov    0x802688(,%edx,4),%eax
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	75 ee                	jne    800e1e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e30:	a1 08 40 80 00       	mov    0x804008,%eax
  800e35:	8b 40 48             	mov    0x48(%eax),%eax
  800e38:	83 ec 04             	sub    $0x4,%esp
  800e3b:	51                   	push   %ecx
  800e3c:	50                   	push   %eax
  800e3d:	68 0c 26 80 00       	push   $0x80260c
  800e42:	e8 1d f3 ff ff       	call   800164 <cprintf>
	*dev = 0;
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e50:	83 c4 10             	add    $0x10,%esp
  800e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    
			*dev = devtab[i];
  800e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e64:	eb f2                	jmp    800e58 <dev_lookup+0x4d>

00800e66 <fd_close>:
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	57                   	push   %edi
  800e6a:	56                   	push   %esi
  800e6b:	53                   	push   %ebx
  800e6c:	83 ec 24             	sub    $0x24,%esp
  800e6f:	8b 75 08             	mov    0x8(%ebp),%esi
  800e72:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e75:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e78:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e79:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e7f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e82:	50                   	push   %eax
  800e83:	e8 33 ff ff ff       	call   800dbb <fd_lookup>
  800e88:	89 c3                	mov    %eax,%ebx
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	78 05                	js     800e96 <fd_close+0x30>
	    || fd != fd2)
  800e91:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e94:	74 16                	je     800eac <fd_close+0x46>
		return (must_exist ? r : 0);
  800e96:	89 f8                	mov    %edi,%eax
  800e98:	84 c0                	test   %al,%al
  800e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9f:	0f 44 d8             	cmove  %eax,%ebx
}
  800ea2:	89 d8                	mov    %ebx,%eax
  800ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800eb2:	50                   	push   %eax
  800eb3:	ff 36                	pushl  (%esi)
  800eb5:	e8 51 ff ff ff       	call   800e0b <dev_lookup>
  800eba:	89 c3                	mov    %eax,%ebx
  800ebc:	83 c4 10             	add    $0x10,%esp
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	78 1a                	js     800edd <fd_close+0x77>
		if (dev->dev_close)
  800ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	74 0b                	je     800edd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	56                   	push   %esi
  800ed6:	ff d0                	call   *%eax
  800ed8:	89 c3                	mov    %eax,%ebx
  800eda:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800edd:	83 ec 08             	sub    $0x8,%esp
  800ee0:	56                   	push   %esi
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 cf fc ff ff       	call   800bb7 <sys_page_unmap>
	return r;
  800ee8:	83 c4 10             	add    $0x10,%esp
  800eeb:	eb b5                	jmp    800ea2 <fd_close+0x3c>

00800eed <close>:

int
close(int fdnum)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ef3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef6:	50                   	push   %eax
  800ef7:	ff 75 08             	pushl  0x8(%ebp)
  800efa:	e8 bc fe ff ff       	call   800dbb <fd_lookup>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	85 c0                	test   %eax,%eax
  800f04:	79 02                	jns    800f08 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    
		return fd_close(fd, 1);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	6a 01                	push   $0x1
  800f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f10:	e8 51 ff ff ff       	call   800e66 <fd_close>
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	eb ec                	jmp    800f06 <close+0x19>

00800f1a <close_all>:

void
close_all(void)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	53                   	push   %ebx
  800f1e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f26:	83 ec 0c             	sub    $0xc,%esp
  800f29:	53                   	push   %ebx
  800f2a:	e8 be ff ff ff       	call   800eed <close>
	for (i = 0; i < MAXFD; i++)
  800f2f:	83 c3 01             	add    $0x1,%ebx
  800f32:	83 c4 10             	add    $0x10,%esp
  800f35:	83 fb 20             	cmp    $0x20,%ebx
  800f38:	75 ec                	jne    800f26 <close_all+0xc>
}
  800f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f3d:	c9                   	leave  
  800f3e:	c3                   	ret    

00800f3f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f48:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 08             	pushl  0x8(%ebp)
  800f4f:	e8 67 fe ff ff       	call   800dbb <fd_lookup>
  800f54:	89 c3                	mov    %eax,%ebx
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	0f 88 81 00 00 00    	js     800fe2 <dup+0xa3>
		return r;
	close(newfdnum);
  800f61:	83 ec 0c             	sub    $0xc,%esp
  800f64:	ff 75 0c             	pushl  0xc(%ebp)
  800f67:	e8 81 ff ff ff       	call   800eed <close>

	newfd = INDEX2FD(newfdnum);
  800f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f6f:	c1 e6 0c             	shl    $0xc,%esi
  800f72:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f78:	83 c4 04             	add    $0x4,%esp
  800f7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7e:	e8 cf fd ff ff       	call   800d52 <fd2data>
  800f83:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f85:	89 34 24             	mov    %esi,(%esp)
  800f88:	e8 c5 fd ff ff       	call   800d52 <fd2data>
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f92:	89 d8                	mov    %ebx,%eax
  800f94:	c1 e8 16             	shr    $0x16,%eax
  800f97:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f9e:	a8 01                	test   $0x1,%al
  800fa0:	74 11                	je     800fb3 <dup+0x74>
  800fa2:	89 d8                	mov    %ebx,%eax
  800fa4:	c1 e8 0c             	shr    $0xc,%eax
  800fa7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fae:	f6 c2 01             	test   $0x1,%dl
  800fb1:	75 39                	jne    800fec <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fb6:	89 d0                	mov    %edx,%eax
  800fb8:	c1 e8 0c             	shr    $0xc,%eax
  800fbb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	25 07 0e 00 00       	and    $0xe07,%eax
  800fca:	50                   	push   %eax
  800fcb:	56                   	push   %esi
  800fcc:	6a 00                	push   $0x0
  800fce:	52                   	push   %edx
  800fcf:	6a 00                	push   $0x0
  800fd1:	e8 9f fb ff ff       	call   800b75 <sys_page_map>
  800fd6:	89 c3                	mov    %eax,%ebx
  800fd8:	83 c4 20             	add    $0x20,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	78 31                	js     801010 <dup+0xd1>
		goto err;

	return newfdnum;
  800fdf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fe2:	89 d8                	mov    %ebx,%eax
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	25 07 0e 00 00       	and    $0xe07,%eax
  800ffb:	50                   	push   %eax
  800ffc:	57                   	push   %edi
  800ffd:	6a 00                	push   $0x0
  800fff:	53                   	push   %ebx
  801000:	6a 00                	push   $0x0
  801002:	e8 6e fb ff ff       	call   800b75 <sys_page_map>
  801007:	89 c3                	mov    %eax,%ebx
  801009:	83 c4 20             	add    $0x20,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	79 a3                	jns    800fb3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	56                   	push   %esi
  801014:	6a 00                	push   $0x0
  801016:	e8 9c fb ff ff       	call   800bb7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80101b:	83 c4 08             	add    $0x8,%esp
  80101e:	57                   	push   %edi
  80101f:	6a 00                	push   $0x0
  801021:	e8 91 fb ff ff       	call   800bb7 <sys_page_unmap>
	return r;
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	eb b7                	jmp    800fe2 <dup+0xa3>

0080102b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	53                   	push   %ebx
  80102f:	83 ec 1c             	sub    $0x1c,%esp
  801032:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801035:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801038:	50                   	push   %eax
  801039:	53                   	push   %ebx
  80103a:	e8 7c fd ff ff       	call   800dbb <fd_lookup>
  80103f:	83 c4 10             	add    $0x10,%esp
  801042:	85 c0                	test   %eax,%eax
  801044:	78 3f                	js     801085 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104c:	50                   	push   %eax
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	ff 30                	pushl  (%eax)
  801052:	e8 b4 fd ff ff       	call   800e0b <dev_lookup>
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	85 c0                	test   %eax,%eax
  80105c:	78 27                	js     801085 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80105e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801061:	8b 42 08             	mov    0x8(%edx),%eax
  801064:	83 e0 03             	and    $0x3,%eax
  801067:	83 f8 01             	cmp    $0x1,%eax
  80106a:	74 1e                	je     80108a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80106c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106f:	8b 40 08             	mov    0x8(%eax),%eax
  801072:	85 c0                	test   %eax,%eax
  801074:	74 35                	je     8010ab <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801076:	83 ec 04             	sub    $0x4,%esp
  801079:	ff 75 10             	pushl  0x10(%ebp)
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	52                   	push   %edx
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
}
  801085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801088:	c9                   	leave  
  801089:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80108a:	a1 08 40 80 00       	mov    0x804008,%eax
  80108f:	8b 40 48             	mov    0x48(%eax),%eax
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	53                   	push   %ebx
  801096:	50                   	push   %eax
  801097:	68 4d 26 80 00       	push   $0x80264d
  80109c:	e8 c3 f0 ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a9:	eb da                	jmp    801085 <read+0x5a>
		return -E_NOT_SUPP;
  8010ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010b0:	eb d3                	jmp    801085 <read+0x5a>

008010b2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	57                   	push   %edi
  8010b6:	56                   	push   %esi
  8010b7:	53                   	push   %ebx
  8010b8:	83 ec 0c             	sub    $0xc,%esp
  8010bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010be:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c6:	39 f3                	cmp    %esi,%ebx
  8010c8:	73 23                	jae    8010ed <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	89 f0                	mov    %esi,%eax
  8010cf:	29 d8                	sub    %ebx,%eax
  8010d1:	50                   	push   %eax
  8010d2:	89 d8                	mov    %ebx,%eax
  8010d4:	03 45 0c             	add    0xc(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	57                   	push   %edi
  8010d9:	e8 4d ff ff ff       	call   80102b <read>
		if (m < 0)
  8010de:	83 c4 10             	add    $0x10,%esp
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	78 06                	js     8010eb <readn+0x39>
			return m;
		if (m == 0)
  8010e5:	74 06                	je     8010ed <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8010e7:	01 c3                	add    %eax,%ebx
  8010e9:	eb db                	jmp    8010c6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010eb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010ed:	89 d8                	mov    %ebx,%eax
  8010ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 1c             	sub    $0x1c,%esp
  8010fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801101:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801104:	50                   	push   %eax
  801105:	53                   	push   %ebx
  801106:	e8 b0 fc ff ff       	call   800dbb <fd_lookup>
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	78 3a                	js     80114c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801118:	50                   	push   %eax
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	ff 30                	pushl  (%eax)
  80111e:	e8 e8 fc ff ff       	call   800e0b <dev_lookup>
  801123:	83 c4 10             	add    $0x10,%esp
  801126:	85 c0                	test   %eax,%eax
  801128:	78 22                	js     80114c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80112a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801131:	74 1e                	je     801151 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801136:	8b 52 0c             	mov    0xc(%edx),%edx
  801139:	85 d2                	test   %edx,%edx
  80113b:	74 35                	je     801172 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	ff 75 10             	pushl  0x10(%ebp)
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	50                   	push   %eax
  801147:	ff d2                	call   *%edx
  801149:	83 c4 10             	add    $0x10,%esp
}
  80114c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114f:	c9                   	leave  
  801150:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801151:	a1 08 40 80 00       	mov    0x804008,%eax
  801156:	8b 40 48             	mov    0x48(%eax),%eax
  801159:	83 ec 04             	sub    $0x4,%esp
  80115c:	53                   	push   %ebx
  80115d:	50                   	push   %eax
  80115e:	68 69 26 80 00       	push   $0x802669
  801163:	e8 fc ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801170:	eb da                	jmp    80114c <write+0x55>
		return -E_NOT_SUPP;
  801172:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801177:	eb d3                	jmp    80114c <write+0x55>

00801179 <seek>:

int
seek(int fdnum, off_t offset)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80117f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	ff 75 08             	pushl  0x8(%ebp)
  801186:	e8 30 fc ff ff       	call   800dbb <fd_lookup>
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 0e                	js     8011a0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801192:	8b 55 0c             	mov    0xc(%ebp),%edx
  801195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801198:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80119b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 1c             	sub    $0x1c,%esp
  8011a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011af:	50                   	push   %eax
  8011b0:	53                   	push   %ebx
  8011b1:	e8 05 fc ff ff       	call   800dbb <fd_lookup>
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 37                	js     8011f4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c3:	50                   	push   %eax
  8011c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c7:	ff 30                	pushl  (%eax)
  8011c9:	e8 3d fc ff ff       	call   800e0b <dev_lookup>
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	78 1f                	js     8011f4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011dc:	74 1b                	je     8011f9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e1:	8b 52 18             	mov    0x18(%edx),%edx
  8011e4:	85 d2                	test   %edx,%edx
  8011e6:	74 32                	je     80121a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ee:	50                   	push   %eax
  8011ef:	ff d2                	call   *%edx
  8011f1:	83 c4 10             	add    $0x10,%esp
}
  8011f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011f9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011fe:	8b 40 48             	mov    0x48(%eax),%eax
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	53                   	push   %ebx
  801205:	50                   	push   %eax
  801206:	68 2c 26 80 00       	push   $0x80262c
  80120b:	e8 54 ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801218:	eb da                	jmp    8011f4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80121a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80121f:	eb d3                	jmp    8011f4 <ftruncate+0x52>

00801221 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	53                   	push   %ebx
  801225:	83 ec 1c             	sub    $0x1c,%esp
  801228:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 84 fb ff ff       	call   800dbb <fd_lookup>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	78 4b                	js     801289 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801244:	50                   	push   %eax
  801245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801248:	ff 30                	pushl  (%eax)
  80124a:	e8 bc fb ff ff       	call   800e0b <dev_lookup>
  80124f:	83 c4 10             	add    $0x10,%esp
  801252:	85 c0                	test   %eax,%eax
  801254:	78 33                	js     801289 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801259:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80125d:	74 2f                	je     80128e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80125f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801262:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801269:	00 00 00 
	stat->st_isdir = 0;
  80126c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801273:	00 00 00 
	stat->st_dev = dev;
  801276:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80127c:	83 ec 08             	sub    $0x8,%esp
  80127f:	53                   	push   %ebx
  801280:	ff 75 f0             	pushl  -0x10(%ebp)
  801283:	ff 50 14             	call   *0x14(%eax)
  801286:	83 c4 10             	add    $0x10,%esp
}
  801289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    
		return -E_NOT_SUPP;
  80128e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801293:	eb f4                	jmp    801289 <fstat+0x68>

00801295 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	6a 00                	push   $0x0
  80129f:	ff 75 08             	pushl  0x8(%ebp)
  8012a2:	e8 2f 02 00 00       	call   8014d6 <open>
  8012a7:	89 c3                	mov    %eax,%ebx
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 1b                	js     8012cb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	e8 65 ff ff ff       	call   801221 <fstat>
  8012bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8012be:	89 1c 24             	mov    %ebx,(%esp)
  8012c1:	e8 27 fc ff ff       	call   800eed <close>
	return r;
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	89 f3                	mov    %esi,%ebx
}
  8012cb:	89 d8                	mov    %ebx,%eax
  8012cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    

008012d4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	89 c6                	mov    %eax,%esi
  8012db:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012dd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012e4:	74 27                	je     80130d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012e6:	6a 07                	push   $0x7
  8012e8:	68 00 50 80 00       	push   $0x805000
  8012ed:	56                   	push   %esi
  8012ee:	ff 35 00 40 80 00    	pushl  0x804000
  8012f4:	e8 65 0c 00 00       	call   801f5e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012f9:	83 c4 0c             	add    $0xc,%esp
  8012fc:	6a 00                	push   $0x0
  8012fe:	53                   	push   %ebx
  8012ff:	6a 00                	push   $0x0
  801301:	e8 e5 0b 00 00       	call   801eeb <ipc_recv>
}
  801306:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5d                   	pop    %ebp
  80130c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80130d:	83 ec 0c             	sub    $0xc,%esp
  801310:	6a 01                	push   $0x1
  801312:	e8 b3 0c 00 00       	call   801fca <ipc_find_env>
  801317:	a3 00 40 80 00       	mov    %eax,0x804000
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	eb c5                	jmp    8012e6 <fsipc+0x12>

00801321 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8b 40 0c             	mov    0xc(%eax),%eax
  80132d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80133a:	ba 00 00 00 00       	mov    $0x0,%edx
  80133f:	b8 02 00 00 00       	mov    $0x2,%eax
  801344:	e8 8b ff ff ff       	call   8012d4 <fsipc>
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <devfile_flush>:
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8b 40 0c             	mov    0xc(%eax),%eax
  801357:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80135c:	ba 00 00 00 00       	mov    $0x0,%edx
  801361:	b8 06 00 00 00       	mov    $0x6,%eax
  801366:	e8 69 ff ff ff       	call   8012d4 <fsipc>
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <devfile_stat>:
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	53                   	push   %ebx
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8b 40 0c             	mov    0xc(%eax),%eax
  80137d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801382:	ba 00 00 00 00       	mov    $0x0,%edx
  801387:	b8 05 00 00 00       	mov    $0x5,%eax
  80138c:	e8 43 ff ff ff       	call   8012d4 <fsipc>
  801391:	85 c0                	test   %eax,%eax
  801393:	78 2c                	js     8013c1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801395:	83 ec 08             	sub    $0x8,%esp
  801398:	68 00 50 80 00       	push   $0x805000
  80139d:	53                   	push   %ebx
  80139e:	e8 9d f3 ff ff       	call   800740 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013a3:	a1 80 50 80 00       	mov    0x805080,%eax
  8013a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013ae:	a1 84 50 80 00       	mov    0x805084,%eax
  8013b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <devfile_write>:
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8013d0:	85 db                	test   %ebx,%ebx
  8013d2:	75 07                	jne    8013db <devfile_write+0x15>
	return n_all;
  8013d4:	89 d8                	mov    %ebx,%eax
}
  8013d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e1:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8013e6:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	68 08 50 80 00       	push   $0x805008
  8013f8:	e8 d1 f4 ff ff       	call   8008ce <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801402:	b8 04 00 00 00       	mov    $0x4,%eax
  801407:	e8 c8 fe ff ff       	call   8012d4 <fsipc>
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 c3                	js     8013d6 <devfile_write+0x10>
	  assert(r <= n_left);
  801413:	39 d8                	cmp    %ebx,%eax
  801415:	77 0b                	ja     801422 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801417:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80141c:	7f 1d                	jg     80143b <devfile_write+0x75>
    n_all += r;
  80141e:	89 c3                	mov    %eax,%ebx
  801420:	eb b2                	jmp    8013d4 <devfile_write+0xe>
	  assert(r <= n_left);
  801422:	68 9c 26 80 00       	push   $0x80269c
  801427:	68 a8 26 80 00       	push   $0x8026a8
  80142c:	68 9f 00 00 00       	push   $0x9f
  801431:	68 bd 26 80 00       	push   $0x8026bd
  801436:	e8 6a 0a 00 00       	call   801ea5 <_panic>
	  assert(r <= PGSIZE);
  80143b:	68 c8 26 80 00       	push   $0x8026c8
  801440:	68 a8 26 80 00       	push   $0x8026a8
  801445:	68 a0 00 00 00       	push   $0xa0
  80144a:	68 bd 26 80 00       	push   $0x8026bd
  80144f:	e8 51 0a 00 00       	call   801ea5 <_panic>

00801454 <devfile_read>:
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	56                   	push   %esi
  801458:	53                   	push   %ebx
  801459:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8b 40 0c             	mov    0xc(%eax),%eax
  801462:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801467:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80146d:	ba 00 00 00 00       	mov    $0x0,%edx
  801472:	b8 03 00 00 00       	mov    $0x3,%eax
  801477:	e8 58 fe ff ff       	call   8012d4 <fsipc>
  80147c:	89 c3                	mov    %eax,%ebx
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 1f                	js     8014a1 <devfile_read+0x4d>
	assert(r <= n);
  801482:	39 f0                	cmp    %esi,%eax
  801484:	77 24                	ja     8014aa <devfile_read+0x56>
	assert(r <= PGSIZE);
  801486:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80148b:	7f 33                	jg     8014c0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	50                   	push   %eax
  801491:	68 00 50 80 00       	push   $0x805000
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	e8 30 f4 ff ff       	call   8008ce <memmove>
	return r;
  80149e:	83 c4 10             	add    $0x10,%esp
}
  8014a1:	89 d8                	mov    %ebx,%eax
  8014a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a6:	5b                   	pop    %ebx
  8014a7:	5e                   	pop    %esi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    
	assert(r <= n);
  8014aa:	68 d4 26 80 00       	push   $0x8026d4
  8014af:	68 a8 26 80 00       	push   $0x8026a8
  8014b4:	6a 7c                	push   $0x7c
  8014b6:	68 bd 26 80 00       	push   $0x8026bd
  8014bb:	e8 e5 09 00 00       	call   801ea5 <_panic>
	assert(r <= PGSIZE);
  8014c0:	68 c8 26 80 00       	push   $0x8026c8
  8014c5:	68 a8 26 80 00       	push   $0x8026a8
  8014ca:	6a 7d                	push   $0x7d
  8014cc:	68 bd 26 80 00       	push   $0x8026bd
  8014d1:	e8 cf 09 00 00       	call   801ea5 <_panic>

008014d6 <open>:
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
  8014db:	83 ec 1c             	sub    $0x1c,%esp
  8014de:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014e1:	56                   	push   %esi
  8014e2:	e8 20 f2 ff ff       	call   800707 <strlen>
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014ef:	7f 6c                	jg     80155d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014f1:	83 ec 0c             	sub    $0xc,%esp
  8014f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	e8 6c f8 ff ff       	call   800d69 <fd_alloc>
  8014fd:	89 c3                	mov    %eax,%ebx
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 3c                	js     801542 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801506:	83 ec 08             	sub    $0x8,%esp
  801509:	56                   	push   %esi
  80150a:	68 00 50 80 00       	push   $0x805000
  80150f:	e8 2c f2 ff ff       	call   800740 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151f:	b8 01 00 00 00       	mov    $0x1,%eax
  801524:	e8 ab fd ff ff       	call   8012d4 <fsipc>
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 19                	js     80154b <open+0x75>
	return fd2num(fd);
  801532:	83 ec 0c             	sub    $0xc,%esp
  801535:	ff 75 f4             	pushl  -0xc(%ebp)
  801538:	e8 05 f8 ff ff       	call   800d42 <fd2num>
  80153d:	89 c3                	mov    %eax,%ebx
  80153f:	83 c4 10             	add    $0x10,%esp
}
  801542:	89 d8                	mov    %ebx,%eax
  801544:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    
		fd_close(fd, 0);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	6a 00                	push   $0x0
  801550:	ff 75 f4             	pushl  -0xc(%ebp)
  801553:	e8 0e f9 ff ff       	call   800e66 <fd_close>
		return r;
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	eb e5                	jmp    801542 <open+0x6c>
		return -E_BAD_PATH;
  80155d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801562:	eb de                	jmp    801542 <open+0x6c>

00801564 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80156a:	ba 00 00 00 00       	mov    $0x0,%edx
  80156f:	b8 08 00 00 00       	mov    $0x8,%eax
  801574:	e8 5b fd ff ff       	call   8012d4 <fsipc>
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
  801580:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	e8 c4 f7 ff ff       	call   800d52 <fd2data>
  80158e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801590:	83 c4 08             	add    $0x8,%esp
  801593:	68 db 26 80 00       	push   $0x8026db
  801598:	53                   	push   %ebx
  801599:	e8 a2 f1 ff ff       	call   800740 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80159e:	8b 46 04             	mov    0x4(%esi),%eax
  8015a1:	2b 06                	sub    (%esi),%eax
  8015a3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015b0:	00 00 00 
	stat->st_dev = &devpipe;
  8015b3:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015ba:	30 80 00 
	return 0;
}
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	53                   	push   %ebx
  8015cd:	83 ec 0c             	sub    $0xc,%esp
  8015d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015d3:	53                   	push   %ebx
  8015d4:	6a 00                	push   $0x0
  8015d6:	e8 dc f5 ff ff       	call   800bb7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015db:	89 1c 24             	mov    %ebx,(%esp)
  8015de:	e8 6f f7 ff ff       	call   800d52 <fd2data>
  8015e3:	83 c4 08             	add    $0x8,%esp
  8015e6:	50                   	push   %eax
  8015e7:	6a 00                	push   $0x0
  8015e9:	e8 c9 f5 ff ff       	call   800bb7 <sys_page_unmap>
}
  8015ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <_pipeisclosed>:
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	57                   	push   %edi
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 1c             	sub    $0x1c,%esp
  8015fc:	89 c7                	mov    %eax,%edi
  8015fe:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801600:	a1 08 40 80 00       	mov    0x804008,%eax
  801605:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	57                   	push   %edi
  80160c:	e8 f2 09 00 00       	call   802003 <pageref>
  801611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801614:	89 34 24             	mov    %esi,(%esp)
  801617:	e8 e7 09 00 00       	call   802003 <pageref>
		nn = thisenv->env_runs;
  80161c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801622:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	39 cb                	cmp    %ecx,%ebx
  80162a:	74 1b                	je     801647 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80162c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80162f:	75 cf                	jne    801600 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801631:	8b 42 58             	mov    0x58(%edx),%eax
  801634:	6a 01                	push   $0x1
  801636:	50                   	push   %eax
  801637:	53                   	push   %ebx
  801638:	68 e2 26 80 00       	push   $0x8026e2
  80163d:	e8 22 eb ff ff       	call   800164 <cprintf>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	eb b9                	jmp    801600 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801647:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80164a:	0f 94 c0             	sete   %al
  80164d:	0f b6 c0             	movzbl %al,%eax
}
  801650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <devpipe_write>:
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	57                   	push   %edi
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
  80165e:	83 ec 28             	sub    $0x28,%esp
  801661:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801664:	56                   	push   %esi
  801665:	e8 e8 f6 ff ff       	call   800d52 <fd2data>
  80166a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	bf 00 00 00 00       	mov    $0x0,%edi
  801674:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801677:	74 4f                	je     8016c8 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801679:	8b 43 04             	mov    0x4(%ebx),%eax
  80167c:	8b 0b                	mov    (%ebx),%ecx
  80167e:	8d 51 20             	lea    0x20(%ecx),%edx
  801681:	39 d0                	cmp    %edx,%eax
  801683:	72 14                	jb     801699 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801685:	89 da                	mov    %ebx,%edx
  801687:	89 f0                	mov    %esi,%eax
  801689:	e8 65 ff ff ff       	call   8015f3 <_pipeisclosed>
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 3b                	jne    8016cd <devpipe_write+0x75>
			sys_yield();
  801692:	e8 7c f4 ff ff       	call   800b13 <sys_yield>
  801697:	eb e0                	jmp    801679 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016a0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016a3:	89 c2                	mov    %eax,%edx
  8016a5:	c1 fa 1f             	sar    $0x1f,%edx
  8016a8:	89 d1                	mov    %edx,%ecx
  8016aa:	c1 e9 1b             	shr    $0x1b,%ecx
  8016ad:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016b0:	83 e2 1f             	and    $0x1f,%edx
  8016b3:	29 ca                	sub    %ecx,%edx
  8016b5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016b9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016bd:	83 c0 01             	add    $0x1,%eax
  8016c0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016c3:	83 c7 01             	add    $0x1,%edi
  8016c6:	eb ac                	jmp    801674 <devpipe_write+0x1c>
	return i;
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	eb 05                	jmp    8016d2 <devpipe_write+0x7a>
				return 0;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <devpipe_read>:
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	57                   	push   %edi
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 18             	sub    $0x18,%esp
  8016e3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016e6:	57                   	push   %edi
  8016e7:	e8 66 f6 ff ff       	call   800d52 <fd2data>
  8016ec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	be 00 00 00 00       	mov    $0x0,%esi
  8016f6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016f9:	75 14                	jne    80170f <devpipe_read+0x35>
	return i;
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	eb 02                	jmp    801702 <devpipe_read+0x28>
				return i;
  801700:	89 f0                	mov    %esi,%eax
}
  801702:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5f                   	pop    %edi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    
			sys_yield();
  80170a:	e8 04 f4 ff ff       	call   800b13 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80170f:	8b 03                	mov    (%ebx),%eax
  801711:	3b 43 04             	cmp    0x4(%ebx),%eax
  801714:	75 18                	jne    80172e <devpipe_read+0x54>
			if (i > 0)
  801716:	85 f6                	test   %esi,%esi
  801718:	75 e6                	jne    801700 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80171a:	89 da                	mov    %ebx,%edx
  80171c:	89 f8                	mov    %edi,%eax
  80171e:	e8 d0 fe ff ff       	call   8015f3 <_pipeisclosed>
  801723:	85 c0                	test   %eax,%eax
  801725:	74 e3                	je     80170a <devpipe_read+0x30>
				return 0;
  801727:	b8 00 00 00 00       	mov    $0x0,%eax
  80172c:	eb d4                	jmp    801702 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80172e:	99                   	cltd   
  80172f:	c1 ea 1b             	shr    $0x1b,%edx
  801732:	01 d0                	add    %edx,%eax
  801734:	83 e0 1f             	and    $0x1f,%eax
  801737:	29 d0                	sub    %edx,%eax
  801739:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80173e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801741:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801744:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801747:	83 c6 01             	add    $0x1,%esi
  80174a:	eb aa                	jmp    8016f6 <devpipe_read+0x1c>

0080174c <pipe>:
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	e8 0c f6 ff ff       	call   800d69 <fd_alloc>
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	0f 88 23 01 00 00    	js     80188d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	68 07 04 00 00       	push   $0x407
  801772:	ff 75 f4             	pushl  -0xc(%ebp)
  801775:	6a 00                	push   $0x0
  801777:	e8 b6 f3 ff ff       	call   800b32 <sys_page_alloc>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	0f 88 04 01 00 00    	js     80188d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801789:	83 ec 0c             	sub    $0xc,%esp
  80178c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	e8 d4 f5 ff ff       	call   800d69 <fd_alloc>
  801795:	89 c3                	mov    %eax,%ebx
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	85 c0                	test   %eax,%eax
  80179c:	0f 88 db 00 00 00    	js     80187d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 07 04 00 00       	push   $0x407
  8017aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ad:	6a 00                	push   $0x0
  8017af:	e8 7e f3 ff ff       	call   800b32 <sys_page_alloc>
  8017b4:	89 c3                	mov    %eax,%ebx
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	0f 88 bc 00 00 00    	js     80187d <pipe+0x131>
	va = fd2data(fd0);
  8017c1:	83 ec 0c             	sub    $0xc,%esp
  8017c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c7:	e8 86 f5 ff ff       	call   800d52 <fd2data>
  8017cc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ce:	83 c4 0c             	add    $0xc,%esp
  8017d1:	68 07 04 00 00       	push   $0x407
  8017d6:	50                   	push   %eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	e8 54 f3 ff ff       	call   800b32 <sys_page_alloc>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	0f 88 82 00 00 00    	js     80186d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f1:	e8 5c f5 ff ff       	call   800d52 <fd2data>
  8017f6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017fd:	50                   	push   %eax
  8017fe:	6a 00                	push   $0x0
  801800:	56                   	push   %esi
  801801:	6a 00                	push   $0x0
  801803:	e8 6d f3 ff ff       	call   800b75 <sys_page_map>
  801808:	89 c3                	mov    %eax,%ebx
  80180a:	83 c4 20             	add    $0x20,%esp
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 4e                	js     80185f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801811:	a1 20 30 80 00       	mov    0x803020,%eax
  801816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801819:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80181b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801825:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801828:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80182a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801834:	83 ec 0c             	sub    $0xc,%esp
  801837:	ff 75 f4             	pushl  -0xc(%ebp)
  80183a:	e8 03 f5 ff ff       	call   800d42 <fd2num>
  80183f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801842:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801844:	83 c4 04             	add    $0x4,%esp
  801847:	ff 75 f0             	pushl  -0x10(%ebp)
  80184a:	e8 f3 f4 ff ff       	call   800d42 <fd2num>
  80184f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801852:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80185d:	eb 2e                	jmp    80188d <pipe+0x141>
	sys_page_unmap(0, va);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	56                   	push   %esi
  801863:	6a 00                	push   $0x0
  801865:	e8 4d f3 ff ff       	call   800bb7 <sys_page_unmap>
  80186a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	ff 75 f0             	pushl  -0x10(%ebp)
  801873:	6a 00                	push   $0x0
  801875:	e8 3d f3 ff ff       	call   800bb7 <sys_page_unmap>
  80187a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	ff 75 f4             	pushl  -0xc(%ebp)
  801883:	6a 00                	push   $0x0
  801885:	e8 2d f3 ff ff       	call   800bb7 <sys_page_unmap>
  80188a:	83 c4 10             	add    $0x10,%esp
}
  80188d:	89 d8                	mov    %ebx,%eax
  80188f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801892:	5b                   	pop    %ebx
  801893:	5e                   	pop    %esi
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    

00801896 <pipeisclosed>:
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	e8 13 f5 ff ff       	call   800dbb <fd_lookup>
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 18                	js     8018c7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8018af:	83 ec 0c             	sub    $0xc,%esp
  8018b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b5:	e8 98 f4 ff ff       	call   800d52 <fd2data>
	return _pipeisclosed(fd, p);
  8018ba:	89 c2                	mov    %eax,%edx
  8018bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bf:	e8 2f fd ff ff       	call   8015f3 <_pipeisclosed>
  8018c4:	83 c4 10             	add    $0x10,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018cf:	68 fa 26 80 00       	push   $0x8026fa
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	e8 64 ee ff ff       	call   800740 <strcpy>
	return 0;
}
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <devsock_close>:
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	53                   	push   %ebx
  8018e7:	83 ec 10             	sub    $0x10,%esp
  8018ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018ed:	53                   	push   %ebx
  8018ee:	e8 10 07 00 00       	call   802003 <pageref>
  8018f3:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018f6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018fb:	83 f8 01             	cmp    $0x1,%eax
  8018fe:	74 07                	je     801907 <devsock_close+0x24>
}
  801900:	89 d0                	mov    %edx,%eax
  801902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801905:	c9                   	leave  
  801906:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801907:	83 ec 0c             	sub    $0xc,%esp
  80190a:	ff 73 0c             	pushl  0xc(%ebx)
  80190d:	e8 b9 02 00 00       	call   801bcb <nsipc_close>
  801912:	89 c2                	mov    %eax,%edx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	eb e7                	jmp    801900 <devsock_close+0x1d>

00801919 <devsock_write>:
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 10             	pushl  0x10(%ebp)
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	ff 70 0c             	pushl  0xc(%eax)
  80192d:	e8 76 03 00 00       	call   801ca8 <nsipc_send>
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <devsock_read>:
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	ff 75 10             	pushl  0x10(%ebp)
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	ff 70 0c             	pushl  0xc(%eax)
  801948:	e8 ef 02 00 00       	call   801c3c <nsipc_recv>
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <fd2sockid>:
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801955:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	e8 5c f4 ff ff       	call   800dbb <fd_lookup>
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	78 10                	js     801976 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  80196f:	39 08                	cmp    %ecx,(%eax)
  801971:	75 05                	jne    801978 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801973:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    
		return -E_NOT_SUPP;
  801978:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80197d:	eb f7                	jmp    801976 <fd2sockid+0x27>

0080197f <alloc_sockfd>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801989:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198c:	50                   	push   %eax
  80198d:	e8 d7 f3 ff ff       	call   800d69 <fd_alloc>
  801992:	89 c3                	mov    %eax,%ebx
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 43                	js     8019de <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	68 07 04 00 00       	push   $0x407
  8019a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a6:	6a 00                	push   $0x0
  8019a8:	e8 85 f1 ff ff       	call   800b32 <sys_page_alloc>
  8019ad:	89 c3                	mov    %eax,%ebx
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 28                	js     8019de <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019bf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019cb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019ce:	83 ec 0c             	sub    $0xc,%esp
  8019d1:	50                   	push   %eax
  8019d2:	e8 6b f3 ff ff       	call   800d42 <fd2num>
  8019d7:	89 c3                	mov    %eax,%ebx
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	eb 0c                	jmp    8019ea <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	56                   	push   %esi
  8019e2:	e8 e4 01 00 00       	call   801bcb <nsipc_close>
		return r;
  8019e7:	83 c4 10             	add    $0x10,%esp
}
  8019ea:	89 d8                	mov    %ebx,%eax
  8019ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <accept>:
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	e8 4e ff ff ff       	call   80194f <fd2sockid>
  801a01:	85 c0                	test   %eax,%eax
  801a03:	78 1b                	js     801a20 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	ff 75 10             	pushl  0x10(%ebp)
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	50                   	push   %eax
  801a0f:	e8 0e 01 00 00       	call   801b22 <nsipc_accept>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 05                	js     801a20 <accept+0x2d>
	return alloc_sockfd(r);
  801a1b:	e8 5f ff ff ff       	call   80197f <alloc_sockfd>
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <bind>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	e8 1f ff ff ff       	call   80194f <fd2sockid>
  801a30:	85 c0                	test   %eax,%eax
  801a32:	78 12                	js     801a46 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	e8 31 01 00 00       	call   801b74 <nsipc_bind>
  801a43:	83 c4 10             	add    $0x10,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <shutdown>:
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	e8 f9 fe ff ff       	call   80194f <fd2sockid>
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 0f                	js     801a69 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a5a:	83 ec 08             	sub    $0x8,%esp
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	50                   	push   %eax
  801a61:	e8 43 01 00 00       	call   801ba9 <nsipc_shutdown>
  801a66:	83 c4 10             	add    $0x10,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <connect>:
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	e8 d6 fe ff ff       	call   80194f <fd2sockid>
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 12                	js     801a8f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	e8 59 01 00 00       	call   801be5 <nsipc_connect>
  801a8c:	83 c4 10             	add    $0x10,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <listen>:
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	e8 b0 fe ff ff       	call   80194f <fd2sockid>
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 0f                	js     801ab2 <listen+0x21>
	return nsipc_listen(r, backlog);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	e8 6b 01 00 00       	call   801c1a <nsipc_listen>
  801aaf:	83 c4 10             	add    $0x10,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aba:	ff 75 10             	pushl  0x10(%ebp)
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	ff 75 08             	pushl  0x8(%ebp)
  801ac3:	e8 3e 02 00 00       	call   801d06 <nsipc_socket>
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 05                	js     801ad4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801acf:	e8 ab fe ff ff       	call   80197f <alloc_sockfd>
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801adf:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ae6:	74 26                	je     801b0e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ae8:	6a 07                	push   $0x7
  801aea:	68 00 60 80 00       	push   $0x806000
  801aef:	53                   	push   %ebx
  801af0:	ff 35 04 40 80 00    	pushl  0x804004
  801af6:	e8 63 04 00 00       	call   801f5e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801afb:	83 c4 0c             	add    $0xc,%esp
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	e8 e2 03 00 00       	call   801eeb <ipc_recv>
}
  801b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	6a 02                	push   $0x2
  801b13:	e8 b2 04 00 00       	call   801fca <ipc_find_env>
  801b18:	a3 04 40 80 00       	mov    %eax,0x804004
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	eb c6                	jmp    801ae8 <nsipc+0x12>

00801b22 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	56                   	push   %esi
  801b26:	53                   	push   %ebx
  801b27:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b32:	8b 06                	mov    (%esi),%eax
  801b34:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b39:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3e:	e8 93 ff ff ff       	call   801ad6 <nsipc>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	85 c0                	test   %eax,%eax
  801b47:	79 09                	jns    801b52 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5d                   	pop    %ebp
  801b51:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	ff 35 10 60 80 00    	pushl  0x806010
  801b5b:	68 00 60 80 00       	push   $0x806000
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	e8 66 ed ff ff       	call   8008ce <memmove>
		*addrlen = ret->ret_addrlen;
  801b68:	a1 10 60 80 00       	mov    0x806010,%eax
  801b6d:	89 06                	mov    %eax,(%esi)
  801b6f:	83 c4 10             	add    $0x10,%esp
	return r;
  801b72:	eb d5                	jmp    801b49 <nsipc_accept+0x27>

00801b74 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	53                   	push   %ebx
  801b78:	83 ec 08             	sub    $0x8,%esp
  801b7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b86:	53                   	push   %ebx
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	68 04 60 80 00       	push   $0x806004
  801b8f:	e8 3a ed ff ff       	call   8008ce <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b94:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b9a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b9f:	e8 32 ff ff ff       	call   801ad6 <nsipc>
}
  801ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bbf:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc4:	e8 0d ff ff ff       	call   801ad6 <nsipc>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <nsipc_close>:

int
nsipc_close(int s)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bd9:	b8 04 00 00 00       	mov    $0x4,%eax
  801bde:	e8 f3 fe ff ff       	call   801ad6 <nsipc>
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 08             	sub    $0x8,%esp
  801bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bf7:	53                   	push   %ebx
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	68 04 60 80 00       	push   $0x806004
  801c00:	e8 c9 ec ff ff       	call   8008ce <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c05:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c0b:	b8 05 00 00 00       	mov    $0x5,%eax
  801c10:	e8 c1 fe ff ff       	call   801ad6 <nsipc>
}
  801c15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c30:	b8 06 00 00 00       	mov    $0x6,%eax
  801c35:	e8 9c fe ff ff       	call   801ad6 <nsipc>
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	56                   	push   %esi
  801c40:	53                   	push   %ebx
  801c41:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c4c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c52:	8b 45 14             	mov    0x14(%ebp),%eax
  801c55:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c5a:	b8 07 00 00 00       	mov    $0x7,%eax
  801c5f:	e8 72 fe ff ff       	call   801ad6 <nsipc>
  801c64:	89 c3                	mov    %eax,%ebx
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 1f                	js     801c89 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c6a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c6f:	7f 21                	jg     801c92 <nsipc_recv+0x56>
  801c71:	39 c6                	cmp    %eax,%esi
  801c73:	7c 1d                	jl     801c92 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	50                   	push   %eax
  801c79:	68 00 60 80 00       	push   $0x806000
  801c7e:	ff 75 0c             	pushl  0xc(%ebp)
  801c81:	e8 48 ec ff ff       	call   8008ce <memmove>
  801c86:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c89:	89 d8                	mov    %ebx,%eax
  801c8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c92:	68 06 27 80 00       	push   $0x802706
  801c97:	68 a8 26 80 00       	push   $0x8026a8
  801c9c:	6a 62                	push   $0x62
  801c9e:	68 1b 27 80 00       	push   $0x80271b
  801ca3:	e8 fd 01 00 00       	call   801ea5 <_panic>

00801ca8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	53                   	push   %ebx
  801cac:	83 ec 04             	sub    $0x4,%esp
  801caf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cba:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cc0:	7f 2e                	jg     801cf0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	53                   	push   %ebx
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	68 0c 60 80 00       	push   $0x80600c
  801cce:	e8 fb eb ff ff       	call   8008ce <memmove>
	nsipcbuf.send.req_size = size;
  801cd3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cdc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ce1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce6:	e8 eb fd ff ff       	call   801ad6 <nsipc>
}
  801ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    
	assert(size < 1600);
  801cf0:	68 27 27 80 00       	push   $0x802727
  801cf5:	68 a8 26 80 00       	push   $0x8026a8
  801cfa:	6a 6d                	push   $0x6d
  801cfc:	68 1b 27 80 00       	push   $0x80271b
  801d01:	e8 9f 01 00 00       	call   801ea5 <_panic>

00801d06 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d17:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d24:	b8 09 00 00 00       	mov    $0x9,%eax
  801d29:	e8 a8 fd ff ff       	call   801ad6 <nsipc>
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
  801d35:	c3                   	ret    

00801d36 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d3c:	68 33 27 80 00       	push   $0x802733
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	e8 f7 e9 ff ff       	call   800740 <strcpy>
	return 0;
}
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <devcons_write>:
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	57                   	push   %edi
  801d54:	56                   	push   %esi
  801d55:	53                   	push   %ebx
  801d56:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d5c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d61:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d67:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d6a:	73 31                	jae    801d9d <devcons_write+0x4d>
		m = n - tot;
  801d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d6f:	29 f3                	sub    %esi,%ebx
  801d71:	83 fb 7f             	cmp    $0x7f,%ebx
  801d74:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d79:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	53                   	push   %ebx
  801d80:	89 f0                	mov    %esi,%eax
  801d82:	03 45 0c             	add    0xc(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	57                   	push   %edi
  801d87:	e8 42 eb ff ff       	call   8008ce <memmove>
		sys_cputs(buf, m);
  801d8c:	83 c4 08             	add    $0x8,%esp
  801d8f:	53                   	push   %ebx
  801d90:	57                   	push   %edi
  801d91:	e8 e0 ec ff ff       	call   800a76 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d96:	01 de                	add    %ebx,%esi
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	eb ca                	jmp    801d67 <devcons_write+0x17>
}
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da2:	5b                   	pop    %ebx
  801da3:	5e                   	pop    %esi
  801da4:	5f                   	pop    %edi
  801da5:	5d                   	pop    %ebp
  801da6:	c3                   	ret    

00801da7 <devcons_read>:
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 08             	sub    $0x8,%esp
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db6:	74 21                	je     801dd9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801db8:	e8 d7 ec ff ff       	call   800a94 <sys_cgetc>
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	75 07                	jne    801dc8 <devcons_read+0x21>
		sys_yield();
  801dc1:	e8 4d ed ff ff       	call   800b13 <sys_yield>
  801dc6:	eb f0                	jmp    801db8 <devcons_read+0x11>
	if (c < 0)
  801dc8:	78 0f                	js     801dd9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801dca:	83 f8 04             	cmp    $0x4,%eax
  801dcd:	74 0c                	je     801ddb <devcons_read+0x34>
	*(char*)vbuf = c;
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	88 02                	mov    %al,(%edx)
	return 1;
  801dd4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    
		return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  801de0:	eb f7                	jmp    801dd9 <devcons_read+0x32>

00801de2 <cputchar>:
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dee:	6a 01                	push   $0x1
  801df0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801df3:	50                   	push   %eax
  801df4:	e8 7d ec ff ff       	call   800a76 <sys_cputs>
}
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <getchar>:
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e04:	6a 01                	push   $0x1
  801e06:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e09:	50                   	push   %eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	e8 1a f2 ff ff       	call   80102b <read>
	if (r < 0)
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	85 c0                	test   %eax,%eax
  801e16:	78 06                	js     801e1e <getchar+0x20>
	if (r < 1)
  801e18:	74 06                	je     801e20 <getchar+0x22>
	return c;
  801e1a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    
		return -E_EOF;
  801e20:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e25:	eb f7                	jmp    801e1e <getchar+0x20>

00801e27 <iscons>:
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e30:	50                   	push   %eax
  801e31:	ff 75 08             	pushl  0x8(%ebp)
  801e34:	e8 82 ef ff ff       	call   800dbb <fd_lookup>
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 11                	js     801e51 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e49:	39 10                	cmp    %edx,(%eax)
  801e4b:	0f 94 c0             	sete   %al
  801e4e:	0f b6 c0             	movzbl %al,%eax
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <opencons>:
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5c:	50                   	push   %eax
  801e5d:	e8 07 ef ff ff       	call   800d69 <fd_alloc>
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 3a                	js     801ea3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	68 07 04 00 00       	push   $0x407
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	6a 00                	push   $0x0
  801e76:	e8 b7 ec ff ff       	call   800b32 <sys_page_alloc>
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 21                	js     801ea3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e8b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e90:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	50                   	push   %eax
  801e9b:	e8 a2 ee ff ff       	call   800d42 <fd2num>
  801ea0:	83 c4 10             	add    $0x10,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801eaa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ead:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801eb3:	e8 3c ec ff ff       	call   800af4 <sys_getenvid>
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	ff 75 0c             	pushl  0xc(%ebp)
  801ebe:	ff 75 08             	pushl  0x8(%ebp)
  801ec1:	56                   	push   %esi
  801ec2:	50                   	push   %eax
  801ec3:	68 40 27 80 00       	push   $0x802740
  801ec8:	e8 97 e2 ff ff       	call   800164 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ecd:	83 c4 18             	add    $0x18,%esp
  801ed0:	53                   	push   %ebx
  801ed1:	ff 75 10             	pushl  0x10(%ebp)
  801ed4:	e8 3a e2 ff ff       	call   800113 <vcprintf>
	cprintf("\n");
  801ed9:	c7 04 24 f3 26 80 00 	movl   $0x8026f3,(%esp)
  801ee0:	e8 7f e2 ff ff       	call   800164 <cprintf>
  801ee5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ee8:	cc                   	int3   
  801ee9:	eb fd                	jmp    801ee8 <_panic+0x43>

00801eeb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	8b 75 08             	mov    0x8(%ebp),%esi
  801ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	74 4f                	je     801f4c <ipc_recv+0x61>
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	50                   	push   %eax
  801f01:	e8 dc ed ff ff       	call   800ce2 <sys_ipc_recv>
  801f06:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801f09:	85 f6                	test   %esi,%esi
  801f0b:	74 14                	je     801f21 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f12:	85 c0                	test   %eax,%eax
  801f14:	75 09                	jne    801f1f <ipc_recv+0x34>
  801f16:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f1c:	8b 52 74             	mov    0x74(%edx),%edx
  801f1f:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f21:	85 db                	test   %ebx,%ebx
  801f23:	74 14                	je     801f39 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f25:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 09                	jne    801f37 <ipc_recv+0x4c>
  801f2e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f34:	8b 52 78             	mov    0x78(%edx),%edx
  801f37:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	75 08                	jne    801f45 <ipc_recv+0x5a>
  801f3d:	a1 08 40 80 00       	mov    0x804008,%eax
  801f42:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f48:	5b                   	pop    %ebx
  801f49:	5e                   	pop    %esi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	68 00 00 c0 ee       	push   $0xeec00000
  801f54:	e8 89 ed ff ff       	call   800ce2 <sys_ipc_recv>
  801f59:	83 c4 10             	add    $0x10,%esp
  801f5c:	eb ab                	jmp    801f09 <ipc_recv+0x1e>

00801f5e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f6a:	8b 75 10             	mov    0x10(%ebp),%esi
  801f6d:	eb 20                	jmp    801f8f <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f6f:	6a 00                	push   $0x0
  801f71:	68 00 00 c0 ee       	push   $0xeec00000
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	57                   	push   %edi
  801f7a:	e8 40 ed ff ff       	call   800cbf <sys_ipc_try_send>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	eb 1f                	jmp    801fa5 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f86:	e8 88 eb ff ff       	call   800b13 <sys_yield>
	while(retval != 0) {
  801f8b:	85 db                	test   %ebx,%ebx
  801f8d:	74 33                	je     801fc2 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f8f:	85 f6                	test   %esi,%esi
  801f91:	74 dc                	je     801f6f <ipc_send+0x11>
  801f93:	ff 75 14             	pushl  0x14(%ebp)
  801f96:	56                   	push   %esi
  801f97:	ff 75 0c             	pushl  0xc(%ebp)
  801f9a:	57                   	push   %edi
  801f9b:	e8 1f ed ff ff       	call   800cbf <sys_ipc_try_send>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801fa5:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801fa8:	74 dc                	je     801f86 <ipc_send+0x28>
  801faa:	85 db                	test   %ebx,%ebx
  801fac:	74 d8                	je     801f86 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	68 64 27 80 00       	push   $0x802764
  801fb6:	6a 35                	push   $0x35
  801fb8:	68 94 27 80 00       	push   $0x802794
  801fbd:	e8 e3 fe ff ff       	call   801ea5 <_panic>
	}
}
  801fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc5:	5b                   	pop    %ebx
  801fc6:	5e                   	pop    %esi
  801fc7:	5f                   	pop    %edi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fd5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fd8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fde:	8b 52 50             	mov    0x50(%edx),%edx
  801fe1:	39 ca                	cmp    %ecx,%edx
  801fe3:	74 11                	je     801ff6 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fe5:	83 c0 01             	add    $0x1,%eax
  801fe8:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fed:	75 e6                	jne    801fd5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	eb 0b                	jmp    802001 <ipc_find_env+0x37>
			return envs[i].env_id;
  801ff6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ff9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ffe:	8b 40 48             	mov    0x48(%eax),%eax
}
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    

00802003 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802009:	89 d0                	mov    %edx,%eax
  80200b:	c1 e8 16             	shr    $0x16,%eax
  80200e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80201a:	f6 c1 01             	test   $0x1,%cl
  80201d:	74 1d                	je     80203c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80201f:	c1 ea 0c             	shr    $0xc,%edx
  802022:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802029:	f6 c2 01             	test   $0x1,%dl
  80202c:	74 0e                	je     80203c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80202e:	c1 ea 0c             	shr    $0xc,%edx
  802031:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802038:	ef 
  802039:	0f b7 c0             	movzwl %ax,%eax
}
  80203c:	5d                   	pop    %ebp
  80203d:	c3                   	ret    
  80203e:	66 90                	xchg   %ax,%ax

00802040 <__udivdi3>:
  802040:	f3 0f 1e fb          	endbr32 
  802044:	55                   	push   %ebp
  802045:	57                   	push   %edi
  802046:	56                   	push   %esi
  802047:	53                   	push   %ebx
  802048:	83 ec 1c             	sub    $0x1c,%esp
  80204b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80204f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802053:	8b 74 24 34          	mov    0x34(%esp),%esi
  802057:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80205b:	85 d2                	test   %edx,%edx
  80205d:	75 49                	jne    8020a8 <__udivdi3+0x68>
  80205f:	39 f3                	cmp    %esi,%ebx
  802061:	76 15                	jbe    802078 <__udivdi3+0x38>
  802063:	31 ff                	xor    %edi,%edi
  802065:	89 e8                	mov    %ebp,%eax
  802067:	89 f2                	mov    %esi,%edx
  802069:	f7 f3                	div    %ebx
  80206b:	89 fa                	mov    %edi,%edx
  80206d:	83 c4 1c             	add    $0x1c,%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5f                   	pop    %edi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    
  802075:	8d 76 00             	lea    0x0(%esi),%esi
  802078:	89 d9                	mov    %ebx,%ecx
  80207a:	85 db                	test   %ebx,%ebx
  80207c:	75 0b                	jne    802089 <__udivdi3+0x49>
  80207e:	b8 01 00 00 00       	mov    $0x1,%eax
  802083:	31 d2                	xor    %edx,%edx
  802085:	f7 f3                	div    %ebx
  802087:	89 c1                	mov    %eax,%ecx
  802089:	31 d2                	xor    %edx,%edx
  80208b:	89 f0                	mov    %esi,%eax
  80208d:	f7 f1                	div    %ecx
  80208f:	89 c6                	mov    %eax,%esi
  802091:	89 e8                	mov    %ebp,%eax
  802093:	89 f7                	mov    %esi,%edi
  802095:	f7 f1                	div    %ecx
  802097:	89 fa                	mov    %edi,%edx
  802099:	83 c4 1c             	add    $0x1c,%esp
  80209c:	5b                   	pop    %ebx
  80209d:	5e                   	pop    %esi
  80209e:	5f                   	pop    %edi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    
  8020a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020a8:	39 f2                	cmp    %esi,%edx
  8020aa:	77 1c                	ja     8020c8 <__udivdi3+0x88>
  8020ac:	0f bd fa             	bsr    %edx,%edi
  8020af:	83 f7 1f             	xor    $0x1f,%edi
  8020b2:	75 2c                	jne    8020e0 <__udivdi3+0xa0>
  8020b4:	39 f2                	cmp    %esi,%edx
  8020b6:	72 06                	jb     8020be <__udivdi3+0x7e>
  8020b8:	31 c0                	xor    %eax,%eax
  8020ba:	39 eb                	cmp    %ebp,%ebx
  8020bc:	77 ad                	ja     80206b <__udivdi3+0x2b>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	eb a6                	jmp    80206b <__udivdi3+0x2b>
  8020c5:	8d 76 00             	lea    0x0(%esi),%esi
  8020c8:	31 ff                	xor    %edi,%edi
  8020ca:	31 c0                	xor    %eax,%eax
  8020cc:	89 fa                	mov    %edi,%edx
  8020ce:	83 c4 1c             	add    $0x1c,%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    
  8020d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020dd:	8d 76 00             	lea    0x0(%esi),%esi
  8020e0:	89 f9                	mov    %edi,%ecx
  8020e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020e7:	29 f8                	sub    %edi,%eax
  8020e9:	d3 e2                	shl    %cl,%edx
  8020eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ef:	89 c1                	mov    %eax,%ecx
  8020f1:	89 da                	mov    %ebx,%edx
  8020f3:	d3 ea                	shr    %cl,%edx
  8020f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020f9:	09 d1                	or     %edx,%ecx
  8020fb:	89 f2                	mov    %esi,%edx
  8020fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e3                	shl    %cl,%ebx
  802105:	89 c1                	mov    %eax,%ecx
  802107:	d3 ea                	shr    %cl,%edx
  802109:	89 f9                	mov    %edi,%ecx
  80210b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80210f:	89 eb                	mov    %ebp,%ebx
  802111:	d3 e6                	shl    %cl,%esi
  802113:	89 c1                	mov    %eax,%ecx
  802115:	d3 eb                	shr    %cl,%ebx
  802117:	09 de                	or     %ebx,%esi
  802119:	89 f0                	mov    %esi,%eax
  80211b:	f7 74 24 08          	divl   0x8(%esp)
  80211f:	89 d6                	mov    %edx,%esi
  802121:	89 c3                	mov    %eax,%ebx
  802123:	f7 64 24 0c          	mull   0xc(%esp)
  802127:	39 d6                	cmp    %edx,%esi
  802129:	72 15                	jb     802140 <__udivdi3+0x100>
  80212b:	89 f9                	mov    %edi,%ecx
  80212d:	d3 e5                	shl    %cl,%ebp
  80212f:	39 c5                	cmp    %eax,%ebp
  802131:	73 04                	jae    802137 <__udivdi3+0xf7>
  802133:	39 d6                	cmp    %edx,%esi
  802135:	74 09                	je     802140 <__udivdi3+0x100>
  802137:	89 d8                	mov    %ebx,%eax
  802139:	31 ff                	xor    %edi,%edi
  80213b:	e9 2b ff ff ff       	jmp    80206b <__udivdi3+0x2b>
  802140:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802143:	31 ff                	xor    %edi,%edi
  802145:	e9 21 ff ff ff       	jmp    80206b <__udivdi3+0x2b>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	66 90                	xchg   %ax,%ax
  80214e:	66 90                	xchg   %ax,%ax

00802150 <__umoddi3>:
  802150:	f3 0f 1e fb          	endbr32 
  802154:	55                   	push   %ebp
  802155:	57                   	push   %edi
  802156:	56                   	push   %esi
  802157:	53                   	push   %ebx
  802158:	83 ec 1c             	sub    $0x1c,%esp
  80215b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80215f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802163:	8b 74 24 30          	mov    0x30(%esp),%esi
  802167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80216b:	89 da                	mov    %ebx,%edx
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 3f                	jne    8021b0 <__umoddi3+0x60>
  802171:	39 df                	cmp    %ebx,%edi
  802173:	76 13                	jbe    802188 <__umoddi3+0x38>
  802175:	89 f0                	mov    %esi,%eax
  802177:	f7 f7                	div    %edi
  802179:	89 d0                	mov    %edx,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	83 c4 1c             	add    $0x1c,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	8d 76 00             	lea    0x0(%esi),%esi
  802188:	89 fd                	mov    %edi,%ebp
  80218a:	85 ff                	test   %edi,%edi
  80218c:	75 0b                	jne    802199 <__umoddi3+0x49>
  80218e:	b8 01 00 00 00       	mov    $0x1,%eax
  802193:	31 d2                	xor    %edx,%edx
  802195:	f7 f7                	div    %edi
  802197:	89 c5                	mov    %eax,%ebp
  802199:	89 d8                	mov    %ebx,%eax
  80219b:	31 d2                	xor    %edx,%edx
  80219d:	f7 f5                	div    %ebp
  80219f:	89 f0                	mov    %esi,%eax
  8021a1:	f7 f5                	div    %ebp
  8021a3:	89 d0                	mov    %edx,%eax
  8021a5:	eb d4                	jmp    80217b <__umoddi3+0x2b>
  8021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	89 f1                	mov    %esi,%ecx
  8021b2:	39 d8                	cmp    %ebx,%eax
  8021b4:	76 0a                	jbe    8021c0 <__umoddi3+0x70>
  8021b6:	89 f0                	mov    %esi,%eax
  8021b8:	83 c4 1c             	add    $0x1c,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    
  8021c0:	0f bd e8             	bsr    %eax,%ebp
  8021c3:	83 f5 1f             	xor    $0x1f,%ebp
  8021c6:	75 20                	jne    8021e8 <__umoddi3+0x98>
  8021c8:	39 d8                	cmp    %ebx,%eax
  8021ca:	0f 82 b0 00 00 00    	jb     802280 <__umoddi3+0x130>
  8021d0:	39 f7                	cmp    %esi,%edi
  8021d2:	0f 86 a8 00 00 00    	jbe    802280 <__umoddi3+0x130>
  8021d8:	89 c8                	mov    %ecx,%eax
  8021da:	83 c4 1c             	add    $0x1c,%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5f                   	pop    %edi
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    
  8021e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e8:	89 e9                	mov    %ebp,%ecx
  8021ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8021ef:	29 ea                	sub    %ebp,%edx
  8021f1:	d3 e0                	shl    %cl,%eax
  8021f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f7:	89 d1                	mov    %edx,%ecx
  8021f9:	89 f8                	mov    %edi,%eax
  8021fb:	d3 e8                	shr    %cl,%eax
  8021fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802201:	89 54 24 04          	mov    %edx,0x4(%esp)
  802205:	8b 54 24 04          	mov    0x4(%esp),%edx
  802209:	09 c1                	or     %eax,%ecx
  80220b:	89 d8                	mov    %ebx,%eax
  80220d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802211:	89 e9                	mov    %ebp,%ecx
  802213:	d3 e7                	shl    %cl,%edi
  802215:	89 d1                	mov    %edx,%ecx
  802217:	d3 e8                	shr    %cl,%eax
  802219:	89 e9                	mov    %ebp,%ecx
  80221b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80221f:	d3 e3                	shl    %cl,%ebx
  802221:	89 c7                	mov    %eax,%edi
  802223:	89 d1                	mov    %edx,%ecx
  802225:	89 f0                	mov    %esi,%eax
  802227:	d3 e8                	shr    %cl,%eax
  802229:	89 e9                	mov    %ebp,%ecx
  80222b:	89 fa                	mov    %edi,%edx
  80222d:	d3 e6                	shl    %cl,%esi
  80222f:	09 d8                	or     %ebx,%eax
  802231:	f7 74 24 08          	divl   0x8(%esp)
  802235:	89 d1                	mov    %edx,%ecx
  802237:	89 f3                	mov    %esi,%ebx
  802239:	f7 64 24 0c          	mull   0xc(%esp)
  80223d:	89 c6                	mov    %eax,%esi
  80223f:	89 d7                	mov    %edx,%edi
  802241:	39 d1                	cmp    %edx,%ecx
  802243:	72 06                	jb     80224b <__umoddi3+0xfb>
  802245:	75 10                	jne    802257 <__umoddi3+0x107>
  802247:	39 c3                	cmp    %eax,%ebx
  802249:	73 0c                	jae    802257 <__umoddi3+0x107>
  80224b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80224f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802253:	89 d7                	mov    %edx,%edi
  802255:	89 c6                	mov    %eax,%esi
  802257:	89 ca                	mov    %ecx,%edx
  802259:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225e:	29 f3                	sub    %esi,%ebx
  802260:	19 fa                	sbb    %edi,%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	d3 e0                	shl    %cl,%eax
  802266:	89 e9                	mov    %ebp,%ecx
  802268:	d3 eb                	shr    %cl,%ebx
  80226a:	d3 ea                	shr    %cl,%edx
  80226c:	09 d8                	or     %ebx,%eax
  80226e:	83 c4 1c             	add    $0x1c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    
  802276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80227d:	8d 76 00             	lea    0x0(%esi),%esi
  802280:	89 da                	mov    %ebx,%edx
  802282:	29 fe                	sub    %edi,%esi
  802284:	19 c2                	sbb    %eax,%edx
  802286:	89 f1                	mov    %esi,%ecx
  802288:	89 c8                	mov    %ecx,%eax
  80228a:	e9 4b ff ff ff       	jmp    8021da <__umoddi3+0x8a>
