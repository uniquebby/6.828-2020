
obj/user/forktree.debug：     文件格式 elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 26 0b 00 00       	call   800b68 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 60 27 80 00       	push   $0x802760
  80004c:	e8 87 01 00 00       	call   8001d8 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 f8 06 00 00       	call   80077b <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 71 27 80 00       	push   $0x802771
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 b5 06 00 00       	call   800761 <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 79 0e 00 00       	call   800f2d <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 60 00 00 00       	call   800129 <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 70 27 80 00       	push   $0x802770
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 75 0a 00 00       	call   800b68 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 b4 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012f:	e8 ff 11 00 00       	call   801333 <close_all>
	sys_env_destroy(0);
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	6a 00                	push   $0x0
  800139:	e8 e9 09 00 00       	call   800b27 <sys_env_destroy>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	53                   	push   %ebx
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014d:	8b 13                	mov    (%ebx),%edx
  80014f:	8d 42 01             	lea    0x1(%edx),%eax
  800152:	89 03                	mov    %eax,(%ebx)
  800154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800157:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800160:	74 09                	je     80016b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800162:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800169:	c9                   	leave  
  80016a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	68 ff 00 00 00       	push   $0xff
  800173:	8d 43 08             	lea    0x8(%ebx),%eax
  800176:	50                   	push   %eax
  800177:	e8 6e 09 00 00       	call   800aea <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	eb db                	jmp    800162 <putch+0x1f>

00800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800190:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800197:	00 00 00 
	b.cnt = 0;
  80019a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	68 43 01 80 00       	push   $0x800143
  8001b6:	e8 19 01 00 00       	call   8002d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bb:	83 c4 08             	add    $0x8,%esp
  8001be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 1a 09 00 00       	call   800aea <sys_cputs>

	return b.cnt;
}
  8001d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e1:	50                   	push   %eax
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	e8 9d ff ff ff       	call   800187 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	89 d6                	mov    %edx,%esi
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800202:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800208:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800210:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800213:	3b 45 10             	cmp    0x10(%ebp),%eax
  800216:	89 d0                	mov    %edx,%eax
  800218:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  80021b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80021e:	73 15                	jae    800235 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800220:	83 eb 01             	sub    $0x1,%ebx
  800223:	85 db                	test   %ebx,%ebx
  800225:	7e 43                	jle    80026a <printnum+0x7e>
			putch(padc, putdat);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	ff 75 18             	pushl  0x18(%ebp)
  80022e:	ff d7                	call   *%edi
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	eb eb                	jmp    800220 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 18             	pushl  0x18(%ebp)
  80023b:	8b 45 14             	mov    0x14(%ebp),%eax
  80023e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800241:	53                   	push   %ebx
  800242:	ff 75 10             	pushl  0x10(%ebp)
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024b:	ff 75 e0             	pushl  -0x20(%ebp)
  80024e:	ff 75 dc             	pushl  -0x24(%ebp)
  800251:	ff 75 d8             	pushl  -0x28(%ebp)
  800254:	e8 a7 22 00 00       	call   802500 <__udivdi3>
  800259:	83 c4 18             	add    $0x18,%esp
  80025c:	52                   	push   %edx
  80025d:	50                   	push   %eax
  80025e:	89 f2                	mov    %esi,%edx
  800260:	89 f8                	mov    %edi,%eax
  800262:	e8 85 ff ff ff       	call   8001ec <printnum>
  800267:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	ff 75 e0             	pushl  -0x20(%ebp)
  800277:	ff 75 dc             	pushl  -0x24(%ebp)
  80027a:	ff 75 d8             	pushl  -0x28(%ebp)
  80027d:	e8 8e 23 00 00       	call   802610 <__umoddi3>
  800282:	83 c4 14             	add    $0x14,%esp
  800285:	0f be 80 80 27 80 00 	movsbl 0x802780(%eax),%eax
  80028c:	50                   	push   %eax
  80028d:	ff d7                	call   *%edi
}
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800295:	5b                   	pop    %ebx
  800296:	5e                   	pop    %esi
  800297:	5f                   	pop    %edi
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    

0080029a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a4:	8b 10                	mov    (%eax),%edx
  8002a6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a9:	73 0a                	jae    8002b5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ae:	89 08                	mov    %ecx,(%eax)
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	88 02                	mov    %al,(%edx)
}
  8002b5:	5d                   	pop    %ebp
  8002b6:	c3                   	ret    

008002b7 <printfmt>:
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002bd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c0:	50                   	push   %eax
  8002c1:	ff 75 10             	pushl  0x10(%ebp)
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 05 00 00 00       	call   8002d4 <vprintfmt>
}
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    

