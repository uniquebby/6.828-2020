
obj/user/sendpage.debug：     文件格式 elf32-i386


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
  80002c:	e8 73 01 00 00       	call   8001a4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 b0 0f 00 00       	call   800fee <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 84 a5 00 00 00    	je     8000ee <umain+0xbb>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800049:	a1 08 40 80 00       	mov    0x804008,%eax
  80004e:	8b 40 48             	mov    0x48(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 a0 00       	push   $0xa00000
  80005b:	50                   	push   %eax
  80005c:	e8 06 0c 00 00       	call   800c67 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 30 80 00    	pushl  0x803004
  80006a:	e8 cd 07 00 00       	call   80083c <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 30 80 00    	pushl  0x803004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 df 09 00 00       	call   800a65 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 f8 11 00 00       	call   80128f <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 72 11 00 00       	call   80121c <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 20 28 80 00       	push   $0x802820
  8000ba:	e8 da 01 00 00       	call   800299 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 30 80 00    	pushl  0x803000
  8000c8:	e8 6f 07 00 00       	call   80083c <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 30 80 00    	pushl  0x803000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 65 08 00 00       	call   800946 <strncmp>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	0f 84 a3 00 00 00    	je     80018f <umain+0x15c>
		cprintf("parent received correct message\n");
	return;
}
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	6a 00                	push   $0x0
  8000f3:	68 00 00 b0 00       	push   $0xb00000
  8000f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 1b 11 00 00       	call   80121c <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 20 28 80 00       	push   $0x802820
  800111:	e8 83 01 00 00       	call   800299 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 30 80 00    	pushl  0x803004
  80011f:	e8 18 07 00 00       	call   80083c <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 30 80 00    	pushl  0x803004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 0e 08 00 00       	call   800946 <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 30 80 00    	pushl  0x803000
  800148:	e8 ef 06 00 00       	call   80083c <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 30 80 00    	pushl  0x803000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 01 09 00 00       	call   800a65 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 1a 11 00 00       	call   80128f <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 34 28 80 00       	push   $0x802834
  800185:	e8 0f 01 00 00       	call   800299 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 54 28 80 00       	push   $0x802854
  800197:	e8 fd 00 00 00       	call   800299 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	e9 48 ff ff ff       	jmp    8000ec <umain+0xb9>

008001a4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001af:	e8 75 0a 00 00       	call   800c29 <sys_getenvid>
  8001b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c1:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c6:	85 db                	test   %ebx,%ebx
  8001c8:	7e 07                	jle    8001d1 <libmain+0x2d>
		binaryname = argv[0];
  8001ca:	8b 06                	mov    (%esi),%eax
  8001cc:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	e8 58 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001db:	e8 0a 00 00 00       	call   8001ea <exit>
}
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001f0:	e8 17 13 00 00       	call   80150c <close_all>
	sys_env_destroy(0);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	6a 00                	push   $0x0
  8001fa:	e8 e9 09 00 00       	call   800be8 <sys_env_destroy>
}
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	53                   	push   %ebx
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80020e:	8b 13                	mov    (%ebx),%edx
  800210:	8d 42 01             	lea    0x1(%edx),%eax
  800213:	89 03                	mov    %eax,(%ebx)
  800215:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800218:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80021c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800221:	74 09                	je     80022c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800223:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800227:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	68 ff 00 00 00       	push   $0xff
  800234:	8d 43 08             	lea    0x8(%ebx),%eax
  800237:	50                   	push   %eax
  800238:	e8 6e 09 00 00       	call   800bab <sys_cputs>
		b->idx = 0;
  80023d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	eb db                	jmp    800223 <putch+0x1f>

