
obj/user/lsfd.debug：     文件格式 elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 a0 25 80 00       	push   $0x8025a0
  80003e:	e8 c3 01 00 00       	call   800206 <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 78 0d 00 00       	call   800de4 <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 8c 0d 00 00       	call   800e14 <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 b4 25 80 00       	push   $0x8025b4
  8000c2:	e8 3f 01 00 00       	call   800206 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 3b 13 00 00       	call   801417 <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 b4 25 80 00       	push   $0x8025b4
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 54 17 00 00       	call   801858 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	e8 75 0a 00 00       	call   800b96 <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x2d>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015d:	e8 ae 0f 00 00       	call   801110 <close_all>
	sys_env_destroy(0);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	6a 00                	push   $0x0
  800167:	e8 e9 09 00 00       	call   800b55 <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	53                   	push   %ebx
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017b:	8b 13                	mov    (%ebx),%edx
  80017d:	8d 42 01             	lea    0x1(%edx),%eax
  800180:	89 03                	mov    %eax,(%ebx)
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800189:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018e:	74 09                	je     800199 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800197:	c9                   	leave  
  800198:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	68 ff 00 00 00       	push   $0xff
  8001a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 6e 09 00 00       	call   800b18 <sys_cputs>
		b->idx = 0;
  8001aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb db                	jmp    800190 <putch+0x1f>