008002d4 <vprintfmt>:
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	57                   	push   %edi
  8002d8:	56                   	push   %esi
  8002d9:	53                   	push   %ebx
  8002da:	83 ec 3c             	sub    $0x3c,%esp
  8002dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e6:	eb 0a                	jmp    8002f2 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	53                   	push   %ebx
  8002ec:	50                   	push   %eax
  8002ed:	ff d6                	call   *%esi
  8002ef:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002f2:	83 c7 01             	add    $0x1,%edi
  8002f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002f9:	83 f8 25             	cmp    $0x25,%eax
  8002fc:	74 0c                	je     80030a <vprintfmt+0x36>
			if (ch == '\0')
  8002fe:	85 c0                	test   %eax,%eax
  800300:	75 e6                	jne    8002e8 <vprintfmt+0x14>
}
  800302:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5f                   	pop    %edi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    
		padc = ' ';
  80030a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80030e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800315:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80031c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800323:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8d 47 01             	lea    0x1(%edi),%eax
  80032b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032e:	0f b6 17             	movzbl (%edi),%edx
  800331:	8d 42 dd             	lea    -0x23(%edx),%eax
  800334:	3c 55                	cmp    $0x55,%al
  800336:	0f 87 ba 03 00 00    	ja     8006f6 <vprintfmt+0x422>
  80033c:	0f b6 c0             	movzbl %al,%eax
  80033f:	ff 24 85 c0 28 80 00 	jmp    *0x8028c0(,%eax,4)
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800349:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80034d:	eb d9                	jmp    800328 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800352:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800356:	eb d0                	jmp    800328 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	0f b6 d2             	movzbl %dl,%edx
  80035b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80035e:	b8 00 00 00 00       	mov    $0x0,%eax
  800363:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800366:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800369:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800370:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800373:	83 f9 09             	cmp    $0x9,%ecx
  800376:	77 55                	ja     8003cd <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800378:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037b:	eb e9                	jmp    800366 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80037d:	8b 45 14             	mov    0x14(%ebp),%eax
  800380:	8b 00                	mov    (%eax),%eax
  800382:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8d 40 04             	lea    0x4(%eax),%eax
  80038b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800395:	79 91                	jns    800328 <vprintfmt+0x54>
				width = precision, precision = -1;
  800397:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a4:	eb 82                	jmp    800328 <vprintfmt+0x54>
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	0f 49 d0             	cmovns %eax,%edx
  8003b3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b9:	e9 6a ff ff ff       	jmp    800328 <vprintfmt+0x54>
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003c8:	e9 5b ff ff ff       	jmp    800328 <vprintfmt+0x54>
  8003cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d3:	eb bc                	jmp    800391 <vprintfmt+0xbd>
			lflag++;
  8003d5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003db:	e9 48 ff ff ff       	jmp    800328 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e3:	8d 78 04             	lea    0x4(%eax),%edi
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	53                   	push   %ebx
  8003ea:	ff 30                	pushl  (%eax)
  8003ec:	ff d6                	call   *%esi
			break;
  8003ee:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f4:	e9 9c 02 00 00       	jmp    800695 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 78 04             	lea    0x4(%eax),%edi
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	99                   	cltd   
  800402:	31 d0                	xor    %edx,%eax
  800404:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800406:	83 f8 0f             	cmp    $0xf,%eax
  800409:	7f 23                	jg     80042e <vprintfmt+0x15a>
  80040b:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  800412:	85 d2                	test   %edx,%edx
  800414:	74 18                	je     80042e <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800416:	52                   	push   %edx
  800417:	68 c6 2c 80 00       	push   $0x802cc6
  80041c:	53                   	push   %ebx
  80041d:	56                   	push   %esi
  80041e:	e8 94 fe ff ff       	call   8002b7 <printfmt>
  800423:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800426:	89 7d 14             	mov    %edi,0x14(%ebp)
  800429:	e9 67 02 00 00       	jmp    800695 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80042e:	50                   	push   %eax
  80042f:	68 98 27 80 00       	push   $0x802798
  800434:	53                   	push   %ebx
  800435:	56                   	push   %esi
  800436:	e8 7c fe ff ff       	call   8002b7 <printfmt>
  80043b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800441:	e9 4f 02 00 00       	jmp    800695 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	83 c0 04             	add    $0x4,%eax
  80044c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800454:	85 d2                	test   %edx,%edx
  800456:	b8 91 27 80 00       	mov    $0x802791,%eax
  80045b:	0f 45 c2             	cmovne %edx,%eax
  80045e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800461:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800465:	7e 06                	jle    80046d <vprintfmt+0x199>
  800467:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80046b:	75 0d                	jne    80047a <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800470:	89 c7                	mov    %eax,%edi
  800472:	03 45 e0             	add    -0x20(%ebp),%eax
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800478:	eb 3f                	jmp    8004b9 <vprintfmt+0x1e5>
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 d8             	pushl  -0x28(%ebp)
  800480:	50                   	push   %eax
  800481:	e8 0d 03 00 00       	call   800793 <strnlen>
  800486:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800489:	29 c2                	sub    %eax,%edx
  80048b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800493:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800497:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80049a:	85 ff                	test   %edi,%edi
  80049c:	7e 58                	jle    8004f6 <vprintfmt+0x222>
					putch(padc, putdat);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	53                   	push   %ebx
  8004a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a7:	83 ef 01             	sub    $0x1,%edi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	eb eb                	jmp    80049a <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	53                   	push   %ebx
  8004b3:	52                   	push   %edx
  8004b4:	ff d6                	call   *%esi
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004bc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004be:	83 c7 01             	add    $0x1,%edi
  8004c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004c5:	0f be d0             	movsbl %al,%edx
  8004c8:	85 d2                	test   %edx,%edx
  8004ca:	74 45                	je     800511 <vprintfmt+0x23d>
  8004cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d0:	78 06                	js     8004d8 <vprintfmt+0x204>
  8004d2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004d6:	78 35                	js     80050d <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004dc:	74 d1                	je     8004af <vprintfmt+0x1db>
  8004de:	0f be c0             	movsbl %al,%eax
  8004e1:	83 e8 20             	sub    $0x20,%eax
  8004e4:	83 f8 5e             	cmp    $0x5e,%eax
  8004e7:	76 c6                	jbe    8004af <vprintfmt+0x1db>
					putch('?', putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	53                   	push   %ebx
  8004ed:	6a 3f                	push   $0x3f
  8004ef:	ff d6                	call   *%esi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	eb c3                	jmp    8004b9 <vprintfmt+0x1e5>
  8004f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f9:	85 d2                	test   %edx,%edx
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	0f 49 c2             	cmovns %edx,%eax
  800503:	29 c2                	sub    %eax,%edx
  800505:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800508:	e9 60 ff ff ff       	jmp    80046d <vprintfmt+0x199>
  80050d:	89 cf                	mov    %ecx,%edi
  80050f:	eb 02                	jmp    800513 <vprintfmt+0x23f>
  800511:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800513:	85 ff                	test   %edi,%edi
  800515:	7e 10                	jle    800527 <vprintfmt+0x253>
				putch(' ', putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	53                   	push   %ebx
  80051b:	6a 20                	push   $0x20
  80051d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051f:	83 ef 01             	sub    $0x1,%edi
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	eb ec                	jmp    800513 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800527:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	e9 63 01 00 00       	jmp    800695 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800532:	83 f9 01             	cmp    $0x1,%ecx
  800535:	7f 1b                	jg     800552 <vprintfmt+0x27e>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	74 63                	je     80059e <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	99                   	cltd   
  800544:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 04             	lea    0x4(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	eb 17                	jmp    800569 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8b 50 04             	mov    0x4(%eax),%edx
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 40 08             	lea    0x8(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800569:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800574:	85 c9                	test   %ecx,%ecx
  800576:	0f 89 ff 00 00 00    	jns    80067b <vprintfmt+0x3a7>
				putch('-', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 2d                	push   $0x2d
  800582:	ff d6                	call   *%esi
				num = -(long long) num;
  800584:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800587:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80058a:	f7 da                	neg    %edx
  80058c:	83 d1 00             	adc    $0x0,%ecx
  80058f:	f7 d9                	neg    %ecx
  800591:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800594:	b8 0a 00 00 00       	mov    $0xa,%eax
  800599:	e9 dd 00 00 00       	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a6:	99                   	cltd   
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 04             	lea    0x4(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	eb b4                	jmp    800569 <vprintfmt+0x295>
	if (lflag >= 2)
  8005b5:	83 f9 01             	cmp    $0x1,%ecx
  8005b8:	7f 1e                	jg     8005d8 <vprintfmt+0x304>
	else if (lflag)
  8005ba:	85 c9                	test   %ecx,%ecx
  8005bc:	74 32                	je     8005f0 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c8:	8d 40 04             	lea    0x4(%eax),%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d3:	e9 a3 00 00 00       	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 10                	mov    (%eax),%edx
  8005dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e0:	8d 40 08             	lea    0x8(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005eb:	e9 8b 00 00 00       	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
  800605:	eb 74                	jmp    80067b <vprintfmt+0x3a7>
	if (lflag >= 2)
  800607:	83 f9 01             	cmp    $0x1,%ecx
  80060a:	7f 1b                	jg     800627 <vprintfmt+0x353>
	else if (lflag)
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	74 2c                	je     80063c <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800620:	b8 08 00 00 00       	mov    $0x8,%eax
  800625:	eb 54                	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 10                	mov    (%eax),%edx
  80062c:	8b 48 04             	mov    0x4(%eax),%ecx
  80062f:	8d 40 08             	lea    0x8(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800635:	b8 08 00 00 00       	mov    $0x8,%eax
  80063a:	eb 3f                	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 10                	mov    (%eax),%edx
  800641:	b9 00 00 00 00       	mov    $0x0,%ecx
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064c:	b8 08 00 00 00       	mov    $0x8,%eax
  800651:	eb 28                	jmp    80067b <vprintfmt+0x3a7>
			putch('0', putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	53                   	push   %ebx
  800657:	6a 30                	push   $0x30
  800659:	ff d6                	call   *%esi
			putch('x', putdat);
  80065b:	83 c4 08             	add    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 78                	push   $0x78
  800661:	ff d6                	call   *%esi
			num = (unsigned long long)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 10                	mov    (%eax),%edx
  800668:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80066d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800682:	57                   	push   %edi
  800683:	ff 75 e0             	pushl  -0x20(%ebp)
  800686:	50                   	push   %eax
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	89 da                	mov    %ebx,%edx
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	e8 5a fb ff ff       	call   8001ec <printnum>
			break;
  800692:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800695:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800698:	e9 55 fc ff ff       	jmp    8002f2 <vprintfmt+0x1e>
	if (lflag >= 2)
  80069d:	83 f9 01             	cmp    $0x1,%ecx
  8006a0:	7f 1b                	jg     8006bd <vprintfmt+0x3e9>
	else if (lflag)
  8006a2:	85 c9                	test   %ecx,%ecx
  8006a4:	74 2c                	je     8006d2 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bb:	eb be                	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c5:	8d 40 08             	lea    0x8(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d0:	eb a9                	jmp    80067b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 10                	mov    (%eax),%edx
  8006d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e7:	eb 92                	jmp    80067b <vprintfmt+0x3a7>
			putch(ch, putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	6a 25                	push   $0x25
  8006ef:	ff d6                	call   *%esi
			break;
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb 9f                	jmp    800695 <vprintfmt+0x3c1>
			putch('%', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 25                	push   $0x25
  8006fc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	89 f8                	mov    %edi,%eax
  800703:	eb 03                	jmp    800708 <vprintfmt+0x434>
  800705:	83 e8 01             	sub    $0x1,%eax
  800708:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80070c:	75 f7                	jne    800705 <vprintfmt+0x431>
  80070e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800711:	eb 82                	jmp    800695 <vprintfmt+0x3c1>

00800713 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	83 ec 18             	sub    $0x18,%esp
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80071f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800722:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800726:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800730:	85 c0                	test   %eax,%eax
  800732:	74 26                	je     80075a <vsnprintf+0x47>
  800734:	85 d2                	test   %edx,%edx
  800736:	7e 22                	jle    80075a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800738:	ff 75 14             	pushl  0x14(%ebp)
  80073b:	ff 75 10             	pushl  0x10(%ebp)
  80073e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800741:	50                   	push   %eax
  800742:	68 9a 02 80 00       	push   $0x80029a
  800747:	e8 88 fb ff ff       	call   8002d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80074c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800755:	83 c4 10             	add    $0x10,%esp
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    
		return -E_INVAL;
  80075a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075f:	eb f7                	jmp    800758 <vsnprintf+0x45>

00800761 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800767:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80076a:	50                   	push   %eax
  80076b:	ff 75 10             	pushl  0x10(%ebp)
  80076e:	ff 75 0c             	pushl  0xc(%ebp)
  800771:	ff 75 08             	pushl  0x8(%ebp)
  800774:	e8 9a ff ff ff       	call   800713 <vsnprintf>
	va_end(ap);

	return rc;
}
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800781:	b8 00 00 00 00       	mov    $0x0,%eax
  800786:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80078a:	74 05                	je     800791 <strlen+0x16>
		n++;
  80078c:	83 c0 01             	add    $0x1,%eax
  80078f:	eb f5                	jmp    800786 <strlen+0xb>
	return n;
}
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800799:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 0d                	je     8007b2 <strnlen+0x1f>
  8007a5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007a9:	74 05                	je     8007b0 <strnlen+0x1d>
		n++;
  8007ab:	83 c2 01             	add    $0x1,%edx
  8007ae:	eb f1                	jmp    8007a1 <strnlen+0xe>
  8007b0:	89 d0                	mov    %edx,%eax
	return n;
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	53                   	push   %ebx
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007be:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007c7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007ca:	83 c2 01             	add    $0x1,%edx
  8007cd:	84 c9                	test   %cl,%cl
  8007cf:	75 f2                	jne    8007c3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007d1:	5b                   	pop    %ebx
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	53                   	push   %ebx
  8007d8:	83 ec 10             	sub    $0x10,%esp
  8007db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007de:	53                   	push   %ebx
  8007df:	e8 97 ff ff ff       	call   80077b <strlen>
  8007e4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	01 d8                	add    %ebx,%eax
  8007ec:	50                   	push   %eax
  8007ed:	e8 c2 ff ff ff       	call   8007b4 <strcpy>
	return dst;
}
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    

008007f9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	56                   	push   %esi
  8007fd:	53                   	push   %ebx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800804:	89 c6                	mov    %eax,%esi
  800806:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800809:	89 c2                	mov    %eax,%edx
  80080b:	39 f2                	cmp    %esi,%edx
  80080d:	74 11                	je     800820 <strncpy+0x27>
		*dst++ = *src;
  80080f:	83 c2 01             	add    $0x1,%edx
  800812:	0f b6 19             	movzbl (%ecx),%ebx
  800815:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800818:	80 fb 01             	cmp    $0x1,%bl
  80081b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80081e:	eb eb                	jmp    80080b <strncpy+0x12>
	}
	return ret;
}
  800820:	5b                   	pop    %ebx
  800821:	5e                   	pop    %esi
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	56                   	push   %esi
  800828:	53                   	push   %ebx
  800829:	8b 75 08             	mov    0x8(%ebp),%esi
  80082c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082f:	8b 55 10             	mov    0x10(%ebp),%edx
  800832:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800834:	85 d2                	test   %edx,%edx
  800836:	74 21                	je     800859 <strlcpy+0x35>
  800838:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80083c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80083e:	39 c2                	cmp    %eax,%edx
  800840:	74 14                	je     800856 <strlcpy+0x32>
  800842:	0f b6 19             	movzbl (%ecx),%ebx
  800845:	84 db                	test   %bl,%bl
  800847:	74 0b                	je     800854 <strlcpy+0x30>
			*dst++ = *src++;
  800849:	83 c1 01             	add    $0x1,%ecx
  80084c:	83 c2 01             	add    $0x1,%edx
  80084f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800852:	eb ea                	jmp    80083e <strlcpy+0x1a>
  800854:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800856:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800859:	29 f0                	sub    %esi,%eax
}
  80085b:	5b                   	pop    %ebx
  80085c:	5e                   	pop    %esi
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800865:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800868:	0f b6 01             	movzbl (%ecx),%eax
  80086b:	84 c0                	test   %al,%al
  80086d:	74 0c                	je     80087b <strcmp+0x1c>
  80086f:	3a 02                	cmp    (%edx),%al
  800871:	75 08                	jne    80087b <strcmp+0x1c>
		p++, q++;
  800873:	83 c1 01             	add    $0x1,%ecx
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	eb ed                	jmp    800868 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80087b:	0f b6 c0             	movzbl %al,%eax
  80087e:	0f b6 12             	movzbl (%edx),%edx
  800881:	29 d0                	sub    %edx,%eax
}
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088f:	89 c3                	mov    %eax,%ebx
  800891:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800894:	eb 06                	jmp    80089c <strncmp+0x17>
		n--, p++, q++;
  800896:	83 c0 01             	add    $0x1,%eax
  800899:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80089c:	39 d8                	cmp    %ebx,%eax
  80089e:	74 16                	je     8008b6 <strncmp+0x31>
  8008a0:	0f b6 08             	movzbl (%eax),%ecx
  8008a3:	84 c9                	test   %cl,%cl
  8008a5:	74 04                	je     8008ab <strncmp+0x26>
  8008a7:	3a 0a                	cmp    (%edx),%cl
  8008a9:	74 eb                	je     800896 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ab:	0f b6 00             	movzbl (%eax),%eax
  8008ae:	0f b6 12             	movzbl (%edx),%edx
  8008b1:	29 d0                	sub    %edx,%eax
}
  8008b3:	5b                   	pop    %ebx
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    
		return 0;
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb f6                	jmp    8008b3 <strncmp+0x2e>

008008bd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c7:	0f b6 10             	movzbl (%eax),%edx
  8008ca:	84 d2                	test   %dl,%dl
  8008cc:	74 09                	je     8008d7 <strchr+0x1a>
		if (*s == c)
  8008ce:	38 ca                	cmp    %cl,%dl
  8008d0:	74 0a                	je     8008dc <strchr+0x1f>
	for (; *s; s++)
  8008d2:	83 c0 01             	add    $0x1,%eax
  8008d5:	eb f0                	jmp    8008c7 <strchr+0xa>
			return (char *) s;
	return 0;
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008eb:	38 ca                	cmp    %cl,%dl
  8008ed:	74 09                	je     8008f8 <strfind+0x1a>
  8008ef:	84 d2                	test   %dl,%dl
  8008f1:	74 05                	je     8008f8 <strfind+0x1a>
	for (; *s; s++)
  8008f3:	83 c0 01             	add    $0x1,%eax
  8008f6:	eb f0                	jmp    8008e8 <strfind+0xa>
			break;
	return (char *) s;
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	57                   	push   %edi
  8008fe:	56                   	push   %esi
  8008ff:	53                   	push   %ebx
  800900:	8b 7d 08             	mov    0x8(%ebp),%edi
  800903:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800906:	85 c9                	test   %ecx,%ecx
  800908:	74 31                	je     80093b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80090a:	89 f8                	mov    %edi,%eax
  80090c:	09 c8                	or     %ecx,%eax
  80090e:	a8 03                	test   $0x3,%al
  800910:	75 23                	jne    800935 <memset+0x3b>
		c &= 0xFF;
  800912:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800916:	89 d3                	mov    %edx,%ebx
  800918:	c1 e3 08             	shl    $0x8,%ebx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	c1 e0 18             	shl    $0x18,%eax
  800920:	89 d6                	mov    %edx,%esi
  800922:	c1 e6 10             	shl    $0x10,%esi
  800925:	09 f0                	or     %esi,%eax
  800927:	09 c2                	or     %eax,%edx
  800929:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80092b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80092e:	89 d0                	mov    %edx,%eax
  800930:	fc                   	cld    
  800931:	f3 ab                	rep stos %eax,%es:(%edi)
  800933:	eb 06                	jmp    80093b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800935:	8b 45 0c             	mov    0xc(%ebp),%eax
  800938:	fc                   	cld    
  800939:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80093b:	89 f8                	mov    %edi,%eax
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5f                   	pop    %edi
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	57                   	push   %edi
  800946:	56                   	push   %esi
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80094d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800950:	39 c6                	cmp    %eax,%esi
  800952:	73 32                	jae    800986 <memmove+0x44>
  800954:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800957:	39 c2                	cmp    %eax,%edx
  800959:	76 2b                	jbe    800986 <memmove+0x44>
		s += n;
		d += n;
  80095b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095e:	89 fe                	mov    %edi,%esi
  800960:	09 ce                	or     %ecx,%esi
  800962:	09 d6                	or     %edx,%esi
  800964:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80096a:	75 0e                	jne    80097a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80096c:	83 ef 04             	sub    $0x4,%edi
  80096f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800972:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800975:	fd                   	std    
  800976:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800978:	eb 09                	jmp    800983 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80097a:	83 ef 01             	sub    $0x1,%edi
  80097d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800980:	fd                   	std    
  800981:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800983:	fc                   	cld    
  800984:	eb 1a                	jmp    8009a0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800986:	89 c2                	mov    %eax,%edx
  800988:	09 ca                	or     %ecx,%edx
  80098a:	09 f2                	or     %esi,%edx
  80098c:	f6 c2 03             	test   $0x3,%dl
  80098f:	75 0a                	jne    80099b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800991:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800994:	89 c7                	mov    %eax,%edi
  800996:	fc                   	cld    
  800997:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800999:	eb 05                	jmp    8009a0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80099b:	89 c7                	mov    %eax,%edi
  80099d:	fc                   	cld    
  80099e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a0:	5e                   	pop    %esi
  8009a1:	5f                   	pop    %edi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009aa:	ff 75 10             	pushl  0x10(%ebp)
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	e8 8a ff ff ff       	call   800942 <memmove>
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	56                   	push   %esi
  8009be:	53                   	push   %ebx
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c5:	89 c6                	mov    %eax,%esi
  8009c7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ca:	39 f0                	cmp    %esi,%eax
  8009cc:	74 1c                	je     8009ea <memcmp+0x30>
		if (*s1 != *s2)
  8009ce:	0f b6 08             	movzbl (%eax),%ecx
  8009d1:	0f b6 1a             	movzbl (%edx),%ebx
  8009d4:	38 d9                	cmp    %bl,%cl
  8009d6:	75 08                	jne    8009e0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d8:	83 c0 01             	add    $0x1,%eax
  8009db:	83 c2 01             	add    $0x1,%edx
  8009de:	eb ea                	jmp    8009ca <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009e0:	0f b6 c1             	movzbl %cl,%eax
  8009e3:	0f b6 db             	movzbl %bl,%ebx
  8009e6:	29 d8                	sub    %ebx,%eax
  8009e8:	eb 05                	jmp    8009ef <memcmp+0x35>
	}

	return 0;
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009fc:	89 c2                	mov    %eax,%edx
  8009fe:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a01:	39 d0                	cmp    %edx,%eax
  800a03:	73 09                	jae    800a0e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a05:	38 08                	cmp    %cl,(%eax)
  800a07:	74 05                	je     800a0e <memfind+0x1b>
	for (; s < ends; s++)
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	eb f3                	jmp    800a01 <memfind+0xe>
			break;
	return (void *) s;
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	57                   	push   %edi
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a19:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a1c:	eb 03                	jmp    800a21 <strtol+0x11>
		s++;
  800a1e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a21:	0f b6 01             	movzbl (%ecx),%eax
  800a24:	3c 20                	cmp    $0x20,%al
  800a26:	74 f6                	je     800a1e <strtol+0xe>
  800a28:	3c 09                	cmp    $0x9,%al
  800a2a:	74 f2                	je     800a1e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a2c:	3c 2b                	cmp    $0x2b,%al
  800a2e:	74 2a                	je     800a5a <strtol+0x4a>
	int neg = 0;
  800a30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a35:	3c 2d                	cmp    $0x2d,%al
  800a37:	74 2b                	je     800a64 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a39:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a3f:	75 0f                	jne    800a50 <strtol+0x40>
  800a41:	80 39 30             	cmpb   $0x30,(%ecx)
  800a44:	74 28                	je     800a6e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a46:	85 db                	test   %ebx,%ebx
  800a48:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a4d:	0f 44 d8             	cmove  %eax,%ebx
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a58:	eb 50                	jmp    800aaa <strtol+0x9a>
		s++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a5d:	bf 00 00 00 00       	mov    $0x0,%edi
  800a62:	eb d5                	jmp    800a39 <strtol+0x29>
		s++, neg = 1;
  800a64:	83 c1 01             	add    $0x1,%ecx
  800a67:	bf 01 00 00 00       	mov    $0x1,%edi
  800a6c:	eb cb                	jmp    800a39 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a72:	74 0e                	je     800a82 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a74:	85 db                	test   %ebx,%ebx
  800a76:	75 d8                	jne    800a50 <strtol+0x40>
		s++, base = 8;
  800a78:	83 c1 01             	add    $0x1,%ecx
  800a7b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a80:	eb ce                	jmp    800a50 <strtol+0x40>
		s += 2, base = 16;
  800a82:	83 c1 02             	add    $0x2,%ecx
  800a85:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a8a:	eb c4                	jmp    800a50 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a8c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a8f:	89 f3                	mov    %esi,%ebx
  800a91:	80 fb 19             	cmp    $0x19,%bl
  800a94:	77 29                	ja     800abf <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a96:	0f be d2             	movsbl %dl,%edx
  800a99:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a9c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a9f:	7d 30                	jge    800ad1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800aa1:	83 c1 01             	add    $0x1,%ecx
  800aa4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aaa:	0f b6 11             	movzbl (%ecx),%edx
  800aad:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ab0:	89 f3                	mov    %esi,%ebx
  800ab2:	80 fb 09             	cmp    $0x9,%bl
  800ab5:	77 d5                	ja     800a8c <strtol+0x7c>
			dig = *s - '0';
  800ab7:	0f be d2             	movsbl %dl,%edx
  800aba:	83 ea 30             	sub    $0x30,%edx
  800abd:	eb dd                	jmp    800a9c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800abf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac2:	89 f3                	mov    %esi,%ebx
  800ac4:	80 fb 19             	cmp    $0x19,%bl
  800ac7:	77 08                	ja     800ad1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ac9:	0f be d2             	movsbl %dl,%edx
  800acc:	83 ea 37             	sub    $0x37,%edx
  800acf:	eb cb                	jmp    800a9c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad5:	74 05                	je     800adc <strtol+0xcc>
		*endptr = (char *) s;
  800ad7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ada:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800adc:	89 c2                	mov    %eax,%edx
  800ade:	f7 da                	neg    %edx
  800ae0:	85 ff                	test   %edi,%edi
  800ae2:	0f 45 c2             	cmovne %edx,%eax
}
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5f                   	pop    %edi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	57                   	push   %edi
  800aee:	56                   	push   %esi
  800aef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af0:	b8 00 00 00 00       	mov    $0x0,%eax
  800af5:	8b 55 08             	mov    0x8(%ebp),%edx
  800af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afb:	89 c3                	mov    %eax,%ebx
  800afd:	89 c7                	mov    %eax,%edi
  800aff:	89 c6                	mov    %eax,%esi
  800b01:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	57                   	push   %edi
  800b0c:	56                   	push   %esi
  800b0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b13:	b8 01 00 00 00       	mov    $0x1,%eax
  800b18:	89 d1                	mov    %edx,%ecx
  800b1a:	89 d3                	mov    %edx,%ebx
  800b1c:	89 d7                	mov    %edx,%edi
  800b1e:	89 d6                	mov    %edx,%esi
  800b20:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b35:	8b 55 08             	mov    0x8(%ebp),%edx
  800b38:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3d:	89 cb                	mov    %ecx,%ebx
  800b3f:	89 cf                	mov    %ecx,%edi
  800b41:	89 ce                	mov    %ecx,%esi
  800b43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b45:	85 c0                	test   %eax,%eax
  800b47:	7f 08                	jg     800b51 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5f                   	pop    %edi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	6a 03                	push   $0x3
  800b57:	68 7f 2a 80 00       	push   $0x802a7f
  800b5c:	6a 23                	push   $0x23
  800b5e:	68 9c 2a 80 00       	push   $0x802a9c
  800b63:	e8 56 17 00 00       	call   8022be <_panic>

00800b68 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b73:	b8 02 00 00 00       	mov    $0x2,%eax
  800b78:	89 d1                	mov    %edx,%ecx
  800b7a:	89 d3                	mov    %edx,%ebx
  800b7c:	89 d7                	mov    %edx,%edi
  800b7e:	89 d6                	mov    %edx,%esi
  800b80:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <sys_yield>:

void
sys_yield(void)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b97:	89 d1                	mov    %edx,%ecx
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	89 d7                	mov    %edx,%edi
  800b9d:	89 d6                	mov    %edx,%esi
  800b9f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
  800bac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800baf:	be 00 00 00 00       	mov    $0x0,%esi
  800bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bba:	b8 04 00 00 00       	mov    $0x4,%eax
  800bbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc2:	89 f7                	mov    %esi,%edi
  800bc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc6:	85 c0                	test   %eax,%eax
  800bc8:	7f 08                	jg     800bd2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	50                   	push   %eax
  800bd6:	6a 04                	push   $0x4
  800bd8:	68 7f 2a 80 00       	push   $0x802a7f
  800bdd:	6a 23                	push   $0x23
  800bdf:	68 9c 2a 80 00       	push   $0x802a9c
  800be4:	e8 d5 16 00 00       	call   8022be <_panic>

00800be9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf8:	b8 05 00 00 00       	mov    $0x5,%eax
  800bfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c00:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c03:	8b 75 18             	mov    0x18(%ebp),%esi
  800c06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	7f 08                	jg     800c14 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c14:	83 ec 0c             	sub    $0xc,%esp
  800c17:	50                   	push   %eax
  800c18:	6a 05                	push   $0x5
  800c1a:	68 7f 2a 80 00       	push   $0x802a7f
  800c1f:	6a 23                	push   $0x23
  800c21:	68 9c 2a 80 00       	push   $0x802a9c
  800c26:	e8 93 16 00 00       	call   8022be <_panic>

00800c2b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3f:	b8 06 00 00 00       	mov    $0x6,%eax
  800c44:	89 df                	mov    %ebx,%edi
  800c46:	89 de                	mov    %ebx,%esi
  800c48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	7f 08                	jg     800c56 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	6a 06                	push   $0x6
  800c5c:	68 7f 2a 80 00       	push   $0x802a7f
  800c61:	6a 23                	push   $0x23
  800c63:	68 9c 2a 80 00       	push   $0x802a9c
  800c68:	e8 51 16 00 00       	call   8022be <_panic>

00800c6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	b8 08 00 00 00       	mov    $0x8,%eax
  800c86:	89 df                	mov    %ebx,%edi
  800c88:	89 de                	mov    %ebx,%esi
  800c8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	7f 08                	jg     800c98 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	50                   	push   %eax
  800c9c:	6a 08                	push   $0x8
  800c9e:	68 7f 2a 80 00       	push   $0x802a7f
  800ca3:	6a 23                	push   $0x23
  800ca5:	68 9c 2a 80 00       	push   $0x802a9c
  800caa:	e8 0f 16 00 00       	call   8022be <_panic>

00800caf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc3:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc8:	89 df                	mov    %ebx,%edi
  800cca:	89 de                	mov    %ebx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 09                	push   $0x9
  800ce0:	68 7f 2a 80 00       	push   $0x802a7f
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 9c 2a 80 00       	push   $0x802a9c
  800cec:	e8 cd 15 00 00       	call   8022be <_panic>

00800cf1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
  800cf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0a:	89 df                	mov    %ebx,%edi
  800d0c:	89 de                	mov    %ebx,%esi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 0a                	push   $0xa
  800d22:	68 7f 2a 80 00       	push   $0x802a7f
  800d27:	6a 23                	push   $0x23
  800d29:	68 9c 2a 80 00       	push   $0x802a9c
  800d2e:	e8 8b 15 00 00       	call   8022be <_panic>

00800d33 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d44:	be 00 00 00 00       	mov    $0x0,%esi
  800d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
  800d5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d6c:	89 cb                	mov    %ecx,%ebx
  800d6e:	89 cf                	mov    %ecx,%edi
  800d70:	89 ce                	mov    %ecx,%esi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 0d                	push   $0xd
  800d86:	68 7f 2a 80 00       	push   $0x802a7f
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 9c 2a 80 00       	push   $0x802a9c
  800d92:	e8 27 15 00 00       	call   8022be <_panic>

00800d97 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800da2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800da7:	89 d1                	mov    %edx,%ecx
  800da9:	89 d3                	mov    %edx,%ebx
  800dab:	89 d7                	mov    %edx,%edi
  800dad:	89 d6                	mov    %edx,%esi
  800daf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800dc2:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800dc4:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800dc7:	89 d9                	mov    %ebx,%ecx
  800dc9:	c1 e9 16             	shr    $0x16,%ecx
  800dcc:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800dd3:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800dd8:	f6 c1 01             	test   $0x1,%cl
  800ddb:	74 0c                	je     800de9 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800ddd:	89 d9                	mov    %ebx,%ecx
  800ddf:	c1 e9 0c             	shr    $0xc,%ecx
  800de2:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800de9:	f6 c2 02             	test   $0x2,%dl
  800dec:	0f 84 a3 00 00 00    	je     800e95 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800df2:	89 da                	mov    %ebx,%edx
  800df4:	c1 ea 0c             	shr    $0xc,%edx
  800df7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dfe:	f6 c6 08             	test   $0x8,%dh
  800e01:	0f 84 b7 00 00 00    	je     800ebe <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800e07:	e8 5c fd ff ff       	call   800b68 <sys_getenvid>
  800e0c:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	6a 07                	push   $0x7
  800e13:	68 00 f0 7f 00       	push   $0x7ff000
  800e18:	50                   	push   %eax
  800e19:	e8 88 fd ff ff       	call   800ba6 <sys_page_alloc>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	85 c0                	test   %eax,%eax
  800e23:	0f 88 bc 00 00 00    	js     800ee5 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800e29:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800e2f:	83 ec 04             	sub    $0x4,%esp
  800e32:	68 00 10 00 00       	push   $0x1000
  800e37:	53                   	push   %ebx
  800e38:	68 00 f0 7f 00       	push   $0x7ff000
  800e3d:	e8 00 fb ff ff       	call   800942 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800e42:	83 c4 08             	add    $0x8,%esp
  800e45:	53                   	push   %ebx
  800e46:	56                   	push   %esi
  800e47:	e8 df fd ff ff       	call   800c2b <sys_page_unmap>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	0f 88 a0 00 00 00    	js     800ef7 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800e57:	83 ec 0c             	sub    $0xc,%esp
  800e5a:	6a 07                	push   $0x7
  800e5c:	53                   	push   %ebx
  800e5d:	56                   	push   %esi
  800e5e:	68 00 f0 7f 00       	push   $0x7ff000
  800e63:	56                   	push   %esi
  800e64:	e8 80 fd ff ff       	call   800be9 <sys_page_map>
  800e69:	83 c4 20             	add    $0x20,%esp
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	0f 88 95 00 00 00    	js     800f09 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	68 00 f0 7f 00       	push   $0x7ff000
  800e7c:	56                   	push   %esi
  800e7d:	e8 a9 fd ff ff       	call   800c2b <sys_page_unmap>
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	85 c0                	test   %eax,%eax
  800e87:	0f 88 8e 00 00 00    	js     800f1b <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800e95:	8b 70 28             	mov    0x28(%eax),%esi
  800e98:	e8 cb fc ff ff       	call   800b68 <sys_getenvid>
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	50                   	push   %eax
  800ea0:	68 ac 2a 80 00       	push   $0x802aac
  800ea5:	e8 2e f3 ff ff       	call   8001d8 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800eaa:	83 c4 0c             	add    $0xc,%esp
  800ead:	68 d0 2a 80 00       	push   $0x802ad0
  800eb2:	6a 27                	push   $0x27
  800eb4:	68 a4 2b 80 00       	push   $0x802ba4
  800eb9:	e8 00 14 00 00       	call   8022be <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800ebe:	8b 78 28             	mov    0x28(%eax),%edi
  800ec1:	e8 a2 fc ff ff       	call   800b68 <sys_getenvid>
  800ec6:	57                   	push   %edi
  800ec7:	53                   	push   %ebx
  800ec8:	50                   	push   %eax
  800ec9:	68 ac 2a 80 00       	push   $0x802aac
  800ece:	e8 05 f3 ff ff       	call   8001d8 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800ed3:	56                   	push   %esi
  800ed4:	68 04 2b 80 00       	push   $0x802b04
  800ed9:	6a 2b                	push   $0x2b
  800edb:	68 a4 2b 80 00       	push   $0x802ba4
  800ee0:	e8 d9 13 00 00       	call   8022be <_panic>
      panic("pgfault: page allocation failed %e", r);
  800ee5:	50                   	push   %eax
  800ee6:	68 3c 2b 80 00       	push   $0x802b3c
  800eeb:	6a 39                	push   $0x39
  800eed:	68 a4 2b 80 00       	push   $0x802ba4
  800ef2:	e8 c7 13 00 00       	call   8022be <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800ef7:	50                   	push   %eax
  800ef8:	68 60 2b 80 00       	push   $0x802b60
  800efd:	6a 3e                	push   $0x3e
  800eff:	68 a4 2b 80 00       	push   $0x802ba4
  800f04:	e8 b5 13 00 00       	call   8022be <_panic>
      panic("pgfault: page map failed (%e)", r);
  800f09:	50                   	push   %eax
  800f0a:	68 af 2b 80 00       	push   $0x802baf
  800f0f:	6a 40                	push   $0x40
  800f11:	68 a4 2b 80 00       	push   $0x802ba4
  800f16:	e8 a3 13 00 00       	call   8022be <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f1b:	50                   	push   %eax
  800f1c:	68 60 2b 80 00       	push   $0x802b60
  800f21:	6a 42                	push   $0x42
  800f23:	68 a4 2b 80 00       	push   $0x802ba4
  800f28:	e8 91 13 00 00       	call   8022be <_panic>

00800f2d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800f36:	68 b6 0d 80 00       	push   $0x800db6
  800f3b:	e8 c4 13 00 00       	call   802304 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f40:	b8 07 00 00 00       	mov    $0x7,%eax
  800f45:	cd 30                	int    $0x30
  800f47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  800f4a:	83 c4 10             	add    $0x10,%esp
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	78 2d                	js     800f7e <fork+0x51>
  800f51:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  800f58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f5c:	0f 85 a6 00 00 00    	jne    801008 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  800f62:	e8 01 fc ff ff       	call   800b68 <sys_getenvid>
  800f67:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f6c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f6f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f74:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  800f79:	e9 79 01 00 00       	jmp    8010f7 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  800f7e:	50                   	push   %eax
  800f7f:	68 cd 2b 80 00       	push   $0x802bcd
  800f84:	68 aa 00 00 00       	push   $0xaa
  800f89:	68 a4 2b 80 00       	push   $0x802ba4
  800f8e:	e8 2b 13 00 00       	call   8022be <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  800f93:	83 ec 0c             	sub    $0xc,%esp
  800f96:	6a 05                	push   $0x5
  800f98:	53                   	push   %ebx
  800f99:	57                   	push   %edi
  800f9a:	53                   	push   %ebx
  800f9b:	6a 00                	push   $0x0
  800f9d:	e8 47 fc ff ff       	call   800be9 <sys_page_map>
  800fa2:	83 c4 20             	add    $0x20,%esp
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	79 4d                	jns    800ff6 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  800fa9:	50                   	push   %eax
  800faa:	68 d6 2b 80 00       	push   $0x802bd6
  800faf:	6a 61                	push   $0x61
  800fb1:	68 a4 2b 80 00       	push   $0x802ba4
  800fb6:	e8 03 13 00 00       	call   8022be <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	68 05 08 00 00       	push   $0x805
  800fc3:	53                   	push   %ebx
  800fc4:	57                   	push   %edi
  800fc5:	53                   	push   %ebx
  800fc6:	6a 00                	push   $0x0
  800fc8:	e8 1c fc ff ff       	call   800be9 <sys_page_map>
  800fcd:	83 c4 20             	add    $0x20,%esp
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	0f 88 b7 00 00 00    	js     80108f <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	68 05 08 00 00       	push   $0x805
  800fe0:	53                   	push   %ebx
  800fe1:	6a 00                	push   $0x0
  800fe3:	53                   	push   %ebx
  800fe4:	6a 00                	push   $0x0
  800fe6:	e8 fe fb ff ff       	call   800be9 <sys_page_map>
  800feb:	83 c4 20             	add    $0x20,%esp
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	0f 88 ab 00 00 00    	js     8010a1 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800ff6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800ffc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801002:	0f 84 ab 00 00 00    	je     8010b3 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  801008:	89 d8                	mov    %ebx,%eax
  80100a:	c1 e8 16             	shr    $0x16,%eax
  80100d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801014:	a8 01                	test   $0x1,%al
  801016:	74 de                	je     800ff6 <fork+0xc9>
  801018:	89 d8                	mov    %ebx,%eax
  80101a:	c1 e8 0c             	shr    $0xc,%eax
  80101d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801024:	f6 c2 01             	test   $0x1,%dl
  801027:	74 cd                	je     800ff6 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801029:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  80102c:	89 c2                	mov    %eax,%edx
  80102e:	c1 ea 16             	shr    $0x16,%edx
  801031:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801038:	f6 c2 01             	test   $0x1,%dl
  80103b:	74 b9                	je     800ff6 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  80103d:	c1 e8 0c             	shr    $0xc,%eax
  801040:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801047:	a8 01                	test   $0x1,%al
  801049:	74 ab                	je     800ff6 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  80104b:	a9 02 08 00 00       	test   $0x802,%eax
  801050:	0f 84 3d ff ff ff    	je     800f93 <fork+0x66>
	else if(pte & PTE_SHARE)
  801056:	f6 c4 04             	test   $0x4,%ah
  801059:	0f 84 5c ff ff ff    	je     800fbb <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80105f:	83 ec 0c             	sub    $0xc,%esp
  801062:	25 07 0e 00 00       	and    $0xe07,%eax
  801067:	50                   	push   %eax
  801068:	53                   	push   %ebx
  801069:	57                   	push   %edi
  80106a:	53                   	push   %ebx
  80106b:	6a 00                	push   $0x0
  80106d:	e8 77 fb ff ff       	call   800be9 <sys_page_map>
  801072:	83 c4 20             	add    $0x20,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	0f 89 79 ff ff ff    	jns    800ff6 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80107d:	50                   	push   %eax
  80107e:	68 d6 2b 80 00       	push   $0x802bd6
  801083:	6a 67                	push   $0x67
  801085:	68 a4 2b 80 00       	push   $0x802ba4
  80108a:	e8 2f 12 00 00       	call   8022be <_panic>
			panic("Page Map Failed: %e", error_code);
  80108f:	50                   	push   %eax
  801090:	68 d6 2b 80 00       	push   $0x802bd6
  801095:	6a 6d                	push   $0x6d
  801097:	68 a4 2b 80 00       	push   $0x802ba4
  80109c:	e8 1d 12 00 00       	call   8022be <_panic>
			panic("Page Map Failed: %e", error_code);
  8010a1:	50                   	push   %eax
  8010a2:	68 d6 2b 80 00       	push   $0x802bd6
  8010a7:	6a 70                	push   $0x70
  8010a9:	68 a4 2b 80 00       	push   $0x802ba4
  8010ae:	e8 0b 12 00 00       	call   8022be <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	6a 07                	push   $0x7
  8010b8:	68 00 f0 bf ee       	push   $0xeebff000
  8010bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010c0:	e8 e1 fa ff ff       	call   800ba6 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	78 36                	js     801102 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	68 7a 23 80 00       	push   $0x80237a
  8010d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d7:	e8 15 fc ff ff       	call   800cf1 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010dc:	83 c4 10             	add    $0x10,%esp
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	78 34                	js     801117 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8010e3:	83 ec 08             	sub    $0x8,%esp
  8010e6:	6a 02                	push   $0x2
  8010e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010eb:	e8 7d fb ff ff       	call   800c6d <sys_env_set_status>
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 35                	js     80112c <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8010f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5f                   	pop    %edi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801102:	50                   	push   %eax
  801103:	68 cd 2b 80 00       	push   $0x802bcd
  801108:	68 ba 00 00 00       	push   $0xba
  80110d:	68 a4 2b 80 00       	push   $0x802ba4
  801112:	e8 a7 11 00 00       	call   8022be <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801117:	50                   	push   %eax
  801118:	68 80 2b 80 00       	push   $0x802b80
  80111d:	68 bf 00 00 00       	push   $0xbf
  801122:	68 a4 2b 80 00       	push   $0x802ba4
  801127:	e8 92 11 00 00       	call   8022be <_panic>
      panic("sys_env_set_status: %e", r);
  80112c:	50                   	push   %eax
  80112d:	68 ea 2b 80 00       	push   $0x802bea
  801132:	68 c3 00 00 00       	push   $0xc3
  801137:	68 a4 2b 80 00       	push   $0x802ba4
  80113c:	e8 7d 11 00 00       	call   8022be <_panic>

00801141 <sfork>:

// Challenge!
int
sfork(void)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801147:	68 01 2c 80 00       	push   $0x802c01
  80114c:	68 cc 00 00 00       	push   $0xcc
  801151:	68 a4 2b 80 00       	push   $0x802ba4
  801156:	e8 63 11 00 00       	call   8022be <_panic>

0080115b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	05 00 00 00 30       	add    $0x30000000,%eax
  801166:	c1 e8 0c             	shr    $0xc,%eax
}
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801176:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    

00801182 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	c1 ea 16             	shr    $0x16,%edx
  80118f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801196:	f6 c2 01             	test   $0x1,%dl
  801199:	74 2d                	je     8011c8 <fd_alloc+0x46>
  80119b:	89 c2                	mov    %eax,%edx
  80119d:	c1 ea 0c             	shr    $0xc,%edx
  8011a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a7:	f6 c2 01             	test   $0x1,%dl
  8011aa:	74 1c                	je     8011c8 <fd_alloc+0x46>
  8011ac:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b6:	75 d2                	jne    80118a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011c1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c6:	eb 0a                	jmp    8011d2 <fd_alloc+0x50>
			*fd_store = fd;
  8011c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    

008011d4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011da:	83 f8 1f             	cmp    $0x1f,%eax
  8011dd:	77 30                	ja     80120f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011df:	c1 e0 0c             	shl    $0xc,%eax
  8011e2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011ed:	f6 c2 01             	test   $0x1,%dl
  8011f0:	74 24                	je     801216 <fd_lookup+0x42>
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	c1 ea 0c             	shr    $0xc,%edx
  8011f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fe:	f6 c2 01             	test   $0x1,%dl
  801201:	74 1a                	je     80121d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801203:	8b 55 0c             	mov    0xc(%ebp),%edx
  801206:	89 02                	mov    %eax,(%edx)
	return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
		return -E_INVAL;
  80120f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801214:	eb f7                	jmp    80120d <fd_lookup+0x39>
		return -E_INVAL;
  801216:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121b:	eb f0                	jmp    80120d <fd_lookup+0x39>
  80121d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801222:	eb e9                	jmp    80120d <fd_lookup+0x39>

00801224 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80122d:	ba 00 00 00 00       	mov    $0x0,%edx
  801232:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801237:	39 08                	cmp    %ecx,(%eax)
  801239:	74 38                	je     801273 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80123b:	83 c2 01             	add    $0x1,%edx
  80123e:	8b 04 95 94 2c 80 00 	mov    0x802c94(,%edx,4),%eax
  801245:	85 c0                	test   %eax,%eax
  801247:	75 ee                	jne    801237 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801249:	a1 08 40 80 00       	mov    0x804008,%eax
  80124e:	8b 40 48             	mov    0x48(%eax),%eax
  801251:	83 ec 04             	sub    $0x4,%esp
  801254:	51                   	push   %ecx
  801255:	50                   	push   %eax
  801256:	68 18 2c 80 00       	push   $0x802c18
  80125b:	e8 78 ef ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801271:	c9                   	leave  
  801272:	c3                   	ret    
			*dev = devtab[i];
  801273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801276:	89 01                	mov    %eax,(%ecx)
			return 0;
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
  80127d:	eb f2                	jmp    801271 <dev_lookup+0x4d>

0080127f <fd_close>:
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	83 ec 24             	sub    $0x24,%esp
  801288:	8b 75 08             	mov    0x8(%ebp),%esi
  80128b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80128e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801291:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801292:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801298:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80129b:	50                   	push   %eax
  80129c:	e8 33 ff ff ff       	call   8011d4 <fd_lookup>
  8012a1:	89 c3                	mov    %eax,%ebx
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 05                	js     8012af <fd_close+0x30>
	    || fd != fd2)
  8012aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012ad:	74 16                	je     8012c5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012af:	89 f8                	mov    %edi,%eax
  8012b1:	84 c0                	test   %al,%al
  8012b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b8:	0f 44 d8             	cmove  %eax,%ebx
}
  8012bb:	89 d8                	mov    %ebx,%eax
  8012bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c0:	5b                   	pop    %ebx
  8012c1:	5e                   	pop    %esi
  8012c2:	5f                   	pop    %edi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c5:	83 ec 08             	sub    $0x8,%esp
  8012c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012cb:	50                   	push   %eax
  8012cc:	ff 36                	pushl  (%esi)
  8012ce:	e8 51 ff ff ff       	call   801224 <dev_lookup>
  8012d3:	89 c3                	mov    %eax,%ebx
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 1a                	js     8012f6 <fd_close+0x77>
		if (dev->dev_close)
  8012dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012df:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012e2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 0b                	je     8012f6 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	56                   	push   %esi
  8012ef:	ff d0                	call   *%eax
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	56                   	push   %esi
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 2a f9 ff ff       	call   800c2b <sys_page_unmap>
	return r;
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	eb b5                	jmp    8012bb <fd_close+0x3c>