00800248 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800251:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800258:	00 00 00 
	b.cnt = 0;
  80025b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800262:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800265:	ff 75 0c             	pushl  0xc(%ebp)
  800268:	ff 75 08             	pushl  0x8(%ebp)
  80026b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800271:	50                   	push   %eax
  800272:	68 04 02 80 00       	push   $0x800204
  800277:	e8 19 01 00 00       	call   800395 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80027c:	83 c4 08             	add    $0x8,%esp
  80027f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800285:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80028b:	50                   	push   %eax
  80028c:	e8 1a 09 00 00       	call   800bab <sys_cputs>

	return b.cnt;
}
  800291:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a2:	50                   	push   %eax
  8002a3:	ff 75 08             	pushl  0x8(%ebp)
  8002a6:	e8 9d ff ff ff       	call   800248 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	57                   	push   %edi
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
  8002b3:	83 ec 1c             	sub    $0x1c,%esp
  8002b6:	89 c7                	mov    %eax,%edi
  8002b8:	89 d6                	mov    %edx,%esi
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ce:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002d1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002d4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d7:	89 d0                	mov    %edx,%eax
  8002d9:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8002dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002df:	73 15                	jae    8002f6 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002e1:	83 eb 01             	sub    $0x1,%ebx
  8002e4:	85 db                	test   %ebx,%ebx
  8002e6:	7e 43                	jle    80032b <printnum+0x7e>
			putch(padc, putdat);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	56                   	push   %esi
  8002ec:	ff 75 18             	pushl  0x18(%ebp)
  8002ef:	ff d7                	call   *%edi
  8002f1:	83 c4 10             	add    $0x10,%esp
  8002f4:	eb eb                	jmp    8002e1 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	ff 75 18             	pushl  0x18(%ebp)
  8002fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800302:	53                   	push   %ebx
  800303:	ff 75 10             	pushl  0x10(%ebp)
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	ff 75 e0             	pushl  -0x20(%ebp)
  80030f:	ff 75 dc             	pushl  -0x24(%ebp)
  800312:	ff 75 d8             	pushl  -0x28(%ebp)
  800315:	e8 a6 22 00 00       	call   8025c0 <__udivdi3>
  80031a:	83 c4 18             	add    $0x18,%esp
  80031d:	52                   	push   %edx
  80031e:	50                   	push   %eax
  80031f:	89 f2                	mov    %esi,%edx
  800321:	89 f8                	mov    %edi,%eax
  800323:	e8 85 ff ff ff       	call   8002ad <printnum>
  800328:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	56                   	push   %esi
  80032f:	83 ec 04             	sub    $0x4,%esp
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	ff 75 e0             	pushl  -0x20(%ebp)
  800338:	ff 75 dc             	pushl  -0x24(%ebp)
  80033b:	ff 75 d8             	pushl  -0x28(%ebp)
  80033e:	e8 8d 23 00 00       	call   8026d0 <__umoddi3>
  800343:	83 c4 14             	add    $0x14,%esp
  800346:	0f be 80 cc 28 80 00 	movsbl 0x8028cc(%eax),%eax
  80034d:	50                   	push   %eax
  80034e:	ff d7                	call   *%edi
}
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800361:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800365:	8b 10                	mov    (%eax),%edx
  800367:	3b 50 04             	cmp    0x4(%eax),%edx
  80036a:	73 0a                	jae    800376 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036f:	89 08                	mov    %ecx,(%eax)
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	88 02                	mov    %al,(%edx)
}
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <printfmt>:
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800381:	50                   	push   %eax
  800382:	ff 75 10             	pushl  0x10(%ebp)
  800385:	ff 75 0c             	pushl  0xc(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 05 00 00 00       	call   800395 <vprintfmt>
}
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <vprintfmt>:
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	57                   	push   %edi
  800399:	56                   	push   %esi
  80039a:	53                   	push   %ebx
  80039b:	83 ec 3c             	sub    $0x3c,%esp
  80039e:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a7:	eb 0a                	jmp    8003b3 <vprintfmt+0x1e>
			putch(ch, putdat);
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	53                   	push   %ebx
  8003ad:	50                   	push   %eax
  8003ae:	ff d6                	call   *%esi
  8003b0:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b3:	83 c7 01             	add    $0x1,%edi
  8003b6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003ba:	83 f8 25             	cmp    $0x25,%eax
  8003bd:	74 0c                	je     8003cb <vprintfmt+0x36>
			if (ch == '\0')
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	75 e6                	jne    8003a9 <vprintfmt+0x14>
}
  8003c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    
		padc = ' ';
  8003cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8d 47 01             	lea    0x1(%edi),%eax
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ef:	0f b6 17             	movzbl (%edi),%edx
  8003f2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f5:	3c 55                	cmp    $0x55,%al
  8003f7:	0f 87 ba 03 00 00    	ja     8007b7 <vprintfmt+0x422>
  8003fd:	0f b6 c0             	movzbl %al,%eax
  800400:	ff 24 85 00 2a 80 00 	jmp    *0x802a00(,%eax,4)
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80040e:	eb d9                	jmp    8003e9 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800413:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800417:	eb d0                	jmp    8003e9 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800419:	0f b6 d2             	movzbl %dl,%edx
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800427:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80042e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800431:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800434:	83 f9 09             	cmp    $0x9,%ecx
  800437:	77 55                	ja     80048e <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800439:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043c:	eb e9                	jmp    800427 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80043e:	8b 45 14             	mov    0x14(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8d 40 04             	lea    0x4(%eax),%eax
  80044c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800452:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800456:	79 91                	jns    8003e9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800458:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800465:	eb 82                	jmp    8003e9 <vprintfmt+0x54>
  800467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046a:	85 c0                	test   %eax,%eax
  80046c:	ba 00 00 00 00       	mov    $0x0,%edx
  800471:	0f 49 d0             	cmovns %eax,%edx
  800474:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80047a:	e9 6a ff ff ff       	jmp    8003e9 <vprintfmt+0x54>
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800482:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800489:	e9 5b ff ff ff       	jmp    8003e9 <vprintfmt+0x54>
  80048e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800491:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800494:	eb bc                	jmp    800452 <vprintfmt+0xbd>
			lflag++;
  800496:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049c:	e9 48 ff ff ff       	jmp    8003e9 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8004a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a4:	8d 78 04             	lea    0x4(%eax),%edi
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	53                   	push   %ebx
  8004ab:	ff 30                	pushl  (%eax)
  8004ad:	ff d6                	call   *%esi
			break;
  8004af:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b5:	e9 9c 02 00 00       	jmp    800756 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 78 04             	lea    0x4(%eax),%edi
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	99                   	cltd   
  8004c3:	31 d0                	xor    %edx,%eax
  8004c5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c7:	83 f8 0f             	cmp    $0xf,%eax
  8004ca:	7f 23                	jg     8004ef <vprintfmt+0x15a>
  8004cc:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  8004d3:	85 d2                	test   %edx,%edx
  8004d5:	74 18                	je     8004ef <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8004d7:	52                   	push   %edx
  8004d8:	68 42 2e 80 00       	push   $0x802e42
  8004dd:	53                   	push   %ebx
  8004de:	56                   	push   %esi
  8004df:	e8 94 fe ff ff       	call   800378 <printfmt>
  8004e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ea:	e9 67 02 00 00       	jmp    800756 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8004ef:	50                   	push   %eax
  8004f0:	68 e4 28 80 00       	push   $0x8028e4
  8004f5:	53                   	push   %ebx
  8004f6:	56                   	push   %esi
  8004f7:	e8 7c fe ff ff       	call   800378 <printfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ff:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800502:	e9 4f 02 00 00       	jmp    800756 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	83 c0 04             	add    $0x4,%eax
  80050d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800515:	85 d2                	test   %edx,%edx
  800517:	b8 dd 28 80 00       	mov    $0x8028dd,%eax
  80051c:	0f 45 c2             	cmovne %edx,%eax
  80051f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800522:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800526:	7e 06                	jle    80052e <vprintfmt+0x199>
  800528:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80052c:	75 0d                	jne    80053b <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800531:	89 c7                	mov    %eax,%edi
  800533:	03 45 e0             	add    -0x20(%ebp),%eax
  800536:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800539:	eb 3f                	jmp    80057a <vprintfmt+0x1e5>
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 d8             	pushl  -0x28(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 0d 03 00 00       	call   800854 <strnlen>
  800547:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054a:	29 c2                	sub    %eax,%edx
  80054c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800554:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800558:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055b:	85 ff                	test   %edi,%edi
  80055d:	7e 58                	jle    8005b7 <vprintfmt+0x222>
					putch(padc, putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	ff 75 e0             	pushl  -0x20(%ebp)
  800566:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800568:	83 ef 01             	sub    $0x1,%edi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb eb                	jmp    80055b <vprintfmt+0x1c6>
					putch(ch, putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	52                   	push   %edx
  800575:	ff d6                	call   *%esi
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057f:	83 c7 01             	add    $0x1,%edi
  800582:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800586:	0f be d0             	movsbl %al,%edx
  800589:	85 d2                	test   %edx,%edx
  80058b:	74 45                	je     8005d2 <vprintfmt+0x23d>
  80058d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800591:	78 06                	js     800599 <vprintfmt+0x204>
  800593:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800597:	78 35                	js     8005ce <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800599:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80059d:	74 d1                	je     800570 <vprintfmt+0x1db>
  80059f:	0f be c0             	movsbl %al,%eax
  8005a2:	83 e8 20             	sub    $0x20,%eax
  8005a5:	83 f8 5e             	cmp    $0x5e,%eax
  8005a8:	76 c6                	jbe    800570 <vprintfmt+0x1db>
					putch('?', putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	6a 3f                	push   $0x3f
  8005b0:	ff d6                	call   *%esi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	eb c3                	jmp    80057a <vprintfmt+0x1e5>
  8005b7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005ba:	85 d2                	test   %edx,%edx
  8005bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c1:	0f 49 c2             	cmovns %edx,%eax
  8005c4:	29 c2                	sub    %eax,%edx
  8005c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005c9:	e9 60 ff ff ff       	jmp    80052e <vprintfmt+0x199>
  8005ce:	89 cf                	mov    %ecx,%edi
  8005d0:	eb 02                	jmp    8005d4 <vprintfmt+0x23f>
  8005d2:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8005d4:	85 ff                	test   %edi,%edi
  8005d6:	7e 10                	jle    8005e8 <vprintfmt+0x253>
				putch(' ', putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 20                	push   $0x20
  8005de:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e0:	83 ef 01             	sub    $0x1,%edi
  8005e3:	83 c4 10             	add    $0x10,%esp
  8005e6:	eb ec                	jmp    8005d4 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ee:	e9 63 01 00 00       	jmp    800756 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8005f3:	83 f9 01             	cmp    $0x1,%ecx
  8005f6:	7f 1b                	jg     800613 <vprintfmt+0x27e>
	else if (lflag)
  8005f8:	85 c9                	test   %ecx,%ecx
  8005fa:	74 63                	je     80065f <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	99                   	cltd   
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	eb 17                	jmp    80062a <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 08             	lea    0x8(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80062d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800635:	85 c9                	test   %ecx,%ecx
  800637:	0f 89 ff 00 00 00    	jns    80073c <vprintfmt+0x3a7>
				putch('-', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 2d                	push   $0x2d
  800643:	ff d6                	call   *%esi
				num = -(long long) num;
  800645:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800648:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80064b:	f7 da                	neg    %edx
  80064d:	83 d1 00             	adc    $0x0,%ecx
  800650:	f7 d9                	neg    %ecx
  800652:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065a:	e9 dd 00 00 00       	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	99                   	cltd   
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb b4                	jmp    80062a <vprintfmt+0x295>
	if (lflag >= 2)
  800676:	83 f9 01             	cmp    $0x1,%ecx
  800679:	7f 1e                	jg     800699 <vprintfmt+0x304>
	else if (lflag)
  80067b:	85 c9                	test   %ecx,%ecx
  80067d:	74 32                	je     8006b1 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800694:	e9 a3 00 00 00       	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 10                	mov    (%eax),%edx
  80069e:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a1:	8d 40 08             	lea    0x8(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ac:	e9 8b 00 00 00       	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 10                	mov    (%eax),%edx
  8006b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bb:	8d 40 04             	lea    0x4(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c6:	eb 74                	jmp    80073c <vprintfmt+0x3a7>
	if (lflag >= 2)
  8006c8:	83 f9 01             	cmp    $0x1,%ecx
  8006cb:	7f 1b                	jg     8006e8 <vprintfmt+0x353>
	else if (lflag)
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	74 2c                	je     8006fd <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e6:	eb 54                	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f0:	8d 40 08             	lea    0x8(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fb:	eb 3f                	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
  800712:	eb 28                	jmp    80073c <vprintfmt+0x3a7>
			putch('0', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 30                	push   $0x30
  80071a:	ff d6                	call   *%esi
			putch('x', putdat);
  80071c:	83 c4 08             	add    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 78                	push   $0x78
  800722:	ff d6                	call   *%esi
			num = (unsigned long long)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80072e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80073c:	83 ec 0c             	sub    $0xc,%esp
  80073f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800743:	57                   	push   %edi
  800744:	ff 75 e0             	pushl  -0x20(%ebp)
  800747:	50                   	push   %eax
  800748:	51                   	push   %ecx
  800749:	52                   	push   %edx
  80074a:	89 da                	mov    %ebx,%edx
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	e8 5a fb ff ff       	call   8002ad <printnum>
			break;
  800753:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800756:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	e9 55 fc ff ff       	jmp    8003b3 <vprintfmt+0x1e>
	if (lflag >= 2)
  80075e:	83 f9 01             	cmp    $0x1,%ecx
  800761:	7f 1b                	jg     80077e <vprintfmt+0x3e9>
	else if (lflag)
  800763:	85 c9                	test   %ecx,%ecx
  800765:	74 2c                	je     800793 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 10                	mov    (%eax),%edx
  80076c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
  80077c:	eb be                	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8b 10                	mov    (%eax),%edx
  800783:	8b 48 04             	mov    0x4(%eax),%ecx
  800786:	8d 40 08             	lea    0x8(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078c:	b8 10 00 00 00       	mov    $0x10,%eax
  800791:	eb a9                	jmp    80073c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 10                	mov    (%eax),%edx
  800798:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079d:	8d 40 04             	lea    0x4(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a8:	eb 92                	jmp    80073c <vprintfmt+0x3a7>
			putch(ch, putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	6a 25                	push   $0x25
  8007b0:	ff d6                	call   *%esi
			break;
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	eb 9f                	jmp    800756 <vprintfmt+0x3c1>
			putch('%', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	6a 25                	push   $0x25
  8007bd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	89 f8                	mov    %edi,%eax
  8007c4:	eb 03                	jmp    8007c9 <vprintfmt+0x434>
  8007c6:	83 e8 01             	sub    $0x1,%eax
  8007c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007cd:	75 f7                	jne    8007c6 <vprintfmt+0x431>
  8007cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d2:	eb 82                	jmp    800756 <vprintfmt+0x3c1>

008007d4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 18             	sub    $0x18,%esp
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	74 26                	je     80081b <vsnprintf+0x47>
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	7e 22                	jle    80081b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f9:	ff 75 14             	pushl  0x14(%ebp)
  8007fc:	ff 75 10             	pushl  0x10(%ebp)
  8007ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800802:	50                   	push   %eax
  800803:	68 5b 03 80 00       	push   $0x80035b
  800808:	e8 88 fb ff ff       	call   800395 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80080d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800810:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800816:	83 c4 10             	add    $0x10,%esp
}
  800819:	c9                   	leave  
  80081a:	c3                   	ret    
		return -E_INVAL;
  80081b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800820:	eb f7                	jmp    800819 <vsnprintf+0x45>

00800822 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800828:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80082b:	50                   	push   %eax
  80082c:	ff 75 10             	pushl  0x10(%ebp)
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	ff 75 08             	pushl  0x8(%ebp)
  800835:	e8 9a ff ff ff       	call   8007d4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084b:	74 05                	je     800852 <strlen+0x16>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
  800850:	eb f5                	jmp    800847 <strlen+0xb>
	return n;
}
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085d:	ba 00 00 00 00       	mov    $0x0,%edx
  800862:	39 c2                	cmp    %eax,%edx
  800864:	74 0d                	je     800873 <strnlen+0x1f>
  800866:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80086a:	74 05                	je     800871 <strnlen+0x1d>
		n++;
  80086c:	83 c2 01             	add    $0x1,%edx
  80086f:	eb f1                	jmp    800862 <strnlen+0xe>
  800871:	89 d0                	mov    %edx,%eax
	return n;
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	53                   	push   %ebx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
  800884:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800888:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80088b:	83 c2 01             	add    $0x1,%edx
  80088e:	84 c9                	test   %cl,%cl
  800890:	75 f2                	jne    800884 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800892:	5b                   	pop    %ebx
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	83 ec 10             	sub    $0x10,%esp
  80089c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80089f:	53                   	push   %ebx
  8008a0:	e8 97 ff ff ff       	call   80083c <strlen>
  8008a5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	01 d8                	add    %ebx,%eax
  8008ad:	50                   	push   %eax
  8008ae:	e8 c2 ff ff ff       	call   800875 <strcpy>
	return dst;
}
  8008b3:	89 d8                	mov    %ebx,%eax
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	56                   	push   %esi
  8008be:	53                   	push   %ebx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c5:	89 c6                	mov    %eax,%esi
  8008c7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ca:	89 c2                	mov    %eax,%edx
  8008cc:	39 f2                	cmp    %esi,%edx
  8008ce:	74 11                	je     8008e1 <strncpy+0x27>
		*dst++ = *src;
  8008d0:	83 c2 01             	add    $0x1,%edx
  8008d3:	0f b6 19             	movzbl (%ecx),%ebx
  8008d6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d9:	80 fb 01             	cmp    $0x1,%bl
  8008dc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008df:	eb eb                	jmp    8008cc <strncpy+0x12>
	}
	return ret;
}
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f0:	8b 55 10             	mov    0x10(%ebp),%edx
  8008f3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f5:	85 d2                	test   %edx,%edx
  8008f7:	74 21                	je     80091a <strlcpy+0x35>
  8008f9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008fd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008ff:	39 c2                	cmp    %eax,%edx
  800901:	74 14                	je     800917 <strlcpy+0x32>
  800903:	0f b6 19             	movzbl (%ecx),%ebx
  800906:	84 db                	test   %bl,%bl
  800908:	74 0b                	je     800915 <strlcpy+0x30>
			*dst++ = *src++;
  80090a:	83 c1 01             	add    $0x1,%ecx
  80090d:	83 c2 01             	add    $0x1,%edx
  800910:	88 5a ff             	mov    %bl,-0x1(%edx)
  800913:	eb ea                	jmp    8008ff <strlcpy+0x1a>
  800915:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800917:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80091a:	29 f0                	sub    %esi,%eax
}
  80091c:	5b                   	pop    %ebx
  80091d:	5e                   	pop    %esi
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800926:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	84 c0                	test   %al,%al
  80092e:	74 0c                	je     80093c <strcmp+0x1c>
  800930:	3a 02                	cmp    (%edx),%al
  800932:	75 08                	jne    80093c <strcmp+0x1c>
		p++, q++;
  800934:	83 c1 01             	add    $0x1,%ecx
  800937:	83 c2 01             	add    $0x1,%edx
  80093a:	eb ed                	jmp    800929 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093c:	0f b6 c0             	movzbl %al,%eax
  80093f:	0f b6 12             	movzbl (%edx),%edx
  800942:	29 d0                	sub    %edx,%eax
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	53                   	push   %ebx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800950:	89 c3                	mov    %eax,%ebx
  800952:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800955:	eb 06                	jmp    80095d <strncmp+0x17>
		n--, p++, q++;
  800957:	83 c0 01             	add    $0x1,%eax
  80095a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095d:	39 d8                	cmp    %ebx,%eax
  80095f:	74 16                	je     800977 <strncmp+0x31>
  800961:	0f b6 08             	movzbl (%eax),%ecx
  800964:	84 c9                	test   %cl,%cl
  800966:	74 04                	je     80096c <strncmp+0x26>
  800968:	3a 0a                	cmp    (%edx),%cl
  80096a:	74 eb                	je     800957 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096c:	0f b6 00             	movzbl (%eax),%eax
  80096f:	0f b6 12             	movzbl (%edx),%edx
  800972:	29 d0                	sub    %edx,%eax
}
  800974:	5b                   	pop    %ebx
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    
		return 0;
  800977:	b8 00 00 00 00       	mov    $0x0,%eax
  80097c:	eb f6                	jmp    800974 <strncmp+0x2e>

0080097e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800988:	0f b6 10             	movzbl (%eax),%edx
  80098b:	84 d2                	test   %dl,%dl
  80098d:	74 09                	je     800998 <strchr+0x1a>
		if (*s == c)
  80098f:	38 ca                	cmp    %cl,%dl
  800991:	74 0a                	je     80099d <strchr+0x1f>
	for (; *s; s++)
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	eb f0                	jmp    800988 <strchr+0xa>
			return (char *) s;
	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ac:	38 ca                	cmp    %cl,%dl
  8009ae:	74 09                	je     8009b9 <strfind+0x1a>
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	74 05                	je     8009b9 <strfind+0x1a>
	for (; *s; s++)
  8009b4:	83 c0 01             	add    $0x1,%eax
  8009b7:	eb f0                	jmp    8009a9 <strfind+0xa>
			break;
	return (char *) s;
}
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	57                   	push   %edi
  8009bf:	56                   	push   %esi
  8009c0:	53                   	push   %ebx
  8009c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c7:	85 c9                	test   %ecx,%ecx
  8009c9:	74 31                	je     8009fc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009cb:	89 f8                	mov    %edi,%eax
  8009cd:	09 c8                	or     %ecx,%eax
  8009cf:	a8 03                	test   $0x3,%al
  8009d1:	75 23                	jne    8009f6 <memset+0x3b>
		c &= 0xFF;
  8009d3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d7:	89 d3                	mov    %edx,%ebx
  8009d9:	c1 e3 08             	shl    $0x8,%ebx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 18             	shl    $0x18,%eax
  8009e1:	89 d6                	mov    %edx,%esi
  8009e3:	c1 e6 10             	shl    $0x10,%esi
  8009e6:	09 f0                	or     %esi,%eax
  8009e8:	09 c2                	or     %eax,%edx
  8009ea:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ec:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ef:	89 d0                	mov    %edx,%eax
  8009f1:	fc                   	cld    
  8009f2:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f4:	eb 06                	jmp    8009fc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	fc                   	cld    
  8009fa:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fc:	89 f8                	mov    %edi,%eax
  8009fe:	5b                   	pop    %ebx
  8009ff:	5e                   	pop    %esi
  800a00:	5f                   	pop    %edi
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	57                   	push   %edi
  800a07:	56                   	push   %esi
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a11:	39 c6                	cmp    %eax,%esi
  800a13:	73 32                	jae    800a47 <memmove+0x44>
  800a15:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a18:	39 c2                	cmp    %eax,%edx
  800a1a:	76 2b                	jbe    800a47 <memmove+0x44>
		s += n;
		d += n;
  800a1c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	89 fe                	mov    %edi,%esi
  800a21:	09 ce                	or     %ecx,%esi
  800a23:	09 d6                	or     %edx,%esi
  800a25:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2b:	75 0e                	jne    800a3b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a2d:	83 ef 04             	sub    $0x4,%edi
  800a30:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a33:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a36:	fd                   	std    
  800a37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a39:	eb 09                	jmp    800a44 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3b:	83 ef 01             	sub    $0x1,%edi
  800a3e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a41:	fd                   	std    
  800a42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a44:	fc                   	cld    
  800a45:	eb 1a                	jmp    800a61 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a47:	89 c2                	mov    %eax,%edx
  800a49:	09 ca                	or     %ecx,%edx
  800a4b:	09 f2                	or     %esi,%edx
  800a4d:	f6 c2 03             	test   $0x3,%dl
  800a50:	75 0a                	jne    800a5c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a55:	89 c7                	mov    %eax,%edi
  800a57:	fc                   	cld    
  800a58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5a:	eb 05                	jmp    800a61 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a61:	5e                   	pop    %esi
  800a62:	5f                   	pop    %edi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a6b:	ff 75 10             	pushl  0x10(%ebp)
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	e8 8a ff ff ff       	call   800a03 <memmove>
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a86:	89 c6                	mov    %eax,%esi
  800a88:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8b:	39 f0                	cmp    %esi,%eax
  800a8d:	74 1c                	je     800aab <memcmp+0x30>
		if (*s1 != *s2)
  800a8f:	0f b6 08             	movzbl (%eax),%ecx
  800a92:	0f b6 1a             	movzbl (%edx),%ebx
  800a95:	38 d9                	cmp    %bl,%cl
  800a97:	75 08                	jne    800aa1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a99:	83 c0 01             	add    $0x1,%eax
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	eb ea                	jmp    800a8b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aa1:	0f b6 c1             	movzbl %cl,%eax
  800aa4:	0f b6 db             	movzbl %bl,%ebx
  800aa7:	29 d8                	sub    %ebx,%eax
  800aa9:	eb 05                	jmp    800ab0 <memcmp+0x35>
	}

	return 0;
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab0:	5b                   	pop    %ebx
  800ab1:	5e                   	pop    %esi
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800abd:	89 c2                	mov    %eax,%edx
  800abf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac2:	39 d0                	cmp    %edx,%eax
  800ac4:	73 09                	jae    800acf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac6:	38 08                	cmp    %cl,(%eax)
  800ac8:	74 05                	je     800acf <memfind+0x1b>
	for (; s < ends; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	eb f3                	jmp    800ac2 <memfind+0xe>
			break;
	return (void *) s;
}
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	57                   	push   %edi
  800ad5:	56                   	push   %esi
  800ad6:	53                   	push   %ebx
  800ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ada:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800add:	eb 03                	jmp    800ae2 <strtol+0x11>
		s++;
  800adf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae2:	0f b6 01             	movzbl (%ecx),%eax
  800ae5:	3c 20                	cmp    $0x20,%al
  800ae7:	74 f6                	je     800adf <strtol+0xe>
  800ae9:	3c 09                	cmp    $0x9,%al
  800aeb:	74 f2                	je     800adf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aed:	3c 2b                	cmp    $0x2b,%al
  800aef:	74 2a                	je     800b1b <strtol+0x4a>
	int neg = 0;
  800af1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af6:	3c 2d                	cmp    $0x2d,%al
  800af8:	74 2b                	je     800b25 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b00:	75 0f                	jne    800b11 <strtol+0x40>
  800b02:	80 39 30             	cmpb   $0x30,(%ecx)
  800b05:	74 28                	je     800b2f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b07:	85 db                	test   %ebx,%ebx
  800b09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0e:	0f 44 d8             	cmove  %eax,%ebx
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b19:	eb 50                	jmp    800b6b <strtol+0x9a>
		s++;
  800b1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b23:	eb d5                	jmp    800afa <strtol+0x29>
		s++, neg = 1;
  800b25:	83 c1 01             	add    $0x1,%ecx
  800b28:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2d:	eb cb                	jmp    800afa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b33:	74 0e                	je     800b43 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	75 d8                	jne    800b11 <strtol+0x40>
		s++, base = 8;
  800b39:	83 c1 01             	add    $0x1,%ecx
  800b3c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b41:	eb ce                	jmp    800b11 <strtol+0x40>
		s += 2, base = 16;
  800b43:	83 c1 02             	add    $0x2,%ecx
  800b46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4b:	eb c4                	jmp    800b11 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b4d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b50:	89 f3                	mov    %esi,%ebx
  800b52:	80 fb 19             	cmp    $0x19,%bl
  800b55:	77 29                	ja     800b80 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b57:	0f be d2             	movsbl %dl,%edx
  800b5a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b60:	7d 30                	jge    800b92 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b62:	83 c1 01             	add    $0x1,%ecx
  800b65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b69:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b6b:	0f b6 11             	movzbl (%ecx),%edx
  800b6e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b71:	89 f3                	mov    %esi,%ebx
  800b73:	80 fb 09             	cmp    $0x9,%bl
  800b76:	77 d5                	ja     800b4d <strtol+0x7c>
			dig = *s - '0';
  800b78:	0f be d2             	movsbl %dl,%edx
  800b7b:	83 ea 30             	sub    $0x30,%edx
  800b7e:	eb dd                	jmp    800b5d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b83:	89 f3                	mov    %esi,%ebx
  800b85:	80 fb 19             	cmp    $0x19,%bl
  800b88:	77 08                	ja     800b92 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b8a:	0f be d2             	movsbl %dl,%edx
  800b8d:	83 ea 37             	sub    $0x37,%edx
  800b90:	eb cb                	jmp    800b5d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b96:	74 05                	je     800b9d <strtol+0xcc>
		*endptr = (char *) s;
  800b98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	f7 da                	neg    %edx
  800ba1:	85 ff                	test   %edi,%edi
  800ba3:	0f 45 c2             	cmovne %edx,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5f                   	pop    %edi
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbc:	89 c3                	mov    %eax,%ebx
  800bbe:	89 c7                	mov    %eax,%edi
  800bc0:	89 c6                	mov    %eax,%esi
  800bc2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd9:	89 d1                	mov    %edx,%ecx
  800bdb:	89 d3                	mov    %edx,%ebx
  800bdd:	89 d7                	mov    %edx,%edi
  800bdf:	89 d6                	mov    %edx,%esi
  800be1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfe:	89 cb                	mov    %ecx,%ebx
  800c00:	89 cf                	mov    %ecx,%edi
  800c02:	89 ce                	mov    %ecx,%esi
  800c04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c06:	85 c0                	test   %eax,%eax
  800c08:	7f 08                	jg     800c12 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c12:	83 ec 0c             	sub    $0xc,%esp
  800c15:	50                   	push   %eax
  800c16:	6a 03                	push   $0x3
  800c18:	68 bf 2b 80 00       	push   $0x802bbf
  800c1d:	6a 23                	push   $0x23
  800c1f:	68 dc 2b 80 00       	push   $0x802bdc
  800c24:	e8 6e 18 00 00       	call   802497 <_panic>

00800c29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 02 00 00 00       	mov    $0x2,%eax
  800c39:	89 d1                	mov    %edx,%ecx
  800c3b:	89 d3                	mov    %edx,%ebx
  800c3d:	89 d7                	mov    %edx,%edi
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_yield>:

void
sys_yield(void)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c58:	89 d1                	mov    %edx,%ecx
  800c5a:	89 d3                	mov    %edx,%ebx
  800c5c:	89 d7                	mov    %edx,%edi
  800c5e:	89 d6                	mov    %edx,%esi
  800c60:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c70:	be 00 00 00 00       	mov    $0x0,%esi
  800c75:	8b 55 08             	mov    0x8(%ebp),%edx
  800c78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c83:	89 f7                	mov    %esi,%edi
  800c85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	7f 08                	jg     800c93 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	50                   	push   %eax
  800c97:	6a 04                	push   $0x4
  800c99:	68 bf 2b 80 00       	push   $0x802bbf
  800c9e:	6a 23                	push   $0x23
  800ca0:	68 dc 2b 80 00       	push   $0x802bdc
  800ca5:	e8 ed 17 00 00       	call   802497 <_panic>

00800caa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	b8 05 00 00 00       	mov    $0x5,%eax
  800cbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc4:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 05                	push   $0x5
  800cdb:	68 bf 2b 80 00       	push   $0x802bbf
  800ce0:	6a 23                	push   $0x23
  800ce2:	68 dc 2b 80 00       	push   $0x802bdc
  800ce7:	e8 ab 17 00 00       	call   802497 <_panic>

00800cec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	b8 06 00 00 00       	mov    $0x6,%eax
  800d05:	89 df                	mov    %ebx,%edi
  800d07:	89 de                	mov    %ebx,%esi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 06                	push   $0x6
  800d1d:	68 bf 2b 80 00       	push   $0x802bbf
  800d22:	6a 23                	push   $0x23
  800d24:	68 dc 2b 80 00       	push   $0x802bdc
  800d29:	e8 69 17 00 00       	call   802497 <_panic>

00800d2e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 08 00 00 00       	mov    $0x8,%eax
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	89 de                	mov    %ebx,%esi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 08                	push   $0x8
  800d5f:	68 bf 2b 80 00       	push   $0x802bbf
  800d64:	6a 23                	push   $0x23
  800d66:	68 dc 2b 80 00       	push   $0x802bdc
  800d6b:	e8 27 17 00 00       	call   802497 <_panic>

00800d70 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 09 00 00 00       	mov    $0x9,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 09                	push   $0x9
  800da1:	68 bf 2b 80 00       	push   $0x802bbf
  800da6:	6a 23                	push   $0x23
  800da8:	68 dc 2b 80 00       	push   $0x802bdc
  800dad:	e8 e5 16 00 00       	call   802497 <_panic>

00800db2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	50                   	push   %eax
  800de1:	6a 0a                	push   $0xa
  800de3:	68 bf 2b 80 00       	push   $0x802bbf
  800de8:	6a 23                	push   $0x23
  800dea:	68 dc 2b 80 00       	push   $0x802bdc
  800def:	e8 a3 16 00 00       	call   802497 <_panic>

00800df4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e05:	be 00 00 00 00       	mov    $0x0,%esi
  800e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e10:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e25:	8b 55 08             	mov    0x8(%ebp),%edx
  800e28:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2d:	89 cb                	mov    %ecx,%ebx
  800e2f:	89 cf                	mov    %ecx,%edi
  800e31:	89 ce                	mov    %ecx,%esi
  800e33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	7f 08                	jg     800e41 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 0d                	push   $0xd
  800e47:	68 bf 2b 80 00       	push   $0x802bbf
  800e4c:	6a 23                	push   $0x23
  800e4e:	68 dc 2b 80 00       	push   $0x802bdc
  800e53:	e8 3f 16 00 00       	call   802497 <_panic>

00800e58 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e63:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e68:	89 d1                	mov    %edx,%ecx
  800e6a:	89 d3                	mov    %edx,%ebx
  800e6c:	89 d7                	mov    %edx,%edi
  800e6e:	89 d6                	mov    %edx,%esi
  800e70:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e83:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800e85:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800e88:	89 d9                	mov    %ebx,%ecx
  800e8a:	c1 e9 16             	shr    $0x16,%ecx
  800e8d:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800e94:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800e99:	f6 c1 01             	test   $0x1,%cl
  800e9c:	74 0c                	je     800eaa <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800e9e:	89 d9                	mov    %ebx,%ecx
  800ea0:	c1 e9 0c             	shr    $0xc,%ecx
  800ea3:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800eaa:	f6 c2 02             	test   $0x2,%dl
  800ead:	0f 84 a3 00 00 00    	je     800f56 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800eb3:	89 da                	mov    %ebx,%edx
  800eb5:	c1 ea 0c             	shr    $0xc,%edx
  800eb8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ebf:	f6 c6 08             	test   $0x8,%dh
  800ec2:	0f 84 b7 00 00 00    	je     800f7f <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800ec8:	e8 5c fd ff ff       	call   800c29 <sys_getenvid>
  800ecd:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800ecf:	83 ec 04             	sub    $0x4,%esp
  800ed2:	6a 07                	push   $0x7
  800ed4:	68 00 f0 7f 00       	push   $0x7ff000
  800ed9:	50                   	push   %eax
  800eda:	e8 88 fd ff ff       	call   800c67 <sys_page_alloc>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	0f 88 bc 00 00 00    	js     800fa6 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800eea:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800ef0:	83 ec 04             	sub    $0x4,%esp
  800ef3:	68 00 10 00 00       	push   $0x1000
  800ef8:	53                   	push   %ebx
  800ef9:	68 00 f0 7f 00       	push   $0x7ff000
  800efe:	e8 00 fb ff ff       	call   800a03 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800f03:	83 c4 08             	add    $0x8,%esp
  800f06:	53                   	push   %ebx
  800f07:	56                   	push   %esi
  800f08:	e8 df fd ff ff       	call   800cec <sys_page_unmap>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	0f 88 a0 00 00 00    	js     800fb8 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	6a 07                	push   $0x7
  800f1d:	53                   	push   %ebx
  800f1e:	56                   	push   %esi
  800f1f:	68 00 f0 7f 00       	push   $0x7ff000
  800f24:	56                   	push   %esi
  800f25:	e8 80 fd ff ff       	call   800caa <sys_page_map>
  800f2a:	83 c4 20             	add    $0x20,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	0f 88 95 00 00 00    	js     800fca <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	68 00 f0 7f 00       	push   $0x7ff000
  800f3d:	56                   	push   %esi
  800f3e:	e8 a9 fd ff ff       	call   800cec <sys_page_unmap>
  800f43:	83 c4 10             	add    $0x10,%esp
  800f46:	85 c0                	test   %eax,%eax
  800f48:	0f 88 8e 00 00 00    	js     800fdc <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800f56:	8b 70 28             	mov    0x28(%eax),%esi
  800f59:	e8 cb fc ff ff       	call   800c29 <sys_getenvid>
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	50                   	push   %eax
  800f61:	68 ec 2b 80 00       	push   $0x802bec
  800f66:	e8 2e f3 ff ff       	call   800299 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800f6b:	83 c4 0c             	add    $0xc,%esp
  800f6e:	68 10 2c 80 00       	push   $0x802c10
  800f73:	6a 27                	push   $0x27
  800f75:	68 e4 2c 80 00       	push   $0x802ce4
  800f7a:	e8 18 15 00 00       	call   802497 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800f7f:	8b 78 28             	mov    0x28(%eax),%edi
  800f82:	e8 a2 fc ff ff       	call   800c29 <sys_getenvid>
  800f87:	57                   	push   %edi
  800f88:	53                   	push   %ebx
  800f89:	50                   	push   %eax
  800f8a:	68 ec 2b 80 00       	push   $0x802bec
  800f8f:	e8 05 f3 ff ff       	call   800299 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800f94:	56                   	push   %esi
  800f95:	68 44 2c 80 00       	push   $0x802c44
  800f9a:	6a 2b                	push   $0x2b
  800f9c:	68 e4 2c 80 00       	push   $0x802ce4
  800fa1:	e8 f1 14 00 00       	call   802497 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800fa6:	50                   	push   %eax
  800fa7:	68 7c 2c 80 00       	push   $0x802c7c
  800fac:	6a 39                	push   $0x39
  800fae:	68 e4 2c 80 00       	push   $0x802ce4
  800fb3:	e8 df 14 00 00       	call   802497 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800fb8:	50                   	push   %eax
  800fb9:	68 a0 2c 80 00       	push   $0x802ca0
  800fbe:	6a 3e                	push   $0x3e
  800fc0:	68 e4 2c 80 00       	push   $0x802ce4
  800fc5:	e8 cd 14 00 00       	call   802497 <_panic>
      panic("pgfault: page map failed (%e)", r);
  800fca:	50                   	push   %eax
  800fcb:	68 ef 2c 80 00       	push   $0x802cef
  800fd0:	6a 40                	push   $0x40
  800fd2:	68 e4 2c 80 00       	push   $0x802ce4
  800fd7:	e8 bb 14 00 00       	call   802497 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800fdc:	50                   	push   %eax
  800fdd:	68 a0 2c 80 00       	push   $0x802ca0
  800fe2:	6a 42                	push   $0x42
  800fe4:	68 e4 2c 80 00       	push   $0x802ce4
  800fe9:	e8 a9 14 00 00       	call   802497 <_panic>

00800fee <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800ff7:	68 77 0e 80 00       	push   $0x800e77
  800ffc:	e8 dc 14 00 00       	call   8024dd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801001:	b8 07 00 00 00       	mov    $0x7,%eax
  801006:	cd 30                	int    $0x30
  801008:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	78 2d                	js     80103f <fork+0x51>
  801012:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  801019:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80101d:	0f 85 a6 00 00 00    	jne    8010c9 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  801023:	e8 01 fc ff ff       	call   800c29 <sys_getenvid>
  801028:	25 ff 03 00 00       	and    $0x3ff,%eax
  80102d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801030:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801035:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  80103a:	e9 79 01 00 00       	jmp    8011b8 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  80103f:	50                   	push   %eax
  801040:	68 0d 2d 80 00       	push   $0x802d0d
  801045:	68 aa 00 00 00       	push   $0xaa
  80104a:	68 e4 2c 80 00       	push   $0x802ce4
  80104f:	e8 43 14 00 00       	call   802497 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	6a 05                	push   $0x5
  801059:	53                   	push   %ebx
  80105a:	57                   	push   %edi
  80105b:	53                   	push   %ebx
  80105c:	6a 00                	push   $0x0
  80105e:	e8 47 fc ff ff       	call   800caa <sys_page_map>
  801063:	83 c4 20             	add    $0x20,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	79 4d                	jns    8010b7 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80106a:	50                   	push   %eax
  80106b:	68 16 2d 80 00       	push   $0x802d16
  801070:	6a 61                	push   $0x61
  801072:	68 e4 2c 80 00       	push   $0x802ce4
  801077:	e8 1b 14 00 00       	call   802497 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80107c:	83 ec 0c             	sub    $0xc,%esp
  80107f:	68 05 08 00 00       	push   $0x805
  801084:	53                   	push   %ebx
  801085:	57                   	push   %edi
  801086:	53                   	push   %ebx
  801087:	6a 00                	push   $0x0
  801089:	e8 1c fc ff ff       	call   800caa <sys_page_map>
  80108e:	83 c4 20             	add    $0x20,%esp
  801091:	85 c0                	test   %eax,%eax
  801093:	0f 88 b7 00 00 00    	js     801150 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801099:	83 ec 0c             	sub    $0xc,%esp
  80109c:	68 05 08 00 00       	push   $0x805
  8010a1:	53                   	push   %ebx
  8010a2:	6a 00                	push   $0x0
  8010a4:	53                   	push   %ebx
  8010a5:	6a 00                	push   $0x0
  8010a7:	e8 fe fb ff ff       	call   800caa <sys_page_map>
  8010ac:	83 c4 20             	add    $0x20,%esp
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	0f 88 ab 00 00 00    	js     801162 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010bd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010c3:	0f 84 ab 00 00 00    	je     801174 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	c1 e8 16             	shr    $0x16,%eax
  8010ce:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010d5:	a8 01                	test   $0x1,%al
  8010d7:	74 de                	je     8010b7 <fork+0xc9>
  8010d9:	89 d8                	mov    %ebx,%eax
  8010db:	c1 e8 0c             	shr    $0xc,%eax
  8010de:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 cd                	je     8010b7 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  8010ea:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  8010ed:	89 c2                	mov    %eax,%edx
  8010ef:	c1 ea 16             	shr    $0x16,%edx
  8010f2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f9:	f6 c2 01             	test   $0x1,%dl
  8010fc:	74 b9                	je     8010b7 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  8010fe:	c1 e8 0c             	shr    $0xc,%eax
  801101:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801108:	a8 01                	test   $0x1,%al
  80110a:	74 ab                	je     8010b7 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  80110c:	a9 02 08 00 00       	test   $0x802,%eax
  801111:	0f 84 3d ff ff ff    	je     801054 <fork+0x66>
	else if(pte & PTE_SHARE)
  801117:	f6 c4 04             	test   $0x4,%ah
  80111a:	0f 84 5c ff ff ff    	je     80107c <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	25 07 0e 00 00       	and    $0xe07,%eax
  801128:	50                   	push   %eax
  801129:	53                   	push   %ebx
  80112a:	57                   	push   %edi
  80112b:	53                   	push   %ebx
  80112c:	6a 00                	push   $0x0
  80112e:	e8 77 fb ff ff       	call   800caa <sys_page_map>
  801133:	83 c4 20             	add    $0x20,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	0f 89 79 ff ff ff    	jns    8010b7 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80113e:	50                   	push   %eax
  80113f:	68 16 2d 80 00       	push   $0x802d16
  801144:	6a 67                	push   $0x67
  801146:	68 e4 2c 80 00       	push   $0x802ce4
  80114b:	e8 47 13 00 00       	call   802497 <_panic>
			panic("Page Map Failed: %e", error_code);
  801150:	50                   	push   %eax
  801151:	68 16 2d 80 00       	push   $0x802d16
  801156:	6a 6d                	push   $0x6d
  801158:	68 e4 2c 80 00       	push   $0x802ce4
  80115d:	e8 35 13 00 00       	call   802497 <_panic>
			panic("Page Map Failed: %e", error_code);
  801162:	50                   	push   %eax
  801163:	68 16 2d 80 00       	push   $0x802d16
  801168:	6a 70                	push   $0x70
  80116a:	68 e4 2c 80 00       	push   $0x802ce4
  80116f:	e8 23 13 00 00       	call   802497 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	6a 07                	push   $0x7
  801179:	68 00 f0 bf ee       	push   $0xeebff000
  80117e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801181:	e8 e1 fa ff ff       	call   800c67 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	78 36                	js     8011c3 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	68 53 25 80 00       	push   $0x802553
  801195:	ff 75 e4             	pushl  -0x1c(%ebp)
  801198:	e8 15 fc ff ff       	call   800db2 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80119d:	83 c4 10             	add    $0x10,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	78 34                	js     8011d8 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	6a 02                	push   $0x2
  8011a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ac:	e8 7d fb ff ff       	call   800d2e <sys_env_set_status>
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 35                	js     8011ed <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8011b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011be:	5b                   	pop    %ebx
  8011bf:	5e                   	pop    %esi
  8011c0:	5f                   	pop    %edi
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  8011c3:	50                   	push   %eax
  8011c4:	68 0d 2d 80 00       	push   $0x802d0d
  8011c9:	68 ba 00 00 00       	push   $0xba
  8011ce:	68 e4 2c 80 00       	push   $0x802ce4
  8011d3:	e8 bf 12 00 00       	call   802497 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8011d8:	50                   	push   %eax
  8011d9:	68 c0 2c 80 00       	push   $0x802cc0
  8011de:	68 bf 00 00 00       	push   $0xbf
  8011e3:	68 e4 2c 80 00       	push   $0x802ce4
  8011e8:	e8 aa 12 00 00       	call   802497 <_panic>
      panic("sys_env_set_status: %e", r);
  8011ed:	50                   	push   %eax
  8011ee:	68 2a 2d 80 00       	push   $0x802d2a
  8011f3:	68 c3 00 00 00       	push   $0xc3
  8011f8:	68 e4 2c 80 00       	push   $0x802ce4
  8011fd:	e8 95 12 00 00       	call   802497 <_panic>

00801202 <sfork>:

// Challenge!
int
sfork(void)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801208:	68 41 2d 80 00       	push   $0x802d41
  80120d:	68 cc 00 00 00       	push   $0xcc
  801212:	68 e4 2c 80 00       	push   $0x802ce4
  801217:	e8 7b 12 00 00       	call   802497 <_panic>

0080121c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	8b 75 08             	mov    0x8(%ebp),%esi
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80122a:	85 c0                	test   %eax,%eax
  80122c:	74 4f                	je     80127d <ipc_recv+0x61>
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	50                   	push   %eax
  801232:	e8 e0 fb ff ff       	call   800e17 <sys_ipc_recv>
  801237:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  80123a:	85 f6                	test   %esi,%esi
  80123c:	74 14                	je     801252 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  80123e:	ba 00 00 00 00       	mov    $0x0,%edx
  801243:	85 c0                	test   %eax,%eax
  801245:	75 09                	jne    801250 <ipc_recv+0x34>
  801247:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80124d:	8b 52 74             	mov    0x74(%edx),%edx
  801250:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801252:	85 db                	test   %ebx,%ebx
  801254:	74 14                	je     80126a <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801256:	ba 00 00 00 00       	mov    $0x0,%edx
  80125b:	85 c0                	test   %eax,%eax
  80125d:	75 09                	jne    801268 <ipc_recv+0x4c>
  80125f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801265:	8b 52 78             	mov    0x78(%edx),%edx
  801268:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 08                	jne    801276 <ipc_recv+0x5a>
  80126e:	a1 08 40 80 00       	mov    0x804008,%eax
  801273:	8b 40 70             	mov    0x70(%eax),%eax
}
  801276:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	68 00 00 c0 ee       	push   $0xeec00000
  801285:	e8 8d fb ff ff       	call   800e17 <sys_ipc_recv>
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	eb ab                	jmp    80123a <ipc_recv+0x1e>

0080128f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	57                   	push   %edi
  801293:	56                   	push   %esi
  801294:	53                   	push   %ebx
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	8b 7d 08             	mov    0x8(%ebp),%edi
  80129b:	8b 75 10             	mov    0x10(%ebp),%esi
  80129e:	eb 20                	jmp    8012c0 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8012a0:	6a 00                	push   $0x0
  8012a2:	68 00 00 c0 ee       	push   $0xeec00000
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	57                   	push   %edi
  8012ab:	e8 44 fb ff ff       	call   800df4 <sys_ipc_try_send>
  8012b0:	89 c3                	mov    %eax,%ebx
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	eb 1f                	jmp    8012d6 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  8012b7:	e8 8c f9 ff ff       	call   800c48 <sys_yield>
	while(retval != 0) {
  8012bc:	85 db                	test   %ebx,%ebx
  8012be:	74 33                	je     8012f3 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8012c0:	85 f6                	test   %esi,%esi
  8012c2:	74 dc                	je     8012a0 <ipc_send+0x11>
  8012c4:	ff 75 14             	pushl  0x14(%ebp)
  8012c7:	56                   	push   %esi
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	57                   	push   %edi
  8012cc:	e8 23 fb ff ff       	call   800df4 <sys_ipc_try_send>
  8012d1:	89 c3                	mov    %eax,%ebx
  8012d3:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8012d6:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8012d9:	74 dc                	je     8012b7 <ipc_send+0x28>
  8012db:	85 db                	test   %ebx,%ebx
  8012dd:	74 d8                	je     8012b7 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8012df:	83 ec 04             	sub    $0x4,%esp
  8012e2:	68 58 2d 80 00       	push   $0x802d58
  8012e7:	6a 35                	push   $0x35
  8012e9:	68 88 2d 80 00       	push   $0x802d88
  8012ee:	e8 a4 11 00 00       	call   802497 <_panic>
	}
}
  8012f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f6:	5b                   	pop    %ebx
  8012f7:	5e                   	pop    %esi
  8012f8:	5f                   	pop    %edi
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801306:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801309:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80130f:	8b 52 50             	mov    0x50(%edx),%edx
  801312:	39 ca                	cmp    %ecx,%edx
  801314:	74 11                	je     801327 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801316:	83 c0 01             	add    $0x1,%eax
  801319:	3d 00 04 00 00       	cmp    $0x400,%eax
  80131e:	75 e6                	jne    801306 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
  801325:	eb 0b                	jmp    801332 <ipc_find_env+0x37>
			return envs[i].env_id;
  801327:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80132a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80132f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801332:	5d                   	pop    %ebp
  801333:	c3                   	ret    

00801334 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	05 00 00 00 30       	add    $0x30000000,%eax
  80133f:	c1 e8 0c             	shr    $0xc,%eax
}
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80134f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801354:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801363:	89 c2                	mov    %eax,%edx
  801365:	c1 ea 16             	shr    $0x16,%edx
  801368:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136f:	f6 c2 01             	test   $0x1,%dl
  801372:	74 2d                	je     8013a1 <fd_alloc+0x46>
  801374:	89 c2                	mov    %eax,%edx
  801376:	c1 ea 0c             	shr    $0xc,%edx
  801379:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801380:	f6 c2 01             	test   $0x1,%dl
  801383:	74 1c                	je     8013a1 <fd_alloc+0x46>
  801385:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80138a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80138f:	75 d2                	jne    801363 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80139a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80139f:	eb 0a                	jmp    8013ab <fd_alloc+0x50>
			*fd_store = fd;
  8013a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ab:	5d                   	pop    %ebp
  8013ac:	c3                   	ret    

008013ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013b3:	83 f8 1f             	cmp    $0x1f,%eax
  8013b6:	77 30                	ja     8013e8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013b8:	c1 e0 0c             	shl    $0xc,%eax
  8013bb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013c0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013c6:	f6 c2 01             	test   $0x1,%dl
  8013c9:	74 24                	je     8013ef <fd_lookup+0x42>
  8013cb:	89 c2                	mov    %eax,%edx
  8013cd:	c1 ea 0c             	shr    $0xc,%edx
  8013d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d7:	f6 c2 01             	test   $0x1,%dl
  8013da:	74 1a                	je     8013f6 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013df:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e6:	5d                   	pop    %ebp
  8013e7:	c3                   	ret    
		return -E_INVAL;
  8013e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ed:	eb f7                	jmp    8013e6 <fd_lookup+0x39>
		return -E_INVAL;
  8013ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f4:	eb f0                	jmp    8013e6 <fd_lookup+0x39>
  8013f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fb:	eb e9                	jmp    8013e6 <fd_lookup+0x39>

008013fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801406:	ba 00 00 00 00       	mov    $0x0,%edx
  80140b:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801410:	39 08                	cmp    %ecx,(%eax)
  801412:	74 38                	je     80144c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801414:	83 c2 01             	add    $0x1,%edx
  801417:	8b 04 95 10 2e 80 00 	mov    0x802e10(,%edx,4),%eax
  80141e:	85 c0                	test   %eax,%eax
  801420:	75 ee                	jne    801410 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801422:	a1 08 40 80 00       	mov    0x804008,%eax
  801427:	8b 40 48             	mov    0x48(%eax),%eax
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	51                   	push   %ecx
  80142e:	50                   	push   %eax
  80142f:	68 94 2d 80 00       	push   $0x802d94
  801434:	e8 60 ee ff ff       	call   800299 <cprintf>
	*dev = 0;
  801439:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    
			*dev = devtab[i];
  80144c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
  801456:	eb f2                	jmp    80144a <dev_lookup+0x4d>

00801458 <fd_close>:
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	57                   	push   %edi
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	83 ec 24             	sub    $0x24,%esp
  801461:	8b 75 08             	mov    0x8(%ebp),%esi
  801464:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801467:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80146a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80146b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801471:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801474:	50                   	push   %eax
  801475:	e8 33 ff ff ff       	call   8013ad <fd_lookup>
  80147a:	89 c3                	mov    %eax,%ebx
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 05                	js     801488 <fd_close+0x30>
	    || fd != fd2)
  801483:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801486:	74 16                	je     80149e <fd_close+0x46>
		return (must_exist ? r : 0);
  801488:	89 f8                	mov    %edi,%eax
  80148a:	84 c0                	test   %al,%al
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	0f 44 d8             	cmove  %eax,%ebx
}
  801494:	89 d8                	mov    %ebx,%eax
  801496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801499:	5b                   	pop    %ebx
  80149a:	5e                   	pop    %esi
  80149b:	5f                   	pop    %edi
  80149c:	5d                   	pop    %ebp
  80149d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 36                	pushl  (%esi)
  8014a7:	e8 51 ff ff ff       	call   8013fd <dev_lookup>
  8014ac:	89 c3                	mov    %eax,%ebx
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 1a                	js     8014cf <fd_close+0x77>
		if (dev->dev_close)
  8014b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 0b                	je     8014cf <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	56                   	push   %esi
  8014c8:	ff d0                	call   *%eax
  8014ca:	89 c3                	mov    %eax,%ebx
  8014cc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	56                   	push   %esi
  8014d3:	6a 00                	push   $0x0
  8014d5:	e8 12 f8 ff ff       	call   800cec <sys_page_unmap>
	return r;
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	eb b5                	jmp    801494 <fd_close+0x3c>

008014df <close>:

int
close(int fdnum)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	e8 bc fe ff ff       	call   8013ad <fd_lookup>
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	79 02                	jns    8014fa <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    
		return fd_close(fd, 1);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	6a 01                	push   $0x1
  8014ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801502:	e8 51 ff ff ff       	call   801458 <fd_close>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	eb ec                	jmp    8014f8 <close+0x19>

0080150c <close_all>:

void
close_all(void)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	53                   	push   %ebx
  801510:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801513:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	53                   	push   %ebx
  80151c:	e8 be ff ff ff       	call   8014df <close>
	for (i = 0; i < MAXFD; i++)
  801521:	83 c3 01             	add    $0x1,%ebx
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	83 fb 20             	cmp    $0x20,%ebx
  80152a:	75 ec                	jne    801518 <close_all+0xc>
}
  80152c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	57                   	push   %edi
  801535:	56                   	push   %esi
  801536:	53                   	push   %ebx
  801537:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80153a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	ff 75 08             	pushl  0x8(%ebp)
  801541:	e8 67 fe ff ff       	call   8013ad <fd_lookup>
  801546:	89 c3                	mov    %eax,%ebx
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	0f 88 81 00 00 00    	js     8015d4 <dup+0xa3>
		return r;
	close(newfdnum);
  801553:	83 ec 0c             	sub    $0xc,%esp
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	e8 81 ff ff ff       	call   8014df <close>

	newfd = INDEX2FD(newfdnum);
  80155e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801561:	c1 e6 0c             	shl    $0xc,%esi
  801564:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80156a:	83 c4 04             	add    $0x4,%esp
  80156d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801570:	e8 cf fd ff ff       	call   801344 <fd2data>
  801575:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801577:	89 34 24             	mov    %esi,(%esp)
  80157a:	e8 c5 fd ff ff       	call   801344 <fd2data>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801584:	89 d8                	mov    %ebx,%eax
  801586:	c1 e8 16             	shr    $0x16,%eax
  801589:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801590:	a8 01                	test   $0x1,%al
  801592:	74 11                	je     8015a5 <dup+0x74>
  801594:	89 d8                	mov    %ebx,%eax
  801596:	c1 e8 0c             	shr    $0xc,%eax
  801599:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015a0:	f6 c2 01             	test   $0x1,%dl
  8015a3:	75 39                	jne    8015de <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015a8:	89 d0                	mov    %edx,%eax
  8015aa:	c1 e8 0c             	shr    $0xc,%eax
  8015ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015bc:	50                   	push   %eax
  8015bd:	56                   	push   %esi
  8015be:	6a 00                	push   $0x0
  8015c0:	52                   	push   %edx
  8015c1:	6a 00                	push   $0x0
  8015c3:	e8 e2 f6 ff ff       	call   800caa <sys_page_map>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	83 c4 20             	add    $0x20,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 31                	js     801602 <dup+0xd1>
		goto err;

	return newfdnum;
  8015d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015d4:	89 d8                	mov    %ebx,%eax
  8015d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d9:	5b                   	pop    %ebx
  8015da:	5e                   	pop    %esi
  8015db:	5f                   	pop    %edi
  8015dc:	5d                   	pop    %ebp
  8015dd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e5:	83 ec 0c             	sub    $0xc,%esp
  8015e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ed:	50                   	push   %eax
  8015ee:	57                   	push   %edi
  8015ef:	6a 00                	push   $0x0
  8015f1:	53                   	push   %ebx
  8015f2:	6a 00                	push   $0x0
  8015f4:	e8 b1 f6 ff ff       	call   800caa <sys_page_map>
  8015f9:	89 c3                	mov    %eax,%ebx
  8015fb:	83 c4 20             	add    $0x20,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	79 a3                	jns    8015a5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	56                   	push   %esi
  801606:	6a 00                	push   $0x0
  801608:	e8 df f6 ff ff       	call   800cec <sys_page_unmap>
	sys_page_unmap(0, nva);
  80160d:	83 c4 08             	add    $0x8,%esp
  801610:	57                   	push   %edi
  801611:	6a 00                	push   $0x0
  801613:	e8 d4 f6 ff ff       	call   800cec <sys_page_unmap>
	return r;
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	eb b7                	jmp    8015d4 <dup+0xa3>

0080161d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	53                   	push   %ebx
  801621:	83 ec 1c             	sub    $0x1c,%esp
  801624:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801627:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162a:	50                   	push   %eax
  80162b:	53                   	push   %ebx
  80162c:	e8 7c fd ff ff       	call   8013ad <fd_lookup>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	78 3f                	js     801677 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163e:	50                   	push   %eax
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	ff 30                	pushl  (%eax)
  801644:	e8 b4 fd ff ff       	call   8013fd <dev_lookup>
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 27                	js     801677 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801650:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801653:	8b 42 08             	mov    0x8(%edx),%eax
  801656:	83 e0 03             	and    $0x3,%eax
  801659:	83 f8 01             	cmp    $0x1,%eax
  80165c:	74 1e                	je     80167c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80165e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801661:	8b 40 08             	mov    0x8(%eax),%eax
  801664:	85 c0                	test   %eax,%eax
  801666:	74 35                	je     80169d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	ff 75 10             	pushl  0x10(%ebp)
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	52                   	push   %edx
  801672:	ff d0                	call   *%eax
  801674:	83 c4 10             	add    $0x10,%esp
}
  801677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80167c:	a1 08 40 80 00       	mov    0x804008,%eax
  801681:	8b 40 48             	mov    0x48(%eax),%eax
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	53                   	push   %ebx
  801688:	50                   	push   %eax
  801689:	68 d5 2d 80 00       	push   $0x802dd5
  80168e:	e8 06 ec ff ff       	call   800299 <cprintf>
		return -E_INVAL;
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169b:	eb da                	jmp    801677 <read+0x5a>
		return -E_NOT_SUPP;
  80169d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a2:	eb d3                	jmp    801677 <read+0x5a>