008001b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c5:	00 00 00 
	b.cnt = 0;
  8001c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	68 71 01 80 00       	push   $0x800171
  8001e4:	e8 19 01 00 00       	call   800302 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e9:	83 c4 08             	add    $0x8,%esp
  8001ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 1a 09 00 00       	call   800b18 <sys_cputs>

	return b.cnt;
}
  8001fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020f:	50                   	push   %eax
  800210:	ff 75 08             	pushl  0x8(%ebp)
  800213:	e8 9d ff ff ff       	call   8001b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	57                   	push   %edi
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	83 ec 1c             	sub    $0x1c,%esp
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 d6                	mov    %edx,%esi
  800227:	8b 45 08             	mov    0x8(%ebp),%eax
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800230:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800233:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800241:	3b 45 10             	cmp    0x10(%ebp),%eax
  800244:	89 d0                	mov    %edx,%eax
  800246:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800249:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80024c:	73 15                	jae    800263 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80024e:	83 eb 01             	sub    $0x1,%ebx
  800251:	85 db                	test   %ebx,%ebx
  800253:	7e 43                	jle    800298 <printnum+0x7e>
			putch(padc, putdat);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	56                   	push   %esi
  800259:	ff 75 18             	pushl  0x18(%ebp)
  80025c:	ff d7                	call   *%edi
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	eb eb                	jmp    80024e <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	ff 75 18             	pushl  0x18(%ebp)
  800269:	8b 45 14             	mov    0x14(%ebp),%eax
  80026c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80026f:	53                   	push   %ebx
  800270:	ff 75 10             	pushl  0x10(%ebp)
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	ff 75 e4             	pushl  -0x1c(%ebp)
  800279:	ff 75 e0             	pushl  -0x20(%ebp)
  80027c:	ff 75 dc             	pushl  -0x24(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 c9 20 00 00       	call   802350 <__udivdi3>
  800287:	83 c4 18             	add    $0x18,%esp
  80028a:	52                   	push   %edx
  80028b:	50                   	push   %eax
  80028c:	89 f2                	mov    %esi,%edx
  80028e:	89 f8                	mov    %edi,%eax
  800290:	e8 85 ff ff ff       	call   80021a <printnum>
  800295:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800298:	83 ec 08             	sub    $0x8,%esp
  80029b:	56                   	push   %esi
  80029c:	83 ec 04             	sub    $0x4,%esp
  80029f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ab:	e8 b0 21 00 00       	call   802460 <__umoddi3>
  8002b0:	83 c4 14             	add    $0x14,%esp
  8002b3:	0f be 80 e6 25 80 00 	movsbl 0x8025e6(%eax),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff d7                	call   *%edi
}
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c3:	5b                   	pop    %ebx
  8002c4:	5e                   	pop    %esi
  8002c5:	5f                   	pop    %edi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d7:	73 0a                	jae    8002e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dc:	89 08                	mov    %ecx,(%eax)
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	88 02                	mov    %al,(%edx)
}
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <printfmt>:
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ee:	50                   	push   %eax
  8002ef:	ff 75 10             	pushl  0x10(%ebp)
  8002f2:	ff 75 0c             	pushl  0xc(%ebp)
  8002f5:	ff 75 08             	pushl  0x8(%ebp)
  8002f8:	e8 05 00 00 00       	call   800302 <vprintfmt>
}
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <vprintfmt>:
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 3c             	sub    $0x3c,%esp
  80030b:	8b 75 08             	mov    0x8(%ebp),%esi
  80030e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800311:	8b 7d 10             	mov    0x10(%ebp),%edi
  800314:	eb 0a                	jmp    800320 <vprintfmt+0x1e>
			putch(ch, putdat);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	53                   	push   %ebx
  80031a:	50                   	push   %eax
  80031b:	ff d6                	call   *%esi
  80031d:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800320:	83 c7 01             	add    $0x1,%edi
  800323:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800327:	83 f8 25             	cmp    $0x25,%eax
  80032a:	74 0c                	je     800338 <vprintfmt+0x36>
			if (ch == '\0')
  80032c:	85 c0                	test   %eax,%eax
  80032e:	75 e6                	jne    800316 <vprintfmt+0x14>
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		padc = ' ';
  800338:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80033c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800343:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800351:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8d 47 01             	lea    0x1(%edi),%eax
  800359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035c:	0f b6 17             	movzbl (%edi),%edx
  80035f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800362:	3c 55                	cmp    $0x55,%al
  800364:	0f 87 ba 03 00 00    	ja     800724 <vprintfmt+0x422>
  80036a:	0f b6 c0             	movzbl %al,%eax
  80036d:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800377:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80037b:	eb d9                	jmp    800356 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800380:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800384:	eb d0                	jmp    800356 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800386:	0f b6 d2             	movzbl %dl,%edx
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800394:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800397:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a1:	83 f9 09             	cmp    $0x9,%ecx
  8003a4:	77 55                	ja     8003fb <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003a6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a9:	eb e9                	jmp    800394 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8d 40 04             	lea    0x4(%eax),%eax
  8003b9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c3:	79 91                	jns    800356 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d2:	eb 82                	jmp    800356 <vprintfmt+0x54>
  8003d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003de:	0f 49 d0             	cmovns %eax,%edx
  8003e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e7:	e9 6a ff ff ff       	jmp    800356 <vprintfmt+0x54>
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ef:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003f6:	e9 5b ff ff ff       	jmp    800356 <vprintfmt+0x54>
  8003fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800401:	eb bc                	jmp    8003bf <vprintfmt+0xbd>
			lflag++;
  800403:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800409:	e9 48 ff ff ff       	jmp    800356 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8d 78 04             	lea    0x4(%eax),%edi
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	53                   	push   %ebx
  800418:	ff 30                	pushl  (%eax)
  80041a:	ff d6                	call   *%esi
			break;
  80041c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800422:	e9 9c 02 00 00       	jmp    8006c3 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 78 04             	lea    0x4(%eax),%edi
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	99                   	cltd   
  800430:	31 d0                	xor    %edx,%eax
  800432:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800434:	83 f8 0f             	cmp    $0xf,%eax
  800437:	7f 23                	jg     80045c <vprintfmt+0x15a>
  800439:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  800440:	85 d2                	test   %edx,%edx
  800442:	74 18                	je     80045c <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800444:	52                   	push   %edx
  800445:	68 ba 29 80 00       	push   $0x8029ba
  80044a:	53                   	push   %ebx
  80044b:	56                   	push   %esi
  80044c:	e8 94 fe ff ff       	call   8002e5 <printfmt>
  800451:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800454:	89 7d 14             	mov    %edi,0x14(%ebp)
  800457:	e9 67 02 00 00       	jmp    8006c3 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80045c:	50                   	push   %eax
  80045d:	68 fe 25 80 00       	push   $0x8025fe
  800462:	53                   	push   %ebx
  800463:	56                   	push   %esi
  800464:	e8 7c fe ff ff       	call   8002e5 <printfmt>
  800469:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046f:	e9 4f 02 00 00       	jmp    8006c3 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	83 c0 04             	add    $0x4,%eax
  80047a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800482:	85 d2                	test   %edx,%edx
  800484:	b8 f7 25 80 00       	mov    $0x8025f7,%eax
  800489:	0f 45 c2             	cmovne %edx,%eax
  80048c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80048f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800493:	7e 06                	jle    80049b <vprintfmt+0x199>
  800495:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800499:	75 0d                	jne    8004a8 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049e:	89 c7                	mov    %eax,%edi
  8004a0:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a6:	eb 3f                	jmp    8004e7 <vprintfmt+0x1e5>
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ae:	50                   	push   %eax
  8004af:	e8 0d 03 00 00       	call   8007c1 <strnlen>
  8004b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b7:	29 c2                	sub    %eax,%edx
  8004b9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004c1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c8:	85 ff                	test   %edi,%edi
  8004ca:	7e 58                	jle    800524 <vprintfmt+0x222>
					putch(padc, putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	53                   	push   %ebx
  8004d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d5:	83 ef 01             	sub    $0x1,%edi
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	eb eb                	jmp    8004c8 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	53                   	push   %ebx
  8004e1:	52                   	push   %edx
  8004e2:	ff d6                	call   *%esi
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ea:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ec:	83 c7 01             	add    $0x1,%edi
  8004ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f3:	0f be d0             	movsbl %al,%edx
  8004f6:	85 d2                	test   %edx,%edx
  8004f8:	74 45                	je     80053f <vprintfmt+0x23d>
  8004fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fe:	78 06                	js     800506 <vprintfmt+0x204>
  800500:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800504:	78 35                	js     80053b <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800506:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80050a:	74 d1                	je     8004dd <vprintfmt+0x1db>
  80050c:	0f be c0             	movsbl %al,%eax
  80050f:	83 e8 20             	sub    $0x20,%eax
  800512:	83 f8 5e             	cmp    $0x5e,%eax
  800515:	76 c6                	jbe    8004dd <vprintfmt+0x1db>
					putch('?', putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	53                   	push   %ebx
  80051b:	6a 3f                	push   $0x3f
  80051d:	ff d6                	call   *%esi
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	eb c3                	jmp    8004e7 <vprintfmt+0x1e5>
  800524:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	b8 00 00 00 00       	mov    $0x0,%eax
  80052e:	0f 49 c2             	cmovns %edx,%eax
  800531:	29 c2                	sub    %eax,%edx
  800533:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800536:	e9 60 ff ff ff       	jmp    80049b <vprintfmt+0x199>
  80053b:	89 cf                	mov    %ecx,%edi
  80053d:	eb 02                	jmp    800541 <vprintfmt+0x23f>
  80053f:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800541:	85 ff                	test   %edi,%edi
  800543:	7e 10                	jle    800555 <vprintfmt+0x253>
				putch(' ', putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	53                   	push   %ebx
  800549:	6a 20                	push   $0x20
  80054b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054d:	83 ef 01             	sub    $0x1,%edi
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	eb ec                	jmp    800541 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 63 01 00 00       	jmp    8006c3 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800560:	83 f9 01             	cmp    $0x1,%ecx
  800563:	7f 1b                	jg     800580 <vprintfmt+0x27e>
	else if (lflag)
  800565:	85 c9                	test   %ecx,%ecx
  800567:	74 63                	je     8005cc <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	99                   	cltd   
  800572:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8d 40 04             	lea    0x4(%eax),%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	eb 17                	jmp    800597 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800597:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a2:	85 c9                	test   %ecx,%ecx
  8005a4:	0f 89 ff 00 00 00    	jns    8006a9 <vprintfmt+0x3a7>
				putch('-', putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	6a 2d                	push   $0x2d
  8005b0:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b8:	f7 da                	neg    %edx
  8005ba:	83 d1 00             	adc    $0x0,%ecx
  8005bd:	f7 d9                	neg    %ecx
  8005bf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c7:	e9 dd 00 00 00       	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	99                   	cltd   
  8005d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 40 04             	lea    0x4(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e1:	eb b4                	jmp    800597 <vprintfmt+0x295>
	if (lflag >= 2)
  8005e3:	83 f9 01             	cmp    $0x1,%ecx
  8005e6:	7f 1e                	jg     800606 <vprintfmt+0x304>
	else if (lflag)
  8005e8:	85 c9                	test   %ecx,%ecx
  8005ea:	74 32                	je     80061e <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 10                	mov    (%eax),%edx
  8005f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f6:	8d 40 04             	lea    0x4(%eax),%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800601:	e9 a3 00 00 00       	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 48 04             	mov    0x4(%eax),%ecx
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 8b 00 00 00       	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 10                	mov    (%eax),%edx
  800623:	b9 00 00 00 00       	mov    $0x0,%ecx
  800628:	8d 40 04             	lea    0x4(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800633:	eb 74                	jmp    8006a9 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800635:	83 f9 01             	cmp    $0x1,%ecx
  800638:	7f 1b                	jg     800655 <vprintfmt+0x353>
	else if (lflag)
  80063a:	85 c9                	test   %ecx,%ecx
  80063c:	74 2c                	je     80066a <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 10                	mov    (%eax),%edx
  800643:	b9 00 00 00 00       	mov    $0x0,%ecx
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064e:	b8 08 00 00 00       	mov    $0x8,%eax
  800653:	eb 54                	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 10                	mov    (%eax),%edx
  80065a:	8b 48 04             	mov    0x4(%eax),%ecx
  80065d:	8d 40 08             	lea    0x8(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800663:	b8 08 00 00 00       	mov    $0x8,%eax
  800668:	eb 3f                	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 10                	mov    (%eax),%edx
  80066f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067a:	b8 08 00 00 00       	mov    $0x8,%eax
  80067f:	eb 28                	jmp    8006a9 <vprintfmt+0x3a7>
			putch('0', putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	53                   	push   %ebx
  800685:	6a 30                	push   $0x30
  800687:	ff d6                	call   *%esi
			putch('x', putdat);
  800689:	83 c4 08             	add    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	6a 78                	push   $0x78
  80068f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006b0:	57                   	push   %edi
  8006b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b4:	50                   	push   %eax
  8006b5:	51                   	push   %ecx
  8006b6:	52                   	push   %edx
  8006b7:	89 da                	mov    %ebx,%edx
  8006b9:	89 f0                	mov    %esi,%eax
  8006bb:	e8 5a fb ff ff       	call   80021a <printnum>
			break;
  8006c0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c6:	e9 55 fc ff ff       	jmp    800320 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006cb:	83 f9 01             	cmp    $0x1,%ecx
  8006ce:	7f 1b                	jg     8006eb <vprintfmt+0x3e9>
	else if (lflag)
  8006d0:	85 c9                	test   %ecx,%ecx
  8006d2:	74 2c                	je     800700 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e9:	eb be                	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f3:	8d 40 08             	lea    0x8(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fe:	eb a9                	jmp    8006a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 10                	mov    (%eax),%edx
  800705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070a:	8d 40 04             	lea    0x4(%eax),%eax
  80070d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800710:	b8 10 00 00 00       	mov    $0x10,%eax
  800715:	eb 92                	jmp    8006a9 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	6a 25                	push   $0x25
  80071d:	ff d6                	call   *%esi
			break;
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	eb 9f                	jmp    8006c3 <vprintfmt+0x3c1>
			putch('%', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	6a 25                	push   $0x25
  80072a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	89 f8                	mov    %edi,%eax
  800731:	eb 03                	jmp    800736 <vprintfmt+0x434>
  800733:	83 e8 01             	sub    $0x1,%eax
  800736:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80073a:	75 f7                	jne    800733 <vprintfmt+0x431>
  80073c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073f:	eb 82                	jmp    8006c3 <vprintfmt+0x3c1>

00800741 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 18             	sub    $0x18,%esp
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800750:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800754:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 26                	je     800788 <vsnprintf+0x47>
  800762:	85 d2                	test   %edx,%edx
  800764:	7e 22                	jle    800788 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800766:	ff 75 14             	pushl  0x14(%ebp)
  800769:	ff 75 10             	pushl  0x10(%ebp)
  80076c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80076f:	50                   	push   %eax
  800770:	68 c8 02 80 00       	push   $0x8002c8
  800775:	e8 88 fb ff ff       	call   800302 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800783:	83 c4 10             	add    $0x10,%esp
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    
		return -E_INVAL;
  800788:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80078d:	eb f7                	jmp    800786 <vsnprintf+0x45>

0080078f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800795:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800798:	50                   	push   %eax
  800799:	ff 75 10             	pushl  0x10(%ebp)
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	ff 75 08             	pushl  0x8(%ebp)
  8007a2:	e8 9a ff ff ff       	call   800741 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007af:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b8:	74 05                	je     8007bf <strlen+0x16>
		n++;
  8007ba:	83 c0 01             	add    $0x1,%eax
  8007bd:	eb f5                	jmp    8007b4 <strlen+0xb>
	return n;
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	39 c2                	cmp    %eax,%edx
  8007d1:	74 0d                	je     8007e0 <strnlen+0x1f>
  8007d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007d7:	74 05                	je     8007de <strnlen+0x1d>
		n++;
  8007d9:	83 c2 01             	add    $0x1,%edx
  8007dc:	eb f1                	jmp    8007cf <strnlen+0xe>
  8007de:	89 d0                	mov    %edx,%eax
	return n;
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	53                   	push   %ebx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007f5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007f8:	83 c2 01             	add    $0x1,%edx
  8007fb:	84 c9                	test   %cl,%cl
  8007fd:	75 f2                	jne    8007f1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007ff:	5b                   	pop    %ebx
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	83 ec 10             	sub    $0x10,%esp
  800809:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80080c:	53                   	push   %ebx
  80080d:	e8 97 ff ff ff       	call   8007a9 <strlen>
  800812:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	01 d8                	add    %ebx,%eax
  80081a:	50                   	push   %eax
  80081b:	e8 c2 ff ff ff       	call   8007e2 <strcpy>
	return dst;
}
  800820:	89 d8                	mov    %ebx,%eax
  800822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	56                   	push   %esi
  80082b:	53                   	push   %ebx
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800832:	89 c6                	mov    %eax,%esi
  800834:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800837:	89 c2                	mov    %eax,%edx
  800839:	39 f2                	cmp    %esi,%edx
  80083b:	74 11                	je     80084e <strncpy+0x27>
		*dst++ = *src;
  80083d:	83 c2 01             	add    $0x1,%edx
  800840:	0f b6 19             	movzbl (%ecx),%ebx
  800843:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800846:	80 fb 01             	cmp    $0x1,%bl
  800849:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80084c:	eb eb                	jmp    800839 <strncpy+0x12>
	}
	return ret;
}
  80084e:	5b                   	pop    %ebx
  80084f:	5e                   	pop    %esi
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	56                   	push   %esi
  800856:	53                   	push   %ebx
  800857:	8b 75 08             	mov    0x8(%ebp),%esi
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	8b 55 10             	mov    0x10(%ebp),%edx
  800860:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800862:	85 d2                	test   %edx,%edx
  800864:	74 21                	je     800887 <strlcpy+0x35>
  800866:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80086a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80086c:	39 c2                	cmp    %eax,%edx
  80086e:	74 14                	je     800884 <strlcpy+0x32>
  800870:	0f b6 19             	movzbl (%ecx),%ebx
  800873:	84 db                	test   %bl,%bl
  800875:	74 0b                	je     800882 <strlcpy+0x30>
			*dst++ = *src++;
  800877:	83 c1 01             	add    $0x1,%ecx
  80087a:	83 c2 01             	add    $0x1,%edx
  80087d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800880:	eb ea                	jmp    80086c <strlcpy+0x1a>
  800882:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800884:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800887:	29 f0                	sub    %esi,%eax
}
  800889:	5b                   	pop    %ebx
  80088a:	5e                   	pop    %esi
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800893:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800896:	0f b6 01             	movzbl (%ecx),%eax
  800899:	84 c0                	test   %al,%al
  80089b:	74 0c                	je     8008a9 <strcmp+0x1c>
  80089d:	3a 02                	cmp    (%edx),%al
  80089f:	75 08                	jne    8008a9 <strcmp+0x1c>
		p++, q++;
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c2 01             	add    $0x1,%edx
  8008a7:	eb ed                	jmp    800896 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a9:	0f b6 c0             	movzbl %al,%eax
  8008ac:	0f b6 12             	movzbl (%edx),%edx
  8008af:	29 d0                	sub    %edx,%eax
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bd:	89 c3                	mov    %eax,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c2:	eb 06                	jmp    8008ca <strncmp+0x17>
		n--, p++, q++;
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008ca:	39 d8                	cmp    %ebx,%eax
  8008cc:	74 16                	je     8008e4 <strncmp+0x31>
  8008ce:	0f b6 08             	movzbl (%eax),%ecx
  8008d1:	84 c9                	test   %cl,%cl
  8008d3:	74 04                	je     8008d9 <strncmp+0x26>
  8008d5:	3a 0a                	cmp    (%edx),%cl
  8008d7:	74 eb                	je     8008c4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d9:	0f b6 00             	movzbl (%eax),%eax
  8008dc:	0f b6 12             	movzbl (%edx),%edx
  8008df:	29 d0                	sub    %edx,%eax
}
  8008e1:	5b                   	pop    %ebx
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    
		return 0;
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	eb f6                	jmp    8008e1 <strncmp+0x2e>

008008eb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f5:	0f b6 10             	movzbl (%eax),%edx
  8008f8:	84 d2                	test   %dl,%dl
  8008fa:	74 09                	je     800905 <strchr+0x1a>
		if (*s == c)
  8008fc:	38 ca                	cmp    %cl,%dl
  8008fe:	74 0a                	je     80090a <strchr+0x1f>
	for (; *s; s++)
  800900:	83 c0 01             	add    $0x1,%eax
  800903:	eb f0                	jmp    8008f5 <strchr+0xa>
			return (char *) s;
	return 0;
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800916:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800919:	38 ca                	cmp    %cl,%dl
  80091b:	74 09                	je     800926 <strfind+0x1a>
  80091d:	84 d2                	test   %dl,%dl
  80091f:	74 05                	je     800926 <strfind+0x1a>
	for (; *s; s++)
  800921:	83 c0 01             	add    $0x1,%eax
  800924:	eb f0                	jmp    800916 <strfind+0xa>
			break;
	return (char *) s;
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	57                   	push   %edi
  80092c:	56                   	push   %esi
  80092d:	53                   	push   %ebx
  80092e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800931:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800934:	85 c9                	test   %ecx,%ecx
  800936:	74 31                	je     800969 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800938:	89 f8                	mov    %edi,%eax
  80093a:	09 c8                	or     %ecx,%eax
  80093c:	a8 03                	test   $0x3,%al
  80093e:	75 23                	jne    800963 <memset+0x3b>
		c &= 0xFF;
  800940:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800944:	89 d3                	mov    %edx,%ebx
  800946:	c1 e3 08             	shl    $0x8,%ebx
  800949:	89 d0                	mov    %edx,%eax
  80094b:	c1 e0 18             	shl    $0x18,%eax
  80094e:	89 d6                	mov    %edx,%esi
  800950:	c1 e6 10             	shl    $0x10,%esi
  800953:	09 f0                	or     %esi,%eax
  800955:	09 c2                	or     %eax,%edx
  800957:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800959:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	fc                   	cld    
  80095f:	f3 ab                	rep stos %eax,%es:(%edi)
  800961:	eb 06                	jmp    800969 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	fc                   	cld    
  800967:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800969:	89 f8                	mov    %edi,%eax
  80096b:	5b                   	pop    %ebx
  80096c:	5e                   	pop    %esi
  80096d:	5f                   	pop    %edi
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	57                   	push   %edi
  800974:	56                   	push   %esi
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097e:	39 c6                	cmp    %eax,%esi
  800980:	73 32                	jae    8009b4 <memmove+0x44>
  800982:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800985:	39 c2                	cmp    %eax,%edx
  800987:	76 2b                	jbe    8009b4 <memmove+0x44>
		s += n;
		d += n;
  800989:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098c:	89 fe                	mov    %edi,%esi
  80098e:	09 ce                	or     %ecx,%esi
  800990:	09 d6                	or     %edx,%esi
  800992:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800998:	75 0e                	jne    8009a8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80099a:	83 ef 04             	sub    $0x4,%edi
  80099d:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a3:	fd                   	std    
  8009a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a6:	eb 09                	jmp    8009b1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a8:	83 ef 01             	sub    $0x1,%edi
  8009ab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ae:	fd                   	std    
  8009af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b1:	fc                   	cld    
  8009b2:	eb 1a                	jmp    8009ce <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	89 c2                	mov    %eax,%edx
  8009b6:	09 ca                	or     %ecx,%edx
  8009b8:	09 f2                	or     %esi,%edx
  8009ba:	f6 c2 03             	test   $0x3,%dl
  8009bd:	75 0a                	jne    8009c9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009bf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c2:	89 c7                	mov    %eax,%edi
  8009c4:	fc                   	cld    
  8009c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c7:	eb 05                	jmp    8009ce <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009c9:	89 c7                	mov    %eax,%edi
  8009cb:	fc                   	cld    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009ce:	5e                   	pop    %esi
  8009cf:	5f                   	pop    %edi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d8:	ff 75 10             	pushl  0x10(%ebp)
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	ff 75 08             	pushl  0x8(%ebp)
  8009e1:	e8 8a ff ff ff       	call   800970 <memmove>
}
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f3:	89 c6                	mov    %eax,%esi
  8009f5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f8:	39 f0                	cmp    %esi,%eax
  8009fa:	74 1c                	je     800a18 <memcmp+0x30>
		if (*s1 != *s2)
  8009fc:	0f b6 08             	movzbl (%eax),%ecx
  8009ff:	0f b6 1a             	movzbl (%edx),%ebx
  800a02:	38 d9                	cmp    %bl,%cl
  800a04:	75 08                	jne    800a0e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a06:	83 c0 01             	add    $0x1,%eax
  800a09:	83 c2 01             	add    $0x1,%edx
  800a0c:	eb ea                	jmp    8009f8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a0e:	0f b6 c1             	movzbl %cl,%eax
  800a11:	0f b6 db             	movzbl %bl,%ebx
  800a14:	29 d8                	sub    %ebx,%eax
  800a16:	eb 05                	jmp    800a1d <memcmp+0x35>
	}

	return 0;
  800a18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1d:	5b                   	pop    %ebx
  800a1e:	5e                   	pop    %esi
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2a:	89 c2                	mov    %eax,%edx
  800a2c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2f:	39 d0                	cmp    %edx,%eax
  800a31:	73 09                	jae    800a3c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a33:	38 08                	cmp    %cl,(%eax)
  800a35:	74 05                	je     800a3c <memfind+0x1b>
	for (; s < ends; s++)
  800a37:	83 c0 01             	add    $0x1,%eax
  800a3a:	eb f3                	jmp    800a2f <memfind+0xe>
			break;
	return (void *) s;
}
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	57                   	push   %edi
  800a42:	56                   	push   %esi
  800a43:	53                   	push   %ebx
  800a44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4a:	eb 03                	jmp    800a4f <strtol+0x11>
		s++;
  800a4c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a4f:	0f b6 01             	movzbl (%ecx),%eax
  800a52:	3c 20                	cmp    $0x20,%al
  800a54:	74 f6                	je     800a4c <strtol+0xe>
  800a56:	3c 09                	cmp    $0x9,%al
  800a58:	74 f2                	je     800a4c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a5a:	3c 2b                	cmp    $0x2b,%al
  800a5c:	74 2a                	je     800a88 <strtol+0x4a>
	int neg = 0;
  800a5e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a63:	3c 2d                	cmp    $0x2d,%al
  800a65:	74 2b                	je     800a92 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a67:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a6d:	75 0f                	jne    800a7e <strtol+0x40>
  800a6f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a72:	74 28                	je     800a9c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a74:	85 db                	test   %ebx,%ebx
  800a76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7b:	0f 44 d8             	cmove  %eax,%ebx
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a86:	eb 50                	jmp    800ad8 <strtol+0x9a>
		s++;
  800a88:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a90:	eb d5                	jmp    800a67 <strtol+0x29>
		s++, neg = 1;
  800a92:	83 c1 01             	add    $0x1,%ecx
  800a95:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9a:	eb cb                	jmp    800a67 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa0:	74 0e                	je     800ab0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	75 d8                	jne    800a7e <strtol+0x40>
		s++, base = 8;
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aae:	eb ce                	jmp    800a7e <strtol+0x40>
		s += 2, base = 16;
  800ab0:	83 c1 02             	add    $0x2,%ecx
  800ab3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab8:	eb c4                	jmp    800a7e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aba:	8d 72 9f             	lea    -0x61(%edx),%esi
  800abd:	89 f3                	mov    %esi,%ebx
  800abf:	80 fb 19             	cmp    $0x19,%bl
  800ac2:	77 29                	ja     800aed <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ac4:	0f be d2             	movsbl %dl,%edx
  800ac7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aca:	3b 55 10             	cmp    0x10(%ebp),%edx
  800acd:	7d 30                	jge    800aff <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800acf:	83 c1 01             	add    $0x1,%ecx
  800ad2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad8:	0f b6 11             	movzbl (%ecx),%edx
  800adb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ade:	89 f3                	mov    %esi,%ebx
  800ae0:	80 fb 09             	cmp    $0x9,%bl
  800ae3:	77 d5                	ja     800aba <strtol+0x7c>
			dig = *s - '0';
  800ae5:	0f be d2             	movsbl %dl,%edx
  800ae8:	83 ea 30             	sub    $0x30,%edx
  800aeb:	eb dd                	jmp    800aca <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800aed:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af0:	89 f3                	mov    %esi,%ebx
  800af2:	80 fb 19             	cmp    $0x19,%bl
  800af5:	77 08                	ja     800aff <strtol+0xc1>
			dig = *s - 'A' + 10;
  800af7:	0f be d2             	movsbl %dl,%edx
  800afa:	83 ea 37             	sub    $0x37,%edx
  800afd:	eb cb                	jmp    800aca <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b03:	74 05                	je     800b0a <strtol+0xcc>
		*endptr = (char *) s;
  800b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b08:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	f7 da                	neg    %edx
  800b0e:	85 ff                	test   %edi,%edi
  800b10:	0f 45 c2             	cmovne %edx,%eax
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b29:	89 c3                	mov    %eax,%ebx
  800b2b:	89 c7                	mov    %eax,%edi
  800b2d:	89 c6                	mov    %eax,%esi
  800b2f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b41:	b8 01 00 00 00       	mov    $0x1,%eax
  800b46:	89 d1                	mov    %edx,%ecx
  800b48:	89 d3                	mov    %edx,%ebx
  800b4a:	89 d7                	mov    %edx,%edi
  800b4c:	89 d6                	mov    %edx,%esi
  800b4e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
  800b66:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6b:	89 cb                	mov    %ecx,%ebx
  800b6d:	89 cf                	mov    %ecx,%edi
  800b6f:	89 ce                	mov    %ecx,%esi
  800b71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b73:	85 c0                	test   %eax,%eax
  800b75:	7f 08                	jg     800b7f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	50                   	push   %eax
  800b83:	6a 03                	push   $0x3
  800b85:	68 df 28 80 00       	push   $0x8028df
  800b8a:	6a 23                	push   $0x23
  800b8c:	68 fc 28 80 00       	push   $0x8028fc
  800b91:	e8 19 16 00 00       	call   8021af <_panic>

00800b96 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba6:	89 d1                	mov    %edx,%ecx
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	89 d7                	mov    %edx,%edi
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_yield>:

void
sys_yield(void)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	57                   	push   %edi
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bc5:	89 d1                	mov    %edx,%ecx
  800bc7:	89 d3                	mov    %edx,%ebx
  800bc9:	89 d7                	mov    %edx,%edi
  800bcb:	89 d6                	mov    %edx,%esi
  800bcd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bdd:	be 00 00 00 00       	mov    $0x0,%esi
  800be2:	8b 55 08             	mov    0x8(%ebp),%edx
  800be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf0:	89 f7                	mov    %esi,%edi
  800bf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	7f 08                	jg     800c00 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c00:	83 ec 0c             	sub    $0xc,%esp
  800c03:	50                   	push   %eax
  800c04:	6a 04                	push   $0x4
  800c06:	68 df 28 80 00       	push   $0x8028df
  800c0b:	6a 23                	push   $0x23
  800c0d:	68 fc 28 80 00       	push   $0x8028fc
  800c12:	e8 98 15 00 00       	call   8021af <_panic>

00800c17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c26:	b8 05 00 00 00       	mov    $0x5,%eax
  800c2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c31:	8b 75 18             	mov    0x18(%ebp),%esi
  800c34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c36:	85 c0                	test   %eax,%eax
  800c38:	7f 08                	jg     800c42 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c42:	83 ec 0c             	sub    $0xc,%esp
  800c45:	50                   	push   %eax
  800c46:	6a 05                	push   $0x5
  800c48:	68 df 28 80 00       	push   $0x8028df
  800c4d:	6a 23                	push   $0x23
  800c4f:	68 fc 28 80 00       	push   $0x8028fc
  800c54:	e8 56 15 00 00       	call   8021af <_panic>

00800c59 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c72:	89 df                	mov    %ebx,%edi
  800c74:	89 de                	mov    %ebx,%esi
  800c76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	7f 08                	jg     800c84 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c84:	83 ec 0c             	sub    $0xc,%esp
  800c87:	50                   	push   %eax
  800c88:	6a 06                	push   $0x6
  800c8a:	68 df 28 80 00       	push   $0x8028df
  800c8f:	6a 23                	push   $0x23
  800c91:	68 fc 28 80 00       	push   $0x8028fc
  800c96:	e8 14 15 00 00       	call   8021af <_panic>

00800c9b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 08                	push   $0x8
  800ccc:	68 df 28 80 00       	push   $0x8028df
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 fc 28 80 00       	push   $0x8028fc
  800cd8:	e8 d2 14 00 00       	call   8021af <_panic>

00800cdd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	89 de                	mov    %ebx,%esi
  800cfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7f 08                	jg     800d08 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	50                   	push   %eax
  800d0c:	6a 09                	push   $0x9
  800d0e:	68 df 28 80 00       	push   $0x8028df
  800d13:	6a 23                	push   $0x23
  800d15:	68 fc 28 80 00       	push   $0x8028fc
  800d1a:	e8 90 14 00 00       	call   8021af <_panic>

00800d1f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d33:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d38:	89 df                	mov    %ebx,%edi
  800d3a:	89 de                	mov    %ebx,%esi
  800d3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	7f 08                	jg     800d4a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	6a 0a                	push   $0xa
  800d50:	68 df 28 80 00       	push   $0x8028df
  800d55:	6a 23                	push   $0x23
  800d57:	68 fc 28 80 00       	push   $0x8028fc
  800d5c:	e8 4e 14 00 00       	call   8021af <_panic>

00800d61 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d72:	be 00 00 00 00       	mov    $0x0,%esi
  800d77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d92:	8b 55 08             	mov    0x8(%ebp),%edx
  800d95:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d9a:	89 cb                	mov    %ecx,%ebx
  800d9c:	89 cf                	mov    %ecx,%edi
  800d9e:	89 ce                	mov    %ecx,%esi
  800da0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7f 08                	jg     800dae <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	50                   	push   %eax
  800db2:	6a 0d                	push   $0xd
  800db4:	68 df 28 80 00       	push   $0x8028df
  800db9:	6a 23                	push   $0x23
  800dbb:	68 fc 28 80 00       	push   $0x8028fc
  800dc0:	e8 ea 13 00 00       	call   8021af <_panic>

00800dc5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dd5:	89 d1                	mov    %edx,%ecx
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	89 d7                	mov    %edx,%edi
  800ddb:	89 d6                	mov    %edx,%esi
  800ddd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800df0:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800df2:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800df5:	83 3a 01             	cmpl   $0x1,(%edx)
  800df8:	7e 09                	jle    800e03 <argstart+0x1f>
  800dfa:	ba b1 25 80 00       	mov    $0x8025b1,%edx
  800dff:	85 c9                	test   %ecx,%ecx
  800e01:	75 05                	jne    800e08 <argstart+0x24>
  800e03:	ba 00 00 00 00       	mov    $0x0,%edx
  800e08:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800e0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <argnext>:

int
argnext(struct Argstate *args)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	53                   	push   %ebx
  800e18:	83 ec 04             	sub    $0x4,%esp
  800e1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800e1e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800e25:	8b 43 08             	mov    0x8(%ebx),%eax
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	74 72                	je     800e9e <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800e2c:	80 38 00             	cmpb   $0x0,(%eax)
  800e2f:	75 48                	jne    800e79 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800e31:	8b 0b                	mov    (%ebx),%ecx
  800e33:	83 39 01             	cmpl   $0x1,(%ecx)
  800e36:	74 58                	je     800e90 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800e38:	8b 53 04             	mov    0x4(%ebx),%edx
  800e3b:	8b 42 04             	mov    0x4(%edx),%eax
  800e3e:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e41:	75 4d                	jne    800e90 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800e43:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e47:	74 47                	je     800e90 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800e49:	83 c0 01             	add    $0x1,%eax
  800e4c:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800e4f:	83 ec 04             	sub    $0x4,%esp
  800e52:	8b 01                	mov    (%ecx),%eax
  800e54:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800e5b:	50                   	push   %eax
  800e5c:	8d 42 08             	lea    0x8(%edx),%eax
  800e5f:	50                   	push   %eax
  800e60:	83 c2 04             	add    $0x4,%edx
  800e63:	52                   	push   %edx
  800e64:	e8 07 fb ff ff       	call   800970 <memmove>
		(*args->argc)--;
  800e69:	8b 03                	mov    (%ebx),%eax
  800e6b:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800e6e:	8b 43 08             	mov    0x8(%ebx),%eax
  800e71:	83 c4 10             	add    $0x10,%esp
  800e74:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e77:	74 11                	je     800e8a <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800e79:	8b 53 08             	mov    0x8(%ebx),%edx
  800e7c:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800e7f:	83 c2 01             	add    $0x1,%edx
  800e82:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800e85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800e8a:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e8e:	75 e9                	jne    800e79 <argnext+0x65>
	args->curarg = 0;
  800e90:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800e9c:	eb e7                	jmp    800e85 <argnext+0x71>
		return -1;
  800e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800ea3:	eb e0                	jmp    800e85 <argnext+0x71>

00800ea5 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 04             	sub    $0x4,%esp
  800eac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800eaf:	8b 43 08             	mov    0x8(%ebx),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	74 5b                	je     800f11 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  800eb6:	80 38 00             	cmpb   $0x0,(%eax)
  800eb9:	74 12                	je     800ecd <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800ebb:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800ebe:	c7 43 08 b1 25 80 00 	movl   $0x8025b1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800ec5:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800ec8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    
	} else if (*args->argc > 1) {
  800ecd:	8b 13                	mov    (%ebx),%edx
  800ecf:	83 3a 01             	cmpl   $0x1,(%edx)
  800ed2:	7f 10                	jg     800ee4 <argnextvalue+0x3f>
		args->argvalue = 0;
  800ed4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800edb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800ee2:	eb e1                	jmp    800ec5 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  800ee4:	8b 43 04             	mov    0x4(%ebx),%eax
  800ee7:	8b 48 04             	mov    0x4(%eax),%ecx
  800eea:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800eed:	83 ec 04             	sub    $0x4,%esp
  800ef0:	8b 12                	mov    (%edx),%edx
  800ef2:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800ef9:	52                   	push   %edx
  800efa:	8d 50 08             	lea    0x8(%eax),%edx
  800efd:	52                   	push   %edx
  800efe:	83 c0 04             	add    $0x4,%eax
  800f01:	50                   	push   %eax
  800f02:	e8 69 fa ff ff       	call   800970 <memmove>
		(*args->argc)--;
  800f07:	8b 03                	mov    (%ebx),%eax
  800f09:	83 28 01             	subl   $0x1,(%eax)
  800f0c:	83 c4 10             	add    $0x10,%esp
  800f0f:	eb b4                	jmp    800ec5 <argnextvalue+0x20>
		return 0;
  800f11:	b8 00 00 00 00       	mov    $0x0,%eax
  800f16:	eb b0                	jmp    800ec8 <argnextvalue+0x23>

00800f18 <argvalue>:
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f21:	8b 42 0c             	mov    0xc(%edx),%eax
  800f24:	85 c0                	test   %eax,%eax
  800f26:	74 02                	je     800f2a <argvalue+0x12>
}
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	52                   	push   %edx
  800f2e:	e8 72 ff ff ff       	call   800ea5 <argnextvalue>
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	eb f0                	jmp    800f28 <argvalue+0x10>

00800f38 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	05 00 00 00 30       	add    $0x30000000,%eax
  800f43:	c1 e8 0c             	shr    $0xc,%eax
}
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f58:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f67:	89 c2                	mov    %eax,%edx
  800f69:	c1 ea 16             	shr    $0x16,%edx
  800f6c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f73:	f6 c2 01             	test   $0x1,%dl
  800f76:	74 2d                	je     800fa5 <fd_alloc+0x46>
  800f78:	89 c2                	mov    %eax,%edx
  800f7a:	c1 ea 0c             	shr    $0xc,%edx
  800f7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f84:	f6 c2 01             	test   $0x1,%dl
  800f87:	74 1c                	je     800fa5 <fd_alloc+0x46>
  800f89:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f8e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f93:	75 d2                	jne    800f67 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f9e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fa3:	eb 0a                	jmp    800faf <fd_alloc+0x50>
			*fd_store = fd;
  800fa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fb7:	83 f8 1f             	cmp    $0x1f,%eax
  800fba:	77 30                	ja     800fec <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fbc:	c1 e0 0c             	shl    $0xc,%eax
  800fbf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fc4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fca:	f6 c2 01             	test   $0x1,%dl
  800fcd:	74 24                	je     800ff3 <fd_lookup+0x42>
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	c1 ea 0c             	shr    $0xc,%edx
  800fd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdb:	f6 c2 01             	test   $0x1,%dl
  800fde:	74 1a                	je     800ffa <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe3:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		return -E_INVAL;
  800fec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff1:	eb f7                	jmp    800fea <fd_lookup+0x39>
		return -E_INVAL;
  800ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff8:	eb f0                	jmp    800fea <fd_lookup+0x39>
  800ffa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fff:	eb e9                	jmp    800fea <fd_lookup+0x39>