00801306 <close>:

int
close(int fdnum)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130f:	50                   	push   %eax
  801310:	ff 75 08             	pushl  0x8(%ebp)
  801313:	e8 bc fe ff ff       	call   8011d4 <fd_lookup>
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	79 02                	jns    801321 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    
		return fd_close(fd, 1);
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	6a 01                	push   $0x1
  801326:	ff 75 f4             	pushl  -0xc(%ebp)
  801329:	e8 51 ff ff ff       	call   80127f <fd_close>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	eb ec                	jmp    80131f <close+0x19>

00801333 <close_all>:

void
close_all(void)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	53                   	push   %ebx
  801337:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80133a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80133f:	83 ec 0c             	sub    $0xc,%esp
  801342:	53                   	push   %ebx
  801343:	e8 be ff ff ff       	call   801306 <close>
	for (i = 0; i < MAXFD; i++)
  801348:	83 c3 01             	add    $0x1,%ebx
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	83 fb 20             	cmp    $0x20,%ebx
  801351:	75 ec                	jne    80133f <close_all+0xc>
}
  801353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	57                   	push   %edi
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801361:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	ff 75 08             	pushl  0x8(%ebp)
  801368:	e8 67 fe ff ff       	call   8011d4 <fd_lookup>
  80136d:	89 c3                	mov    %eax,%ebx
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	0f 88 81 00 00 00    	js     8013fb <dup+0xa3>
		return r;
	close(newfdnum);
  80137a:	83 ec 0c             	sub    $0xc,%esp
  80137d:	ff 75 0c             	pushl  0xc(%ebp)
  801380:	e8 81 ff ff ff       	call   801306 <close>

	newfd = INDEX2FD(newfdnum);
  801385:	8b 75 0c             	mov    0xc(%ebp),%esi
  801388:	c1 e6 0c             	shl    $0xc,%esi
  80138b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801391:	83 c4 04             	add    $0x4,%esp
  801394:	ff 75 e4             	pushl  -0x1c(%ebp)
  801397:	e8 cf fd ff ff       	call   80116b <fd2data>
  80139c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80139e:	89 34 24             	mov    %esi,(%esp)
  8013a1:	e8 c5 fd ff ff       	call   80116b <fd2data>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	c1 e8 16             	shr    $0x16,%eax
  8013b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b7:	a8 01                	test   $0x1,%al
  8013b9:	74 11                	je     8013cc <dup+0x74>
  8013bb:	89 d8                	mov    %ebx,%eax
  8013bd:	c1 e8 0c             	shr    $0xc,%eax
  8013c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c7:	f6 c2 01             	test   $0x1,%dl
  8013ca:	75 39                	jne    801405 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cf:	89 d0                	mov    %edx,%eax
  8013d1:	c1 e8 0c             	shr    $0xc,%eax
  8013d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013db:	83 ec 0c             	sub    $0xc,%esp
  8013de:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e3:	50                   	push   %eax
  8013e4:	56                   	push   %esi
  8013e5:	6a 00                	push   $0x0
  8013e7:	52                   	push   %edx
  8013e8:	6a 00                	push   $0x0
  8013ea:	e8 fa f7 ff ff       	call   800be9 <sys_page_map>
  8013ef:	89 c3                	mov    %eax,%ebx
  8013f1:	83 c4 20             	add    $0x20,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 31                	js     801429 <dup+0xd1>
		goto err;

	return newfdnum;
  8013f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013fb:	89 d8                	mov    %ebx,%eax
  8013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801405:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140c:	83 ec 0c             	sub    $0xc,%esp
  80140f:	25 07 0e 00 00       	and    $0xe07,%eax
  801414:	50                   	push   %eax
  801415:	57                   	push   %edi
  801416:	6a 00                	push   $0x0
  801418:	53                   	push   %ebx
  801419:	6a 00                	push   $0x0
  80141b:	e8 c9 f7 ff ff       	call   800be9 <sys_page_map>
  801420:	89 c3                	mov    %eax,%ebx
  801422:	83 c4 20             	add    $0x20,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	79 a3                	jns    8013cc <dup+0x74>
	sys_page_unmap(0, newfd);
  801429:	83 ec 08             	sub    $0x8,%esp
  80142c:	56                   	push   %esi
  80142d:	6a 00                	push   $0x0
  80142f:	e8 f7 f7 ff ff       	call   800c2b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801434:	83 c4 08             	add    $0x8,%esp
  801437:	57                   	push   %edi
  801438:	6a 00                	push   $0x0
  80143a:	e8 ec f7 ff ff       	call   800c2b <sys_page_unmap>
	return r;
  80143f:	83 c4 10             	add    $0x10,%esp
  801442:	eb b7                	jmp    8013fb <dup+0xa3>