008016a4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	57                   	push   %edi
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 0c             	sub    $0xc,%esp
  8016ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b8:	39 f3                	cmp    %esi,%ebx
  8016ba:	73 23                	jae    8016df <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	89 f0                	mov    %esi,%eax
  8016c1:	29 d8                	sub    %ebx,%eax
  8016c3:	50                   	push   %eax
  8016c4:	89 d8                	mov    %ebx,%eax
  8016c6:	03 45 0c             	add    0xc(%ebp),%eax
  8016c9:	50                   	push   %eax
  8016ca:	57                   	push   %edi
  8016cb:	e8 4d ff ff ff       	call   80161d <read>
		if (m < 0)
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 06                	js     8016dd <readn+0x39>
			return m;
		if (m == 0)
  8016d7:	74 06                	je     8016df <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8016d9:	01 c3                	add    %eax,%ebx
  8016db:	eb db                	jmp    8016b8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016dd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5f                   	pop    %edi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 1c             	sub    $0x1c,%esp
  8016f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f6:	50                   	push   %eax
  8016f7:	53                   	push   %ebx
  8016f8:	e8 b0 fc ff ff       	call   8013ad <fd_lookup>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	85 c0                	test   %eax,%eax
  801702:	78 3a                	js     80173e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	ff 30                	pushl  (%eax)
  801710:	e8 e8 fc ff ff       	call   8013fd <dev_lookup>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 22                	js     80173e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801723:	74 1e                	je     801743 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801728:	8b 52 0c             	mov    0xc(%edx),%edx
  80172b:	85 d2                	test   %edx,%edx
  80172d:	74 35                	je     801764 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	ff 75 10             	pushl  0x10(%ebp)
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	50                   	push   %eax
  801739:	ff d2                	call   *%edx
  80173b:	83 c4 10             	add    $0x10,%esp
}
  80173e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801741:	c9                   	leave  
  801742:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801743:	a1 08 40 80 00       	mov    0x804008,%eax
  801748:	8b 40 48             	mov    0x48(%eax),%eax
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	53                   	push   %ebx
  80174f:	50                   	push   %eax
  801750:	68 f1 2d 80 00       	push   $0x802df1
  801755:	e8 3f eb ff ff       	call   800299 <cprintf>
		return -E_INVAL;
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801762:	eb da                	jmp    80173e <write+0x55>
		return -E_NOT_SUPP;
  801764:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801769:	eb d3                	jmp    80173e <write+0x55>