00801001 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 08             	sub    $0x8,%esp
  801007:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80100a:	ba 00 00 00 00       	mov    $0x0,%edx
  80100f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801014:	39 08                	cmp    %ecx,(%eax)
  801016:	74 38                	je     801050 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801018:	83 c2 01             	add    $0x1,%edx
  80101b:	8b 04 95 88 29 80 00 	mov    0x802988(,%edx,4),%eax
  801022:	85 c0                	test   %eax,%eax
  801024:	75 ee                	jne    801014 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801026:	a1 08 40 80 00       	mov    0x804008,%eax
  80102b:	8b 40 48             	mov    0x48(%eax),%eax
  80102e:	83 ec 04             	sub    $0x4,%esp
  801031:	51                   	push   %ecx
  801032:	50                   	push   %eax
  801033:	68 0c 29 80 00       	push   $0x80290c
  801038:	e8 c9 f1 ff ff       	call   800206 <cprintf>
	*dev = 0;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801046:	83 c4 10             	add    $0x10,%esp
  801049:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    
			*dev = devtab[i];
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	89 01                	mov    %eax,(%ecx)
			return 0;
  801055:	b8 00 00 00 00       	mov    $0x0,%eax
  80105a:	eb f2                	jmp    80104e <dev_lookup+0x4d>