00801444 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	53                   	push   %ebx
  801448:	83 ec 1c             	sub    $0x1c,%esp
  80144b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	53                   	push   %ebx
  801453:	e8 7c fd ff ff       	call   8011d4 <fd_lookup>
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 3f                	js     80149e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801469:	ff 30                	pushl  (%eax)
  80146b:	e8 b4 fd ff ff       	call   801224 <dev_lookup>
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	78 27                	js     80149e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147a:	8b 42 08             	mov    0x8(%edx),%eax
  80147d:	83 e0 03             	and    $0x3,%eax
  801480:	83 f8 01             	cmp    $0x1,%eax
  801483:	74 1e                	je     8014a3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801488:	8b 40 08             	mov    0x8(%eax),%eax
  80148b:	85 c0                	test   %eax,%eax
  80148d:	74 35                	je     8014c4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	ff 75 10             	pushl  0x10(%ebp)
  801495:	ff 75 0c             	pushl  0xc(%ebp)
  801498:	52                   	push   %edx
  801499:	ff d0                	call   *%eax
  80149b:	83 c4 10             	add    $0x10,%esp
}
  80149e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8014a8:	8b 40 48             	mov    0x48(%eax),%eax
  8014ab:	83 ec 04             	sub    $0x4,%esp
  8014ae:	53                   	push   %ebx
  8014af:	50                   	push   %eax
  8014b0:	68 59 2c 80 00       	push   $0x802c59
  8014b5:	e8 1e ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c2:	eb da                	jmp    80149e <read+0x5a>
		return -E_NOT_SUPP;
  8014c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c9:	eb d3                	jmp    80149e <read+0x5a>