0080176b <seek>:

int
seek(int fdnum, off_t offset)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	e8 30 fc ff ff       	call   8013ad <fd_lookup>
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	78 0e                	js     801792 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801784:	8b 55 0c             	mov    0xc(%ebp),%edx
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	53                   	push   %ebx
  801798:	83 ec 1c             	sub    $0x1c,%esp
  80179b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a1:	50                   	push   %eax
  8017a2:	53                   	push   %ebx
  8017a3:	e8 05 fc ff ff       	call   8013ad <fd_lookup>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 37                	js     8017e6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017af:	83 ec 08             	sub    $0x8,%esp
  8017b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b5:	50                   	push   %eax
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b9:	ff 30                	pushl  (%eax)
  8017bb:	e8 3d fc ff ff       	call   8013fd <dev_lookup>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 1f                	js     8017e6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ce:	74 1b                	je     8017eb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d3:	8b 52 18             	mov    0x18(%edx),%edx
  8017d6:	85 d2                	test   %edx,%edx
  8017d8:	74 32                	je     80180c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	50                   	push   %eax
  8017e1:	ff d2                	call   *%edx
  8017e3:	83 c4 10             	add    $0x10,%esp
}
  8017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017eb:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017f0:	8b 40 48             	mov    0x48(%eax),%eax
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	53                   	push   %ebx
  8017f7:	50                   	push   %eax
  8017f8:	68 b4 2d 80 00       	push   $0x802db4
  8017fd:	e8 97 ea ff ff       	call   800299 <cprintf>
		return -E_INVAL;
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180a:	eb da                	jmp    8017e6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80180c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801811:	eb d3                	jmp    8017e6 <ftruncate+0x52>