0080105c <fd_close>:
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	57                   	push   %edi
  801060:	56                   	push   %esi
  801061:	53                   	push   %ebx
  801062:	83 ec 24             	sub    $0x24,%esp
  801065:	8b 75 08             	mov    0x8(%ebp),%esi
  801068:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80106b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80106e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801075:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801078:	50                   	push   %eax
  801079:	e8 33 ff ff ff       	call   800fb1 <fd_lookup>
  80107e:	89 c3                	mov    %eax,%ebx
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	78 05                	js     80108c <fd_close+0x30>
	    || fd != fd2)
  801087:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80108a:	74 16                	je     8010a2 <fd_close+0x46>
		return (must_exist ? r : 0);
  80108c:	89 f8                	mov    %edi,%eax
  80108e:	84 c0                	test   %al,%al
  801090:	b8 00 00 00 00       	mov    $0x0,%eax
  801095:	0f 44 d8             	cmove  %eax,%ebx
}
  801098:	89 d8                	mov    %ebx,%eax
  80109a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109d:	5b                   	pop    %ebx
  80109e:	5e                   	pop    %esi
  80109f:	5f                   	pop    %edi
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010a2:	83 ec 08             	sub    $0x8,%esp
  8010a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a8:	50                   	push   %eax
  8010a9:	ff 36                	pushl  (%esi)
  8010ab:	e8 51 ff ff ff       	call   801001 <dev_lookup>
  8010b0:	89 c3                	mov    %eax,%ebx
  8010b2:	83 c4 10             	add    $0x10,%esp
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	78 1a                	js     8010d3 <fd_close+0x77>
		if (dev->dev_close)
  8010b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010bc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010bf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	74 0b                	je     8010d3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	56                   	push   %esi
  8010cc:	ff d0                	call   *%eax
  8010ce:	89 c3                	mov    %eax,%ebx
  8010d0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	56                   	push   %esi
  8010d7:	6a 00                	push   $0x0
  8010d9:	e8 7b fb ff ff       	call   800c59 <sys_page_unmap>
	return r;
  8010de:	83 c4 10             	add    $0x10,%esp
  8010e1:	eb b5                	jmp    801098 <fd_close+0x3c>

008010e3 <close>:

int
close(int fdnum)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ec:	50                   	push   %eax
  8010ed:	ff 75 08             	pushl  0x8(%ebp)
  8010f0:	e8 bc fe ff ff       	call   800fb1 <fd_lookup>
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	79 02                	jns    8010fe <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    
		return fd_close(fd, 1);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	6a 01                	push   $0x1
  801103:	ff 75 f4             	pushl  -0xc(%ebp)
  801106:	e8 51 ff ff ff       	call   80105c <fd_close>
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	eb ec                	jmp    8010fc <close+0x19>

00801110 <close_all>:

void
close_all(void)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	53                   	push   %ebx
  801114:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801117:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80111c:	83 ec 0c             	sub    $0xc,%esp
  80111f:	53                   	push   %ebx
  801120:	e8 be ff ff ff       	call   8010e3 <close>
	for (i = 0; i < MAXFD; i++)
  801125:	83 c3 01             	add    $0x1,%ebx
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	83 fb 20             	cmp    $0x20,%ebx
  80112e:	75 ec                	jne    80111c <close_all+0xc>
}
  801130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80113e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 67 fe ff ff       	call   800fb1 <fd_lookup>
  80114a:	89 c3                	mov    %eax,%ebx
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	0f 88 81 00 00 00    	js     8011d8 <dup+0xa3>
		return r;
	close(newfdnum);
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	e8 81 ff ff ff       	call   8010e3 <close>

	newfd = INDEX2FD(newfdnum);
  801162:	8b 75 0c             	mov    0xc(%ebp),%esi
  801165:	c1 e6 0c             	shl    $0xc,%esi
  801168:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80116e:	83 c4 04             	add    $0x4,%esp
  801171:	ff 75 e4             	pushl  -0x1c(%ebp)
  801174:	e8 cf fd ff ff       	call   800f48 <fd2data>
  801179:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80117b:	89 34 24             	mov    %esi,(%esp)
  80117e:	e8 c5 fd ff ff       	call   800f48 <fd2data>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801188:	89 d8                	mov    %ebx,%eax
  80118a:	c1 e8 16             	shr    $0x16,%eax
  80118d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801194:	a8 01                	test   $0x1,%al
  801196:	74 11                	je     8011a9 <dup+0x74>
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	c1 e8 0c             	shr    $0xc,%eax
  80119d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a4:	f6 c2 01             	test   $0x1,%dl
  8011a7:	75 39                	jne    8011e2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011ac:	89 d0                	mov    %edx,%eax
  8011ae:	c1 e8 0c             	shr    $0xc,%eax
  8011b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8011c0:	50                   	push   %eax
  8011c1:	56                   	push   %esi
  8011c2:	6a 00                	push   $0x0
  8011c4:	52                   	push   %edx
  8011c5:	6a 00                	push   $0x0
  8011c7:	e8 4b fa ff ff       	call   800c17 <sys_page_map>
  8011cc:	89 c3                	mov    %eax,%ebx
  8011ce:	83 c4 20             	add    $0x20,%esp
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	78 31                	js     801206 <dup+0xd1>
		goto err;

	return newfdnum;
  8011d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011d8:	89 d8                	mov    %ebx,%eax
  8011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5e                   	pop    %esi
  8011df:	5f                   	pop    %edi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8011f1:	50                   	push   %eax
  8011f2:	57                   	push   %edi
  8011f3:	6a 00                	push   $0x0
  8011f5:	53                   	push   %ebx
  8011f6:	6a 00                	push   $0x0
  8011f8:	e8 1a fa ff ff       	call   800c17 <sys_page_map>
  8011fd:	89 c3                	mov    %eax,%ebx
  8011ff:	83 c4 20             	add    $0x20,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	79 a3                	jns    8011a9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	56                   	push   %esi
  80120a:	6a 00                	push   $0x0
  80120c:	e8 48 fa ff ff       	call   800c59 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801211:	83 c4 08             	add    $0x8,%esp
  801214:	57                   	push   %edi
  801215:	6a 00                	push   $0x0
  801217:	e8 3d fa ff ff       	call   800c59 <sys_page_unmap>
	return r;
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	eb b7                	jmp    8011d8 <dup+0xa3>

00801221 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	53                   	push   %ebx
  801225:	83 ec 1c             	sub    $0x1c,%esp
  801228:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122e:	50                   	push   %eax
  80122f:	53                   	push   %ebx
  801230:	e8 7c fd ff ff       	call   800fb1 <fd_lookup>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 3f                	js     80127b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801242:	50                   	push   %eax
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	ff 30                	pushl  (%eax)
  801248:	e8 b4 fd ff ff       	call   801001 <dev_lookup>
  80124d:	83 c4 10             	add    $0x10,%esp
  801250:	85 c0                	test   %eax,%eax
  801252:	78 27                	js     80127b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801254:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801257:	8b 42 08             	mov    0x8(%edx),%eax
  80125a:	83 e0 03             	and    $0x3,%eax
  80125d:	83 f8 01             	cmp    $0x1,%eax
  801260:	74 1e                	je     801280 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801265:	8b 40 08             	mov    0x8(%eax),%eax
  801268:	85 c0                	test   %eax,%eax
  80126a:	74 35                	je     8012a1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	ff 75 10             	pushl  0x10(%ebp)
  801272:	ff 75 0c             	pushl  0xc(%ebp)
  801275:	52                   	push   %edx
  801276:	ff d0                	call   *%eax
  801278:	83 c4 10             	add    $0x10,%esp
}
  80127b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801280:	a1 08 40 80 00       	mov    0x804008,%eax
  801285:	8b 40 48             	mov    0x48(%eax),%eax
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	53                   	push   %ebx
  80128c:	50                   	push   %eax
  80128d:	68 4d 29 80 00       	push   $0x80294d
  801292:	e8 6f ef ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129f:	eb da                	jmp    80127b <read+0x5a>
		return -E_NOT_SUPP;
  8012a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a6:	eb d3                	jmp    80127b <read+0x5a>