008014cb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	57                   	push   %edi
  8014cf:	56                   	push   %esi
  8014d0:	53                   	push   %ebx
  8014d1:	83 ec 0c             	sub    $0xc,%esp
  8014d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014df:	39 f3                	cmp    %esi,%ebx
  8014e1:	73 23                	jae    801506 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	89 f0                	mov    %esi,%eax
  8014e8:	29 d8                	sub    %ebx,%eax
  8014ea:	50                   	push   %eax
  8014eb:	89 d8                	mov    %ebx,%eax
  8014ed:	03 45 0c             	add    0xc(%ebp),%eax
  8014f0:	50                   	push   %eax
  8014f1:	57                   	push   %edi
  8014f2:	e8 4d ff ff ff       	call   801444 <read>
		if (m < 0)
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 06                	js     801504 <readn+0x39>
			return m;
		if (m == 0)
  8014fe:	74 06                	je     801506 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801500:	01 c3                	add    %eax,%ebx
  801502:	eb db                	jmp    8014df <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801504:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801506:	89 d8                	mov    %ebx,%eax
  801508:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150b:	5b                   	pop    %ebx
  80150c:	5e                   	pop    %esi
  80150d:	5f                   	pop    %edi
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    

00801510 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 1c             	sub    $0x1c,%esp
  801517:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	53                   	push   %ebx
  80151f:	e8 b0 fc ff ff       	call   8011d4 <fd_lookup>
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 3a                	js     801565 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	ff 30                	pushl  (%eax)
  801537:	e8 e8 fc ff ff       	call   801224 <dev_lookup>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 22                	js     801565 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154a:	74 1e                	je     80156a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80154c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154f:	8b 52 0c             	mov    0xc(%edx),%edx
  801552:	85 d2                	test   %edx,%edx
  801554:	74 35                	je     80158b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	ff 75 10             	pushl  0x10(%ebp)
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	50                   	push   %eax
  801560:	ff d2                	call   *%edx
  801562:	83 c4 10             	add    $0x10,%esp
}
  801565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801568:	c9                   	leave  
  801569:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80156a:	a1 08 40 80 00       	mov    0x804008,%eax
  80156f:	8b 40 48             	mov    0x48(%eax),%eax
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	53                   	push   %ebx
  801576:	50                   	push   %eax
  801577:	68 75 2c 80 00       	push   $0x802c75
  80157c:	e8 57 ec ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801589:	eb da                	jmp    801565 <write+0x55>
		return -E_NOT_SUPP;
  80158b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801590:	eb d3                	jmp    801565 <write+0x55>

00801592 <seek>:

int
seek(int fdnum, off_t offset)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	e8 30 fc ff ff       	call   8011d4 <fd_lookup>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 0e                	js     8015b9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 1c             	sub    $0x1c,%esp
  8015c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	53                   	push   %ebx
  8015ca:	e8 05 fc ff ff       	call   8011d4 <fd_lookup>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 37                	js     80160d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015dc:	50                   	push   %eax
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e0:	ff 30                	pushl  (%eax)
  8015e2:	e8 3d fc ff ff       	call   801224 <dev_lookup>
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	78 1f                	js     80160d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f5:	74 1b                	je     801612 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015fa:	8b 52 18             	mov    0x18(%edx),%edx
  8015fd:	85 d2                	test   %edx,%edx
  8015ff:	74 32                	je     801633 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	50                   	push   %eax
  801608:	ff d2                	call   *%edx
  80160a:	83 c4 10             	add    $0x10,%esp
}
  80160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801610:	c9                   	leave  
  801611:	c3                   	ret    
			thisenv->env_id, fdnum);
  801612:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801617:	8b 40 48             	mov    0x48(%eax),%eax
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	53                   	push   %ebx
  80161e:	50                   	push   %eax
  80161f:	68 38 2c 80 00       	push   $0x802c38
  801624:	e8 af eb ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801631:	eb da                	jmp    80160d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801633:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801638:	eb d3                	jmp    80160d <ftruncate+0x52>

0080163a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	53                   	push   %ebx
  80163e:	83 ec 1c             	sub    $0x1c,%esp
  801641:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801644:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801647:	50                   	push   %eax
  801648:	ff 75 08             	pushl  0x8(%ebp)
  80164b:	e8 84 fb ff ff       	call   8011d4 <fd_lookup>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	78 4b                	js     8016a2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801657:	83 ec 08             	sub    $0x8,%esp
  80165a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165d:	50                   	push   %eax
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801661:	ff 30                	pushl  (%eax)
  801663:	e8 bc fb ff ff       	call   801224 <dev_lookup>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 33                	js     8016a2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801672:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801676:	74 2f                	je     8016a7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801678:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80167b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801682:	00 00 00 
	stat->st_isdir = 0;
  801685:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168c:	00 00 00 
	stat->st_dev = dev;
  80168f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	53                   	push   %ebx
  801699:	ff 75 f0             	pushl  -0x10(%ebp)
  80169c:	ff 50 14             	call   *0x14(%eax)
  80169f:	83 c4 10             	add    $0x10,%esp
}
  8016a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    
		return -E_NOT_SUPP;
  8016a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ac:	eb f4                	jmp    8016a2 <fstat+0x68>

008016ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b3:	83 ec 08             	sub    $0x8,%esp
  8016b6:	6a 00                	push   $0x0
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 2f 02 00 00       	call   8018ef <open>
  8016c0:	89 c3                	mov    %eax,%ebx
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 1b                	js     8016e4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	50                   	push   %eax
  8016d0:	e8 65 ff ff ff       	call   80163a <fstat>
  8016d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 27 fc ff ff       	call   801306 <close>
	return r;
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 f3                	mov    %esi,%ebx
}
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5e                   	pop    %esi
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	89 c6                	mov    %eax,%esi
  8016f4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016fd:	74 27                	je     801726 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016ff:	6a 07                	push   $0x7
  801701:	68 00 50 80 00       	push   $0x805000
  801706:	56                   	push   %esi
  801707:	ff 35 00 40 80 00    	pushl  0x804000
  80170d:	e8 02 0d 00 00       	call   802414 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801712:	83 c4 0c             	add    $0xc,%esp
  801715:	6a 00                	push   $0x0
  801717:	53                   	push   %ebx
  801718:	6a 00                	push   $0x0
  80171a:	e8 82 0c 00 00       	call   8023a1 <ipc_recv>
}
  80171f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801722:	5b                   	pop    %ebx
  801723:	5e                   	pop    %esi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	6a 01                	push   $0x1
  80172b:	e8 50 0d 00 00       	call   802480 <ipc_find_env>
  801730:	a3 00 40 80 00       	mov    %eax,0x804000
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	eb c5                	jmp    8016ff <fsipc+0x12>

0080173a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8b 40 0c             	mov    0xc(%eax),%eax
  801746:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801753:	ba 00 00 00 00       	mov    $0x0,%edx
  801758:	b8 02 00 00 00       	mov    $0x2,%eax
  80175d:	e8 8b ff ff ff       	call   8016ed <fsipc>
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <devfile_flush>:
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8b 40 0c             	mov    0xc(%eax),%eax
  801770:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 06 00 00 00       	mov    $0x6,%eax
  80177f:	e8 69 ff ff ff       	call   8016ed <fsipc>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <devfile_stat>:
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	53                   	push   %ebx
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8b 40 0c             	mov    0xc(%eax),%eax
  801796:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80179b:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a5:	e8 43 ff ff ff       	call   8016ed <fsipc>
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 2c                	js     8017da <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	68 00 50 80 00       	push   $0x805000
  8017b6:	53                   	push   %ebx
  8017b7:	e8 f8 ef ff ff       	call   8007b4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017bc:	a1 80 50 80 00       	mov    0x805080,%eax
  8017c1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c7:	a1 84 50 80 00       	mov    0x805084,%eax
  8017cc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <devfile_write>:
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8017e9:	85 db                	test   %ebx,%ebx
  8017eb:	75 07                	jne    8017f4 <devfile_write+0x15>
	return n_all;
  8017ed:	89 d8                	mov    %ebx,%eax
}
  8017ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fa:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8017ff:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	53                   	push   %ebx
  801809:	ff 75 0c             	pushl  0xc(%ebp)
  80180c:	68 08 50 80 00       	push   $0x805008
  801811:	e8 2c f1 ff ff       	call   800942 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	b8 04 00 00 00       	mov    $0x4,%eax
  801820:	e8 c8 fe ff ff       	call   8016ed <fsipc>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 c3                	js     8017ef <devfile_write+0x10>
	  assert(r <= n_left);
  80182c:	39 d8                	cmp    %ebx,%eax
  80182e:	77 0b                	ja     80183b <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801830:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801835:	7f 1d                	jg     801854 <devfile_write+0x75>
    n_all += r;
  801837:	89 c3                	mov    %eax,%ebx
  801839:	eb b2                	jmp    8017ed <devfile_write+0xe>
	  assert(r <= n_left);
  80183b:	68 a8 2c 80 00       	push   $0x802ca8
  801840:	68 b4 2c 80 00       	push   $0x802cb4
  801845:	68 9f 00 00 00       	push   $0x9f
  80184a:	68 c9 2c 80 00       	push   $0x802cc9
  80184f:	e8 6a 0a 00 00       	call   8022be <_panic>
	  assert(r <= PGSIZE);
  801854:	68 d4 2c 80 00       	push   $0x802cd4
  801859:	68 b4 2c 80 00       	push   $0x802cb4
  80185e:	68 a0 00 00 00       	push   $0xa0
  801863:	68 c9 2c 80 00       	push   $0x802cc9
  801868:	e8 51 0a 00 00       	call   8022be <_panic>