00801813 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	53                   	push   %ebx
  801817:	83 ec 1c             	sub    $0x1c,%esp
  80181a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801820:	50                   	push   %eax
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	e8 84 fb ff ff       	call   8013ad <fd_lookup>
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 4b                	js     80187b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801836:	50                   	push   %eax
  801837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183a:	ff 30                	pushl  (%eax)
  80183c:	e8 bc fb ff ff       	call   8013fd <dev_lookup>
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	85 c0                	test   %eax,%eax
  801846:	78 33                	js     80187b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80184f:	74 2f                	je     801880 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801851:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801854:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80185b:	00 00 00 
	stat->st_isdir = 0;
  80185e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801865:	00 00 00 
	stat->st_dev = dev;
  801868:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	53                   	push   %ebx
  801872:	ff 75 f0             	pushl  -0x10(%ebp)
  801875:	ff 50 14             	call   *0x14(%eax)
  801878:	83 c4 10             	add    $0x10,%esp
}
  80187b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    
		return -E_NOT_SUPP;
  801880:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801885:	eb f4                	jmp    80187b <fstat+0x68>

00801887 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	6a 00                	push   $0x0
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	e8 2f 02 00 00       	call   801ac8 <open>
  801899:	89 c3                	mov    %eax,%ebx
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 1b                	js     8018bd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018a2:	83 ec 08             	sub    $0x8,%esp
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	50                   	push   %eax
  8018a9:	e8 65 ff ff ff       	call   801813 <fstat>
  8018ae:	89 c6                	mov    %eax,%esi
	close(fd);
  8018b0:	89 1c 24             	mov    %ebx,(%esp)
  8018b3:	e8 27 fc ff ff       	call   8014df <close>
	return r;
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	89 f3                	mov    %esi,%ebx
}
  8018bd:	89 d8                	mov    %ebx,%eax
  8018bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    

008018c6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	89 c6                	mov    %eax,%esi
  8018cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018cf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018d6:	74 27                	je     8018ff <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d8:	6a 07                	push   $0x7
  8018da:	68 00 50 80 00       	push   $0x805000
  8018df:	56                   	push   %esi
  8018e0:	ff 35 00 40 80 00    	pushl  0x804000
  8018e6:	e8 a4 f9 ff ff       	call   80128f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018eb:	83 c4 0c             	add    $0xc,%esp
  8018ee:	6a 00                	push   $0x0
  8018f0:	53                   	push   %ebx
  8018f1:	6a 00                	push   $0x0
  8018f3:	e8 24 f9 ff ff       	call   80121c <ipc_recv>
}
  8018f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	6a 01                	push   $0x1
  801904:	e8 f2 f9 ff ff       	call   8012fb <ipc_find_env>
  801909:	a3 00 40 80 00       	mov    %eax,0x804000
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	eb c5                	jmp    8018d8 <fsipc+0x12>

00801913 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8b 40 0c             	mov    0xc(%eax),%eax
  80191f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801924:	8b 45 0c             	mov    0xc(%ebp),%eax
  801927:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80192c:	ba 00 00 00 00       	mov    $0x0,%edx
  801931:	b8 02 00 00 00       	mov    $0x2,%eax
  801936:	e8 8b ff ff ff       	call   8018c6 <fsipc>
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <devfile_flush>:
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8b 40 0c             	mov    0xc(%eax),%eax
  801949:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	b8 06 00 00 00       	mov    $0x6,%eax
  801958:	e8 69 ff ff ff       	call   8018c6 <fsipc>
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <devfile_stat>:
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	53                   	push   %ebx
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8b 40 0c             	mov    0xc(%eax),%eax
  80196f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	b8 05 00 00 00       	mov    $0x5,%eax
  80197e:	e8 43 ff ff ff       	call   8018c6 <fsipc>
  801983:	85 c0                	test   %eax,%eax
  801985:	78 2c                	js     8019b3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	68 00 50 80 00       	push   $0x805000
  80198f:	53                   	push   %ebx
  801990:	e8 e0 ee ff ff       	call   800875 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801995:	a1 80 50 80 00       	mov    0x805080,%eax
  80199a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019a0:	a1 84 50 80 00       	mov    0x805084,%eax
  8019a5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <devfile_write>:
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8019c2:	85 db                	test   %ebx,%ebx
  8019c4:	75 07                	jne    8019cd <devfile_write+0x15>
	return n_all;
  8019c6:	89 d8                	mov    %ebx,%eax
}
  8019c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8019d8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	53                   	push   %ebx
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	68 08 50 80 00       	push   $0x805008
  8019ea:	e8 14 f0 ff ff       	call   800a03 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8019f9:	e8 c8 fe ff ff       	call   8018c6 <fsipc>
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	78 c3                	js     8019c8 <devfile_write+0x10>
	  assert(r <= n_left);
  801a05:	39 d8                	cmp    %ebx,%eax
  801a07:	77 0b                	ja     801a14 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801a09:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a0e:	7f 1d                	jg     801a2d <devfile_write+0x75>
    n_all += r;
  801a10:	89 c3                	mov    %eax,%ebx
  801a12:	eb b2                	jmp    8019c6 <devfile_write+0xe>
	  assert(r <= n_left);
  801a14:	68 24 2e 80 00       	push   $0x802e24
  801a19:	68 30 2e 80 00       	push   $0x802e30
  801a1e:	68 9f 00 00 00       	push   $0x9f
  801a23:	68 45 2e 80 00       	push   $0x802e45
  801a28:	e8 6a 0a 00 00       	call   802497 <_panic>
	  assert(r <= PGSIZE);
  801a2d:	68 50 2e 80 00       	push   $0x802e50
  801a32:	68 30 2e 80 00       	push   $0x802e30
  801a37:	68 a0 00 00 00       	push   $0xa0
  801a3c:	68 45 2e 80 00       	push   $0x802e45
  801a41:	e8 51 0a 00 00       	call   802497 <_panic>