008012a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bc:	39 f3                	cmp    %esi,%ebx
  8012be:	73 23                	jae    8012e3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012c0:	83 ec 04             	sub    $0x4,%esp
  8012c3:	89 f0                	mov    %esi,%eax
  8012c5:	29 d8                	sub    %ebx,%eax
  8012c7:	50                   	push   %eax
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	03 45 0c             	add    0xc(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	57                   	push   %edi
  8012cf:	e8 4d ff ff ff       	call   801221 <read>
		if (m < 0)
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 06                	js     8012e1 <readn+0x39>
			return m;
		if (m == 0)
  8012db:	74 06                	je     8012e3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8012dd:	01 c3                	add    %eax,%ebx
  8012df:	eb db                	jmp    8012bc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012e3:	89 d8                	mov    %ebx,%eax
  8012e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e8:	5b                   	pop    %ebx
  8012e9:	5e                   	pop    %esi
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	53                   	push   %ebx
  8012f1:	83 ec 1c             	sub    $0x1c,%esp
  8012f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012fa:	50                   	push   %eax
  8012fb:	53                   	push   %ebx
  8012fc:	e8 b0 fc ff ff       	call   800fb1 <fd_lookup>
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 3a                	js     801342 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801308:	83 ec 08             	sub    $0x8,%esp
  80130b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130e:	50                   	push   %eax
  80130f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801312:	ff 30                	pushl  (%eax)
  801314:	e8 e8 fc ff ff       	call   801001 <dev_lookup>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 22                	js     801342 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801323:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801327:	74 1e                	je     801347 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 52 0c             	mov    0xc(%edx),%edx
  80132f:	85 d2                	test   %edx,%edx
  801331:	74 35                	je     801368 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	ff 75 10             	pushl  0x10(%ebp)
  801339:	ff 75 0c             	pushl  0xc(%ebp)
  80133c:	50                   	push   %eax
  80133d:	ff d2                	call   *%edx
  80133f:	83 c4 10             	add    $0x10,%esp
}
  801342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801345:	c9                   	leave  
  801346:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801347:	a1 08 40 80 00       	mov    0x804008,%eax
  80134c:	8b 40 48             	mov    0x48(%eax),%eax
  80134f:	83 ec 04             	sub    $0x4,%esp
  801352:	53                   	push   %ebx
  801353:	50                   	push   %eax
  801354:	68 69 29 80 00       	push   $0x802969
  801359:	e8 a8 ee ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801366:	eb da                	jmp    801342 <write+0x55>
		return -E_NOT_SUPP;
  801368:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136d:	eb d3                	jmp    801342 <write+0x55>

0080136f <seek>:

int
seek(int fdnum, off_t offset)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801375:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 30 fc ff ff       	call   800fb1 <fd_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 0e                	js     801396 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801388:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801391:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	53                   	push   %ebx
  80139c:	83 ec 1c             	sub    $0x1c,%esp
  80139f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	53                   	push   %ebx
  8013a7:	e8 05 fc ff ff       	call   800fb1 <fd_lookup>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 37                	js     8013ea <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	ff 30                	pushl  (%eax)
  8013bf:	e8 3d fc ff ff       	call   801001 <dev_lookup>
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 1f                	js     8013ea <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d2:	74 1b                	je     8013ef <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 52 18             	mov    0x18(%edx),%edx
  8013da:	85 d2                	test   %edx,%edx
  8013dc:	74 32                	je     801410 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	50                   	push   %eax
  8013e5:	ff d2                	call   *%edx
  8013e7:	83 c4 10             	add    $0x10,%esp
}
  8013ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013ef:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013f4:	8b 40 48             	mov    0x48(%eax),%eax
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	53                   	push   %ebx
  8013fb:	50                   	push   %eax
  8013fc:	68 2c 29 80 00       	push   $0x80292c
  801401:	e8 00 ee ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140e:	eb da                	jmp    8013ea <ftruncate+0x52>
		return -E_NOT_SUPP;
  801410:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801415:	eb d3                	jmp    8013ea <ftruncate+0x52>

00801417 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 1c             	sub    $0x1c,%esp
  80141e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801421:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	e8 84 fb ff ff       	call   800fb1 <fd_lookup>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 4b                	js     80147f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	ff 30                	pushl  (%eax)
  801440:	e8 bc fb ff ff       	call   801001 <dev_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 33                	js     80147f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801453:	74 2f                	je     801484 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801455:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801458:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80145f:	00 00 00 
	stat->st_isdir = 0;
  801462:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801469:	00 00 00 
	stat->st_dev = dev;
  80146c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	53                   	push   %ebx
  801476:	ff 75 f0             	pushl  -0x10(%ebp)
  801479:	ff 50 14             	call   *0x14(%eax)
  80147c:	83 c4 10             	add    $0x10,%esp
}
  80147f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801482:	c9                   	leave  
  801483:	c3                   	ret    
		return -E_NOT_SUPP;
  801484:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801489:	eb f4                	jmp    80147f <fstat+0x68>

0080148b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	56                   	push   %esi
  80148f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	6a 00                	push   $0x0
  801495:	ff 75 08             	pushl  0x8(%ebp)
  801498:	e8 2f 02 00 00       	call   8016cc <open>
  80149d:	89 c3                	mov    %eax,%ebx
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 1b                	js     8014c1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014a6:	83 ec 08             	sub    $0x8,%esp
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	50                   	push   %eax
  8014ad:	e8 65 ff ff ff       	call   801417 <fstat>
  8014b2:	89 c6                	mov    %eax,%esi
	close(fd);
  8014b4:	89 1c 24             	mov    %ebx,(%esp)
  8014b7:	e8 27 fc ff ff       	call   8010e3 <close>
	return r;
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	89 f3                	mov    %esi,%ebx
}
  8014c1:	89 d8                	mov    %ebx,%eax
  8014c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c6:	5b                   	pop    %ebx
  8014c7:	5e                   	pop    %esi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	89 c6                	mov    %eax,%esi
  8014d1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014d3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014da:	74 27                	je     801503 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014dc:	6a 07                	push   $0x7
  8014de:	68 00 50 80 00       	push   $0x805000
  8014e3:	56                   	push   %esi
  8014e4:	ff 35 00 40 80 00    	pushl  0x804000
  8014ea:	e8 79 0d 00 00       	call   802268 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014ef:	83 c4 0c             	add    $0xc,%esp
  8014f2:	6a 00                	push   $0x0
  8014f4:	53                   	push   %ebx
  8014f5:	6a 00                	push   $0x0
  8014f7:	e8 f9 0c 00 00       	call   8021f5 <ipc_recv>
}
  8014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801503:	83 ec 0c             	sub    $0xc,%esp
  801506:	6a 01                	push   $0x1
  801508:	e8 c7 0d 00 00       	call   8022d4 <ipc_find_env>
  80150d:	a3 00 40 80 00       	mov    %eax,0x804000
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	eb c5                	jmp    8014dc <fsipc+0x12>

00801517 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8b 40 0c             	mov    0xc(%eax),%eax
  801523:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801530:	ba 00 00 00 00       	mov    $0x0,%edx
  801535:	b8 02 00 00 00       	mov    $0x2,%eax
  80153a:	e8 8b ff ff ff       	call   8014ca <fsipc>
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <devfile_flush>:
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8b 40 0c             	mov    0xc(%eax),%eax
  80154d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801552:	ba 00 00 00 00       	mov    $0x0,%edx
  801557:	b8 06 00 00 00       	mov    $0x6,%eax
  80155c:	e8 69 ff ff ff       	call   8014ca <fsipc>
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <devfile_stat>:
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	53                   	push   %ebx
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8b 40 0c             	mov    0xc(%eax),%eax
  801573:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801578:	ba 00 00 00 00       	mov    $0x0,%edx
  80157d:	b8 05 00 00 00       	mov    $0x5,%eax
  801582:	e8 43 ff ff ff       	call   8014ca <fsipc>
  801587:	85 c0                	test   %eax,%eax
  801589:	78 2c                	js     8015b7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80158b:	83 ec 08             	sub    $0x8,%esp
  80158e:	68 00 50 80 00       	push   $0x805000
  801593:	53                   	push   %ebx
  801594:	e8 49 f2 ff ff       	call   8007e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801599:	a1 80 50 80 00       	mov    0x805080,%eax
  80159e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015a4:	a1 84 50 80 00       	mov    0x805084,%eax
  8015a9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <devfile_write>:
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	53                   	push   %ebx
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8015c6:	85 db                	test   %ebx,%ebx
  8015c8:	75 07                	jne    8015d1 <devfile_write+0x15>
	return n_all;
  8015ca:	89 d8                	mov    %ebx,%eax
}
  8015cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d7:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8015dc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	53                   	push   %ebx
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	68 08 50 80 00       	push   $0x805008
  8015ee:	e8 7d f3 ff ff       	call   800970 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8015fd:	e8 c8 fe ff ff       	call   8014ca <fsipc>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	85 c0                	test   %eax,%eax
  801607:	78 c3                	js     8015cc <devfile_write+0x10>
	  assert(r <= n_left);
  801609:	39 d8                	cmp    %ebx,%eax
  80160b:	77 0b                	ja     801618 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  80160d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801612:	7f 1d                	jg     801631 <devfile_write+0x75>
    n_all += r;
  801614:	89 c3                	mov    %eax,%ebx
  801616:	eb b2                	jmp    8015ca <devfile_write+0xe>
	  assert(r <= n_left);
  801618:	68 9c 29 80 00       	push   $0x80299c
  80161d:	68 a8 29 80 00       	push   $0x8029a8
  801622:	68 9f 00 00 00       	push   $0x9f
  801627:	68 bd 29 80 00       	push   $0x8029bd
  80162c:	e8 7e 0b 00 00       	call   8021af <_panic>
	  assert(r <= PGSIZE);
  801631:	68 c8 29 80 00       	push   $0x8029c8
  801636:	68 a8 29 80 00       	push   $0x8029a8
  80163b:	68 a0 00 00 00       	push   $0xa0
  801640:	68 bd 29 80 00       	push   $0x8029bd
  801645:	e8 65 0b 00 00       	call   8021af <_panic>

0080164a <devfile_read>:
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
  80164f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8b 40 0c             	mov    0xc(%eax),%eax
  801658:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80165d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801663:	ba 00 00 00 00       	mov    $0x0,%edx
  801668:	b8 03 00 00 00       	mov    $0x3,%eax
  80166d:	e8 58 fe ff ff       	call   8014ca <fsipc>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	85 c0                	test   %eax,%eax
  801676:	78 1f                	js     801697 <devfile_read+0x4d>
	assert(r <= n);
  801678:	39 f0                	cmp    %esi,%eax
  80167a:	77 24                	ja     8016a0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80167c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801681:	7f 33                	jg     8016b6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	50                   	push   %eax
  801687:	68 00 50 80 00       	push   $0x805000
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	e8 dc f2 ff ff       	call   800970 <memmove>
	return r;
  801694:	83 c4 10             	add    $0x10,%esp
}
  801697:	89 d8                	mov    %ebx,%eax
  801699:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169c:	5b                   	pop    %ebx
  80169d:	5e                   	pop    %esi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    
	assert(r <= n);
  8016a0:	68 d4 29 80 00       	push   $0x8029d4
  8016a5:	68 a8 29 80 00       	push   $0x8029a8
  8016aa:	6a 7c                	push   $0x7c
  8016ac:	68 bd 29 80 00       	push   $0x8029bd
  8016b1:	e8 f9 0a 00 00       	call   8021af <_panic>
	assert(r <= PGSIZE);
  8016b6:	68 c8 29 80 00       	push   $0x8029c8
  8016bb:	68 a8 29 80 00       	push   $0x8029a8
  8016c0:	6a 7d                	push   $0x7d
  8016c2:	68 bd 29 80 00       	push   $0x8029bd
  8016c7:	e8 e3 0a 00 00       	call   8021af <_panic>

008016cc <open>:
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 1c             	sub    $0x1c,%esp
  8016d4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016d7:	56                   	push   %esi
  8016d8:	e8 cc f0 ff ff       	call   8007a9 <strlen>
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016e5:	7f 6c                	jg     801753 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	e8 6c f8 ff ff       	call   800f5f <fd_alloc>
  8016f3:	89 c3                	mov    %eax,%ebx
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 3c                	js     801738 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016fc:	83 ec 08             	sub    $0x8,%esp
  8016ff:	56                   	push   %esi
  801700:	68 00 50 80 00       	push   $0x805000
  801705:	e8 d8 f0 ff ff       	call   8007e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80170a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801715:	b8 01 00 00 00       	mov    $0x1,%eax
  80171a:	e8 ab fd ff ff       	call   8014ca <fsipc>
  80171f:	89 c3                	mov    %eax,%ebx
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	78 19                	js     801741 <open+0x75>
	return fd2num(fd);
  801728:	83 ec 0c             	sub    $0xc,%esp
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	e8 05 f8 ff ff       	call   800f38 <fd2num>
  801733:	89 c3                	mov    %eax,%ebx
  801735:	83 c4 10             	add    $0x10,%esp
}
  801738:	89 d8                	mov    %ebx,%eax
  80173a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    
		fd_close(fd, 0);
  801741:	83 ec 08             	sub    $0x8,%esp
  801744:	6a 00                	push   $0x0
  801746:	ff 75 f4             	pushl  -0xc(%ebp)
  801749:	e8 0e f9 ff ff       	call   80105c <fd_close>
		return r;
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	eb e5                	jmp    801738 <open+0x6c>
		return -E_BAD_PATH;
  801753:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801758:	eb de                	jmp    801738 <open+0x6c>

0080175a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	b8 08 00 00 00       	mov    $0x8,%eax
  80176a:	e8 5b fd ff ff       	call   8014ca <fsipc>
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801771:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801775:	7f 01                	jg     801778 <writebuf+0x7>
  801777:	c3                   	ret    
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	53                   	push   %ebx
  80177c:	83 ec 08             	sub    $0x8,%esp
  80177f:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801781:	ff 70 04             	pushl  0x4(%eax)
  801784:	8d 40 10             	lea    0x10(%eax),%eax
  801787:	50                   	push   %eax
  801788:	ff 33                	pushl  (%ebx)
  80178a:	e8 5e fb ff ff       	call   8012ed <write>
		if (result > 0)
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	7e 03                	jle    801799 <writebuf+0x28>
			b->result += result;
  801796:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801799:	39 43 04             	cmp    %eax,0x4(%ebx)
  80179c:	74 0d                	je     8017ab <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	0f 4f c2             	cmovg  %edx,%eax
  8017a8:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <putch>:

static void
putch(int ch, void *thunk)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017ba:	8b 53 04             	mov    0x4(%ebx),%edx
  8017bd:	8d 42 01             	lea    0x1(%edx),%eax
  8017c0:	89 43 04             	mov    %eax,0x4(%ebx)
  8017c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017ca:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017cf:	74 06                	je     8017d7 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8017d1:	83 c4 04             	add    $0x4,%esp
  8017d4:	5b                   	pop    %ebx
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    
		writebuf(b);
  8017d7:	89 d8                	mov    %ebx,%eax
  8017d9:	e8 93 ff ff ff       	call   801771 <writebuf>
		b->idx = 0;
  8017de:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017e5:	eb ea                	jmp    8017d1 <putch+0x21>

008017e7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017f9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801800:	00 00 00 
	b.result = 0;
  801803:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80180a:	00 00 00 
	b.error = 1;
  80180d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801814:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801817:	ff 75 10             	pushl  0x10(%ebp)
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801823:	50                   	push   %eax
  801824:	68 b0 17 80 00       	push   $0x8017b0
  801829:	e8 d4 ea ff ff       	call   800302 <vprintfmt>
	if (b.idx > 0)
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801838:	7f 11                	jg     80184b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80183a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801840:	85 c0                	test   %eax,%eax
  801842:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    
		writebuf(&b);
  80184b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801851:	e8 1b ff ff ff       	call   801771 <writebuf>
  801856:	eb e2                	jmp    80183a <vfprintf+0x53>

00801858 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80185e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801861:	50                   	push   %eax
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	e8 7a ff ff ff       	call   8017e7 <vfprintf>
	va_end(ap);

	return cnt;
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <printf>:

int
printf(const char *fmt, ...)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801875:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801878:	50                   	push   %eax
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	6a 01                	push   $0x1
  80187e:	e8 64 ff ff ff       	call   8017e7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
  80188a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	e8 b0 f6 ff ff       	call   800f48 <fd2data>
  801898:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80189a:	83 c4 08             	add    $0x8,%esp
  80189d:	68 db 29 80 00       	push   $0x8029db
  8018a2:	53                   	push   %ebx
  8018a3:	e8 3a ef ff ff       	call   8007e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018a8:	8b 46 04             	mov    0x4(%esi),%eax
  8018ab:	2b 06                	sub    (%esi),%eax
  8018ad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018ba:	00 00 00 
	stat->st_dev = &devpipe;
  8018bd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018c4:	30 80 00 
	return 0;
}
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    

008018d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	53                   	push   %ebx
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018dd:	53                   	push   %ebx
  8018de:	6a 00                	push   $0x0
  8018e0:	e8 74 f3 ff ff       	call   800c59 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018e5:	89 1c 24             	mov    %ebx,(%esp)
  8018e8:	e8 5b f6 ff ff       	call   800f48 <fd2data>
  8018ed:	83 c4 08             	add    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	e8 61 f3 ff ff       	call   800c59 <sys_page_unmap>
}
  8018f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <_pipeisclosed>:
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 1c             	sub    $0x1c,%esp
  801906:	89 c7                	mov    %eax,%edi
  801908:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80190a:	a1 08 40 80 00       	mov    0x804008,%eax
  80190f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801912:	83 ec 0c             	sub    $0xc,%esp
  801915:	57                   	push   %edi
  801916:	e8 f2 09 00 00       	call   80230d <pageref>
  80191b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80191e:	89 34 24             	mov    %esi,(%esp)
  801921:	e8 e7 09 00 00       	call   80230d <pageref>
		nn = thisenv->env_runs;
  801926:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80192c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	39 cb                	cmp    %ecx,%ebx
  801934:	74 1b                	je     801951 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801936:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801939:	75 cf                	jne    80190a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80193b:	8b 42 58             	mov    0x58(%edx),%eax
  80193e:	6a 01                	push   $0x1
  801940:	50                   	push   %eax
  801941:	53                   	push   %ebx
  801942:	68 e2 29 80 00       	push   $0x8029e2
  801947:	e8 ba e8 ff ff       	call   800206 <cprintf>
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	eb b9                	jmp    80190a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801951:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801954:	0f 94 c0             	sete   %al
  801957:	0f b6 c0             	movzbl %al,%eax
}
  80195a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80195d:	5b                   	pop    %ebx
  80195e:	5e                   	pop    %esi
  80195f:	5f                   	pop    %edi
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    

00801962 <devpipe_write>:
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	57                   	push   %edi
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
  801968:	83 ec 28             	sub    $0x28,%esp
  80196b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80196e:	56                   	push   %esi
  80196f:	e8 d4 f5 ff ff       	call   800f48 <fd2data>
  801974:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	bf 00 00 00 00       	mov    $0x0,%edi
  80197e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801981:	74 4f                	je     8019d2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801983:	8b 43 04             	mov    0x4(%ebx),%eax
  801986:	8b 0b                	mov    (%ebx),%ecx
  801988:	8d 51 20             	lea    0x20(%ecx),%edx
  80198b:	39 d0                	cmp    %edx,%eax
  80198d:	72 14                	jb     8019a3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80198f:	89 da                	mov    %ebx,%edx
  801991:	89 f0                	mov    %esi,%eax
  801993:	e8 65 ff ff ff       	call   8018fd <_pipeisclosed>
  801998:	85 c0                	test   %eax,%eax
  80199a:	75 3b                	jne    8019d7 <devpipe_write+0x75>
			sys_yield();
  80199c:	e8 14 f2 ff ff       	call   800bb5 <sys_yield>
  8019a1:	eb e0                	jmp    801983 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019aa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019ad:	89 c2                	mov    %eax,%edx
  8019af:	c1 fa 1f             	sar    $0x1f,%edx
  8019b2:	89 d1                	mov    %edx,%ecx
  8019b4:	c1 e9 1b             	shr    $0x1b,%ecx
  8019b7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019ba:	83 e2 1f             	and    $0x1f,%edx
  8019bd:	29 ca                	sub    %ecx,%edx
  8019bf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019c3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019c7:	83 c0 01             	add    $0x1,%eax
  8019ca:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019cd:	83 c7 01             	add    $0x1,%edi
  8019d0:	eb ac                	jmp    80197e <devpipe_write+0x1c>
	return i;
  8019d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d5:	eb 05                	jmp    8019dc <devpipe_write+0x7a>
				return 0;
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <devpipe_read>:
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	57                   	push   %edi
  8019e8:	56                   	push   %esi
  8019e9:	53                   	push   %ebx
  8019ea:	83 ec 18             	sub    $0x18,%esp
  8019ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019f0:	57                   	push   %edi
  8019f1:	e8 52 f5 ff ff       	call   800f48 <fd2data>
  8019f6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	be 00 00 00 00       	mov    $0x0,%esi
  801a00:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a03:	75 14                	jne    801a19 <devpipe_read+0x35>
	return i;
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	eb 02                	jmp    801a0c <devpipe_read+0x28>
				return i;
  801a0a:	89 f0                	mov    %esi,%eax
}
  801a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5f                   	pop    %edi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
			sys_yield();
  801a14:	e8 9c f1 ff ff       	call   800bb5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a19:	8b 03                	mov    (%ebx),%eax
  801a1b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a1e:	75 18                	jne    801a38 <devpipe_read+0x54>
			if (i > 0)
  801a20:	85 f6                	test   %esi,%esi
  801a22:	75 e6                	jne    801a0a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801a24:	89 da                	mov    %ebx,%edx
  801a26:	89 f8                	mov    %edi,%eax
  801a28:	e8 d0 fe ff ff       	call   8018fd <_pipeisclosed>
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	74 e3                	je     801a14 <devpipe_read+0x30>
				return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	eb d4                	jmp    801a0c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a38:	99                   	cltd   
  801a39:	c1 ea 1b             	shr    $0x1b,%edx
  801a3c:	01 d0                	add    %edx,%eax
  801a3e:	83 e0 1f             	and    $0x1f,%eax
  801a41:	29 d0                	sub    %edx,%eax
  801a43:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a4b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a4e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a51:	83 c6 01             	add    $0x1,%esi
  801a54:	eb aa                	jmp    801a00 <devpipe_read+0x1c>

00801a56 <pipe>:
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	56                   	push   %esi
  801a5a:	53                   	push   %ebx
  801a5b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a61:	50                   	push   %eax
  801a62:	e8 f8 f4 ff ff       	call   800f5f <fd_alloc>
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	0f 88 23 01 00 00    	js     801b97 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	68 07 04 00 00       	push   $0x407
  801a7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7f:	6a 00                	push   $0x0
  801a81:	e8 4e f1 ff ff       	call   800bd4 <sys_page_alloc>
  801a86:	89 c3                	mov    %eax,%ebx
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	0f 88 04 01 00 00    	js     801b97 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a99:	50                   	push   %eax
  801a9a:	e8 c0 f4 ff ff       	call   800f5f <fd_alloc>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	0f 88 db 00 00 00    	js     801b87 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	68 07 04 00 00       	push   $0x407
  801ab4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab7:	6a 00                	push   $0x0
  801ab9:	e8 16 f1 ff ff       	call   800bd4 <sys_page_alloc>
  801abe:	89 c3                	mov    %eax,%ebx
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	0f 88 bc 00 00 00    	js     801b87 <pipe+0x131>
	va = fd2data(fd0);
  801acb:	83 ec 0c             	sub    $0xc,%esp
  801ace:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad1:	e8 72 f4 ff ff       	call   800f48 <fd2data>
  801ad6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad8:	83 c4 0c             	add    $0xc,%esp
  801adb:	68 07 04 00 00       	push   $0x407
  801ae0:	50                   	push   %eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	e8 ec f0 ff ff       	call   800bd4 <sys_page_alloc>
  801ae8:	89 c3                	mov    %eax,%ebx
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	0f 88 82 00 00 00    	js     801b77 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	ff 75 f0             	pushl  -0x10(%ebp)
  801afb:	e8 48 f4 ff ff       	call   800f48 <fd2data>
  801b00:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b07:	50                   	push   %eax
  801b08:	6a 00                	push   $0x0
  801b0a:	56                   	push   %esi
  801b0b:	6a 00                	push   $0x0
  801b0d:	e8 05 f1 ff ff       	call   800c17 <sys_page_map>
  801b12:	89 c3                	mov    %eax,%ebx
  801b14:	83 c4 20             	add    $0x20,%esp
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 4e                	js     801b69 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801b1b:	a1 20 30 80 00       	mov    0x803020,%eax
  801b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b23:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b28:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b32:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	ff 75 f4             	pushl  -0xc(%ebp)
  801b44:	e8 ef f3 ff ff       	call   800f38 <fd2num>
  801b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b4e:	83 c4 04             	add    $0x4,%esp
  801b51:	ff 75 f0             	pushl  -0x10(%ebp)
  801b54:	e8 df f3 ff ff       	call   800f38 <fd2num>
  801b59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b67:	eb 2e                	jmp    801b97 <pipe+0x141>
	sys_page_unmap(0, va);
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	56                   	push   %esi
  801b6d:	6a 00                	push   $0x0
  801b6f:	e8 e5 f0 ff ff       	call   800c59 <sys_page_unmap>
  801b74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b7d:	6a 00                	push   $0x0
  801b7f:	e8 d5 f0 ff ff       	call   800c59 <sys_page_unmap>
  801b84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b87:	83 ec 08             	sub    $0x8,%esp
  801b8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8d:	6a 00                	push   $0x0
  801b8f:	e8 c5 f0 ff ff       	call   800c59 <sys_page_unmap>
  801b94:	83 c4 10             	add    $0x10,%esp
}
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <pipeisclosed>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ba6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba9:	50                   	push   %eax
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	e8 ff f3 ff ff       	call   800fb1 <fd_lookup>
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 18                	js     801bd1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbf:	e8 84 f3 ff ff       	call   800f48 <fd2data>
	return _pipeisclosed(fd, p);
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc9:	e8 2f fd ff ff       	call   8018fd <_pipeisclosed>
  801bce:	83 c4 10             	add    $0x10,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801bd9:	68 fa 29 80 00       	push   $0x8029fa
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	e8 fc eb ff ff       	call   8007e2 <strcpy>
	return 0;
}
  801be6:	b8 00 00 00 00       	mov    $0x0,%eax
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <devsock_close>:
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	53                   	push   %ebx
  801bf1:	83 ec 10             	sub    $0x10,%esp
  801bf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bf7:	53                   	push   %ebx
  801bf8:	e8 10 07 00 00       	call   80230d <pageref>
  801bfd:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c00:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801c05:	83 f8 01             	cmp    $0x1,%eax
  801c08:	74 07                	je     801c11 <devsock_close+0x24>
}
  801c0a:	89 d0                	mov    %edx,%eax
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	ff 73 0c             	pushl  0xc(%ebx)
  801c17:	e8 b9 02 00 00       	call   801ed5 <nsipc_close>
  801c1c:	89 c2                	mov    %eax,%edx
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	eb e7                	jmp    801c0a <devsock_close+0x1d>