0080186d <devfile_read>:
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	8b 40 0c             	mov    0xc(%eax),%eax
  80187b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801880:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 03 00 00 00       	mov    $0x3,%eax
  801890:	e8 58 fe ff ff       	call   8016ed <fsipc>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	85 c0                	test   %eax,%eax
  801899:	78 1f                	js     8018ba <devfile_read+0x4d>
	assert(r <= n);
  80189b:	39 f0                	cmp    %esi,%eax
  80189d:	77 24                	ja     8018c3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80189f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a4:	7f 33                	jg     8018d9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	50                   	push   %eax
  8018aa:	68 00 50 80 00       	push   $0x805000
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	e8 8b f0 ff ff       	call   800942 <memmove>
	return r;
  8018b7:	83 c4 10             	add    $0x10,%esp
}
  8018ba:	89 d8                	mov    %ebx,%eax
  8018bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    
	assert(r <= n);
  8018c3:	68 e0 2c 80 00       	push   $0x802ce0
  8018c8:	68 b4 2c 80 00       	push   $0x802cb4
  8018cd:	6a 7c                	push   $0x7c
  8018cf:	68 c9 2c 80 00       	push   $0x802cc9
  8018d4:	e8 e5 09 00 00       	call   8022be <_panic>
	assert(r <= PGSIZE);
  8018d9:	68 d4 2c 80 00       	push   $0x802cd4
  8018de:	68 b4 2c 80 00       	push   $0x802cb4
  8018e3:	6a 7d                	push   $0x7d
  8018e5:	68 c9 2c 80 00       	push   $0x802cc9
  8018ea:	e8 cf 09 00 00       	call   8022be <_panic>

008018ef <open>:
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 1c             	sub    $0x1c,%esp
  8018f7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018fa:	56                   	push   %esi
  8018fb:	e8 7b ee ff ff       	call   80077b <strlen>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801908:	7f 6c                	jg     801976 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80190a:	83 ec 0c             	sub    $0xc,%esp
  80190d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801910:	50                   	push   %eax
  801911:	e8 6c f8 ff ff       	call   801182 <fd_alloc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 3c                	js     80195b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	56                   	push   %esi
  801923:	68 00 50 80 00       	push   $0x805000
  801928:	e8 87 ee ff ff       	call   8007b4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	b8 01 00 00 00       	mov    $0x1,%eax
  80193d:	e8 ab fd ff ff       	call   8016ed <fsipc>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 19                	js     801964 <open+0x75>
	return fd2num(fd);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	ff 75 f4             	pushl  -0xc(%ebp)
  801951:	e8 05 f8 ff ff       	call   80115b <fd2num>
  801956:	89 c3                	mov    %eax,%ebx
  801958:	83 c4 10             	add    $0x10,%esp
}
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801960:	5b                   	pop    %ebx
  801961:	5e                   	pop    %esi
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    
		fd_close(fd, 0);
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	6a 00                	push   $0x0
  801969:	ff 75 f4             	pushl  -0xc(%ebp)
  80196c:	e8 0e f9 ff ff       	call   80127f <fd_close>
		return r;
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	eb e5                	jmp    80195b <open+0x6c>
		return -E_BAD_PATH;
  801976:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80197b:	eb de                	jmp    80195b <open+0x6c>

0080197d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801983:	ba 00 00 00 00       	mov    $0x0,%edx
  801988:	b8 08 00 00 00       	mov    $0x8,%eax
  80198d:	e8 5b fd ff ff       	call   8016ed <fsipc>
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80199c:	83 ec 0c             	sub    $0xc,%esp
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	e8 c4 f7 ff ff       	call   80116b <fd2data>
  8019a7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019a9:	83 c4 08             	add    $0x8,%esp
  8019ac:	68 e7 2c 80 00       	push   $0x802ce7
  8019b1:	53                   	push   %ebx
  8019b2:	e8 fd ed ff ff       	call   8007b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019b7:	8b 46 04             	mov    0x4(%esi),%eax
  8019ba:	2b 06                	sub    (%esi),%eax
  8019bc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019c9:	00 00 00 
	stat->st_dev = &devpipe;
  8019cc:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019d3:	30 80 00 
	return 0;
}
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	53                   	push   %ebx
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019ec:	53                   	push   %ebx
  8019ed:	6a 00                	push   $0x0
  8019ef:	e8 37 f2 ff ff       	call   800c2b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019f4:	89 1c 24             	mov    %ebx,(%esp)
  8019f7:	e8 6f f7 ff ff       	call   80116b <fd2data>
  8019fc:	83 c4 08             	add    $0x8,%esp
  8019ff:	50                   	push   %eax
  801a00:	6a 00                	push   $0x0
  801a02:	e8 24 f2 ff ff       	call   800c2b <sys_page_unmap>
}
  801a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <_pipeisclosed>:
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 1c             	sub    $0x1c,%esp
  801a15:	89 c7                	mov    %eax,%edi
  801a17:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a19:	a1 08 40 80 00       	mov    0x804008,%eax
  801a1e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	57                   	push   %edi
  801a25:	e8 8f 0a 00 00       	call   8024b9 <pageref>
  801a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a2d:	89 34 24             	mov    %esi,(%esp)
  801a30:	e8 84 0a 00 00       	call   8024b9 <pageref>
		nn = thisenv->env_runs;
  801a35:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	39 cb                	cmp    %ecx,%ebx
  801a43:	74 1b                	je     801a60 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a45:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a48:	75 cf                	jne    801a19 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a4a:	8b 42 58             	mov    0x58(%edx),%eax
  801a4d:	6a 01                	push   $0x1
  801a4f:	50                   	push   %eax
  801a50:	53                   	push   %ebx
  801a51:	68 ee 2c 80 00       	push   $0x802cee
  801a56:	e8 7d e7 ff ff       	call   8001d8 <cprintf>
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	eb b9                	jmp    801a19 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a60:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a63:	0f 94 c0             	sete   %al
  801a66:	0f b6 c0             	movzbl %al,%eax
}
  801a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a6c:	5b                   	pop    %ebx
  801a6d:	5e                   	pop    %esi
  801a6e:	5f                   	pop    %edi
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <devpipe_write>:
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	57                   	push   %edi
  801a75:	56                   	push   %esi
  801a76:	53                   	push   %ebx
  801a77:	83 ec 28             	sub    $0x28,%esp
  801a7a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a7d:	56                   	push   %esi
  801a7e:	e8 e8 f6 ff ff       	call   80116b <fd2data>
  801a83:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	bf 00 00 00 00       	mov    $0x0,%edi
  801a8d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a90:	74 4f                	je     801ae1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a92:	8b 43 04             	mov    0x4(%ebx),%eax
  801a95:	8b 0b                	mov    (%ebx),%ecx
  801a97:	8d 51 20             	lea    0x20(%ecx),%edx
  801a9a:	39 d0                	cmp    %edx,%eax
  801a9c:	72 14                	jb     801ab2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a9e:	89 da                	mov    %ebx,%edx
  801aa0:	89 f0                	mov    %esi,%eax
  801aa2:	e8 65 ff ff ff       	call   801a0c <_pipeisclosed>
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	75 3b                	jne    801ae6 <devpipe_write+0x75>
			sys_yield();
  801aab:	e8 d7 f0 ff ff       	call   800b87 <sys_yield>
  801ab0:	eb e0                	jmp    801a92 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ab9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801abc:	89 c2                	mov    %eax,%edx
  801abe:	c1 fa 1f             	sar    $0x1f,%edx
  801ac1:	89 d1                	mov    %edx,%ecx
  801ac3:	c1 e9 1b             	shr    $0x1b,%ecx
  801ac6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ac9:	83 e2 1f             	and    $0x1f,%edx
  801acc:	29 ca                	sub    %ecx,%edx
  801ace:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ad2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ad6:	83 c0 01             	add    $0x1,%eax
  801ad9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801adc:	83 c7 01             	add    $0x1,%edi
  801adf:	eb ac                	jmp    801a8d <devpipe_write+0x1c>
	return i;
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	eb 05                	jmp    801aeb <devpipe_write+0x7a>
				return 0;
  801ae6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aee:	5b                   	pop    %ebx
  801aef:	5e                   	pop    %esi
  801af0:	5f                   	pop    %edi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <devpipe_read>:
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	57                   	push   %edi
  801af7:	56                   	push   %esi
  801af8:	53                   	push   %ebx
  801af9:	83 ec 18             	sub    $0x18,%esp
  801afc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801aff:	57                   	push   %edi
  801b00:	e8 66 f6 ff ff       	call   80116b <fd2data>
  801b05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	be 00 00 00 00       	mov    $0x0,%esi
  801b0f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b12:	75 14                	jne    801b28 <devpipe_read+0x35>
	return i;
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	eb 02                	jmp    801b1b <devpipe_read+0x28>
				return i;
  801b19:	89 f0                	mov    %esi,%eax
}
  801b1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5f                   	pop    %edi
  801b21:	5d                   	pop    %ebp
  801b22:	c3                   	ret    
			sys_yield();
  801b23:	e8 5f f0 ff ff       	call   800b87 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b28:	8b 03                	mov    (%ebx),%eax
  801b2a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b2d:	75 18                	jne    801b47 <devpipe_read+0x54>
			if (i > 0)
  801b2f:	85 f6                	test   %esi,%esi
  801b31:	75 e6                	jne    801b19 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b33:	89 da                	mov    %ebx,%edx
  801b35:	89 f8                	mov    %edi,%eax
  801b37:	e8 d0 fe ff ff       	call   801a0c <_pipeisclosed>
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	74 e3                	je     801b23 <devpipe_read+0x30>
				return 0;
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	eb d4                	jmp    801b1b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b47:	99                   	cltd   
  801b48:	c1 ea 1b             	shr    $0x1b,%edx
  801b4b:	01 d0                	add    %edx,%eax
  801b4d:	83 e0 1f             	and    $0x1f,%eax
  801b50:	29 d0                	sub    %edx,%eax
  801b52:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b5a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b5d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b60:	83 c6 01             	add    $0x1,%esi
  801b63:	eb aa                	jmp    801b0f <devpipe_read+0x1c>

00801b65 <pipe>:
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	56                   	push   %esi
  801b69:	53                   	push   %ebx
  801b6a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b70:	50                   	push   %eax
  801b71:	e8 0c f6 ff ff       	call   801182 <fd_alloc>
  801b76:	89 c3                	mov    %eax,%ebx
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	0f 88 23 01 00 00    	js     801ca6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	68 07 04 00 00       	push   $0x407
  801b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8e:	6a 00                	push   $0x0
  801b90:	e8 11 f0 ff ff       	call   800ba6 <sys_page_alloc>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	0f 88 04 01 00 00    	js     801ca6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ba2:	83 ec 0c             	sub    $0xc,%esp
  801ba5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ba8:	50                   	push   %eax
  801ba9:	e8 d4 f5 ff ff       	call   801182 <fd_alloc>
  801bae:	89 c3                	mov    %eax,%ebx
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	0f 88 db 00 00 00    	js     801c96 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	68 07 04 00 00       	push   $0x407
  801bc3:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc6:	6a 00                	push   $0x0
  801bc8:	e8 d9 ef ff ff       	call   800ba6 <sys_page_alloc>
  801bcd:	89 c3                	mov    %eax,%ebx
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	0f 88 bc 00 00 00    	js     801c96 <pipe+0x131>
	va = fd2data(fd0);
  801bda:	83 ec 0c             	sub    $0xc,%esp
  801bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801be0:	e8 86 f5 ff ff       	call   80116b <fd2data>
  801be5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be7:	83 c4 0c             	add    $0xc,%esp
  801bea:	68 07 04 00 00       	push   $0x407
  801bef:	50                   	push   %eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	e8 af ef ff ff       	call   800ba6 <sys_page_alloc>
  801bf7:	89 c3                	mov    %eax,%ebx
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	0f 88 82 00 00 00    	js     801c86 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c04:	83 ec 0c             	sub    $0xc,%esp
  801c07:	ff 75 f0             	pushl  -0x10(%ebp)
  801c0a:	e8 5c f5 ff ff       	call   80116b <fd2data>
  801c0f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c16:	50                   	push   %eax
  801c17:	6a 00                	push   $0x0
  801c19:	56                   	push   %esi
  801c1a:	6a 00                	push   $0x0
  801c1c:	e8 c8 ef ff ff       	call   800be9 <sys_page_map>
  801c21:	89 c3                	mov    %eax,%ebx
  801c23:	83 c4 20             	add    $0x20,%esp
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 4e                	js     801c78 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c2a:	a1 20 30 80 00       	mov    0x803020,%eax
  801c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c32:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c37:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c41:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	ff 75 f4             	pushl  -0xc(%ebp)
  801c53:	e8 03 f5 ff ff       	call   80115b <fd2num>
  801c58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c5d:	83 c4 04             	add    $0x4,%esp
  801c60:	ff 75 f0             	pushl  -0x10(%ebp)
  801c63:	e8 f3 f4 ff ff       	call   80115b <fd2num>
  801c68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c76:	eb 2e                	jmp    801ca6 <pipe+0x141>
	sys_page_unmap(0, va);
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	56                   	push   %esi
  801c7c:	6a 00                	push   $0x0
  801c7e:	e8 a8 ef ff ff       	call   800c2b <sys_page_unmap>
  801c83:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c86:	83 ec 08             	sub    $0x8,%esp
  801c89:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8c:	6a 00                	push   $0x0
  801c8e:	e8 98 ef ff ff       	call   800c2b <sys_page_unmap>
  801c93:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9c:	6a 00                	push   $0x0
  801c9e:	e8 88 ef ff ff       	call   800c2b <sys_page_unmap>
  801ca3:	83 c4 10             	add    $0x10,%esp
}
  801ca6:	89 d8                	mov    %ebx,%eax
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <pipeisclosed>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb8:	50                   	push   %eax
  801cb9:	ff 75 08             	pushl  0x8(%ebp)
  801cbc:	e8 13 f5 ff ff       	call   8011d4 <fd_lookup>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 18                	js     801ce0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cce:	e8 98 f4 ff ff       	call   80116b <fd2data>
	return _pipeisclosed(fd, p);
  801cd3:	89 c2                	mov    %eax,%edx
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	e8 2f fd ff ff       	call   801a0c <_pipeisclosed>
  801cdd:	83 c4 10             	add    $0x10,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ce8:	68 06 2d 80 00       	push   $0x802d06
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	e8 bf ea ff ff       	call   8007b4 <strcpy>
	return 0;
}
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <devsock_close>:
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	53                   	push   %ebx
  801d00:	83 ec 10             	sub    $0x10,%esp
  801d03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d06:	53                   	push   %ebx
  801d07:	e8 ad 07 00 00       	call   8024b9 <pageref>
  801d0c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d0f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d14:	83 f8 01             	cmp    $0x1,%eax
  801d17:	74 07                	je     801d20 <devsock_close+0x24>
}
  801d19:	89 d0                	mov    %edx,%eax
  801d1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	ff 73 0c             	pushl  0xc(%ebx)
  801d26:	e8 b9 02 00 00       	call   801fe4 <nsipc_close>
  801d2b:	89 c2                	mov    %eax,%edx
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	eb e7                	jmp    801d19 <devsock_close+0x1d>