00801a46 <devfile_read>:
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8b 40 0c             	mov    0xc(%eax),%eax
  801a54:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a59:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a64:	b8 03 00 00 00       	mov    $0x3,%eax
  801a69:	e8 58 fe ff ff       	call   8018c6 <fsipc>
  801a6e:	89 c3                	mov    %eax,%ebx
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 1f                	js     801a93 <devfile_read+0x4d>
	assert(r <= n);
  801a74:	39 f0                	cmp    %esi,%eax
  801a76:	77 24                	ja     801a9c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a7d:	7f 33                	jg     801ab2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	50                   	push   %eax
  801a83:	68 00 50 80 00       	push   $0x805000
  801a88:	ff 75 0c             	pushl  0xc(%ebp)
  801a8b:	e8 73 ef ff ff       	call   800a03 <memmove>
	return r;
  801a90:	83 c4 10             	add    $0x10,%esp
}
  801a93:	89 d8                	mov    %ebx,%eax
  801a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a98:	5b                   	pop    %ebx
  801a99:	5e                   	pop    %esi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
	assert(r <= n);
  801a9c:	68 5c 2e 80 00       	push   $0x802e5c
  801aa1:	68 30 2e 80 00       	push   $0x802e30
  801aa6:	6a 7c                	push   $0x7c
  801aa8:	68 45 2e 80 00       	push   $0x802e45
  801aad:	e8 e5 09 00 00       	call   802497 <_panic>
	assert(r <= PGSIZE);
  801ab2:	68 50 2e 80 00       	push   $0x802e50
  801ab7:	68 30 2e 80 00       	push   $0x802e30
  801abc:	6a 7d                	push   $0x7d
  801abe:	68 45 2e 80 00       	push   $0x802e45
  801ac3:	e8 cf 09 00 00       	call   802497 <_panic>

00801ac8 <open>:
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	56                   	push   %esi
  801acc:	53                   	push   %ebx
  801acd:	83 ec 1c             	sub    $0x1c,%esp
  801ad0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ad3:	56                   	push   %esi
  801ad4:	e8 63 ed ff ff       	call   80083c <strlen>
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae1:	7f 6c                	jg     801b4f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae9:	50                   	push   %eax
  801aea:	e8 6c f8 ff ff       	call   80135b <fd_alloc>
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	85 c0                	test   %eax,%eax
  801af6:	78 3c                	js     801b34 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	56                   	push   %esi
  801afc:	68 00 50 80 00       	push   $0x805000
  801b01:	e8 6f ed ff ff       	call   800875 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b09:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	e8 ab fd ff ff       	call   8018c6 <fsipc>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	78 19                	js     801b3d <open+0x75>
	return fd2num(fd);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2a:	e8 05 f8 ff ff       	call   801334 <fd2num>
  801b2f:	89 c3                	mov    %eax,%ebx
  801b31:	83 c4 10             	add    $0x10,%esp
}
  801b34:	89 d8                	mov    %ebx,%eax
  801b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    
		fd_close(fd, 0);
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	6a 00                	push   $0x0
  801b42:	ff 75 f4             	pushl  -0xc(%ebp)
  801b45:	e8 0e f9 ff ff       	call   801458 <fd_close>
		return r;
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	eb e5                	jmp    801b34 <open+0x6c>
		return -E_BAD_PATH;
  801b4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b54:	eb de                	jmp    801b34 <open+0x6c>

00801b56 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b61:	b8 08 00 00 00       	mov    $0x8,%eax
  801b66:	e8 5b fd ff ff       	call   8018c6 <fsipc>
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
  801b72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b75:	83 ec 0c             	sub    $0xc,%esp
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	e8 c4 f7 ff ff       	call   801344 <fd2data>
  801b80:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b82:	83 c4 08             	add    $0x8,%esp
  801b85:	68 63 2e 80 00       	push   $0x802e63
  801b8a:	53                   	push   %ebx
  801b8b:	e8 e5 ec ff ff       	call   800875 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b90:	8b 46 04             	mov    0x4(%esi),%eax
  801b93:	2b 06                	sub    (%esi),%eax
  801b95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba2:	00 00 00 
	stat->st_dev = &devpipe;
  801ba5:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801bac:	30 80 00 
	return 0;
}
  801baf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5d                   	pop    %ebp
  801bba:	c3                   	ret    

00801bbb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	53                   	push   %ebx
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bc5:	53                   	push   %ebx
  801bc6:	6a 00                	push   $0x0
  801bc8:	e8 1f f1 ff ff       	call   800cec <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bcd:	89 1c 24             	mov    %ebx,(%esp)
  801bd0:	e8 6f f7 ff ff       	call   801344 <fd2data>
  801bd5:	83 c4 08             	add    $0x8,%esp
  801bd8:	50                   	push   %eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	e8 0c f1 ff ff       	call   800cec <sys_page_unmap>
}
  801be0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <_pipeisclosed>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	57                   	push   %edi
  801be9:	56                   	push   %esi
  801bea:	53                   	push   %ebx
  801beb:	83 ec 1c             	sub    $0x1c,%esp
  801bee:	89 c7                	mov    %eax,%edi
  801bf0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bf2:	a1 08 40 80 00       	mov    0x804008,%eax
  801bf7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	57                   	push   %edi
  801bfe:	e8 77 09 00 00       	call   80257a <pageref>
  801c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c06:	89 34 24             	mov    %esi,(%esp)
  801c09:	e8 6c 09 00 00       	call   80257a <pageref>
		nn = thisenv->env_runs;
  801c0e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c14:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	39 cb                	cmp    %ecx,%ebx
  801c1c:	74 1b                	je     801c39 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c1e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c21:	75 cf                	jne    801bf2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c23:	8b 42 58             	mov    0x58(%edx),%eax
  801c26:	6a 01                	push   $0x1
  801c28:	50                   	push   %eax
  801c29:	53                   	push   %ebx
  801c2a:	68 6a 2e 80 00       	push   $0x802e6a
  801c2f:	e8 65 e6 ff ff       	call   800299 <cprintf>
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	eb b9                	jmp    801bf2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c39:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c3c:	0f 94 c0             	sete   %al
  801c3f:	0f b6 c0             	movzbl %al,%eax
}
  801c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c45:	5b                   	pop    %ebx
  801c46:	5e                   	pop    %esi
  801c47:	5f                   	pop    %edi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <devpipe_write>:
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	57                   	push   %edi
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 28             	sub    $0x28,%esp
  801c53:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c56:	56                   	push   %esi
  801c57:	e8 e8 f6 ff ff       	call   801344 <fd2data>
  801c5c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	bf 00 00 00 00       	mov    $0x0,%edi
  801c66:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c69:	74 4f                	je     801cba <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c6b:	8b 43 04             	mov    0x4(%ebx),%eax
  801c6e:	8b 0b                	mov    (%ebx),%ecx
  801c70:	8d 51 20             	lea    0x20(%ecx),%edx
  801c73:	39 d0                	cmp    %edx,%eax
  801c75:	72 14                	jb     801c8b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c77:	89 da                	mov    %ebx,%edx
  801c79:	89 f0                	mov    %esi,%eax
  801c7b:	e8 65 ff ff ff       	call   801be5 <_pipeisclosed>
  801c80:	85 c0                	test   %eax,%eax
  801c82:	75 3b                	jne    801cbf <devpipe_write+0x75>
			sys_yield();
  801c84:	e8 bf ef ff ff       	call   800c48 <sys_yield>
  801c89:	eb e0                	jmp    801c6b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c92:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c95:	89 c2                	mov    %eax,%edx
  801c97:	c1 fa 1f             	sar    $0x1f,%edx
  801c9a:	89 d1                	mov    %edx,%ecx
  801c9c:	c1 e9 1b             	shr    $0x1b,%ecx
  801c9f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ca2:	83 e2 1f             	and    $0x1f,%edx
  801ca5:	29 ca                	sub    %ecx,%edx
  801ca7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801caf:	83 c0 01             	add    $0x1,%eax
  801cb2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cb5:	83 c7 01             	add    $0x1,%edi
  801cb8:	eb ac                	jmp    801c66 <devpipe_write+0x1c>
	return i;
  801cba:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbd:	eb 05                	jmp    801cc4 <devpipe_write+0x7a>
				return 0;
  801cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    

00801ccc <devpipe_read>:
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	57                   	push   %edi
  801cd0:	56                   	push   %esi
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 18             	sub    $0x18,%esp
  801cd5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cd8:	57                   	push   %edi
  801cd9:	e8 66 f6 ff ff       	call   801344 <fd2data>
  801cde:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	be 00 00 00 00       	mov    $0x0,%esi
  801ce8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ceb:	75 14                	jne    801d01 <devpipe_read+0x35>
	return i;
  801ced:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf0:	eb 02                	jmp    801cf4 <devpipe_read+0x28>
				return i;
  801cf2:	89 f0                	mov    %esi,%eax
}
  801cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
			sys_yield();
  801cfc:	e8 47 ef ff ff       	call   800c48 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d01:	8b 03                	mov    (%ebx),%eax
  801d03:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d06:	75 18                	jne    801d20 <devpipe_read+0x54>
			if (i > 0)
  801d08:	85 f6                	test   %esi,%esi
  801d0a:	75 e6                	jne    801cf2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d0c:	89 da                	mov    %ebx,%edx
  801d0e:	89 f8                	mov    %edi,%eax
  801d10:	e8 d0 fe ff ff       	call   801be5 <_pipeisclosed>
  801d15:	85 c0                	test   %eax,%eax
  801d17:	74 e3                	je     801cfc <devpipe_read+0x30>
				return 0;
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	eb d4                	jmp    801cf4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d20:	99                   	cltd   
  801d21:	c1 ea 1b             	shr    $0x1b,%edx
  801d24:	01 d0                	add    %edx,%eax
  801d26:	83 e0 1f             	and    $0x1f,%eax
  801d29:	29 d0                	sub    %edx,%eax
  801d2b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d33:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d36:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d39:	83 c6 01             	add    $0x1,%esi
  801d3c:	eb aa                	jmp    801ce8 <devpipe_read+0x1c>

00801d3e <pipe>:
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	56                   	push   %esi
  801d42:	53                   	push   %ebx
  801d43:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d49:	50                   	push   %eax
  801d4a:	e8 0c f6 ff ff       	call   80135b <fd_alloc>
  801d4f:	89 c3                	mov    %eax,%ebx
  801d51:	83 c4 10             	add    $0x10,%esp
  801d54:	85 c0                	test   %eax,%eax
  801d56:	0f 88 23 01 00 00    	js     801e7f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	68 07 04 00 00       	push   $0x407
  801d64:	ff 75 f4             	pushl  -0xc(%ebp)
  801d67:	6a 00                	push   $0x0
  801d69:	e8 f9 ee ff ff       	call   800c67 <sys_page_alloc>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	85 c0                	test   %eax,%eax
  801d75:	0f 88 04 01 00 00    	js     801e7f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d81:	50                   	push   %eax
  801d82:	e8 d4 f5 ff ff       	call   80135b <fd_alloc>
  801d87:	89 c3                	mov    %eax,%ebx
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	0f 88 db 00 00 00    	js     801e6f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	68 07 04 00 00       	push   $0x407
  801d9c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9f:	6a 00                	push   $0x0
  801da1:	e8 c1 ee ff ff       	call   800c67 <sys_page_alloc>
  801da6:	89 c3                	mov    %eax,%ebx
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	0f 88 bc 00 00 00    	js     801e6f <pipe+0x131>
	va = fd2data(fd0);
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	ff 75 f4             	pushl  -0xc(%ebp)
  801db9:	e8 86 f5 ff ff       	call   801344 <fd2data>
  801dbe:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc0:	83 c4 0c             	add    $0xc,%esp
  801dc3:	68 07 04 00 00       	push   $0x407
  801dc8:	50                   	push   %eax
  801dc9:	6a 00                	push   $0x0
  801dcb:	e8 97 ee ff ff       	call   800c67 <sys_page_alloc>
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	0f 88 82 00 00 00    	js     801e5f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	ff 75 f0             	pushl  -0x10(%ebp)
  801de3:	e8 5c f5 ff ff       	call   801344 <fd2data>
  801de8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801def:	50                   	push   %eax
  801df0:	6a 00                	push   $0x0
  801df2:	56                   	push   %esi
  801df3:	6a 00                	push   $0x0
  801df5:	e8 b0 ee ff ff       	call   800caa <sys_page_map>
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	83 c4 20             	add    $0x20,%esp
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 4e                	js     801e51 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e03:	a1 28 30 80 00       	mov    0x803028,%eax
  801e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e10:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2c:	e8 03 f5 ff ff       	call   801334 <fd2num>
  801e31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e34:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e36:	83 c4 04             	add    $0x4,%esp
  801e39:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3c:	e8 f3 f4 ff ff       	call   801334 <fd2num>
  801e41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e44:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e4f:	eb 2e                	jmp    801e7f <pipe+0x141>
	sys_page_unmap(0, va);
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	56                   	push   %esi
  801e55:	6a 00                	push   $0x0
  801e57:	e8 90 ee ff ff       	call   800cec <sys_page_unmap>
  801e5c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	ff 75 f0             	pushl  -0x10(%ebp)
  801e65:	6a 00                	push   $0x0
  801e67:	e8 80 ee ff ff       	call   800cec <sys_page_unmap>
  801e6c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e6f:	83 ec 08             	sub    $0x8,%esp
  801e72:	ff 75 f4             	pushl  -0xc(%ebp)
  801e75:	6a 00                	push   $0x0
  801e77:	e8 70 ee ff ff       	call   800cec <sys_page_unmap>
  801e7c:	83 c4 10             	add    $0x10,%esp
}
  801e7f:	89 d8                	mov    %ebx,%eax
  801e81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    