00801c23 <devsock_write>:
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	ff 75 10             	pushl  0x10(%ebp)
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	ff 70 0c             	pushl  0xc(%eax)
  801c37:	e8 76 03 00 00       	call   801fb2 <nsipc_send>
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <devsock_read>:
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 10             	pushl  0x10(%ebp)
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	ff 70 0c             	pushl  0xc(%eax)
  801c52:	e8 ef 02 00 00       	call   801f46 <nsipc_recv>
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <fd2sockid>:
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c5f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	e8 48 f3 ff ff       	call   800fb1 <fd_lookup>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 10                	js     801c80 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801c79:	39 08                	cmp    %ecx,(%eax)
  801c7b:	75 05                	jne    801c82 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c7d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    
		return -E_NOT_SUPP;
  801c82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c87:	eb f7                	jmp    801c80 <fd2sockid+0x27>

00801c89 <alloc_sockfd>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 1c             	sub    $0x1c,%esp
  801c91:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c96:	50                   	push   %eax
  801c97:	e8 c3 f2 ff ff       	call   800f5f <fd_alloc>
  801c9c:	89 c3                	mov    %eax,%ebx
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	78 43                	js     801ce8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 07 04 00 00       	push   $0x407
  801cad:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb0:	6a 00                	push   $0x0
  801cb2:	e8 1d ef ff ff       	call   800bd4 <sys_page_alloc>
  801cb7:	89 c3                	mov    %eax,%ebx
  801cb9:	83 c4 10             	add    $0x10,%esp
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 28                	js     801ce8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cc9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cd5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	50                   	push   %eax
  801cdc:	e8 57 f2 ff ff       	call   800f38 <fd2num>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	eb 0c                	jmp    801cf4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	56                   	push   %esi
  801cec:	e8 e4 01 00 00       	call   801ed5 <nsipc_close>
		return r;
  801cf1:	83 c4 10             	add    $0x10,%esp
}
  801cf4:	89 d8                	mov    %ebx,%eax
  801cf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf9:	5b                   	pop    %ebx
  801cfa:	5e                   	pop    %esi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    

00801cfd <accept>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	e8 4e ff ff ff       	call   801c59 <fd2sockid>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 1b                	js     801d2a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	ff 75 10             	pushl  0x10(%ebp)
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	50                   	push   %eax
  801d19:	e8 0e 01 00 00       	call   801e2c <nsipc_accept>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	78 05                	js     801d2a <accept+0x2d>
	return alloc_sockfd(r);
  801d25:	e8 5f ff ff ff       	call   801c89 <alloc_sockfd>
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <bind>:
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	e8 1f ff ff ff       	call   801c59 <fd2sockid>
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	78 12                	js     801d50 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	ff 75 10             	pushl  0x10(%ebp)
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	50                   	push   %eax
  801d48:	e8 31 01 00 00       	call   801e7e <nsipc_bind>
  801d4d:	83 c4 10             	add    $0x10,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <shutdown>:
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	e8 f9 fe ff ff       	call   801c59 <fd2sockid>
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 0f                	js     801d73 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d64:	83 ec 08             	sub    $0x8,%esp
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	50                   	push   %eax
  801d6b:	e8 43 01 00 00       	call   801eb3 <nsipc_shutdown>
  801d70:	83 c4 10             	add    $0x10,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <connect>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	e8 d6 fe ff ff       	call   801c59 <fd2sockid>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 12                	js     801d99 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	ff 75 10             	pushl  0x10(%ebp)
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	50                   	push   %eax
  801d91:	e8 59 01 00 00       	call   801eef <nsipc_connect>
  801d96:	83 c4 10             	add    $0x10,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <listen>:
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	e8 b0 fe ff ff       	call   801c59 <fd2sockid>
  801da9:	85 c0                	test   %eax,%eax
  801dab:	78 0f                	js     801dbc <listen+0x21>
	return nsipc_listen(r, backlog);
  801dad:	83 ec 08             	sub    $0x8,%esp
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	50                   	push   %eax
  801db4:	e8 6b 01 00 00       	call   801f24 <nsipc_listen>
  801db9:	83 c4 10             	add    $0x10,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <socket>:

int
socket(int domain, int type, int protocol)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dc4:	ff 75 10             	pushl  0x10(%ebp)
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	e8 3e 02 00 00       	call   802010 <nsipc_socket>
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	78 05                	js     801dde <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801dd9:	e8 ab fe ff ff       	call   801c89 <alloc_sockfd>
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	53                   	push   %ebx
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801de9:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801df0:	74 26                	je     801e18 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801df2:	6a 07                	push   $0x7
  801df4:	68 00 60 80 00       	push   $0x806000
  801df9:	53                   	push   %ebx
  801dfa:	ff 35 04 40 80 00    	pushl  0x804004
  801e00:	e8 63 04 00 00       	call   802268 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e05:	83 c4 0c             	add    $0xc,%esp
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	e8 e2 03 00 00       	call   8021f5 <ipc_recv>
}
  801e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	6a 02                	push   $0x2
  801e1d:	e8 b2 04 00 00       	call   8022d4 <ipc_find_env>
  801e22:	a3 04 40 80 00       	mov    %eax,0x804004
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	eb c6                	jmp    801df2 <nsipc+0x12>

00801e2c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	56                   	push   %esi
  801e30:	53                   	push   %ebx
  801e31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e3c:	8b 06                	mov    (%esi),%eax
  801e3e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e43:	b8 01 00 00 00       	mov    $0x1,%eax
  801e48:	e8 93 ff ff ff       	call   801de0 <nsipc>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	79 09                	jns    801e5c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e53:	89 d8                	mov    %ebx,%eax
  801e55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	ff 35 10 60 80 00    	pushl  0x806010
  801e65:	68 00 60 80 00       	push   $0x806000
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	e8 fe ea ff ff       	call   800970 <memmove>
		*addrlen = ret->ret_addrlen;
  801e72:	a1 10 60 80 00       	mov    0x806010,%eax
  801e77:	89 06                	mov    %eax,(%esi)
  801e79:	83 c4 10             	add    $0x10,%esp
	return r;
  801e7c:	eb d5                	jmp    801e53 <nsipc_accept+0x27>

00801e7e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	53                   	push   %ebx
  801e82:	83 ec 08             	sub    $0x8,%esp
  801e85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e90:	53                   	push   %ebx
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	68 04 60 80 00       	push   $0x806004
  801e99:	e8 d2 ea ff ff       	call   800970 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e9e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ea4:	b8 02 00 00 00       	mov    $0x2,%eax
  801ea9:	e8 32 ff ff ff       	call   801de0 <nsipc>
}
  801eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ec9:	b8 03 00 00 00       	mov    $0x3,%eax
  801ece:	e8 0d ff ff ff       	call   801de0 <nsipc>
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <nsipc_close>:

int
nsipc_close(int s)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ee3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ee8:	e8 f3 fe ff ff       	call   801de0 <nsipc>
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	53                   	push   %ebx
  801ef3:	83 ec 08             	sub    $0x8,%esp
  801ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f01:	53                   	push   %ebx
  801f02:	ff 75 0c             	pushl  0xc(%ebp)
  801f05:	68 04 60 80 00       	push   $0x806004
  801f0a:	e8 61 ea ff ff       	call   800970 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f0f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f15:	b8 05 00 00 00       	mov    $0x5,%eax
  801f1a:	e8 c1 fe ff ff       	call   801de0 <nsipc>
}
  801f1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f35:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f3a:	b8 06 00 00 00       	mov    $0x6,%eax
  801f3f:	e8 9c fe ff ff       	call   801de0 <nsipc>
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	56                   	push   %esi
  801f4a:	53                   	push   %ebx
  801f4b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f56:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f64:	b8 07 00 00 00       	mov    $0x7,%eax
  801f69:	e8 72 fe ff ff       	call   801de0 <nsipc>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	85 c0                	test   %eax,%eax
  801f72:	78 1f                	js     801f93 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f74:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f79:	7f 21                	jg     801f9c <nsipc_recv+0x56>
  801f7b:	39 c6                	cmp    %eax,%esi
  801f7d:	7c 1d                	jl     801f9c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	50                   	push   %eax
  801f83:	68 00 60 80 00       	push   $0x806000
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	e8 e0 e9 ff ff       	call   800970 <memmove>
  801f90:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f93:	89 d8                	mov    %ebx,%eax
  801f95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f9c:	68 06 2a 80 00       	push   $0x802a06
  801fa1:	68 a8 29 80 00       	push   $0x8029a8
  801fa6:	6a 62                	push   $0x62
  801fa8:	68 1b 2a 80 00       	push   $0x802a1b
  801fad:	e8 fd 01 00 00       	call   8021af <_panic>

00801fb2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	53                   	push   %ebx
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fc4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fca:	7f 2e                	jg     801ffa <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	53                   	push   %ebx
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	68 0c 60 80 00       	push   $0x80600c
  801fd8:	e8 93 e9 ff ff       	call   800970 <memmove>
	nsipcbuf.send.req_size = size;
  801fdd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801feb:	b8 08 00 00 00       	mov    $0x8,%eax
  801ff0:	e8 eb fd ff ff       	call   801de0 <nsipc>
}
  801ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    
	assert(size < 1600);
  801ffa:	68 27 2a 80 00       	push   $0x802a27
  801fff:	68 a8 29 80 00       	push   $0x8029a8
  802004:	6a 6d                	push   $0x6d
  802006:	68 1b 2a 80 00       	push   $0x802a1b
  80200b:	e8 9f 01 00 00       	call   8021af <_panic>

00802010 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802026:	8b 45 10             	mov    0x10(%ebp),%eax
  802029:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80202e:	b8 09 00 00 00       	mov    $0x9,%eax
  802033:	e8 a8 fd ff ff       	call   801de0 <nsipc>
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	c3                   	ret    

00802040 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802046:	68 33 2a 80 00       	push   $0x802a33
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	e8 8f e7 ff ff       	call   8007e2 <strcpy>
	return 0;
}
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <devcons_write>:
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	57                   	push   %edi
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802066:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80206b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802071:	3b 75 10             	cmp    0x10(%ebp),%esi
  802074:	73 31                	jae    8020a7 <devcons_write+0x4d>
		m = n - tot;
  802076:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802079:	29 f3                	sub    %esi,%ebx
  80207b:	83 fb 7f             	cmp    $0x7f,%ebx
  80207e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802083:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	53                   	push   %ebx
  80208a:	89 f0                	mov    %esi,%eax
  80208c:	03 45 0c             	add    0xc(%ebp),%eax
  80208f:	50                   	push   %eax
  802090:	57                   	push   %edi
  802091:	e8 da e8 ff ff       	call   800970 <memmove>
		sys_cputs(buf, m);
  802096:	83 c4 08             	add    $0x8,%esp
  802099:	53                   	push   %ebx
  80209a:	57                   	push   %edi
  80209b:	e8 78 ea ff ff       	call   800b18 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a0:	01 de                	add    %ebx,%esi
  8020a2:	83 c4 10             	add    $0x10,%esp
  8020a5:	eb ca                	jmp    802071 <devcons_write+0x17>
}
  8020a7:	89 f0                	mov    %esi,%eax
  8020a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5f                   	pop    %edi
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    

008020b1 <devcons_read>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 08             	sub    $0x8,%esp
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c0:	74 21                	je     8020e3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020c2:	e8 6f ea ff ff       	call   800b36 <sys_cgetc>
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	75 07                	jne    8020d2 <devcons_read+0x21>
		sys_yield();
  8020cb:	e8 e5 ea ff ff       	call   800bb5 <sys_yield>
  8020d0:	eb f0                	jmp    8020c2 <devcons_read+0x11>
	if (c < 0)
  8020d2:	78 0f                	js     8020e3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020d4:	83 f8 04             	cmp    $0x4,%eax
  8020d7:	74 0c                	je     8020e5 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	88 02                	mov    %al,(%edx)
	return 1;
  8020de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    
		return 0;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ea:	eb f7                	jmp    8020e3 <devcons_read+0x32>

008020ec <cputchar>:
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020f8:	6a 01                	push   $0x1
  8020fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020fd:	50                   	push   %eax
  8020fe:	e8 15 ea ff ff       	call   800b18 <sys_cputs>
}
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <getchar>:
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80210e:	6a 01                	push   $0x1
  802110:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802113:	50                   	push   %eax
  802114:	6a 00                	push   $0x0
  802116:	e8 06 f1 ff ff       	call   801221 <read>
	if (r < 0)
  80211b:	83 c4 10             	add    $0x10,%esp
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 06                	js     802128 <getchar+0x20>
	if (r < 1)
  802122:	74 06                	je     80212a <getchar+0x22>
	return c;
  802124:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    
		return -E_EOF;
  80212a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80212f:	eb f7                	jmp    802128 <getchar+0x20>