00801d32 <devsock_write>:
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 10             	pushl  0x10(%ebp)
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	ff 70 0c             	pushl  0xc(%eax)
  801d46:	e8 76 03 00 00       	call   8020c1 <nsipc_send>
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <devsock_read>:
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	ff 75 10             	pushl  0x10(%ebp)
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	ff 70 0c             	pushl  0xc(%eax)
  801d61:	e8 ef 02 00 00       	call   802055 <nsipc_recv>
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <fd2sockid>:
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d6e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	e8 5c f4 ff ff       	call   8011d4 <fd_lookup>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 10                	js     801d8f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d88:	39 08                	cmp    %ecx,(%eax)
  801d8a:	75 05                	jne    801d91 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d8c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    
		return -E_NOT_SUPP;
  801d91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d96:	eb f7                	jmp    801d8f <fd2sockid+0x27>

00801d98 <alloc_sockfd>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 1c             	sub    $0x1c,%esp
  801da0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801da2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da5:	50                   	push   %eax
  801da6:	e8 d7 f3 ff ff       	call   801182 <fd_alloc>
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 43                	js     801df7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	68 07 04 00 00       	push   $0x407
  801dbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 e0 ed ff ff       	call   800ba6 <sys_page_alloc>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 28                	js     801df7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dd8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801de4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	50                   	push   %eax
  801deb:	e8 6b f3 ff ff       	call   80115b <fd2num>
  801df0:	89 c3                	mov    %eax,%ebx
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	eb 0c                	jmp    801e03 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	56                   	push   %esi
  801dfb:	e8 e4 01 00 00       	call   801fe4 <nsipc_close>
		return r;
  801e00:	83 c4 10             	add    $0x10,%esp
}
  801e03:	89 d8                	mov    %ebx,%eax
  801e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5e                   	pop    %esi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <accept>:
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	e8 4e ff ff ff       	call   801d68 <fd2sockid>
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 1b                	js     801e39 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	ff 75 10             	pushl  0x10(%ebp)
  801e24:	ff 75 0c             	pushl  0xc(%ebp)
  801e27:	50                   	push   %eax
  801e28:	e8 0e 01 00 00       	call   801f3b <nsipc_accept>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	85 c0                	test   %eax,%eax
  801e32:	78 05                	js     801e39 <accept+0x2d>
	return alloc_sockfd(r);
  801e34:	e8 5f ff ff ff       	call   801d98 <alloc_sockfd>
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <bind>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	e8 1f ff ff ff       	call   801d68 <fd2sockid>
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	78 12                	js     801e5f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	ff 75 10             	pushl  0x10(%ebp)
  801e53:	ff 75 0c             	pushl  0xc(%ebp)
  801e56:	50                   	push   %eax
  801e57:	e8 31 01 00 00       	call   801f8d <nsipc_bind>
  801e5c:	83 c4 10             	add    $0x10,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <shutdown>:
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	e8 f9 fe ff ff       	call   801d68 <fd2sockid>
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 0f                	js     801e82 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	ff 75 0c             	pushl  0xc(%ebp)
  801e79:	50                   	push   %eax
  801e7a:	e8 43 01 00 00       	call   801fc2 <nsipc_shutdown>
  801e7f:	83 c4 10             	add    $0x10,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <connect>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	e8 d6 fe ff ff       	call   801d68 <fd2sockid>
  801e92:	85 c0                	test   %eax,%eax
  801e94:	78 12                	js     801ea8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	50                   	push   %eax
  801ea0:	e8 59 01 00 00       	call   801ffe <nsipc_connect>
  801ea5:	83 c4 10             	add    $0x10,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <listen>:
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	e8 b0 fe ff ff       	call   801d68 <fd2sockid>
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	78 0f                	js     801ecb <listen+0x21>
	return nsipc_listen(r, backlog);
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	50                   	push   %eax
  801ec3:	e8 6b 01 00 00       	call   802033 <nsipc_listen>
  801ec8:	83 c4 10             	add    $0x10,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <socket>:

int
socket(int domain, int type, int protocol)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ed3:	ff 75 10             	pushl  0x10(%ebp)
  801ed6:	ff 75 0c             	pushl  0xc(%ebp)
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	e8 3e 02 00 00       	call   80211f <nsipc_socket>
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	78 05                	js     801eed <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ee8:	e8 ab fe ff ff       	call   801d98 <alloc_sockfd>
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	53                   	push   %ebx
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ef8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801eff:	74 26                	je     801f27 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f01:	6a 07                	push   $0x7
  801f03:	68 00 60 80 00       	push   $0x806000
  801f08:	53                   	push   %ebx
  801f09:	ff 35 04 40 80 00    	pushl  0x804004
  801f0f:	e8 00 05 00 00       	call   802414 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f14:	83 c4 0c             	add    $0xc,%esp
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	e8 7f 04 00 00       	call   8023a1 <ipc_recv>
}
  801f22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	6a 02                	push   $0x2
  801f2c:	e8 4f 05 00 00       	call   802480 <ipc_find_env>
  801f31:	a3 04 40 80 00       	mov    %eax,0x804004
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	eb c6                	jmp    801f01 <nsipc+0x12>

00801f3b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f4b:	8b 06                	mov    (%esi),%eax
  801f4d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f52:	b8 01 00 00 00       	mov    $0x1,%eax
  801f57:	e8 93 ff ff ff       	call   801eef <nsipc>
  801f5c:	89 c3                	mov    %eax,%ebx
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	79 09                	jns    801f6b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f62:	89 d8                	mov    %ebx,%eax
  801f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f6b:	83 ec 04             	sub    $0x4,%esp
  801f6e:	ff 35 10 60 80 00    	pushl  0x806010
  801f74:	68 00 60 80 00       	push   $0x806000
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	e8 c1 e9 ff ff       	call   800942 <memmove>
		*addrlen = ret->ret_addrlen;
  801f81:	a1 10 60 80 00       	mov    0x806010,%eax
  801f86:	89 06                	mov    %eax,(%esi)
  801f88:	83 c4 10             	add    $0x10,%esp
	return r;
  801f8b:	eb d5                	jmp    801f62 <nsipc_accept+0x27>

00801f8d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	53                   	push   %ebx
  801f91:	83 ec 08             	sub    $0x8,%esp
  801f94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f9f:	53                   	push   %ebx
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	68 04 60 80 00       	push   $0x806004
  801fa8:	e8 95 e9 ff ff       	call   800942 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fad:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fb3:	b8 02 00 00 00       	mov    $0x2,%eax
  801fb8:	e8 32 ff ff ff       	call   801eef <nsipc>
}
  801fbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fd8:	b8 03 00 00 00       	mov    $0x3,%eax
  801fdd:	e8 0d ff ff ff       	call   801eef <nsipc>
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <nsipc_close>:

int
nsipc_close(int s)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ff2:	b8 04 00 00 00       	mov    $0x4,%eax
  801ff7:	e8 f3 fe ff ff       	call   801eef <nsipc>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	53                   	push   %ebx
  802002:	83 ec 08             	sub    $0x8,%esp
  802005:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802010:	53                   	push   %ebx
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	68 04 60 80 00       	push   $0x806004
  802019:	e8 24 e9 ff ff       	call   800942 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80201e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802024:	b8 05 00 00 00       	mov    $0x5,%eax
  802029:	e8 c1 fe ff ff       	call   801eef <nsipc>
}
  80202e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802049:	b8 06 00 00 00       	mov    $0x6,%eax
  80204e:	e8 9c fe ff ff       	call   801eef <nsipc>
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	56                   	push   %esi
  802059:	53                   	push   %ebx
  80205a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802065:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80206b:	8b 45 14             	mov    0x14(%ebp),%eax
  80206e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802073:	b8 07 00 00 00       	mov    $0x7,%eax
  802078:	e8 72 fe ff ff       	call   801eef <nsipc>
  80207d:	89 c3                	mov    %eax,%ebx
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 1f                	js     8020a2 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802083:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802088:	7f 21                	jg     8020ab <nsipc_recv+0x56>
  80208a:	39 c6                	cmp    %eax,%esi
  80208c:	7c 1d                	jl     8020ab <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	50                   	push   %eax
  802092:	68 00 60 80 00       	push   $0x806000
  802097:	ff 75 0c             	pushl  0xc(%ebp)
  80209a:	e8 a3 e8 ff ff       	call   800942 <memmove>
  80209f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020a2:	89 d8                	mov    %ebx,%eax
  8020a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020ab:	68 12 2d 80 00       	push   $0x802d12
  8020b0:	68 b4 2c 80 00       	push   $0x802cb4
  8020b5:	6a 62                	push   $0x62
  8020b7:	68 27 2d 80 00       	push   $0x802d27
  8020bc:	e8 fd 01 00 00       	call   8022be <_panic>

008020c1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	53                   	push   %ebx
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020d3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020d9:	7f 2e                	jg     802109 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	53                   	push   %ebx
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	68 0c 60 80 00       	push   $0x80600c
  8020e7:	e8 56 e8 ff ff       	call   800942 <memmove>
	nsipcbuf.send.req_size = size;
  8020ec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ff:	e8 eb fd ff ff       	call   801eef <nsipc>
}
  802104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802107:	c9                   	leave  
  802108:	c3                   	ret    
	assert(size < 1600);
  802109:	68 33 2d 80 00       	push   $0x802d33
  80210e:	68 b4 2c 80 00       	push   $0x802cb4
  802113:	6a 6d                	push   $0x6d
  802115:	68 27 2d 80 00       	push   $0x802d27
  80211a:	e8 9f 01 00 00       	call   8022be <_panic>

0080211f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802135:	8b 45 10             	mov    0x10(%ebp),%eax
  802138:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80213d:	b8 09 00 00 00       	mov    $0x9,%eax
  802142:	e8 a8 fd ff ff       	call   801eef <nsipc>
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
  80214e:	c3                   	ret    

0080214f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802155:	68 3f 2d 80 00       	push   $0x802d3f
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	e8 52 e6 ff ff       	call   8007b4 <strcpy>
	return 0;
}
  802162:	b8 00 00 00 00       	mov    $0x0,%eax
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <devcons_write>:
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	57                   	push   %edi
  80216d:	56                   	push   %esi
  80216e:	53                   	push   %ebx
  80216f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802175:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80217a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802180:	3b 75 10             	cmp    0x10(%ebp),%esi
  802183:	73 31                	jae    8021b6 <devcons_write+0x4d>
		m = n - tot;
  802185:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802188:	29 f3                	sub    %esi,%ebx
  80218a:	83 fb 7f             	cmp    $0x7f,%ebx
  80218d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802192:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	53                   	push   %ebx
  802199:	89 f0                	mov    %esi,%eax
  80219b:	03 45 0c             	add    0xc(%ebp),%eax
  80219e:	50                   	push   %eax
  80219f:	57                   	push   %edi
  8021a0:	e8 9d e7 ff ff       	call   800942 <memmove>
		sys_cputs(buf, m);
  8021a5:	83 c4 08             	add    $0x8,%esp
  8021a8:	53                   	push   %ebx
  8021a9:	57                   	push   %edi
  8021aa:	e8 3b e9 ff ff       	call   800aea <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021af:	01 de                	add    %ebx,%esi
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	eb ca                	jmp    802180 <devcons_write+0x17>
}
  8021b6:	89 f0                	mov    %esi,%eax
  8021b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    

008021c0 <devcons_read>:
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 08             	sub    $0x8,%esp
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021cf:	74 21                	je     8021f2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021d1:	e8 32 e9 ff ff       	call   800b08 <sys_cgetc>
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 07                	jne    8021e1 <devcons_read+0x21>
		sys_yield();
  8021da:	e8 a8 e9 ff ff       	call   800b87 <sys_yield>
  8021df:	eb f0                	jmp    8021d1 <devcons_read+0x11>
	if (c < 0)
  8021e1:	78 0f                	js     8021f2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021e3:	83 f8 04             	cmp    $0x4,%eax
  8021e6:	74 0c                	je     8021f4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021eb:	88 02                	mov    %al,(%edx)
	return 1;
  8021ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    
		return 0;
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	eb f7                	jmp    8021f2 <devcons_read+0x32>

008021fb <cputchar>:
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802207:	6a 01                	push   $0x1
  802209:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80220c:	50                   	push   %eax
  80220d:	e8 d8 e8 ff ff       	call   800aea <sys_cputs>
}
  802212:	83 c4 10             	add    $0x10,%esp
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <getchar>:
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80221d:	6a 01                	push   $0x1
  80221f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802222:	50                   	push   %eax
  802223:	6a 00                	push   $0x0
  802225:	e8 1a f2 ff ff       	call   801444 <read>
	if (r < 0)
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	78 06                	js     802237 <getchar+0x20>
	if (r < 1)
  802231:	74 06                	je     802239 <getchar+0x22>
	return c;
  802233:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    
		return -E_EOF;
  802239:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80223e:	eb f7                	jmp    802237 <getchar+0x20>