00801e88 <pipeisclosed>:
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e91:	50                   	push   %eax
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	e8 13 f5 ff ff       	call   8013ad <fd_lookup>
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	78 18                	js     801eb9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea7:	e8 98 f4 ff ff       	call   801344 <fd2data>
	return _pipeisclosed(fd, p);
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	e8 2f fd ff ff       	call   801be5 <_pipeisclosed>
  801eb6:	83 c4 10             	add    $0x10,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ec1:	68 82 2e 80 00       	push   $0x802e82
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	e8 a7 e9 ff ff       	call   800875 <strcpy>
	return 0;
}
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <devsock_close>:
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	53                   	push   %ebx
  801ed9:	83 ec 10             	sub    $0x10,%esp
  801edc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801edf:	53                   	push   %ebx
  801ee0:	e8 95 06 00 00       	call   80257a <pageref>
  801ee5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ee8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801eed:	83 f8 01             	cmp    $0x1,%eax
  801ef0:	74 07                	je     801ef9 <devsock_close+0x24>
}
  801ef2:	89 d0                	mov    %edx,%eax
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 73 0c             	pushl  0xc(%ebx)
  801eff:	e8 b9 02 00 00       	call   8021bd <nsipc_close>
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	eb e7                	jmp    801ef2 <devsock_close+0x1d>

00801f0b <devsock_write>:
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 10             	pushl  0x10(%ebp)
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	ff 70 0c             	pushl  0xc(%eax)
  801f1f:	e8 76 03 00 00       	call   80229a <nsipc_send>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <devsock_read>:
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 10             	pushl  0x10(%ebp)
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	ff 70 0c             	pushl  0xc(%eax)
  801f3a:	e8 ef 02 00 00       	call   80222e <nsipc_recv>
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <fd2sockid>:
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	e8 5c f4 ff ff       	call   8013ad <fd_lookup>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 10                	js     801f68 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 0d 44 30 80 00    	mov    0x803044,%ecx
  801f61:	39 08                	cmp    %ecx,(%eax)
  801f63:	75 05                	jne    801f6a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f65:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    
		return -E_NOT_SUPP;
  801f6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f6f:	eb f7                	jmp    801f68 <fd2sockid+0x27>

00801f71 <alloc_sockfd>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	83 ec 1c             	sub    $0x1c,%esp
  801f79:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	e8 d7 f3 ff ff       	call   80135b <fd_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 43                	js     801fd0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 07 04 00 00       	push   $0x407
  801f95:	ff 75 f4             	pushl  -0xc(%ebp)
  801f98:	6a 00                	push   $0x0
  801f9a:	e8 c8 ec ff ff       	call   800c67 <sys_page_alloc>
  801f9f:	89 c3                	mov    %eax,%ebx
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 28                	js     801fd0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801fb1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fbd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	50                   	push   %eax
  801fc4:	e8 6b f3 ff ff       	call   801334 <fd2num>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	eb 0c                	jmp    801fdc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	56                   	push   %esi
  801fd4:	e8 e4 01 00 00       	call   8021bd <nsipc_close>
		return r;
  801fd9:	83 c4 10             	add    $0x10,%esp
}
  801fdc:	89 d8                	mov    %ebx,%eax
  801fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <accept>:
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	e8 4e ff ff ff       	call   801f41 <fd2sockid>
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 1b                	js     802012 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	ff 75 10             	pushl  0x10(%ebp)
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	50                   	push   %eax
  802001:	e8 0e 01 00 00       	call   802114 <nsipc_accept>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	85 c0                	test   %eax,%eax
  80200b:	78 05                	js     802012 <accept+0x2d>
	return alloc_sockfd(r);
  80200d:	e8 5f ff ff ff       	call   801f71 <alloc_sockfd>
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <bind>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	e8 1f ff ff ff       	call   801f41 <fd2sockid>
  802022:	85 c0                	test   %eax,%eax
  802024:	78 12                	js     802038 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	50                   	push   %eax
  802030:	e8 31 01 00 00       	call   802166 <nsipc_bind>
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <shutdown>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	e8 f9 fe ff ff       	call   801f41 <fd2sockid>
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 0f                	js     80205b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80204c:	83 ec 08             	sub    $0x8,%esp
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	50                   	push   %eax
  802053:	e8 43 01 00 00       	call   80219b <nsipc_shutdown>
  802058:	83 c4 10             	add    $0x10,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <connect>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	e8 d6 fe ff ff       	call   801f41 <fd2sockid>
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 12                	js     802081 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	ff 75 10             	pushl  0x10(%ebp)
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	50                   	push   %eax
  802079:	e8 59 01 00 00       	call   8021d7 <nsipc_connect>
  80207e:	83 c4 10             	add    $0x10,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <listen>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	e8 b0 fe ff ff       	call   801f41 <fd2sockid>
  802091:	85 c0                	test   %eax,%eax
  802093:	78 0f                	js     8020a4 <listen+0x21>
	return nsipc_listen(r, backlog);
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	50                   	push   %eax
  80209c:	e8 6b 01 00 00       	call   80220c <nsipc_listen>
  8020a1:	83 c4 10             	add    $0x10,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ac:	ff 75 10             	pushl  0x10(%ebp)
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 3e 02 00 00       	call   8022f8 <nsipc_socket>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 05                	js     8020c6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020c1:	e8 ab fe ff ff       	call   801f71 <alloc_sockfd>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	53                   	push   %ebx
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020d1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8020d8:	74 26                	je     802100 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020da:	6a 07                	push   $0x7
  8020dc:	68 00 60 80 00       	push   $0x806000
  8020e1:	53                   	push   %ebx
  8020e2:	ff 35 04 40 80 00    	pushl  0x804004
  8020e8:	e8 a2 f1 ff ff       	call   80128f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020ed:	83 c4 0c             	add    $0xc,%esp
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	e8 21 f1 ff ff       	call   80121c <ipc_recv>
}
  8020fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	6a 02                	push   $0x2
  802105:	e8 f1 f1 ff ff       	call   8012fb <ipc_find_env>
  80210a:	a3 04 40 80 00       	mov    %eax,0x804004
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	eb c6                	jmp    8020da <nsipc+0x12>

00802114 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	56                   	push   %esi
  802118:	53                   	push   %ebx
  802119:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802124:	8b 06                	mov    (%esi),%eax
  802126:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80212b:	b8 01 00 00 00       	mov    $0x1,%eax
  802130:	e8 93 ff ff ff       	call   8020c8 <nsipc>
  802135:	89 c3                	mov    %eax,%ebx
  802137:	85 c0                	test   %eax,%eax
  802139:	79 09                	jns    802144 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	ff 35 10 60 80 00    	pushl  0x806010
  80214d:	68 00 60 80 00       	push   $0x806000
  802152:	ff 75 0c             	pushl  0xc(%ebp)
  802155:	e8 a9 e8 ff ff       	call   800a03 <memmove>
		*addrlen = ret->ret_addrlen;
  80215a:	a1 10 60 80 00       	mov    0x806010,%eax
  80215f:	89 06                	mov    %eax,(%esi)
  802161:	83 c4 10             	add    $0x10,%esp
	return r;
  802164:	eb d5                	jmp    80213b <nsipc_accept+0x27>

00802166 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	53                   	push   %ebx
  80216a:	83 ec 08             	sub    $0x8,%esp
  80216d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802178:	53                   	push   %ebx
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	68 04 60 80 00       	push   $0x806004
  802181:	e8 7d e8 ff ff       	call   800a03 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802186:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80218c:	b8 02 00 00 00       	mov    $0x2,%eax
  802191:	e8 32 ff ff ff       	call   8020c8 <nsipc>
}
  802196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8021a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ac:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8021b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b6:	e8 0d ff ff ff       	call   8020c8 <nsipc>
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <nsipc_close>:

int
nsipc_close(int s)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8021cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8021d0:	e8 f3 fe ff ff       	call   8020c8 <nsipc>
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	53                   	push   %ebx
  8021db:	83 ec 08             	sub    $0x8,%esp
  8021de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021e9:	53                   	push   %ebx
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	68 04 60 80 00       	push   $0x806004
  8021f2:	e8 0c e8 ff ff       	call   800a03 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8021fd:	b8 05 00 00 00       	mov    $0x5,%eax
  802202:	e8 c1 fe ff ff       	call   8020c8 <nsipc>
}
  802207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80221a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802222:	b8 06 00 00 00       	mov    $0x6,%eax
  802227:	e8 9c fe ff ff       	call   8020c8 <nsipc>
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80223e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80224c:	b8 07 00 00 00       	mov    $0x7,%eax
  802251:	e8 72 fe ff ff       	call   8020c8 <nsipc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 1f                	js     80227b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80225c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802261:	7f 21                	jg     802284 <nsipc_recv+0x56>
  802263:	39 c6                	cmp    %eax,%esi
  802265:	7c 1d                	jl     802284 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	50                   	push   %eax
  80226b:	68 00 60 80 00       	push   $0x806000
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	e8 8b e7 ff ff       	call   800a03 <memmove>
  802278:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80227b:	89 d8                	mov    %ebx,%eax
  80227d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802284:	68 8e 2e 80 00       	push   $0x802e8e
  802289:	68 30 2e 80 00       	push   $0x802e30
  80228e:	6a 62                	push   $0x62
  802290:	68 a3 2e 80 00       	push   $0x802ea3
  802295:	e8 fd 01 00 00       	call   802497 <_panic>

0080229a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	53                   	push   %ebx
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8022ac:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022b2:	7f 2e                	jg     8022e2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	53                   	push   %ebx
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	68 0c 60 80 00       	push   $0x80600c
  8022c0:	e8 3e e7 ff ff       	call   800a03 <memmove>
	nsipcbuf.send.req_size = size;
  8022c5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ce:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8022d8:	e8 eb fd ff ff       	call   8020c8 <nsipc>
}
  8022dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    
	assert(size < 1600);
  8022e2:	68 af 2e 80 00       	push   $0x802eaf
  8022e7:	68 30 2e 80 00       	push   $0x802e30
  8022ec:	6a 6d                	push   $0x6d
  8022ee:	68 a3 2e 80 00       	push   $0x802ea3
  8022f3:	e8 9f 01 00 00       	call   802497 <_panic>

008022f8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80230e:	8b 45 10             	mov    0x10(%ebp),%eax
  802311:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802316:	b8 09 00 00 00       	mov    $0x9,%eax
  80231b:	e8 a8 fd ff ff       	call   8020c8 <nsipc>
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
  802327:	c3                   	ret    

00802328 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80232e:	68 bb 2e 80 00       	push   $0x802ebb
  802333:	ff 75 0c             	pushl  0xc(%ebp)
  802336:	e8 3a e5 ff ff       	call   800875 <strcpy>
	return 0;
}
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <devcons_write>:
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	57                   	push   %edi
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80234e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802353:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802359:	3b 75 10             	cmp    0x10(%ebp),%esi
  80235c:	73 31                	jae    80238f <devcons_write+0x4d>
		m = n - tot;
  80235e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802361:	29 f3                	sub    %esi,%ebx
  802363:	83 fb 7f             	cmp    $0x7f,%ebx
  802366:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80236b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	53                   	push   %ebx
  802372:	89 f0                	mov    %esi,%eax
  802374:	03 45 0c             	add    0xc(%ebp),%eax
  802377:	50                   	push   %eax
  802378:	57                   	push   %edi
  802379:	e8 85 e6 ff ff       	call   800a03 <memmove>
		sys_cputs(buf, m);
  80237e:	83 c4 08             	add    $0x8,%esp
  802381:	53                   	push   %ebx
  802382:	57                   	push   %edi
  802383:	e8 23 e8 ff ff       	call   800bab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802388:	01 de                	add    %ebx,%esi
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	eb ca                	jmp    802359 <devcons_write+0x17>
}
  80238f:	89 f0                	mov    %esi,%eax
  802391:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802394:	5b                   	pop    %ebx
  802395:	5e                   	pop    %esi
  802396:	5f                   	pop    %edi
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    

00802399 <devcons_read>:
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 08             	sub    $0x8,%esp
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023a8:	74 21                	je     8023cb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8023aa:	e8 1a e8 ff ff       	call   800bc9 <sys_cgetc>
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	75 07                	jne    8023ba <devcons_read+0x21>
		sys_yield();
  8023b3:	e8 90 e8 ff ff       	call   800c48 <sys_yield>
  8023b8:	eb f0                	jmp    8023aa <devcons_read+0x11>
	if (c < 0)
  8023ba:	78 0f                	js     8023cb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8023bc:	83 f8 04             	cmp    $0x4,%eax
  8023bf:	74 0c                	je     8023cd <devcons_read+0x34>
	*(char*)vbuf = c;
  8023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c4:	88 02                	mov    %al,(%edx)
	return 1;
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
		return 0;
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d2:	eb f7                	jmp    8023cb <devcons_read+0x32>

008023d4 <cputchar>:
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023e0:	6a 01                	push   $0x1
  8023e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023e5:	50                   	push   %eax
  8023e6:	e8 c0 e7 ff ff       	call   800bab <sys_cputs>
}
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <getchar>:
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023f6:	6a 01                	push   $0x1
  8023f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023fb:	50                   	push   %eax
  8023fc:	6a 00                	push   $0x0
  8023fe:	e8 1a f2 ff ff       	call   80161d <read>
	if (r < 0)
  802403:	83 c4 10             	add    $0x10,%esp
  802406:	85 c0                	test   %eax,%eax
  802408:	78 06                	js     802410 <getchar+0x20>
	if (r < 1)
  80240a:	74 06                	je     802412 <getchar+0x22>
	return c;
  80240c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    
		return -E_EOF;
  802412:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802417:	eb f7                	jmp    802410 <getchar+0x20>

00802419 <iscons>:
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80241f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802422:	50                   	push   %eax
  802423:	ff 75 08             	pushl  0x8(%ebp)
  802426:	e8 82 ef ff ff       	call   8013ad <fd_lookup>
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	85 c0                	test   %eax,%eax
  802430:	78 11                	js     802443 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 15 60 30 80 00    	mov    0x803060,%edx
  80243b:	39 10                	cmp    %edx,(%eax)
  80243d:	0f 94 c0             	sete   %al
  802440:	0f b6 c0             	movzbl %al,%eax
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <opencons>:
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80244b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80244e:	50                   	push   %eax
  80244f:	e8 07 ef ff ff       	call   80135b <fd_alloc>
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	85 c0                	test   %eax,%eax
  802459:	78 3a                	js     802495 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	68 07 04 00 00       	push   $0x407
  802463:	ff 75 f4             	pushl  -0xc(%ebp)
  802466:	6a 00                	push   $0x0
  802468:	e8 fa e7 ff ff       	call   800c67 <sys_page_alloc>
  80246d:	83 c4 10             	add    $0x10,%esp
  802470:	85 c0                	test   %eax,%eax
  802472:	78 21                	js     802495 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 15 60 30 80 00    	mov    0x803060,%edx
  80247d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	50                   	push   %eax
  80248d:	e8 a2 ee ff ff       	call   801334 <fd2num>
  802492:	83 c4 10             	add    $0x10,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	56                   	push   %esi
  80249b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80249c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80249f:	8b 35 08 30 80 00    	mov    0x803008,%esi
  8024a5:	e8 7f e7 ff ff       	call   800c29 <sys_getenvid>
  8024aa:	83 ec 0c             	sub    $0xc,%esp
  8024ad:	ff 75 0c             	pushl  0xc(%ebp)
  8024b0:	ff 75 08             	pushl  0x8(%ebp)
  8024b3:	56                   	push   %esi
  8024b4:	50                   	push   %eax
  8024b5:	68 c8 2e 80 00       	push   $0x802ec8
  8024ba:	e8 da dd ff ff       	call   800299 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024bf:	83 c4 18             	add    $0x18,%esp
  8024c2:	53                   	push   %ebx
  8024c3:	ff 75 10             	pushl  0x10(%ebp)
  8024c6:	e8 7d dd ff ff       	call   800248 <vcprintf>
	cprintf("\n");
  8024cb:	c7 04 24 7b 2e 80 00 	movl   $0x802e7b,(%esp)
  8024d2:	e8 c2 dd ff ff       	call   800299 <cprintf>
  8024d7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024da:	cc                   	int3   
  8024db:	eb fd                	jmp    8024da <_panic+0x43>