00802131 <iscons>:
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802137:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213a:	50                   	push   %eax
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	e8 6e ee ff ff       	call   800fb1 <fd_lookup>
  802143:	83 c4 10             	add    $0x10,%esp
  802146:	85 c0                	test   %eax,%eax
  802148:	78 11                	js     80215b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802153:	39 10                	cmp    %edx,(%eax)
  802155:	0f 94 c0             	sete   %al
  802158:	0f b6 c0             	movzbl %al,%eax
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <opencons>:
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	e8 f3 ed ff ff       	call   800f5f <fd_alloc>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 3a                	js     8021ad <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	68 07 04 00 00       	push   $0x407
  80217b:	ff 75 f4             	pushl  -0xc(%ebp)
  80217e:	6a 00                	push   $0x0
  802180:	e8 4f ea ff ff       	call   800bd4 <sys_page_alloc>
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 21                	js     8021ad <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802195:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	50                   	push   %eax
  8021a5:	e8 8e ed ff ff       	call   800f38 <fd2num>
  8021aa:	83 c4 10             	add    $0x10,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8021b4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021b7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021bd:	e8 d4 e9 ff ff       	call   800b96 <sys_getenvid>
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	56                   	push   %esi
  8021cc:	50                   	push   %eax
  8021cd:	68 40 2a 80 00       	push   $0x802a40
  8021d2:	e8 2f e0 ff ff       	call   800206 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021d7:	83 c4 18             	add    $0x18,%esp
  8021da:	53                   	push   %ebx
  8021db:	ff 75 10             	pushl  0x10(%ebp)
  8021de:	e8 d2 df ff ff       	call   8001b5 <vcprintf>
	cprintf("\n");
  8021e3:	c7 04 24 b0 25 80 00 	movl   $0x8025b0,(%esp)
  8021ea:	e8 17 e0 ff ff       	call   800206 <cprintf>
  8021ef:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021f2:	cc                   	int3   
  8021f3:	eb fd                	jmp    8021f2 <_panic+0x43>

008021f5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	56                   	push   %esi
  8021f9:	53                   	push   %ebx
  8021fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8021fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802200:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802203:	85 c0                	test   %eax,%eax
  802205:	74 4f                	je     802256 <ipc_recv+0x61>
  802207:	83 ec 0c             	sub    $0xc,%esp
  80220a:	50                   	push   %eax
  80220b:	e8 74 eb ff ff       	call   800d84 <sys_ipc_recv>
  802210:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802213:	85 f6                	test   %esi,%esi
  802215:	74 14                	je     80222b <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802217:	ba 00 00 00 00       	mov    $0x0,%edx
  80221c:	85 c0                	test   %eax,%eax
  80221e:	75 09                	jne    802229 <ipc_recv+0x34>
  802220:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802226:	8b 52 74             	mov    0x74(%edx),%edx
  802229:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80222b:	85 db                	test   %ebx,%ebx
  80222d:	74 14                	je     802243 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
  802234:	85 c0                	test   %eax,%eax
  802236:	75 09                	jne    802241 <ipc_recv+0x4c>
  802238:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80223e:	8b 52 78             	mov    0x78(%edx),%edx
  802241:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802243:	85 c0                	test   %eax,%eax
  802245:	75 08                	jne    80224f <ipc_recv+0x5a>
  802247:	a1 08 40 80 00       	mov    0x804008,%eax
  80224c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80224f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802252:	5b                   	pop    %ebx
  802253:	5e                   	pop    %esi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802256:	83 ec 0c             	sub    $0xc,%esp
  802259:	68 00 00 c0 ee       	push   $0xeec00000
  80225e:	e8 21 eb ff ff       	call   800d84 <sys_ipc_recv>
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	eb ab                	jmp    802213 <ipc_recv+0x1e>

00802268 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	57                   	push   %edi
  80226c:	56                   	push   %esi
  80226d:	53                   	push   %ebx
  80226e:	83 ec 0c             	sub    $0xc,%esp
  802271:	8b 7d 08             	mov    0x8(%ebp),%edi
  802274:	8b 75 10             	mov    0x10(%ebp),%esi
  802277:	eb 20                	jmp    802299 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802279:	6a 00                	push   $0x0
  80227b:	68 00 00 c0 ee       	push   $0xeec00000
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	57                   	push   %edi
  802284:	e8 d8 ea ff ff       	call   800d61 <sys_ipc_try_send>
  802289:	89 c3                	mov    %eax,%ebx
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	eb 1f                	jmp    8022af <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802290:	e8 20 e9 ff ff       	call   800bb5 <sys_yield>
	while(retval != 0) {
  802295:	85 db                	test   %ebx,%ebx
  802297:	74 33                	je     8022cc <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802299:	85 f6                	test   %esi,%esi
  80229b:	74 dc                	je     802279 <ipc_send+0x11>
  80229d:	ff 75 14             	pushl  0x14(%ebp)
  8022a0:	56                   	push   %esi
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	57                   	push   %edi
  8022a5:	e8 b7 ea ff ff       	call   800d61 <sys_ipc_try_send>
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8022af:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8022b2:	74 dc                	je     802290 <ipc_send+0x28>
  8022b4:	85 db                	test   %ebx,%ebx
  8022b6:	74 d8                	je     802290 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	68 64 2a 80 00       	push   $0x802a64
  8022c0:	6a 35                	push   $0x35
  8022c2:	68 94 2a 80 00       	push   $0x802a94
  8022c7:	e8 e3 fe ff ff       	call   8021af <_panic>
	}
}
  8022cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022cf:	5b                   	pop    %ebx
  8022d0:	5e                   	pop    %esi
  8022d1:	5f                   	pop    %edi
  8022d2:	5d                   	pop    %ebp
  8022d3:	c3                   	ret    

008022d4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022df:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022e2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022e8:	8b 52 50             	mov    0x50(%edx),%edx
  8022eb:	39 ca                	cmp    %ecx,%edx
  8022ed:	74 11                	je     802300 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8022ef:	83 c0 01             	add    $0x1,%eax
  8022f2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022f7:	75 e6                	jne    8022df <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	eb 0b                	jmp    80230b <ipc_find_env+0x37>
			return envs[i].env_id;
  802300:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802303:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802308:	8b 40 48             	mov    0x48(%eax),%eax
}
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    

0080230d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802313:	89 d0                	mov    %edx,%eax
  802315:	c1 e8 16             	shr    $0x16,%eax
  802318:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802324:	f6 c1 01             	test   $0x1,%cl
  802327:	74 1d                	je     802346 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802329:	c1 ea 0c             	shr    $0xc,%edx
  80232c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802333:	f6 c2 01             	test   $0x1,%dl
  802336:	74 0e                	je     802346 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802338:	c1 ea 0c             	shr    $0xc,%edx
  80233b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802342:	ef 
  802343:	0f b7 c0             	movzwl %ax,%eax
}
  802346:	5d                   	pop    %ebp
  802347:	c3                   	ret    
  802348:	66 90                	xchg   %ax,%ax
  80234a:	66 90                	xchg   %ax,%ax
  80234c:	66 90                	xchg   %ax,%ax
  80234e:	66 90                	xchg   %ax,%ax

00802350 <__udivdi3>:
  802350:	f3 0f 1e fb          	endbr32 
  802354:	55                   	push   %ebp
  802355:	57                   	push   %edi
  802356:	56                   	push   %esi
  802357:	53                   	push   %ebx
  802358:	83 ec 1c             	sub    $0x1c,%esp
  80235b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80235f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802363:	8b 74 24 34          	mov    0x34(%esp),%esi
  802367:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80236b:	85 d2                	test   %edx,%edx
  80236d:	75 49                	jne    8023b8 <__udivdi3+0x68>
  80236f:	39 f3                	cmp    %esi,%ebx
  802371:	76 15                	jbe    802388 <__udivdi3+0x38>
  802373:	31 ff                	xor    %edi,%edi
  802375:	89 e8                	mov    %ebp,%eax
  802377:	89 f2                	mov    %esi,%edx
  802379:	f7 f3                	div    %ebx
  80237b:	89 fa                	mov    %edi,%edx
  80237d:	83 c4 1c             	add    $0x1c,%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5f                   	pop    %edi
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	89 d9                	mov    %ebx,%ecx
  80238a:	85 db                	test   %ebx,%ebx
  80238c:	75 0b                	jne    802399 <__udivdi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 c1                	mov    %eax,%ecx
  802399:	31 d2                	xor    %edx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	f7 f1                	div    %ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f7                	mov    %esi,%edi
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	77 1c                	ja     8023d8 <__udivdi3+0x88>
  8023bc:	0f bd fa             	bsr    %edx,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 2c                	jne    8023f0 <__udivdi3+0xa0>
  8023c4:	39 f2                	cmp    %esi,%edx
  8023c6:	72 06                	jb     8023ce <__udivdi3+0x7e>
  8023c8:	31 c0                	xor    %eax,%eax
  8023ca:	39 eb                	cmp    %ebp,%ebx
  8023cc:	77 ad                	ja     80237b <__udivdi3+0x2b>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb a6                	jmp    80237b <__udivdi3+0x2b>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	89 eb                	mov    %ebp,%ebx
  802421:	d3 e6                	shl    %cl,%esi
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 15                	jb     802450 <__udivdi3+0x100>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 04                	jae    802447 <__udivdi3+0xf7>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	74 09                	je     802450 <__udivdi3+0x100>
  802447:	89 d8                	mov    %ebx,%eax
  802449:	31 ff                	xor    %edi,%edi
  80244b:	e9 2b ff ff ff       	jmp    80237b <__udivdi3+0x2b>
  802450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802453:	31 ff                	xor    %edi,%edi
  802455:	e9 21 ff ff ff       	jmp    80237b <__udivdi3+0x2b>
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	f3 0f 1e fb          	endbr32 
  802464:	55                   	push   %ebp
  802465:	57                   	push   %edi
  802466:	56                   	push   %esi
  802467:	53                   	push   %ebx
  802468:	83 ec 1c             	sub    $0x1c,%esp
  80246b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80246f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802473:	8b 74 24 30          	mov    0x30(%esp),%esi
  802477:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80247b:	89 da                	mov    %ebx,%edx
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 3f                	jne    8024c0 <__umoddi3+0x60>
  802481:	39 df                	cmp    %ebx,%edi
  802483:	76 13                	jbe    802498 <__umoddi3+0x38>
  802485:	89 f0                	mov    %esi,%eax
  802487:	f7 f7                	div    %edi
  802489:	89 d0                	mov    %edx,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	83 c4 1c             	add    $0x1c,%esp
  802490:	5b                   	pop    %ebx
  802491:	5e                   	pop    %esi
  802492:	5f                   	pop    %edi
  802493:	5d                   	pop    %ebp
  802494:	c3                   	ret    
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	89 fd                	mov    %edi,%ebp
  80249a:	85 ff                	test   %edi,%edi
  80249c:	75 0b                	jne    8024a9 <__umoddi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f7                	div    %edi
  8024a7:	89 c5                	mov    %eax,%ebp
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f5                	div    %ebp
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	f7 f5                	div    %ebp
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	eb d4                	jmp    80248b <__umoddi3+0x2b>
  8024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	39 d8                	cmp    %ebx,%eax
  8024c4:	76 0a                	jbe    8024d0 <__umoddi3+0x70>
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	83 c4 1c             	add    $0x1c,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
  8024d0:	0f bd e8             	bsr    %eax,%ebp
  8024d3:	83 f5 1f             	xor    $0x1f,%ebp
  8024d6:	75 20                	jne    8024f8 <__umoddi3+0x98>
  8024d8:	39 d8                	cmp    %ebx,%eax
  8024da:	0f 82 b0 00 00 00    	jb     802590 <__umoddi3+0x130>
  8024e0:	39 f7                	cmp    %esi,%edi
  8024e2:	0f 86 a8 00 00 00    	jbe    802590 <__umoddi3+0x130>
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	83 c4 1c             	add    $0x1c,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ff:	29 ea                	sub    %ebp,%edx
  802501:	d3 e0                	shl    %cl,%eax
  802503:	89 44 24 08          	mov    %eax,0x8(%esp)
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 f8                	mov    %edi,%eax
  80250b:	d3 e8                	shr    %cl,%eax
  80250d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802511:	89 54 24 04          	mov    %edx,0x4(%esp)
  802515:	8b 54 24 04          	mov    0x4(%esp),%edx
  802519:	09 c1                	or     %eax,%ecx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e7                	shl    %cl,%edi
  802525:	89 d1                	mov    %edx,%ecx
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 c7                	mov    %eax,%edi
  802533:	89 d1                	mov    %edx,%ecx
  802535:	89 f0                	mov    %esi,%eax
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	d3 e6                	shl    %cl,%esi
  80253f:	09 d8                	or     %ebx,%eax
  802541:	f7 74 24 08          	divl   0x8(%esp)
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 f3                	mov    %esi,%ebx
  802549:	f7 64 24 0c          	mull   0xc(%esp)
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	89 d7                	mov    %edx,%edi
  802551:	39 d1                	cmp    %edx,%ecx
  802553:	72 06                	jb     80255b <__umoddi3+0xfb>
  802555:	75 10                	jne    802567 <__umoddi3+0x107>
  802557:	39 c3                	cmp    %eax,%ebx
  802559:	73 0c                	jae    802567 <__umoddi3+0x107>
  80255b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80255f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802563:	89 d7                	mov    %edx,%edi
  802565:	89 c6                	mov    %eax,%esi
  802567:	89 ca                	mov    %ecx,%edx
  802569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256e:	29 f3                	sub    %esi,%ebx
  802570:	19 fa                	sbb    %edi,%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	d3 e0                	shl    %cl,%eax
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	d3 eb                	shr    %cl,%ebx
  80257a:	d3 ea                	shr    %cl,%edx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 da                	mov    %ebx,%edx
  802592:	29 fe                	sub    %edi,%esi
  802594:	19 c2                	sbb    %eax,%edx
  802596:	89 f1                	mov    %esi,%ecx
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	e9 4b ff ff ff       	jmp    8024ea <__umoddi3+0x8a>