00802240 <iscons>:
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802246:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802249:	50                   	push   %eax
  80224a:	ff 75 08             	pushl  0x8(%ebp)
  80224d:	e8 82 ef ff ff       	call   8011d4 <fd_lookup>
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	85 c0                	test   %eax,%eax
  802257:	78 11                	js     80226a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802262:	39 10                	cmp    %edx,(%eax)
  802264:	0f 94 c0             	sete   %al
  802267:	0f b6 c0             	movzbl %al,%eax
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <opencons>:
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802272:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802275:	50                   	push   %eax
  802276:	e8 07 ef ff ff       	call   801182 <fd_alloc>
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	85 c0                	test   %eax,%eax
  802280:	78 3a                	js     8022bc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 07 04 00 00       	push   $0x407
  80228a:	ff 75 f4             	pushl  -0xc(%ebp)
  80228d:	6a 00                	push   $0x0
  80228f:	e8 12 e9 ff ff       	call   800ba6 <sys_page_alloc>
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	85 c0                	test   %eax,%eax
  802299:	78 21                	js     8022bc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	50                   	push   %eax
  8022b4:	e8 a2 ee ff ff       	call   80115b <fd2num>
  8022b9:	83 c4 10             	add    $0x10,%esp
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	56                   	push   %esi
  8022c2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8022c3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022c6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022cc:	e8 97 e8 ff ff       	call   800b68 <sys_getenvid>
  8022d1:	83 ec 0c             	sub    $0xc,%esp
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	ff 75 08             	pushl  0x8(%ebp)
  8022da:	56                   	push   %esi
  8022db:	50                   	push   %eax
  8022dc:	68 4c 2d 80 00       	push   $0x802d4c
  8022e1:	e8 f2 de ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022e6:	83 c4 18             	add    $0x18,%esp
  8022e9:	53                   	push   %ebx
  8022ea:	ff 75 10             	pushl  0x10(%ebp)
  8022ed:	e8 95 de ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  8022f2:	c7 04 24 6f 27 80 00 	movl   $0x80276f,(%esp)
  8022f9:	e8 da de ff ff       	call   8001d8 <cprintf>
  8022fe:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802301:	cc                   	int3   
  802302:	eb fd                	jmp    802301 <_panic+0x43>

00802304 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80230a:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802311:	74 0a                	je     80231d <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80231d:	a1 08 40 80 00       	mov    0x804008,%eax
  802322:	8b 40 48             	mov    0x48(%eax),%eax
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	6a 07                	push   $0x7
  80232a:	68 00 f0 bf ee       	push   $0xeebff000
  80232f:	50                   	push   %eax
  802330:	e8 71 e8 ff ff       	call   800ba6 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 2c                	js     802368 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80233c:	e8 27 e8 ff ff       	call   800b68 <sys_getenvid>
  802341:	83 ec 08             	sub    $0x8,%esp
  802344:	68 7a 23 80 00       	push   $0x80237a
  802349:	50                   	push   %eax
  80234a:	e8 a2 e9 ff ff       	call   800cf1 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	85 c0                	test   %eax,%eax
  802354:	79 bd                	jns    802313 <set_pgfault_handler+0xf>
  802356:	50                   	push   %eax
  802357:	68 6f 2d 80 00       	push   $0x802d6f
  80235c:	6a 23                	push   $0x23
  80235e:	68 87 2d 80 00       	push   $0x802d87
  802363:	e8 56 ff ff ff       	call   8022be <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802368:	50                   	push   %eax
  802369:	68 6f 2d 80 00       	push   $0x802d6f
  80236e:	6a 21                	push   $0x21
  802370:	68 87 2d 80 00       	push   $0x802d87
  802375:	e8 44 ff ff ff       	call   8022be <_panic>

0080237a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80237a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80237b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802380:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802382:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802385:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802389:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  80238c:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802390:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802394:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802397:	83 c4 08             	add    $0x8,%esp
	popal
  80239a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80239b:	83 c4 04             	add    $0x4,%esp
	popfl
  80239e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80239f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8023a0:	c3                   	ret    

008023a1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	56                   	push   %esi
  8023a5:	53                   	push   %ebx
  8023a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8023a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	74 4f                	je     802402 <ipc_recv+0x61>
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	50                   	push   %eax
  8023b7:	e8 9a e9 ff ff       	call   800d56 <sys_ipc_recv>
  8023bc:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8023bf:	85 f6                	test   %esi,%esi
  8023c1:	74 14                	je     8023d7 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8023c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 09                	jne    8023d5 <ipc_recv+0x34>
  8023cc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8023d2:	8b 52 74             	mov    0x74(%edx),%edx
  8023d5:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8023d7:	85 db                	test   %ebx,%ebx
  8023d9:	74 14                	je     8023ef <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8023db:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 09                	jne    8023ed <ipc_recv+0x4c>
  8023e4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8023ea:	8b 52 78             	mov    0x78(%edx),%edx
  8023ed:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	75 08                	jne    8023fb <ipc_recv+0x5a>
  8023f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8023f8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fe:	5b                   	pop    %ebx
  8023ff:	5e                   	pop    %esi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	68 00 00 c0 ee       	push   $0xeec00000
  80240a:	e8 47 e9 ff ff       	call   800d56 <sys_ipc_recv>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	eb ab                	jmp    8023bf <ipc_recv+0x1e>

00802414 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	57                   	push   %edi
  802418:	56                   	push   %esi
  802419:	53                   	push   %ebx
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802420:	8b 75 10             	mov    0x10(%ebp),%esi
  802423:	eb 20                	jmp    802445 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802425:	6a 00                	push   $0x0
  802427:	68 00 00 c0 ee       	push   $0xeec00000
  80242c:	ff 75 0c             	pushl  0xc(%ebp)
  80242f:	57                   	push   %edi
  802430:	e8 fe e8 ff ff       	call   800d33 <sys_ipc_try_send>
  802435:	89 c3                	mov    %eax,%ebx
  802437:	83 c4 10             	add    $0x10,%esp
  80243a:	eb 1f                	jmp    80245b <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80243c:	e8 46 e7 ff ff       	call   800b87 <sys_yield>
	while(retval != 0) {
  802441:	85 db                	test   %ebx,%ebx
  802443:	74 33                	je     802478 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802445:	85 f6                	test   %esi,%esi
  802447:	74 dc                	je     802425 <ipc_send+0x11>
  802449:	ff 75 14             	pushl  0x14(%ebp)
  80244c:	56                   	push   %esi
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	57                   	push   %edi
  802451:	e8 dd e8 ff ff       	call   800d33 <sys_ipc_try_send>
  802456:	89 c3                	mov    %eax,%ebx
  802458:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80245b:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80245e:	74 dc                	je     80243c <ipc_send+0x28>
  802460:	85 db                	test   %ebx,%ebx
  802462:	74 d8                	je     80243c <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802464:	83 ec 04             	sub    $0x4,%esp
  802467:	68 98 2d 80 00       	push   $0x802d98
  80246c:	6a 35                	push   $0x35
  80246e:	68 c8 2d 80 00       	push   $0x802dc8
  802473:	e8 46 fe ff ff       	call   8022be <_panic>
	}
}
  802478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    

00802480 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80248e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802494:	8b 52 50             	mov    0x50(%edx),%edx
  802497:	39 ca                	cmp    %ecx,%edx
  802499:	74 11                	je     8024ac <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80249b:	83 c0 01             	add    $0x1,%eax
  80249e:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024a3:	75 e6                	jne    80248b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024aa:	eb 0b                	jmp    8024b7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024b4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    

008024b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024bf:	89 d0                	mov    %edx,%eax
  8024c1:	c1 e8 16             	shr    $0x16,%eax
  8024c4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d0:	f6 c1 01             	test   $0x1,%cl
  8024d3:	74 1d                	je     8024f2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024d5:	c1 ea 0c             	shr    $0xc,%edx
  8024d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024df:	f6 c2 01             	test   $0x1,%dl
  8024e2:	74 0e                	je     8024f2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024e4:	c1 ea 0c             	shr    $0xc,%edx
  8024e7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024ee:	ef 
  8024ef:	0f b7 c0             	movzwl %ax,%eax
}
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
  8024f4:	66 90                	xchg   %ax,%ax
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	f3 0f 1e fb          	endbr32 
  802504:	55                   	push   %ebp
  802505:	57                   	push   %edi
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
  80250b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802513:	8b 74 24 34          	mov    0x34(%esp),%esi
  802517:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80251b:	85 d2                	test   %edx,%edx
  80251d:	75 49                	jne    802568 <__udivdi3+0x68>
  80251f:	39 f3                	cmp    %esi,%ebx
  802521:	76 15                	jbe    802538 <__udivdi3+0x38>
  802523:	31 ff                	xor    %edi,%edi
  802525:	89 e8                	mov    %ebp,%eax
  802527:	89 f2                	mov    %esi,%edx
  802529:	f7 f3                	div    %ebx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	89 d9                	mov    %ebx,%ecx
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	75 0b                	jne    802549 <__udivdi3+0x49>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 c1                	mov    %eax,%ecx
  802549:	31 d2                	xor    %edx,%edx
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	f7 f1                	div    %ecx
  80254f:	89 c6                	mov    %eax,%esi
  802551:	89 e8                	mov    %ebp,%eax
  802553:	89 f7                	mov    %esi,%edi
  802555:	f7 f1                	div    %ecx
  802557:	89 fa                	mov    %edi,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	39 f2                	cmp    %esi,%edx
  80256a:	77 1c                	ja     802588 <__udivdi3+0x88>
  80256c:	0f bd fa             	bsr    %edx,%edi
  80256f:	83 f7 1f             	xor    $0x1f,%edi
  802572:	75 2c                	jne    8025a0 <__udivdi3+0xa0>
  802574:	39 f2                	cmp    %esi,%edx
  802576:	72 06                	jb     80257e <__udivdi3+0x7e>
  802578:	31 c0                	xor    %eax,%eax
  80257a:	39 eb                	cmp    %ebp,%ebx
  80257c:	77 ad                	ja     80252b <__udivdi3+0x2b>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb a6                	jmp    80252b <__udivdi3+0x2b>
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	89 eb                	mov    %ebp,%ebx
  8025d1:	d3 e6                	shl    %cl,%esi
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 15                	jb     802600 <__udivdi3+0x100>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 04                	jae    8025f7 <__udivdi3+0xf7>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	74 09                	je     802600 <__udivdi3+0x100>
  8025f7:	89 d8                	mov    %ebx,%eax
  8025f9:	31 ff                	xor    %edi,%edi
  8025fb:	e9 2b ff ff ff       	jmp    80252b <__udivdi3+0x2b>
  802600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802603:	31 ff                	xor    %edi,%edi
  802605:	e9 21 ff ff ff       	jmp    80252b <__udivdi3+0x2b>
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80261f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802623:	8b 74 24 30          	mov    0x30(%esp),%esi
  802627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80262b:	89 da                	mov    %ebx,%edx
  80262d:	85 c0                	test   %eax,%eax
  80262f:	75 3f                	jne    802670 <__umoddi3+0x60>
  802631:	39 df                	cmp    %ebx,%edi
  802633:	76 13                	jbe    802648 <__umoddi3+0x38>
  802635:	89 f0                	mov    %esi,%eax
  802637:	f7 f7                	div    %edi
  802639:	89 d0                	mov    %edx,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	89 fd                	mov    %edi,%ebp
  80264a:	85 ff                	test   %edi,%edi
  80264c:	75 0b                	jne    802659 <__umoddi3+0x49>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f7                	div    %edi
  802657:	89 c5                	mov    %eax,%ebp
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f5                	div    %ebp
  80265f:	89 f0                	mov    %esi,%eax
  802661:	f7 f5                	div    %ebp
  802663:	89 d0                	mov    %edx,%eax
  802665:	eb d4                	jmp    80263b <__umoddi3+0x2b>
  802667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266e:	66 90                	xchg   %ax,%ax
  802670:	89 f1                	mov    %esi,%ecx
  802672:	39 d8                	cmp    %ebx,%eax
  802674:	76 0a                	jbe    802680 <__umoddi3+0x70>
  802676:	89 f0                	mov    %esi,%eax
  802678:	83 c4 1c             	add    $0x1c,%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	0f bd e8             	bsr    %eax,%ebp
  802683:	83 f5 1f             	xor    $0x1f,%ebp
  802686:	75 20                	jne    8026a8 <__umoddi3+0x98>
  802688:	39 d8                	cmp    %ebx,%eax
  80268a:	0f 82 b0 00 00 00    	jb     802740 <__umoddi3+0x130>
  802690:	39 f7                	cmp    %esi,%edi
  802692:	0f 86 a8 00 00 00    	jbe    802740 <__umoddi3+0x130>
  802698:	89 c8                	mov    %ecx,%eax
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	5b                   	pop    %ebx
  80269e:	5e                   	pop    %esi
  80269f:	5f                   	pop    %edi
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026af:	29 ea                	sub    %ebp,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b7:	89 d1                	mov    %edx,%ecx
  8026b9:	89 f8                	mov    %edi,%eax
  8026bb:	d3 e8                	shr    %cl,%eax
  8026bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026c9:	09 c1                	or     %eax,%ecx
  8026cb:	89 d8                	mov    %ebx,%eax
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	89 d1                	mov    %edx,%ecx
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	d3 e8                	shr    %cl,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	89 fa                	mov    %edi,%edx
  8026ed:	d3 e6                	shl    %cl,%esi
  8026ef:	09 d8                	or     %ebx,%eax
  8026f1:	f7 74 24 08          	divl   0x8(%esp)
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	89 f3                	mov    %esi,%ebx
  8026f9:	f7 64 24 0c          	mull   0xc(%esp)
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	89 d7                	mov    %edx,%edi
  802701:	39 d1                	cmp    %edx,%ecx
  802703:	72 06                	jb     80270b <__umoddi3+0xfb>
  802705:	75 10                	jne    802717 <__umoddi3+0x107>
  802707:	39 c3                	cmp    %eax,%ebx
  802709:	73 0c                	jae    802717 <__umoddi3+0x107>
  80270b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80270f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802713:	89 d7                	mov    %edx,%edi
  802715:	89 c6                	mov    %eax,%esi
  802717:	89 ca                	mov    %ecx,%edx
  802719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271e:	29 f3                	sub    %esi,%ebx
  802720:	19 fa                	sbb    %edi,%edx
  802722:	89 d0                	mov    %edx,%eax
  802724:	d3 e0                	shl    %cl,%eax
  802726:	89 e9                	mov    %ebp,%ecx
  802728:	d3 eb                	shr    %cl,%ebx
  80272a:	d3 ea                	shr    %cl,%edx
  80272c:	09 d8                	or     %ebx,%eax
  80272e:	83 c4 1c             	add    $0x1c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    
  802736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	89 da                	mov    %ebx,%edx
  802742:	29 fe                	sub    %edi,%esi
  802744:	19 c2                	sbb    %eax,%edx
  802746:	89 f1                	mov    %esi,%ecx
  802748:	89 c8                	mov    %ecx,%eax
  80274a:	e9 4b ff ff ff       	jmp    80269a <__umoddi3+0x8a>