008024dd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8024e3:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8024ea:	74 0a                	je     8024f6 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8024f6:	a1 08 40 80 00       	mov    0x804008,%eax
  8024fb:	8b 40 48             	mov    0x48(%eax),%eax
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	6a 07                	push   $0x7
  802503:	68 00 f0 bf ee       	push   $0xeebff000
  802508:	50                   	push   %eax
  802509:	e8 59 e7 ff ff       	call   800c67 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	85 c0                	test   %eax,%eax
  802513:	78 2c                	js     802541 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802515:	e8 0f e7 ff ff       	call   800c29 <sys_getenvid>
  80251a:	83 ec 08             	sub    $0x8,%esp
  80251d:	68 53 25 80 00       	push   $0x802553
  802522:	50                   	push   %eax
  802523:	e8 8a e8 ff ff       	call   800db2 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802528:	83 c4 10             	add    $0x10,%esp
  80252b:	85 c0                	test   %eax,%eax
  80252d:	79 bd                	jns    8024ec <set_pgfault_handler+0xf>
  80252f:	50                   	push   %eax
  802530:	68 ec 2e 80 00       	push   $0x802eec
  802535:	6a 23                	push   $0x23
  802537:	68 04 2f 80 00       	push   $0x802f04
  80253c:	e8 56 ff ff ff       	call   802497 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802541:	50                   	push   %eax
  802542:	68 ec 2e 80 00       	push   $0x802eec
  802547:	6a 21                	push   $0x21
  802549:	68 04 2f 80 00       	push   $0x802f04
  80254e:	e8 44 ff ff ff       	call   802497 <_panic>

00802553 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802553:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802554:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802559:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80255b:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  80255e:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802562:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  802565:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802569:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  80256d:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802570:	83 c4 08             	add    $0x8,%esp
	popal
  802573:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802574:	83 c4 04             	add    $0x4,%esp
	popfl
  802577:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802578:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802579:	c3                   	ret    

0080257a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802580:	89 d0                	mov    %edx,%eax
  802582:	c1 e8 16             	shr    $0x16,%eax
  802585:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802591:	f6 c1 01             	test   $0x1,%cl
  802594:	74 1d                	je     8025b3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802596:	c1 ea 0c             	shr    $0xc,%edx
  802599:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025a0:	f6 c2 01             	test   $0x1,%dl
  8025a3:	74 0e                	je     8025b3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025a5:	c1 ea 0c             	shr    $0xc,%edx
  8025a8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025af:	ef 
  8025b0:	0f b7 c0             	movzwl %ax,%eax
}
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    
  8025b5:	66 90                	xchg   %ax,%ax
  8025b7:	66 90                	xchg   %ax,%ax
  8025b9:	66 90                	xchg   %ax,%ax
  8025bb:	66 90                	xchg   %ax,%ax
  8025bd:	66 90                	xchg   %ax,%ax
  8025bf:	90                   	nop

008025c0 <__udivdi3>:
  8025c0:	f3 0f 1e fb          	endbr32 
  8025c4:	55                   	push   %ebp
  8025c5:	57                   	push   %edi
  8025c6:	56                   	push   %esi
  8025c7:	53                   	push   %ebx
  8025c8:	83 ec 1c             	sub    $0x1c,%esp
  8025cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025db:	85 d2                	test   %edx,%edx
  8025dd:	75 49                	jne    802628 <__udivdi3+0x68>
  8025df:	39 f3                	cmp    %esi,%ebx
  8025e1:	76 15                	jbe    8025f8 <__udivdi3+0x38>
  8025e3:	31 ff                	xor    %edi,%edi
  8025e5:	89 e8                	mov    %ebp,%eax
  8025e7:	89 f2                	mov    %esi,%edx
  8025e9:	f7 f3                	div    %ebx
  8025eb:	89 fa                	mov    %edi,%edx
  8025ed:	83 c4 1c             	add    $0x1c,%esp
  8025f0:	5b                   	pop    %ebx
  8025f1:	5e                   	pop    %esi
  8025f2:	5f                   	pop    %edi
  8025f3:	5d                   	pop    %ebp
  8025f4:	c3                   	ret    
  8025f5:	8d 76 00             	lea    0x0(%esi),%esi
  8025f8:	89 d9                	mov    %ebx,%ecx
  8025fa:	85 db                	test   %ebx,%ebx
  8025fc:	75 0b                	jne    802609 <__udivdi3+0x49>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f3                	div    %ebx
  802607:	89 c1                	mov    %eax,%ecx
  802609:	31 d2                	xor    %edx,%edx
  80260b:	89 f0                	mov    %esi,%eax
  80260d:	f7 f1                	div    %ecx
  80260f:	89 c6                	mov    %eax,%esi
  802611:	89 e8                	mov    %ebp,%eax
  802613:	89 f7                	mov    %esi,%edi
  802615:	f7 f1                	div    %ecx
  802617:	89 fa                	mov    %edi,%edx
  802619:	83 c4 1c             	add    $0x1c,%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5f                   	pop    %edi
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    
  802621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	77 1c                	ja     802648 <__udivdi3+0x88>
  80262c:	0f bd fa             	bsr    %edx,%edi
  80262f:	83 f7 1f             	xor    $0x1f,%edi
  802632:	75 2c                	jne    802660 <__udivdi3+0xa0>
  802634:	39 f2                	cmp    %esi,%edx
  802636:	72 06                	jb     80263e <__udivdi3+0x7e>
  802638:	31 c0                	xor    %eax,%eax
  80263a:	39 eb                	cmp    %ebp,%ebx
  80263c:	77 ad                	ja     8025eb <__udivdi3+0x2b>
  80263e:	b8 01 00 00 00       	mov    $0x1,%eax
  802643:	eb a6                	jmp    8025eb <__udivdi3+0x2b>
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	31 ff                	xor    %edi,%edi
  80264a:	31 c0                	xor    %eax,%eax
  80264c:	89 fa                	mov    %edi,%edx
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	89 f9                	mov    %edi,%ecx
  802662:	b8 20 00 00 00       	mov    $0x20,%eax
  802667:	29 f8                	sub    %edi,%eax
  802669:	d3 e2                	shl    %cl,%edx
  80266b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 da                	mov    %ebx,%edx
  802673:	d3 ea                	shr    %cl,%edx
  802675:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802679:	09 d1                	or     %edx,%ecx
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 f9                	mov    %edi,%ecx
  802683:	d3 e3                	shl    %cl,%ebx
  802685:	89 c1                	mov    %eax,%ecx
  802687:	d3 ea                	shr    %cl,%edx
  802689:	89 f9                	mov    %edi,%ecx
  80268b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80268f:	89 eb                	mov    %ebp,%ebx
  802691:	d3 e6                	shl    %cl,%esi
  802693:	89 c1                	mov    %eax,%ecx
  802695:	d3 eb                	shr    %cl,%ebx
  802697:	09 de                	or     %ebx,%esi
  802699:	89 f0                	mov    %esi,%eax
  80269b:	f7 74 24 08          	divl   0x8(%esp)
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	f7 64 24 0c          	mull   0xc(%esp)
  8026a7:	39 d6                	cmp    %edx,%esi
  8026a9:	72 15                	jb     8026c0 <__udivdi3+0x100>
  8026ab:	89 f9                	mov    %edi,%ecx
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	39 c5                	cmp    %eax,%ebp
  8026b1:	73 04                	jae    8026b7 <__udivdi3+0xf7>
  8026b3:	39 d6                	cmp    %edx,%esi
  8026b5:	74 09                	je     8026c0 <__udivdi3+0x100>
  8026b7:	89 d8                	mov    %ebx,%eax
  8026b9:	31 ff                	xor    %edi,%edi
  8026bb:	e9 2b ff ff ff       	jmp    8025eb <__udivdi3+0x2b>
  8026c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026c3:	31 ff                	xor    %edi,%edi
  8026c5:	e9 21 ff ff ff       	jmp    8025eb <__udivdi3+0x2b>
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	f3 0f 1e fb          	endbr32 
  8026d4:	55                   	push   %ebp
  8026d5:	57                   	push   %edi
  8026d6:	56                   	push   %esi
  8026d7:	53                   	push   %ebx
  8026d8:	83 ec 1c             	sub    $0x1c,%esp
  8026db:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026e3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026eb:	89 da                	mov    %ebx,%edx
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	75 3f                	jne    802730 <__umoddi3+0x60>
  8026f1:	39 df                	cmp    %ebx,%edi
  8026f3:	76 13                	jbe    802708 <__umoddi3+0x38>
  8026f5:	89 f0                	mov    %esi,%eax
  8026f7:	f7 f7                	div    %edi
  8026f9:	89 d0                	mov    %edx,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	83 c4 1c             	add    $0x1c,%esp
  802700:	5b                   	pop    %ebx
  802701:	5e                   	pop    %esi
  802702:	5f                   	pop    %edi
  802703:	5d                   	pop    %ebp
  802704:	c3                   	ret    
  802705:	8d 76 00             	lea    0x0(%esi),%esi
  802708:	89 fd                	mov    %edi,%ebp
  80270a:	85 ff                	test   %edi,%edi
  80270c:	75 0b                	jne    802719 <__umoddi3+0x49>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	f7 f7                	div    %edi
  802717:	89 c5                	mov    %eax,%ebp
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f5                	div    %ebp
  80271f:	89 f0                	mov    %esi,%eax
  802721:	f7 f5                	div    %ebp
  802723:	89 d0                	mov    %edx,%eax
  802725:	eb d4                	jmp    8026fb <__umoddi3+0x2b>
  802727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80272e:	66 90                	xchg   %ax,%ax
  802730:	89 f1                	mov    %esi,%ecx
  802732:	39 d8                	cmp    %ebx,%eax
  802734:	76 0a                	jbe    802740 <__umoddi3+0x70>
  802736:	89 f0                	mov    %esi,%eax
  802738:	83 c4 1c             	add    $0x1c,%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
  802740:	0f bd e8             	bsr    %eax,%ebp
  802743:	83 f5 1f             	xor    $0x1f,%ebp
  802746:	75 20                	jne    802768 <__umoddi3+0x98>
  802748:	39 d8                	cmp    %ebx,%eax
  80274a:	0f 82 b0 00 00 00    	jb     802800 <__umoddi3+0x130>
  802750:	39 f7                	cmp    %esi,%edi
  802752:	0f 86 a8 00 00 00    	jbe    802800 <__umoddi3+0x130>
  802758:	89 c8                	mov    %ecx,%eax
  80275a:	83 c4 1c             	add    $0x1c,%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5e                   	pop    %esi
  80275f:	5f                   	pop    %edi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    
  802762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802768:	89 e9                	mov    %ebp,%ecx
  80276a:	ba 20 00 00 00       	mov    $0x20,%edx
  80276f:	29 ea                	sub    %ebp,%edx
  802771:	d3 e0                	shl    %cl,%eax
  802773:	89 44 24 08          	mov    %eax,0x8(%esp)
  802777:	89 d1                	mov    %edx,%ecx
  802779:	89 f8                	mov    %edi,%eax
  80277b:	d3 e8                	shr    %cl,%eax
  80277d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802781:	89 54 24 04          	mov    %edx,0x4(%esp)
  802785:	8b 54 24 04          	mov    0x4(%esp),%edx
  802789:	09 c1                	or     %eax,%ecx
  80278b:	89 d8                	mov    %ebx,%eax
  80278d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802791:	89 e9                	mov    %ebp,%ecx
  802793:	d3 e7                	shl    %cl,%edi
  802795:	89 d1                	mov    %edx,%ecx
  802797:	d3 e8                	shr    %cl,%eax
  802799:	89 e9                	mov    %ebp,%ecx
  80279b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80279f:	d3 e3                	shl    %cl,%ebx
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	89 d1                	mov    %edx,%ecx
  8027a5:	89 f0                	mov    %esi,%eax
  8027a7:	d3 e8                	shr    %cl,%eax
  8027a9:	89 e9                	mov    %ebp,%ecx
  8027ab:	89 fa                	mov    %edi,%edx
  8027ad:	d3 e6                	shl    %cl,%esi
  8027af:	09 d8                	or     %ebx,%eax
  8027b1:	f7 74 24 08          	divl   0x8(%esp)
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	89 f3                	mov    %esi,%ebx
  8027b9:	f7 64 24 0c          	mull   0xc(%esp)
  8027bd:	89 c6                	mov    %eax,%esi
  8027bf:	89 d7                	mov    %edx,%edi
  8027c1:	39 d1                	cmp    %edx,%ecx
  8027c3:	72 06                	jb     8027cb <__umoddi3+0xfb>
  8027c5:	75 10                	jne    8027d7 <__umoddi3+0x107>
  8027c7:	39 c3                	cmp    %eax,%ebx
  8027c9:	73 0c                	jae    8027d7 <__umoddi3+0x107>
  8027cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027d3:	89 d7                	mov    %edx,%edi
  8027d5:	89 c6                	mov    %eax,%esi
  8027d7:	89 ca                	mov    %ecx,%edx
  8027d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027de:	29 f3                	sub    %esi,%ebx
  8027e0:	19 fa                	sbb    %edi,%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	d3 e0                	shl    %cl,%eax
  8027e6:	89 e9                	mov    %ebp,%ecx
  8027e8:	d3 eb                	shr    %cl,%ebx
  8027ea:	d3 ea                	shr    %cl,%edx
  8027ec:	09 d8                	or     %ebx,%eax
  8027ee:	83 c4 1c             	add    $0x1c,%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
  8027f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027fd:	8d 76 00             	lea    0x0(%esi),%esi
  802800:	89 da                	mov    %ebx,%edx
  802802:	29 fe                	sub    %edi,%esi
  802804:	19 c2                	sbb    %eax,%edx
  802806:	89 f1                	mov    %esi,%ecx
  802808:	89 c8                	mov    %ecx,%eax
  80280a:	e9 4b ff ff ff       	jmp    80275a <__umoddi3+0x8a>
