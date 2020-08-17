
obj/user/pingpong.debug：     文件格式 elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 c9 0e 00 00       	call   800f0a <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 e0 10 00 00       	call   801138 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 e3 0a 00 00       	call   800b45 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 56 27 80 00       	push   $0x802756
  80006a:	e8 46 01 00 00       	call   8001b5 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 24 11 00 00       	call   8011ab <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 a7 0a 00 00       	call   800b45 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 40 27 80 00       	push   $0x802740
  8000a8:	e8 08 01 00 00       	call   8001b5 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 f0 10 00 00       	call   8011ab <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 75 0a 00 00       	call   800b45 <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010c:	e8 17 13 00 00       	call   801428 <close_all>
	sys_env_destroy(0);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	6a 00                	push   $0x0
  800116:	e8 e9 09 00 00       	call   800b04 <sys_env_destroy>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 13                	mov    (%ebx),%edx
  80012c:	8d 42 01             	lea    0x1(%edx),%eax
  80012f:	89 03                	mov    %eax,(%ebx)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800138:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013d:	74 09                	je     800148 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800146:	c9                   	leave  
  800147:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 ff 00 00 00       	push   $0xff
  800150:	8d 43 08             	lea    0x8(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	e8 6e 09 00 00       	call   800ac7 <sys_cputs>
		b->idx = 0;
  800159:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb db                	jmp    80013f <putch+0x1f>

00800164 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	68 20 01 80 00       	push   $0x800120
  800193:	e8 19 01 00 00       	call   8002b1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800198:	83 c4 08             	add    $0x8,%esp
  80019b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 1a 09 00 00       	call   800ac7 <sys_cputs>

	return b.cnt;
}
  8001ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001be:	50                   	push   %eax
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 9d ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 1c             	sub    $0x1c,%esp
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 d6                	mov    %edx,%esi
  8001d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001df:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001f3:	89 d0                	mov    %edx,%eax
  8001f5:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001fb:	73 15                	jae    800212 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001fd:	83 eb 01             	sub    $0x1,%ebx
  800200:	85 db                	test   %ebx,%ebx
  800202:	7e 43                	jle    800247 <printnum+0x7e>
			putch(padc, putdat);
  800204:	83 ec 08             	sub    $0x8,%esp
  800207:	56                   	push   %esi
  800208:	ff 75 18             	pushl  0x18(%ebp)
  80020b:	ff d7                	call   *%edi
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	eb eb                	jmp    8001fd <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	ff 75 18             	pushl  0x18(%ebp)
  800218:	8b 45 14             	mov    0x14(%ebp),%eax
  80021b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80021e:	53                   	push   %ebx
  80021f:	ff 75 10             	pushl  0x10(%ebp)
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	ff 75 e4             	pushl  -0x1c(%ebp)
  800228:	ff 75 e0             	pushl  -0x20(%ebp)
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	e8 aa 22 00 00       	call   8024e0 <__udivdi3>
  800236:	83 c4 18             	add    $0x18,%esp
  800239:	52                   	push   %edx
  80023a:	50                   	push   %eax
  80023b:	89 f2                	mov    %esi,%edx
  80023d:	89 f8                	mov    %edi,%eax
  80023f:	e8 85 ff ff ff       	call   8001c9 <printnum>
  800244:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800251:	ff 75 e0             	pushl  -0x20(%ebp)
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	e8 91 23 00 00       	call   8025f0 <__umoddi3>
  80025f:	83 c4 14             	add    $0x14,%esp
  800262:	0f be 80 73 27 80 00 	movsbl 0x802773(%eax),%eax
  800269:	50                   	push   %eax
  80026a:	ff d7                	call   *%edi
}
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800272:	5b                   	pop    %ebx
  800273:	5e                   	pop    %esi
  800274:	5f                   	pop    %edi
  800275:	5d                   	pop    %ebp
  800276:	c3                   	ret    

00800277 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800281:	8b 10                	mov    (%eax),%edx
  800283:	3b 50 04             	cmp    0x4(%eax),%edx
  800286:	73 0a                	jae    800292 <sprintputch+0x1b>
		*b->buf++ = ch;
  800288:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028b:	89 08                	mov    %ecx,(%eax)
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	88 02                	mov    %al,(%edx)
}
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    

00800294 <printfmt>:
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029d:	50                   	push   %eax
  80029e:	ff 75 10             	pushl  0x10(%ebp)
  8002a1:	ff 75 0c             	pushl  0xc(%ebp)
  8002a4:	ff 75 08             	pushl  0x8(%ebp)
  8002a7:	e8 05 00 00 00       	call   8002b1 <vprintfmt>
}
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <vprintfmt>:
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 3c             	sub    $0x3c,%esp
  8002ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c3:	eb 0a                	jmp    8002cf <vprintfmt+0x1e>
			putch(ch, putdat);
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	53                   	push   %ebx
  8002c9:	50                   	push   %eax
  8002ca:	ff d6                	call   *%esi
  8002cc:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002cf:	83 c7 01             	add    $0x1,%edi
  8002d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002d6:	83 f8 25             	cmp    $0x25,%eax
  8002d9:	74 0c                	je     8002e7 <vprintfmt+0x36>
			if (ch == '\0')
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	75 e6                	jne    8002c5 <vprintfmt+0x14>
}
  8002df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e2:	5b                   	pop    %ebx
  8002e3:	5e                   	pop    %esi
  8002e4:	5f                   	pop    %edi
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    
		padc = ' ';
  8002e7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002eb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800300:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800305:	8d 47 01             	lea    0x1(%edi),%eax
  800308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030b:	0f b6 17             	movzbl (%edi),%edx
  80030e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800311:	3c 55                	cmp    $0x55,%al
  800313:	0f 87 ba 03 00 00    	ja     8006d3 <vprintfmt+0x422>
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	ff 24 85 c0 28 80 00 	jmp    *0x8028c0(,%eax,4)
  800323:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800326:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032a:	eb d9                	jmp    800305 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80032f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800333:	eb d0                	jmp    800305 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800335:	0f b6 d2             	movzbl %dl,%edx
  800338:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
  800340:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800343:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800346:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800350:	83 f9 09             	cmp    $0x9,%ecx
  800353:	77 55                	ja     8003aa <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800355:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800358:	eb e9                	jmp    800343 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80035a:	8b 45 14             	mov    0x14(%ebp),%eax
  80035d:	8b 00                	mov    (%eax),%eax
  80035f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800362:	8b 45 14             	mov    0x14(%ebp),%eax
  800365:	8d 40 04             	lea    0x4(%eax),%eax
  800368:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800372:	79 91                	jns    800305 <vprintfmt+0x54>
				width = precision, precision = -1;
  800374:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800377:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800381:	eb 82                	jmp    800305 <vprintfmt+0x54>
  800383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800386:	85 c0                	test   %eax,%eax
  800388:	ba 00 00 00 00       	mov    $0x0,%edx
  80038d:	0f 49 d0             	cmovns %eax,%edx
  800390:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800396:	e9 6a ff ff ff       	jmp    800305 <vprintfmt+0x54>
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a5:	e9 5b ff ff ff       	jmp    800305 <vprintfmt+0x54>
  8003aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b0:	eb bc                	jmp    80036e <vprintfmt+0xbd>
			lflag++;
  8003b2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b8:	e9 48 ff ff ff       	jmp    800305 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8d 78 04             	lea    0x4(%eax),%edi
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	53                   	push   %ebx
  8003c7:	ff 30                	pushl  (%eax)
  8003c9:	ff d6                	call   *%esi
			break;
  8003cb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ce:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d1:	e9 9c 02 00 00       	jmp    800672 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8003d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d9:	8d 78 04             	lea    0x4(%eax),%edi
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	99                   	cltd   
  8003df:	31 d0                	xor    %edx,%eax
  8003e1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e3:	83 f8 0f             	cmp    $0xf,%eax
  8003e6:	7f 23                	jg     80040b <vprintfmt+0x15a>
  8003e8:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  8003ef:	85 d2                	test   %edx,%edx
  8003f1:	74 18                	je     80040b <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003f3:	52                   	push   %edx
  8003f4:	68 02 2d 80 00       	push   $0x802d02
  8003f9:	53                   	push   %ebx
  8003fa:	56                   	push   %esi
  8003fb:	e8 94 fe ff ff       	call   800294 <printfmt>
  800400:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800403:	89 7d 14             	mov    %edi,0x14(%ebp)
  800406:	e9 67 02 00 00       	jmp    800672 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80040b:	50                   	push   %eax
  80040c:	68 8b 27 80 00       	push   $0x80278b
  800411:	53                   	push   %ebx
  800412:	56                   	push   %esi
  800413:	e8 7c fe ff ff       	call   800294 <printfmt>
  800418:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041e:	e9 4f 02 00 00       	jmp    800672 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	83 c0 04             	add    $0x4,%eax
  800429:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800431:	85 d2                	test   %edx,%edx
  800433:	b8 84 27 80 00       	mov    $0x802784,%eax
  800438:	0f 45 c2             	cmovne %edx,%eax
  80043b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800442:	7e 06                	jle    80044a <vprintfmt+0x199>
  800444:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800448:	75 0d                	jne    800457 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044d:	89 c7                	mov    %eax,%edi
  80044f:	03 45 e0             	add    -0x20(%ebp),%eax
  800452:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800455:	eb 3f                	jmp    800496 <vprintfmt+0x1e5>
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 d8             	pushl  -0x28(%ebp)
  80045d:	50                   	push   %eax
  80045e:	e8 0d 03 00 00       	call   800770 <strnlen>
  800463:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800466:	29 c2                	sub    %eax,%edx
  800468:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800470:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800474:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800477:	85 ff                	test   %edi,%edi
  800479:	7e 58                	jle    8004d3 <vprintfmt+0x222>
					putch(padc, putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	53                   	push   %ebx
  80047f:	ff 75 e0             	pushl  -0x20(%ebp)
  800482:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800484:	83 ef 01             	sub    $0x1,%edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	eb eb                	jmp    800477 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	52                   	push   %edx
  800491:	ff d6                	call   *%esi
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800499:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049b:	83 c7 01             	add    $0x1,%edi
  80049e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a2:	0f be d0             	movsbl %al,%edx
  8004a5:	85 d2                	test   %edx,%edx
  8004a7:	74 45                	je     8004ee <vprintfmt+0x23d>
  8004a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ad:	78 06                	js     8004b5 <vprintfmt+0x204>
  8004af:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004b3:	78 35                	js     8004ea <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b9:	74 d1                	je     80048c <vprintfmt+0x1db>
  8004bb:	0f be c0             	movsbl %al,%eax
  8004be:	83 e8 20             	sub    $0x20,%eax
  8004c1:	83 f8 5e             	cmp    $0x5e,%eax
  8004c4:	76 c6                	jbe    80048c <vprintfmt+0x1db>
					putch('?', putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	6a 3f                	push   $0x3f
  8004cc:	ff d6                	call   *%esi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	eb c3                	jmp    800496 <vprintfmt+0x1e5>
  8004d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d6:	85 d2                	test   %edx,%edx
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	0f 49 c2             	cmovns %edx,%eax
  8004e0:	29 c2                	sub    %eax,%edx
  8004e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e5:	e9 60 ff ff ff       	jmp    80044a <vprintfmt+0x199>
  8004ea:	89 cf                	mov    %ecx,%edi
  8004ec:	eb 02                	jmp    8004f0 <vprintfmt+0x23f>
  8004ee:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8004f0:	85 ff                	test   %edi,%edi
  8004f2:	7e 10                	jle    800504 <vprintfmt+0x253>
				putch(' ', putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	53                   	push   %ebx
  8004f8:	6a 20                	push   $0x20
  8004fa:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fc:	83 ef 01             	sub    $0x1,%edi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	eb ec                	jmp    8004f0 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	e9 63 01 00 00       	jmp    800672 <vprintfmt+0x3c1>
	if (lflag >= 2)
  80050f:	83 f9 01             	cmp    $0x1,%ecx
  800512:	7f 1b                	jg     80052f <vprintfmt+0x27e>
	else if (lflag)
  800514:	85 c9                	test   %ecx,%ecx
  800516:	74 63                	je     80057b <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800520:	99                   	cltd   
  800521:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 04             	lea    0x4(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	eb 17                	jmp    800546 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8b 50 04             	mov    0x4(%eax),%edx
  800535:	8b 00                	mov    (%eax),%eax
  800537:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 40 08             	lea    0x8(%eax),%eax
  800543:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800551:	85 c9                	test   %ecx,%ecx
  800553:	0f 89 ff 00 00 00    	jns    800658 <vprintfmt+0x3a7>
				putch('-', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 2d                	push   $0x2d
  80055f:	ff d6                	call   *%esi
				num = -(long long) num;
  800561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800564:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800567:	f7 da                	neg    %edx
  800569:	83 d1 00             	adc    $0x0,%ecx
  80056c:	f7 d9                	neg    %ecx
  80056e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800571:	b8 0a 00 00 00       	mov    $0xa,%eax
  800576:	e9 dd 00 00 00       	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800583:	99                   	cltd   
  800584:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	eb b4                	jmp    800546 <vprintfmt+0x295>
	if (lflag >= 2)
  800592:	83 f9 01             	cmp    $0x1,%ecx
  800595:	7f 1e                	jg     8005b5 <vprintfmt+0x304>
	else if (lflag)
  800597:	85 c9                	test   %ecx,%ecx
  800599:	74 32                	je     8005cd <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8b 10                	mov    (%eax),%edx
  8005a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b0:	e9 a3 00 00 00       	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 10                	mov    (%eax),%edx
  8005ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bd:	8d 40 08             	lea    0x8(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c8:	e9 8b 00 00 00       	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	eb 74                	jmp    800658 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8005e4:	83 f9 01             	cmp    $0x1,%ecx
  8005e7:	7f 1b                	jg     800604 <vprintfmt+0x353>
	else if (lflag)
  8005e9:	85 c9                	test   %ecx,%ecx
  8005eb:	74 2c                	je     800619 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 10                	mov    (%eax),%edx
  8005f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005fd:	b8 08 00 00 00       	mov    $0x8,%eax
  800602:	eb 54                	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	8b 48 04             	mov    0x4(%eax),%ecx
  80060c:	8d 40 08             	lea    0x8(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800612:	b8 08 00 00 00       	mov    $0x8,%eax
  800617:	eb 3f                	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800623:	8d 40 04             	lea    0x4(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800629:	b8 08 00 00 00       	mov    $0x8,%eax
  80062e:	eb 28                	jmp    800658 <vprintfmt+0x3a7>
			putch('0', putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	6a 30                	push   $0x30
  800636:	ff d6                	call   *%esi
			putch('x', putdat);
  800638:	83 c4 08             	add    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 78                	push   $0x78
  80063e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80065f:	57                   	push   %edi
  800660:	ff 75 e0             	pushl  -0x20(%ebp)
  800663:	50                   	push   %eax
  800664:	51                   	push   %ecx
  800665:	52                   	push   %edx
  800666:	89 da                	mov    %ebx,%edx
  800668:	89 f0                	mov    %esi,%eax
  80066a:	e8 5a fb ff ff       	call   8001c9 <printnum>
			break;
  80066f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800675:	e9 55 fc ff ff       	jmp    8002cf <vprintfmt+0x1e>
	if (lflag >= 2)
  80067a:	83 f9 01             	cmp    $0x1,%ecx
  80067d:	7f 1b                	jg     80069a <vprintfmt+0x3e9>
	else if (lflag)
  80067f:	85 c9                	test   %ecx,%ecx
  800681:	74 2c                	je     8006af <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800693:	b8 10 00 00 00       	mov    $0x10,%eax
  800698:	eb be                	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a2:	8d 40 08             	lea    0x8(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ad:	eb a9                	jmp    800658 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 10                	mov    (%eax),%edx
  8006b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c4:	eb 92                	jmp    800658 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	6a 25                	push   $0x25
  8006cc:	ff d6                	call   *%esi
			break;
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	eb 9f                	jmp    800672 <vprintfmt+0x3c1>
			putch('%', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 25                	push   $0x25
  8006d9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	89 f8                	mov    %edi,%eax
  8006e0:	eb 03                	jmp    8006e5 <vprintfmt+0x434>
  8006e2:	83 e8 01             	sub    $0x1,%eax
  8006e5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e9:	75 f7                	jne    8006e2 <vprintfmt+0x431>
  8006eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ee:	eb 82                	jmp    800672 <vprintfmt+0x3c1>

008006f0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	83 ec 18             	sub    $0x18,%esp
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ff:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800703:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800706:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80070d:	85 c0                	test   %eax,%eax
  80070f:	74 26                	je     800737 <vsnprintf+0x47>
  800711:	85 d2                	test   %edx,%edx
  800713:	7e 22                	jle    800737 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800715:	ff 75 14             	pushl  0x14(%ebp)
  800718:	ff 75 10             	pushl  0x10(%ebp)
  80071b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80071e:	50                   	push   %eax
  80071f:	68 77 02 80 00       	push   $0x800277
  800724:	e8 88 fb ff ff       	call   8002b1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80072c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80072f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800732:	83 c4 10             	add    $0x10,%esp
}
  800735:	c9                   	leave  
  800736:	c3                   	ret    
		return -E_INVAL;
  800737:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073c:	eb f7                	jmp    800735 <vsnprintf+0x45>

0080073e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800744:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800747:	50                   	push   %eax
  800748:	ff 75 10             	pushl  0x10(%ebp)
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	ff 75 08             	pushl  0x8(%ebp)
  800751:	e8 9a ff ff ff       	call   8006f0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800767:	74 05                	je     80076e <strlen+0x16>
		n++;
  800769:	83 c0 01             	add    $0x1,%eax
  80076c:	eb f5                	jmp    800763 <strlen+0xb>
	return n;
}
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800776:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800779:	ba 00 00 00 00       	mov    $0x0,%edx
  80077e:	39 c2                	cmp    %eax,%edx
  800780:	74 0d                	je     80078f <strnlen+0x1f>
  800782:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800786:	74 05                	je     80078d <strnlen+0x1d>
		n++;
  800788:	83 c2 01             	add    $0x1,%edx
  80078b:	eb f1                	jmp    80077e <strnlen+0xe>
  80078d:	89 d0                	mov    %edx,%eax
	return n;
}
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	53                   	push   %ebx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007a7:	83 c2 01             	add    $0x1,%edx
  8007aa:	84 c9                	test   %cl,%cl
  8007ac:	75 f2                	jne    8007a0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007ae:	5b                   	pop    %ebx
  8007af:	5d                   	pop    %ebp
  8007b0:	c3                   	ret    

008007b1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	53                   	push   %ebx
  8007b5:	83 ec 10             	sub    $0x10,%esp
  8007b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007bb:	53                   	push   %ebx
  8007bc:	e8 97 ff ff ff       	call   800758 <strlen>
  8007c1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	01 d8                	add    %ebx,%eax
  8007c9:	50                   	push   %eax
  8007ca:	e8 c2 ff ff ff       	call   800791 <strcpy>
	return dst;
}
  8007cf:	89 d8                	mov    %ebx,%eax
  8007d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e1:	89 c6                	mov    %eax,%esi
  8007e3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e6:	89 c2                	mov    %eax,%edx
  8007e8:	39 f2                	cmp    %esi,%edx
  8007ea:	74 11                	je     8007fd <strncpy+0x27>
		*dst++ = *src;
  8007ec:	83 c2 01             	add    $0x1,%edx
  8007ef:	0f b6 19             	movzbl (%ecx),%ebx
  8007f2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f5:	80 fb 01             	cmp    $0x1,%bl
  8007f8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007fb:	eb eb                	jmp    8007e8 <strncpy+0x12>
	}
	return ret;
}
  8007fd:	5b                   	pop    %ebx
  8007fe:	5e                   	pop    %esi
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	56                   	push   %esi
  800805:	53                   	push   %ebx
  800806:	8b 75 08             	mov    0x8(%ebp),%esi
  800809:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080c:	8b 55 10             	mov    0x10(%ebp),%edx
  80080f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800811:	85 d2                	test   %edx,%edx
  800813:	74 21                	je     800836 <strlcpy+0x35>
  800815:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800819:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80081b:	39 c2                	cmp    %eax,%edx
  80081d:	74 14                	je     800833 <strlcpy+0x32>
  80081f:	0f b6 19             	movzbl (%ecx),%ebx
  800822:	84 db                	test   %bl,%bl
  800824:	74 0b                	je     800831 <strlcpy+0x30>
			*dst++ = *src++;
  800826:	83 c1 01             	add    $0x1,%ecx
  800829:	83 c2 01             	add    $0x1,%edx
  80082c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80082f:	eb ea                	jmp    80081b <strlcpy+0x1a>
  800831:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800833:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800836:	29 f0                	sub    %esi,%eax
}
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800845:	0f b6 01             	movzbl (%ecx),%eax
  800848:	84 c0                	test   %al,%al
  80084a:	74 0c                	je     800858 <strcmp+0x1c>
  80084c:	3a 02                	cmp    (%edx),%al
  80084e:	75 08                	jne    800858 <strcmp+0x1c>
		p++, q++;
  800850:	83 c1 01             	add    $0x1,%ecx
  800853:	83 c2 01             	add    $0x1,%edx
  800856:	eb ed                	jmp    800845 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800858:	0f b6 c0             	movzbl %al,%eax
  80085b:	0f b6 12             	movzbl (%edx),%edx
  80085e:	29 d0                	sub    %edx,%eax
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 c3                	mov    %eax,%ebx
  80086e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800871:	eb 06                	jmp    800879 <strncmp+0x17>
		n--, p++, q++;
  800873:	83 c0 01             	add    $0x1,%eax
  800876:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800879:	39 d8                	cmp    %ebx,%eax
  80087b:	74 16                	je     800893 <strncmp+0x31>
  80087d:	0f b6 08             	movzbl (%eax),%ecx
  800880:	84 c9                	test   %cl,%cl
  800882:	74 04                	je     800888 <strncmp+0x26>
  800884:	3a 0a                	cmp    (%edx),%cl
  800886:	74 eb                	je     800873 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800888:	0f b6 00             	movzbl (%eax),%eax
  80088b:	0f b6 12             	movzbl (%edx),%edx
  80088e:	29 d0                	sub    %edx,%eax
}
  800890:	5b                   	pop    %ebx
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    
		return 0;
  800893:	b8 00 00 00 00       	mov    $0x0,%eax
  800898:	eb f6                	jmp    800890 <strncmp+0x2e>

0080089a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a4:	0f b6 10             	movzbl (%eax),%edx
  8008a7:	84 d2                	test   %dl,%dl
  8008a9:	74 09                	je     8008b4 <strchr+0x1a>
		if (*s == c)
  8008ab:	38 ca                	cmp    %cl,%dl
  8008ad:	74 0a                	je     8008b9 <strchr+0x1f>
	for (; *s; s++)
  8008af:	83 c0 01             	add    $0x1,%eax
  8008b2:	eb f0                	jmp    8008a4 <strchr+0xa>
			return (char *) s;
	return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008c8:	38 ca                	cmp    %cl,%dl
  8008ca:	74 09                	je     8008d5 <strfind+0x1a>
  8008cc:	84 d2                	test   %dl,%dl
  8008ce:	74 05                	je     8008d5 <strfind+0x1a>
	for (; *s; s++)
  8008d0:	83 c0 01             	add    $0x1,%eax
  8008d3:	eb f0                	jmp    8008c5 <strfind+0xa>
			break;
	return (char *) s;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	57                   	push   %edi
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e3:	85 c9                	test   %ecx,%ecx
  8008e5:	74 31                	je     800918 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e7:	89 f8                	mov    %edi,%eax
  8008e9:	09 c8                	or     %ecx,%eax
  8008eb:	a8 03                	test   $0x3,%al
  8008ed:	75 23                	jne    800912 <memset+0x3b>
		c &= 0xFF;
  8008ef:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f3:	89 d3                	mov    %edx,%ebx
  8008f5:	c1 e3 08             	shl    $0x8,%ebx
  8008f8:	89 d0                	mov    %edx,%eax
  8008fa:	c1 e0 18             	shl    $0x18,%eax
  8008fd:	89 d6                	mov    %edx,%esi
  8008ff:	c1 e6 10             	shl    $0x10,%esi
  800902:	09 f0                	or     %esi,%eax
  800904:	09 c2                	or     %eax,%edx
  800906:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800908:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80090b:	89 d0                	mov    %edx,%eax
  80090d:	fc                   	cld    
  80090e:	f3 ab                	rep stos %eax,%es:(%edi)
  800910:	eb 06                	jmp    800918 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800912:	8b 45 0c             	mov    0xc(%ebp),%eax
  800915:	fc                   	cld    
  800916:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800918:	89 f8                	mov    %edi,%eax
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5f                   	pop    %edi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	57                   	push   %edi
  800923:	56                   	push   %esi
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80092d:	39 c6                	cmp    %eax,%esi
  80092f:	73 32                	jae    800963 <memmove+0x44>
  800931:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800934:	39 c2                	cmp    %eax,%edx
  800936:	76 2b                	jbe    800963 <memmove+0x44>
		s += n;
		d += n;
  800938:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093b:	89 fe                	mov    %edi,%esi
  80093d:	09 ce                	or     %ecx,%esi
  80093f:	09 d6                	or     %edx,%esi
  800941:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800947:	75 0e                	jne    800957 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800949:	83 ef 04             	sub    $0x4,%edi
  80094c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80094f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800952:	fd                   	std    
  800953:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800955:	eb 09                	jmp    800960 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800957:	83 ef 01             	sub    $0x1,%edi
  80095a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80095d:	fd                   	std    
  80095e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800960:	fc                   	cld    
  800961:	eb 1a                	jmp    80097d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800963:	89 c2                	mov    %eax,%edx
  800965:	09 ca                	or     %ecx,%edx
  800967:	09 f2                	or     %esi,%edx
  800969:	f6 c2 03             	test   $0x3,%dl
  80096c:	75 0a                	jne    800978 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800971:	89 c7                	mov    %eax,%edi
  800973:	fc                   	cld    
  800974:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800976:	eb 05                	jmp    80097d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800978:	89 c7                	mov    %eax,%edi
  80097a:	fc                   	cld    
  80097b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80097d:	5e                   	pop    %esi
  80097e:	5f                   	pop    %edi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800987:	ff 75 10             	pushl  0x10(%ebp)
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	ff 75 08             	pushl  0x8(%ebp)
  800990:	e8 8a ff ff ff       	call   80091f <memmove>
}
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a2:	89 c6                	mov    %eax,%esi
  8009a4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009a7:	39 f0                	cmp    %esi,%eax
  8009a9:	74 1c                	je     8009c7 <memcmp+0x30>
		if (*s1 != *s2)
  8009ab:	0f b6 08             	movzbl (%eax),%ecx
  8009ae:	0f b6 1a             	movzbl (%edx),%ebx
  8009b1:	38 d9                	cmp    %bl,%cl
  8009b3:	75 08                	jne    8009bd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	eb ea                	jmp    8009a7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009bd:	0f b6 c1             	movzbl %cl,%eax
  8009c0:	0f b6 db             	movzbl %bl,%ebx
  8009c3:	29 d8                	sub    %ebx,%eax
  8009c5:	eb 05                	jmp    8009cc <memcmp+0x35>
	}

	return 0;
  8009c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cc:	5b                   	pop    %ebx
  8009cd:	5e                   	pop    %esi
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009d9:	89 c2                	mov    %eax,%edx
  8009db:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009de:	39 d0                	cmp    %edx,%eax
  8009e0:	73 09                	jae    8009eb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e2:	38 08                	cmp    %cl,(%eax)
  8009e4:	74 05                	je     8009eb <memfind+0x1b>
	for (; s < ends; s++)
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	eb f3                	jmp    8009de <memfind+0xe>
			break;
	return (void *) s;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	57                   	push   %edi
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009f9:	eb 03                	jmp    8009fe <strtol+0x11>
		s++;
  8009fb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009fe:	0f b6 01             	movzbl (%ecx),%eax
  800a01:	3c 20                	cmp    $0x20,%al
  800a03:	74 f6                	je     8009fb <strtol+0xe>
  800a05:	3c 09                	cmp    $0x9,%al
  800a07:	74 f2                	je     8009fb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a09:	3c 2b                	cmp    $0x2b,%al
  800a0b:	74 2a                	je     800a37 <strtol+0x4a>
	int neg = 0;
  800a0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a12:	3c 2d                	cmp    $0x2d,%al
  800a14:	74 2b                	je     800a41 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a1c:	75 0f                	jne    800a2d <strtol+0x40>
  800a1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a21:	74 28                	je     800a4b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a23:	85 db                	test   %ebx,%ebx
  800a25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2a:	0f 44 d8             	cmove  %eax,%ebx
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a35:	eb 50                	jmp    800a87 <strtol+0x9a>
		s++;
  800a37:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3f:	eb d5                	jmp    800a16 <strtol+0x29>
		s++, neg = 1;
  800a41:	83 c1 01             	add    $0x1,%ecx
  800a44:	bf 01 00 00 00       	mov    $0x1,%edi
  800a49:	eb cb                	jmp    800a16 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a4f:	74 0e                	je     800a5f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a51:	85 db                	test   %ebx,%ebx
  800a53:	75 d8                	jne    800a2d <strtol+0x40>
		s++, base = 8;
  800a55:	83 c1 01             	add    $0x1,%ecx
  800a58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a5d:	eb ce                	jmp    800a2d <strtol+0x40>
		s += 2, base = 16;
  800a5f:	83 c1 02             	add    $0x2,%ecx
  800a62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a67:	eb c4                	jmp    800a2d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a69:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a6c:	89 f3                	mov    %esi,%ebx
  800a6e:	80 fb 19             	cmp    $0x19,%bl
  800a71:	77 29                	ja     800a9c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a73:	0f be d2             	movsbl %dl,%edx
  800a76:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a79:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7c:	7d 30                	jge    800aae <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a7e:	83 c1 01             	add    $0x1,%ecx
  800a81:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a85:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a87:	0f b6 11             	movzbl (%ecx),%edx
  800a8a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a8d:	89 f3                	mov    %esi,%ebx
  800a8f:	80 fb 09             	cmp    $0x9,%bl
  800a92:	77 d5                	ja     800a69 <strtol+0x7c>
			dig = *s - '0';
  800a94:	0f be d2             	movsbl %dl,%edx
  800a97:	83 ea 30             	sub    $0x30,%edx
  800a9a:	eb dd                	jmp    800a79 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a9c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a9f:	89 f3                	mov    %esi,%ebx
  800aa1:	80 fb 19             	cmp    $0x19,%bl
  800aa4:	77 08                	ja     800aae <strtol+0xc1>
			dig = *s - 'A' + 10;
  800aa6:	0f be d2             	movsbl %dl,%edx
  800aa9:	83 ea 37             	sub    $0x37,%edx
  800aac:	eb cb                	jmp    800a79 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab2:	74 05                	je     800ab9 <strtol+0xcc>
		*endptr = (char *) s;
  800ab4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ab9:	89 c2                	mov    %eax,%edx
  800abb:	f7 da                	neg    %edx
  800abd:	85 ff                	test   %edi,%edi
  800abf:	0f 45 c2             	cmovne %edx,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5f                   	pop    %edi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	57                   	push   %edi
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad8:	89 c3                	mov    %eax,%ebx
  800ada:	89 c7                	mov    %eax,%edi
  800adc:	89 c6                	mov    %eax,%esi
  800ade:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5f                   	pop    %edi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	57                   	push   %edi
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	b8 01 00 00 00       	mov    $0x1,%eax
  800af5:	89 d1                	mov    %edx,%ecx
  800af7:	89 d3                	mov    %edx,%ebx
  800af9:	89 d7                	mov    %edx,%edi
  800afb:	89 d6                	mov    %edx,%esi
  800afd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
  800b0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	b8 03 00 00 00       	mov    $0x3,%eax
  800b1a:	89 cb                	mov    %ecx,%ebx
  800b1c:	89 cf                	mov    %ecx,%edi
  800b1e:	89 ce                	mov    %ecx,%esi
  800b20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b22:	85 c0                	test   %eax,%eax
  800b24:	7f 08                	jg     800b2e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b29:	5b                   	pop    %ebx
  800b2a:	5e                   	pop    %esi
  800b2b:	5f                   	pop    %edi
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b2e:	83 ec 0c             	sub    $0xc,%esp
  800b31:	50                   	push   %eax
  800b32:	6a 03                	push   $0x3
  800b34:	68 7f 2a 80 00       	push   $0x802a7f
  800b39:	6a 23                	push   $0x23
  800b3b:	68 9c 2a 80 00       	push   $0x802a9c
  800b40:	e8 6e 18 00 00       	call   8023b3 <_panic>

00800b45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	b8 02 00 00 00       	mov    $0x2,%eax
  800b55:	89 d1                	mov    %edx,%ecx
  800b57:	89 d3                	mov    %edx,%ebx
  800b59:	89 d7                	mov    %edx,%edi
  800b5b:	89 d6                	mov    %edx,%esi
  800b5d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <sys_yield>:

void
sys_yield(void)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b74:	89 d1                	mov    %edx,%ecx
  800b76:	89 d3                	mov    %edx,%ebx
  800b78:	89 d7                	mov    %edx,%edi
  800b7a:	89 d6                	mov    %edx,%esi
  800b7c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8c:	be 00 00 00 00       	mov    $0x0,%esi
  800b91:	8b 55 08             	mov    0x8(%ebp),%edx
  800b94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b97:	b8 04 00 00 00       	mov    $0x4,%eax
  800b9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b9f:	89 f7                	mov    %esi,%edi
  800ba1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba3:	85 c0                	test   %eax,%eax
  800ba5:	7f 08                	jg     800baf <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ba7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800baf:	83 ec 0c             	sub    $0xc,%esp
  800bb2:	50                   	push   %eax
  800bb3:	6a 04                	push   $0x4
  800bb5:	68 7f 2a 80 00       	push   $0x802a7f
  800bba:	6a 23                	push   $0x23
  800bbc:	68 9c 2a 80 00       	push   $0x802a9c
  800bc1:	e8 ed 17 00 00       	call   8023b3 <_panic>

00800bc6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd5:	b8 05 00 00 00       	mov    $0x5,%eax
  800bda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bdd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800be0:	8b 75 18             	mov    0x18(%ebp),%esi
  800be3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be5:	85 c0                	test   %eax,%eax
  800be7:	7f 08                	jg     800bf1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf1:	83 ec 0c             	sub    $0xc,%esp
  800bf4:	50                   	push   %eax
  800bf5:	6a 05                	push   $0x5
  800bf7:	68 7f 2a 80 00       	push   $0x802a7f
  800bfc:	6a 23                	push   $0x23
  800bfe:	68 9c 2a 80 00       	push   $0x802a9c
  800c03:	e8 ab 17 00 00       	call   8023b3 <_panic>

00800c08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1c:	b8 06 00 00 00       	mov    $0x6,%eax
  800c21:	89 df                	mov    %ebx,%edi
  800c23:	89 de                	mov    %ebx,%esi
  800c25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c27:	85 c0                	test   %eax,%eax
  800c29:	7f 08                	jg     800c33 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	50                   	push   %eax
  800c37:	6a 06                	push   $0x6
  800c39:	68 7f 2a 80 00       	push   $0x802a7f
  800c3e:	6a 23                	push   $0x23
  800c40:	68 9c 2a 80 00       	push   $0x802a9c
  800c45:	e8 69 17 00 00       	call   8023b3 <_panic>

00800c4a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c63:	89 df                	mov    %ebx,%edi
  800c65:	89 de                	mov    %ebx,%esi
  800c67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c69:	85 c0                	test   %eax,%eax
  800c6b:	7f 08                	jg     800c75 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c75:	83 ec 0c             	sub    $0xc,%esp
  800c78:	50                   	push   %eax
  800c79:	6a 08                	push   $0x8
  800c7b:	68 7f 2a 80 00       	push   $0x802a7f
  800c80:	6a 23                	push   $0x23
  800c82:	68 9c 2a 80 00       	push   $0x802a9c
  800c87:	e8 27 17 00 00       	call   8023b3 <_panic>

00800c8c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ca5:	89 df                	mov    %ebx,%edi
  800ca7:	89 de                	mov    %ebx,%esi
  800ca9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cab:	85 c0                	test   %eax,%eax
  800cad:	7f 08                	jg     800cb7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	83 ec 0c             	sub    $0xc,%esp
  800cba:	50                   	push   %eax
  800cbb:	6a 09                	push   $0x9
  800cbd:	68 7f 2a 80 00       	push   $0x802a7f
  800cc2:	6a 23                	push   $0x23
  800cc4:	68 9c 2a 80 00       	push   $0x802a9c
  800cc9:	e8 e5 16 00 00       	call   8023b3 <_panic>

00800cce <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce7:	89 df                	mov    %ebx,%edi
  800ce9:	89 de                	mov    %ebx,%esi
  800ceb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ced:	85 c0                	test   %eax,%eax
  800cef:	7f 08                	jg     800cf9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf9:	83 ec 0c             	sub    $0xc,%esp
  800cfc:	50                   	push   %eax
  800cfd:	6a 0a                	push   $0xa
  800cff:	68 7f 2a 80 00       	push   $0x802a7f
  800d04:	6a 23                	push   $0x23
  800d06:	68 9c 2a 80 00       	push   $0x802a9c
  800d0b:	e8 a3 16 00 00       	call   8023b3 <_panic>

00800d10 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d21:	be 00 00 00 00       	mov    $0x0,%esi
  800d26:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d29:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d41:	8b 55 08             	mov    0x8(%ebp),%edx
  800d44:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d49:	89 cb                	mov    %ecx,%ebx
  800d4b:	89 cf                	mov    %ecx,%edi
  800d4d:	89 ce                	mov    %ecx,%esi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 0d                	push   $0xd
  800d63:	68 7f 2a 80 00       	push   $0x802a7f
  800d68:	6a 23                	push   $0x23
  800d6a:	68 9c 2a 80 00       	push   $0x802a9c
  800d6f:	e8 3f 16 00 00       	call   8023b3 <_panic>

00800d74 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d84:	89 d1                	mov    %edx,%ecx
  800d86:	89 d3                	mov    %edx,%ebx
  800d88:	89 d7                	mov    %edx,%edi
  800d8a:	89 d6                	mov    %edx,%esi
  800d8c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800d9f:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800da1:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800da4:	89 d9                	mov    %ebx,%ecx
  800da6:	c1 e9 16             	shr    $0x16,%ecx
  800da9:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800db0:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800db5:	f6 c1 01             	test   $0x1,%cl
  800db8:	74 0c                	je     800dc6 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800dba:	89 d9                	mov    %ebx,%ecx
  800dbc:	c1 e9 0c             	shr    $0xc,%ecx
  800dbf:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800dc6:	f6 c2 02             	test   $0x2,%dl
  800dc9:	0f 84 a3 00 00 00    	je     800e72 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800dcf:	89 da                	mov    %ebx,%edx
  800dd1:	c1 ea 0c             	shr    $0xc,%edx
  800dd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ddb:	f6 c6 08             	test   $0x8,%dh
  800dde:	0f 84 b7 00 00 00    	je     800e9b <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800de4:	e8 5c fd ff ff       	call   800b45 <sys_getenvid>
  800de9:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	6a 07                	push   $0x7
  800df0:	68 00 f0 7f 00       	push   $0x7ff000
  800df5:	50                   	push   %eax
  800df6:	e8 88 fd ff ff       	call   800b83 <sys_page_alloc>
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	0f 88 bc 00 00 00    	js     800ec2 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800e06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800e0c:	83 ec 04             	sub    $0x4,%esp
  800e0f:	68 00 10 00 00       	push   $0x1000
  800e14:	53                   	push   %ebx
  800e15:	68 00 f0 7f 00       	push   $0x7ff000
  800e1a:	e8 00 fb ff ff       	call   80091f <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800e1f:	83 c4 08             	add    $0x8,%esp
  800e22:	53                   	push   %ebx
  800e23:	56                   	push   %esi
  800e24:	e8 df fd ff ff       	call   800c08 <sys_page_unmap>
  800e29:	83 c4 10             	add    $0x10,%esp
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	0f 88 a0 00 00 00    	js     800ed4 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	6a 07                	push   $0x7
  800e39:	53                   	push   %ebx
  800e3a:	56                   	push   %esi
  800e3b:	68 00 f0 7f 00       	push   $0x7ff000
  800e40:	56                   	push   %esi
  800e41:	e8 80 fd ff ff       	call   800bc6 <sys_page_map>
  800e46:	83 c4 20             	add    $0x20,%esp
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	0f 88 95 00 00 00    	js     800ee6 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	68 00 f0 7f 00       	push   $0x7ff000
  800e59:	56                   	push   %esi
  800e5a:	e8 a9 fd ff ff       	call   800c08 <sys_page_unmap>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	85 c0                	test   %eax,%eax
  800e64:	0f 88 8e 00 00 00    	js     800ef8 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800e72:	8b 70 28             	mov    0x28(%eax),%esi
  800e75:	e8 cb fc ff ff       	call   800b45 <sys_getenvid>
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	50                   	push   %eax
  800e7d:	68 ac 2a 80 00       	push   $0x802aac
  800e82:	e8 2e f3 ff ff       	call   8001b5 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800e87:	83 c4 0c             	add    $0xc,%esp
  800e8a:	68 d0 2a 80 00       	push   $0x802ad0
  800e8f:	6a 27                	push   $0x27
  800e91:	68 a4 2b 80 00       	push   $0x802ba4
  800e96:	e8 18 15 00 00       	call   8023b3 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800e9b:	8b 78 28             	mov    0x28(%eax),%edi
  800e9e:	e8 a2 fc ff ff       	call   800b45 <sys_getenvid>
  800ea3:	57                   	push   %edi
  800ea4:	53                   	push   %ebx
  800ea5:	50                   	push   %eax
  800ea6:	68 ac 2a 80 00       	push   $0x802aac
  800eab:	e8 05 f3 ff ff       	call   8001b5 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800eb0:	56                   	push   %esi
  800eb1:	68 04 2b 80 00       	push   $0x802b04
  800eb6:	6a 2b                	push   $0x2b
  800eb8:	68 a4 2b 80 00       	push   $0x802ba4
  800ebd:	e8 f1 14 00 00       	call   8023b3 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800ec2:	50                   	push   %eax
  800ec3:	68 3c 2b 80 00       	push   $0x802b3c
  800ec8:	6a 39                	push   $0x39
  800eca:	68 a4 2b 80 00       	push   $0x802ba4
  800ecf:	e8 df 14 00 00       	call   8023b3 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800ed4:	50                   	push   %eax
  800ed5:	68 60 2b 80 00       	push   $0x802b60
  800eda:	6a 3e                	push   $0x3e
  800edc:	68 a4 2b 80 00       	push   $0x802ba4
  800ee1:	e8 cd 14 00 00       	call   8023b3 <_panic>
      panic("pgfault: page map failed (%e)", r);
  800ee6:	50                   	push   %eax
  800ee7:	68 af 2b 80 00       	push   $0x802baf
  800eec:	6a 40                	push   $0x40
  800eee:	68 a4 2b 80 00       	push   $0x802ba4
  800ef3:	e8 bb 14 00 00       	call   8023b3 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800ef8:	50                   	push   %eax
  800ef9:	68 60 2b 80 00       	push   $0x802b60
  800efe:	6a 42                	push   $0x42
  800f00:	68 a4 2b 80 00       	push   $0x802ba4
  800f05:	e8 a9 14 00 00       	call   8023b3 <_panic>

00800f0a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800f13:	68 93 0d 80 00       	push   $0x800d93
  800f18:	e8 dc 14 00 00       	call   8023f9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f1d:	b8 07 00 00 00       	mov    $0x7,%eax
  800f22:	cd 30                	int    $0x30
  800f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	78 2d                	js     800f5b <fork+0x51>
  800f2e:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f30:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	0f 85 a6 00 00 00    	jne    800fe5 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  800f3f:	e8 01 fc ff ff       	call   800b45 <sys_getenvid>
  800f44:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f49:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f4c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f51:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  800f56:	e9 79 01 00 00       	jmp    8010d4 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  800f5b:	50                   	push   %eax
  800f5c:	68 cd 2b 80 00       	push   $0x802bcd
  800f61:	68 aa 00 00 00       	push   $0xaa
  800f66:	68 a4 2b 80 00       	push   $0x802ba4
  800f6b:	e8 43 14 00 00       	call   8023b3 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	6a 05                	push   $0x5
  800f75:	53                   	push   %ebx
  800f76:	57                   	push   %edi
  800f77:	53                   	push   %ebx
  800f78:	6a 00                	push   $0x0
  800f7a:	e8 47 fc ff ff       	call   800bc6 <sys_page_map>
  800f7f:	83 c4 20             	add    $0x20,%esp
  800f82:	85 c0                	test   %eax,%eax
  800f84:	79 4d                	jns    800fd3 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  800f86:	50                   	push   %eax
  800f87:	68 d6 2b 80 00       	push   $0x802bd6
  800f8c:	6a 61                	push   $0x61
  800f8e:	68 a4 2b 80 00       	push   $0x802ba4
  800f93:	e8 1b 14 00 00       	call   8023b3 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	68 05 08 00 00       	push   $0x805
  800fa0:	53                   	push   %ebx
  800fa1:	57                   	push   %edi
  800fa2:	53                   	push   %ebx
  800fa3:	6a 00                	push   $0x0
  800fa5:	e8 1c fc ff ff       	call   800bc6 <sys_page_map>
  800faa:	83 c4 20             	add    $0x20,%esp
  800fad:	85 c0                	test   %eax,%eax
  800faf:	0f 88 b7 00 00 00    	js     80106c <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800fb5:	83 ec 0c             	sub    $0xc,%esp
  800fb8:	68 05 08 00 00       	push   $0x805
  800fbd:	53                   	push   %ebx
  800fbe:	6a 00                	push   $0x0
  800fc0:	53                   	push   %ebx
  800fc1:	6a 00                	push   $0x0
  800fc3:	e8 fe fb ff ff       	call   800bc6 <sys_page_map>
  800fc8:	83 c4 20             	add    $0x20,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	0f 88 ab 00 00 00    	js     80107e <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fd3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fd9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fdf:	0f 84 ab 00 00 00    	je     801090 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  800fe5:	89 d8                	mov    %ebx,%eax
  800fe7:	c1 e8 16             	shr    $0x16,%eax
  800fea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ff1:	a8 01                	test   $0x1,%al
  800ff3:	74 de                	je     800fd3 <fork+0xc9>
  800ff5:	89 d8                	mov    %ebx,%eax
  800ff7:	c1 e8 0c             	shr    $0xc,%eax
  800ffa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801001:	f6 c2 01             	test   $0x1,%dl
  801004:	74 cd                	je     800fd3 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801006:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801009:	89 c2                	mov    %eax,%edx
  80100b:	c1 ea 16             	shr    $0x16,%edx
  80100e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801015:	f6 c2 01             	test   $0x1,%dl
  801018:	74 b9                	je     800fd3 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  80101a:	c1 e8 0c             	shr    $0xc,%eax
  80101d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801024:	a8 01                	test   $0x1,%al
  801026:	74 ab                	je     800fd3 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801028:	a9 02 08 00 00       	test   $0x802,%eax
  80102d:	0f 84 3d ff ff ff    	je     800f70 <fork+0x66>
	else if(pte & PTE_SHARE)
  801033:	f6 c4 04             	test   $0x4,%ah
  801036:	0f 84 5c ff ff ff    	je     800f98 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	25 07 0e 00 00       	and    $0xe07,%eax
  801044:	50                   	push   %eax
  801045:	53                   	push   %ebx
  801046:	57                   	push   %edi
  801047:	53                   	push   %ebx
  801048:	6a 00                	push   $0x0
  80104a:	e8 77 fb ff ff       	call   800bc6 <sys_page_map>
  80104f:	83 c4 20             	add    $0x20,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	0f 89 79 ff ff ff    	jns    800fd3 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80105a:	50                   	push   %eax
  80105b:	68 d6 2b 80 00       	push   $0x802bd6
  801060:	6a 67                	push   $0x67
  801062:	68 a4 2b 80 00       	push   $0x802ba4
  801067:	e8 47 13 00 00       	call   8023b3 <_panic>
			panic("Page Map Failed: %e", error_code);
  80106c:	50                   	push   %eax
  80106d:	68 d6 2b 80 00       	push   $0x802bd6
  801072:	6a 6d                	push   $0x6d
  801074:	68 a4 2b 80 00       	push   $0x802ba4
  801079:	e8 35 13 00 00       	call   8023b3 <_panic>
			panic("Page Map Failed: %e", error_code);
  80107e:	50                   	push   %eax
  80107f:	68 d6 2b 80 00       	push   $0x802bd6
  801084:	6a 70                	push   $0x70
  801086:	68 a4 2b 80 00       	push   $0x802ba4
  80108b:	e8 23 13 00 00       	call   8023b3 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	6a 07                	push   $0x7
  801095:	68 00 f0 bf ee       	push   $0xeebff000
  80109a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109d:	e8 e1 fa ff ff       	call   800b83 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 36                	js     8010df <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	68 6f 24 80 00       	push   $0x80246f
  8010b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010b4:	e8 15 fc ff ff       	call   800cce <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010b9:	83 c4 10             	add    $0x10,%esp
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	78 34                	js     8010f4 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8010c0:	83 ec 08             	sub    $0x8,%esp
  8010c3:	6a 02                	push   $0x2
  8010c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010c8:	e8 7d fb ff ff       	call   800c4a <sys_env_set_status>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 35                	js     801109 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8010d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  8010df:	50                   	push   %eax
  8010e0:	68 cd 2b 80 00       	push   $0x802bcd
  8010e5:	68 ba 00 00 00       	push   $0xba
  8010ea:	68 a4 2b 80 00       	push   $0x802ba4
  8010ef:	e8 bf 12 00 00       	call   8023b3 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010f4:	50                   	push   %eax
  8010f5:	68 80 2b 80 00       	push   $0x802b80
  8010fa:	68 bf 00 00 00       	push   $0xbf
  8010ff:	68 a4 2b 80 00       	push   $0x802ba4
  801104:	e8 aa 12 00 00       	call   8023b3 <_panic>
      panic("sys_env_set_status: %e", r);
  801109:	50                   	push   %eax
  80110a:	68 ea 2b 80 00       	push   $0x802bea
  80110f:	68 c3 00 00 00       	push   $0xc3
  801114:	68 a4 2b 80 00       	push   $0x802ba4
  801119:	e8 95 12 00 00       	call   8023b3 <_panic>

0080111e <sfork>:

// Challenge!
int
sfork(void)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801124:	68 01 2c 80 00       	push   $0x802c01
  801129:	68 cc 00 00 00       	push   $0xcc
  80112e:	68 a4 2b 80 00       	push   $0x802ba4
  801133:	e8 7b 12 00 00       	call   8023b3 <_panic>

00801138 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	8b 75 08             	mov    0x8(%ebp),%esi
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801146:	85 c0                	test   %eax,%eax
  801148:	74 4f                	je     801199 <ipc_recv+0x61>
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	50                   	push   %eax
  80114e:	e8 e0 fb ff ff       	call   800d33 <sys_ipc_recv>
  801153:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801156:	85 f6                	test   %esi,%esi
  801158:	74 14                	je     80116e <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  80115a:	ba 00 00 00 00       	mov    $0x0,%edx
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 09                	jne    80116c <ipc_recv+0x34>
  801163:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801169:	8b 52 74             	mov    0x74(%edx),%edx
  80116c:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80116e:	85 db                	test   %ebx,%ebx
  801170:	74 14                	je     801186 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801172:	ba 00 00 00 00       	mov    $0x0,%edx
  801177:	85 c0                	test   %eax,%eax
  801179:	75 09                	jne    801184 <ipc_recv+0x4c>
  80117b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801181:	8b 52 78             	mov    0x78(%edx),%edx
  801184:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801186:	85 c0                	test   %eax,%eax
  801188:	75 08                	jne    801192 <ipc_recv+0x5a>
  80118a:	a1 08 40 80 00       	mov    0x804008,%eax
  80118f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801192:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	68 00 00 c0 ee       	push   $0xeec00000
  8011a1:	e8 8d fb ff ff       	call   800d33 <sys_ipc_recv>
  8011a6:	83 c4 10             	add    $0x10,%esp
  8011a9:	eb ab                	jmp    801156 <ipc_recv+0x1e>

008011ab <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	57                   	push   %edi
  8011af:	56                   	push   %esi
  8011b0:	53                   	push   %ebx
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011b7:	8b 75 10             	mov    0x10(%ebp),%esi
  8011ba:	eb 20                	jmp    8011dc <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8011bc:	6a 00                	push   $0x0
  8011be:	68 00 00 c0 ee       	push   $0xeec00000
  8011c3:	ff 75 0c             	pushl  0xc(%ebp)
  8011c6:	57                   	push   %edi
  8011c7:	e8 44 fb ff ff       	call   800d10 <sys_ipc_try_send>
  8011cc:	89 c3                	mov    %eax,%ebx
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	eb 1f                	jmp    8011f2 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  8011d3:	e8 8c f9 ff ff       	call   800b64 <sys_yield>
	while(retval != 0) {
  8011d8:	85 db                	test   %ebx,%ebx
  8011da:	74 33                	je     80120f <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8011dc:	85 f6                	test   %esi,%esi
  8011de:	74 dc                	je     8011bc <ipc_send+0x11>
  8011e0:	ff 75 14             	pushl  0x14(%ebp)
  8011e3:	56                   	push   %esi
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	57                   	push   %edi
  8011e8:	e8 23 fb ff ff       	call   800d10 <sys_ipc_try_send>
  8011ed:	89 c3                	mov    %eax,%ebx
  8011ef:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8011f2:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8011f5:	74 dc                	je     8011d3 <ipc_send+0x28>
  8011f7:	85 db                	test   %ebx,%ebx
  8011f9:	74 d8                	je     8011d3 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	68 18 2c 80 00       	push   $0x802c18
  801203:	6a 35                	push   $0x35
  801205:	68 48 2c 80 00       	push   $0x802c48
  80120a:	e8 a4 11 00 00       	call   8023b3 <_panic>
	}
}
  80120f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801222:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801225:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80122b:	8b 52 50             	mov    0x50(%edx),%edx
  80122e:	39 ca                	cmp    %ecx,%edx
  801230:	74 11                	je     801243 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801232:	83 c0 01             	add    $0x1,%eax
  801235:	3d 00 04 00 00       	cmp    $0x400,%eax
  80123a:	75 e6                	jne    801222 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
  801241:	eb 0b                	jmp    80124e <ipc_find_env+0x37>
			return envs[i].env_id;
  801243:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801246:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80124b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	05 00 00 00 30       	add    $0x30000000,%eax
  80125b:	c1 e8 0c             	shr    $0xc,%eax
}
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    

00801260 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80126b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801270:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80127f:	89 c2                	mov    %eax,%edx
  801281:	c1 ea 16             	shr    $0x16,%edx
  801284:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80128b:	f6 c2 01             	test   $0x1,%dl
  80128e:	74 2d                	je     8012bd <fd_alloc+0x46>
  801290:	89 c2                	mov    %eax,%edx
  801292:	c1 ea 0c             	shr    $0xc,%edx
  801295:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129c:	f6 c2 01             	test   $0x1,%dl
  80129f:	74 1c                	je     8012bd <fd_alloc+0x46>
  8012a1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012a6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ab:	75 d2                	jne    80127f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012bb:	eb 0a                	jmp    8012c7 <fd_alloc+0x50>
			*fd_store = fd;
  8012bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012cf:	83 f8 1f             	cmp    $0x1f,%eax
  8012d2:	77 30                	ja     801304 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012d4:	c1 e0 0c             	shl    $0xc,%eax
  8012d7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012dc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012e2:	f6 c2 01             	test   $0x1,%dl
  8012e5:	74 24                	je     80130b <fd_lookup+0x42>
  8012e7:	89 c2                	mov    %eax,%edx
  8012e9:	c1 ea 0c             	shr    $0xc,%edx
  8012ec:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f3:	f6 c2 01             	test   $0x1,%dl
  8012f6:	74 1a                	je     801312 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fb:	89 02                	mov    %eax,(%edx)
	return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    
		return -E_INVAL;
  801304:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801309:	eb f7                	jmp    801302 <fd_lookup+0x39>
		return -E_INVAL;
  80130b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801310:	eb f0                	jmp    801302 <fd_lookup+0x39>
  801312:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801317:	eb e9                	jmp    801302 <fd_lookup+0x39>

00801319 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801322:	ba 00 00 00 00       	mov    $0x0,%edx
  801327:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80132c:	39 08                	cmp    %ecx,(%eax)
  80132e:	74 38                	je     801368 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801330:	83 c2 01             	add    $0x1,%edx
  801333:	8b 04 95 d0 2c 80 00 	mov    0x802cd0(,%edx,4),%eax
  80133a:	85 c0                	test   %eax,%eax
  80133c:	75 ee                	jne    80132c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80133e:	a1 08 40 80 00       	mov    0x804008,%eax
  801343:	8b 40 48             	mov    0x48(%eax),%eax
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	51                   	push   %ecx
  80134a:	50                   	push   %eax
  80134b:	68 54 2c 80 00       	push   $0x802c54
  801350:	e8 60 ee ff ff       	call   8001b5 <cprintf>
	*dev = 0;
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    
			*dev = devtab[i];
  801368:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	eb f2                	jmp    801366 <dev_lookup+0x4d>

00801374 <fd_close>:
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	57                   	push   %edi
  801378:	56                   	push   %esi
  801379:	53                   	push   %ebx
  80137a:	83 ec 24             	sub    $0x24,%esp
  80137d:	8b 75 08             	mov    0x8(%ebp),%esi
  801380:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801383:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801386:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801387:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80138d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801390:	50                   	push   %eax
  801391:	e8 33 ff ff ff       	call   8012c9 <fd_lookup>
  801396:	89 c3                	mov    %eax,%ebx
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 05                	js     8013a4 <fd_close+0x30>
	    || fd != fd2)
  80139f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013a2:	74 16                	je     8013ba <fd_close+0x46>
		return (must_exist ? r : 0);
  8013a4:	89 f8                	mov    %edi,%eax
  8013a6:	84 c0                	test   %al,%al
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ad:	0f 44 d8             	cmove  %eax,%ebx
}
  8013b0:	89 d8                	mov    %ebx,%eax
  8013b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013c0:	50                   	push   %eax
  8013c1:	ff 36                	pushl  (%esi)
  8013c3:	e8 51 ff ff ff       	call   801319 <dev_lookup>
  8013c8:	89 c3                	mov    %eax,%ebx
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 1a                	js     8013eb <fd_close+0x77>
		if (dev->dev_close)
  8013d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013d7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	74 0b                	je     8013eb <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013e0:	83 ec 0c             	sub    $0xc,%esp
  8013e3:	56                   	push   %esi
  8013e4:	ff d0                	call   *%eax
  8013e6:	89 c3                	mov    %eax,%ebx
  8013e8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	56                   	push   %esi
  8013ef:	6a 00                	push   $0x0
  8013f1:	e8 12 f8 ff ff       	call   800c08 <sys_page_unmap>
	return r;
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	eb b5                	jmp    8013b0 <fd_close+0x3c>

008013fb <close>:

int
close(int fdnum)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801401:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	e8 bc fe ff ff       	call   8012c9 <fd_lookup>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	79 02                	jns    801416 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		return fd_close(fd, 1);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	6a 01                	push   $0x1
  80141b:	ff 75 f4             	pushl  -0xc(%ebp)
  80141e:	e8 51 ff ff ff       	call   801374 <fd_close>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	eb ec                	jmp    801414 <close+0x19>

00801428 <close_all>:

void
close_all(void)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	53                   	push   %ebx
  80142c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80142f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	53                   	push   %ebx
  801438:	e8 be ff ff ff       	call   8013fb <close>
	for (i = 0; i < MAXFD; i++)
  80143d:	83 c3 01             	add    $0x1,%ebx
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	83 fb 20             	cmp    $0x20,%ebx
  801446:	75 ec                	jne    801434 <close_all+0xc>
}
  801448:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	57                   	push   %edi
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
  801453:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801456:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	ff 75 08             	pushl  0x8(%ebp)
  80145d:	e8 67 fe ff ff       	call   8012c9 <fd_lookup>
  801462:	89 c3                	mov    %eax,%ebx
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	0f 88 81 00 00 00    	js     8014f0 <dup+0xa3>
		return r;
	close(newfdnum);
  80146f:	83 ec 0c             	sub    $0xc,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 81 ff ff ff       	call   8013fb <close>

	newfd = INDEX2FD(newfdnum);
  80147a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80147d:	c1 e6 0c             	shl    $0xc,%esi
  801480:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801486:	83 c4 04             	add    $0x4,%esp
  801489:	ff 75 e4             	pushl  -0x1c(%ebp)
  80148c:	e8 cf fd ff ff       	call   801260 <fd2data>
  801491:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801493:	89 34 24             	mov    %esi,(%esp)
  801496:	e8 c5 fd ff ff       	call   801260 <fd2data>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014a0:	89 d8                	mov    %ebx,%eax
  8014a2:	c1 e8 16             	shr    $0x16,%eax
  8014a5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ac:	a8 01                	test   $0x1,%al
  8014ae:	74 11                	je     8014c1 <dup+0x74>
  8014b0:	89 d8                	mov    %ebx,%eax
  8014b2:	c1 e8 0c             	shr    $0xc,%eax
  8014b5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014bc:	f6 c2 01             	test   $0x1,%dl
  8014bf:	75 39                	jne    8014fa <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014c4:	89 d0                	mov    %edx,%eax
  8014c6:	c1 e8 0c             	shr    $0xc,%eax
  8014c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d8:	50                   	push   %eax
  8014d9:	56                   	push   %esi
  8014da:	6a 00                	push   $0x0
  8014dc:	52                   	push   %edx
  8014dd:	6a 00                	push   $0x0
  8014df:	e8 e2 f6 ff ff       	call   800bc6 <sys_page_map>
  8014e4:	89 c3                	mov    %eax,%ebx
  8014e6:	83 c4 20             	add    $0x20,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 31                	js     80151e <dup+0xd1>
		goto err;

	return newfdnum;
  8014ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014f0:	89 d8                	mov    %ebx,%eax
  8014f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5f                   	pop    %edi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	25 07 0e 00 00       	and    $0xe07,%eax
  801509:	50                   	push   %eax
  80150a:	57                   	push   %edi
  80150b:	6a 00                	push   $0x0
  80150d:	53                   	push   %ebx
  80150e:	6a 00                	push   $0x0
  801510:	e8 b1 f6 ff ff       	call   800bc6 <sys_page_map>
  801515:	89 c3                	mov    %eax,%ebx
  801517:	83 c4 20             	add    $0x20,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	79 a3                	jns    8014c1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80151e:	83 ec 08             	sub    $0x8,%esp
  801521:	56                   	push   %esi
  801522:	6a 00                	push   $0x0
  801524:	e8 df f6 ff ff       	call   800c08 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801529:	83 c4 08             	add    $0x8,%esp
  80152c:	57                   	push   %edi
  80152d:	6a 00                	push   $0x0
  80152f:	e8 d4 f6 ff ff       	call   800c08 <sys_page_unmap>
	return r;
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	eb b7                	jmp    8014f0 <dup+0xa3>

00801539 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	53                   	push   %ebx
  80153d:	83 ec 1c             	sub    $0x1c,%esp
  801540:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801543:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	53                   	push   %ebx
  801548:	e8 7c fd ff ff       	call   8012c9 <fd_lookup>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	78 3f                	js     801593 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155a:	50                   	push   %eax
  80155b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155e:	ff 30                	pushl  (%eax)
  801560:	e8 b4 fd ff ff       	call   801319 <dev_lookup>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 27                	js     801593 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80156c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156f:	8b 42 08             	mov    0x8(%edx),%eax
  801572:	83 e0 03             	and    $0x3,%eax
  801575:	83 f8 01             	cmp    $0x1,%eax
  801578:	74 1e                	je     801598 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80157a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157d:	8b 40 08             	mov    0x8(%eax),%eax
  801580:	85 c0                	test   %eax,%eax
  801582:	74 35                	je     8015b9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	ff 75 10             	pushl  0x10(%ebp)
  80158a:	ff 75 0c             	pushl  0xc(%ebp)
  80158d:	52                   	push   %edx
  80158e:	ff d0                	call   *%eax
  801590:	83 c4 10             	add    $0x10,%esp
}
  801593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801596:	c9                   	leave  
  801597:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801598:	a1 08 40 80 00       	mov    0x804008,%eax
  80159d:	8b 40 48             	mov    0x48(%eax),%eax
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	53                   	push   %ebx
  8015a4:	50                   	push   %eax
  8015a5:	68 95 2c 80 00       	push   $0x802c95
  8015aa:	e8 06 ec ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b7:	eb da                	jmp    801593 <read+0x5a>
		return -E_NOT_SUPP;
  8015b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015be:	eb d3                	jmp    801593 <read+0x5a>

008015c0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	57                   	push   %edi
  8015c4:	56                   	push   %esi
  8015c5:	53                   	push   %ebx
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015cc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d4:	39 f3                	cmp    %esi,%ebx
  8015d6:	73 23                	jae    8015fb <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	89 f0                	mov    %esi,%eax
  8015dd:	29 d8                	sub    %ebx,%eax
  8015df:	50                   	push   %eax
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	03 45 0c             	add    0xc(%ebp),%eax
  8015e5:	50                   	push   %eax
  8015e6:	57                   	push   %edi
  8015e7:	e8 4d ff ff ff       	call   801539 <read>
		if (m < 0)
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 06                	js     8015f9 <readn+0x39>
			return m;
		if (m == 0)
  8015f3:	74 06                	je     8015fb <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015f5:	01 c3                	add    %eax,%ebx
  8015f7:	eb db                	jmp    8015d4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015fb:	89 d8                	mov    %ebx,%eax
  8015fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801600:	5b                   	pop    %ebx
  801601:	5e                   	pop    %esi
  801602:	5f                   	pop    %edi
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	53                   	push   %ebx
  801609:	83 ec 1c             	sub    $0x1c,%esp
  80160c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801612:	50                   	push   %eax
  801613:	53                   	push   %ebx
  801614:	e8 b0 fc ff ff       	call   8012c9 <fd_lookup>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 3a                	js     80165a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801620:	83 ec 08             	sub    $0x8,%esp
  801623:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	ff 30                	pushl  (%eax)
  80162c:	e8 e8 fc ff ff       	call   801319 <dev_lookup>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	78 22                	js     80165a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163f:	74 1e                	je     80165f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801644:	8b 52 0c             	mov    0xc(%edx),%edx
  801647:	85 d2                	test   %edx,%edx
  801649:	74 35                	je     801680 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	ff 75 10             	pushl  0x10(%ebp)
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	50                   	push   %eax
  801655:	ff d2                	call   *%edx
  801657:	83 c4 10             	add    $0x10,%esp
}
  80165a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80165f:	a1 08 40 80 00       	mov    0x804008,%eax
  801664:	8b 40 48             	mov    0x48(%eax),%eax
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	53                   	push   %ebx
  80166b:	50                   	push   %eax
  80166c:	68 b1 2c 80 00       	push   $0x802cb1
  801671:	e8 3f eb ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167e:	eb da                	jmp    80165a <write+0x55>
		return -E_NOT_SUPP;
  801680:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801685:	eb d3                	jmp    80165a <write+0x55>

00801687 <seek>:

int
seek(int fdnum, off_t offset)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801690:	50                   	push   %eax
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 30 fc ff ff       	call   8012c9 <fd_lookup>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 0e                	js     8016ae <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 1c             	sub    $0x1c,%esp
  8016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bd:	50                   	push   %eax
  8016be:	53                   	push   %ebx
  8016bf:	e8 05 fc ff ff       	call   8012c9 <fd_lookup>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 37                	js     801702 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d1:	50                   	push   %eax
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	ff 30                	pushl  (%eax)
  8016d7:	e8 3d fc ff ff       	call   801319 <dev_lookup>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 1f                	js     801702 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ea:	74 1b                	je     801707 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ef:	8b 52 18             	mov    0x18(%edx),%edx
  8016f2:	85 d2                	test   %edx,%edx
  8016f4:	74 32                	je     801728 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	50                   	push   %eax
  8016fd:	ff d2                	call   *%edx
  8016ff:	83 c4 10             	add    $0x10,%esp
}
  801702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801705:	c9                   	leave  
  801706:	c3                   	ret    
			thisenv->env_id, fdnum);
  801707:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80170c:	8b 40 48             	mov    0x48(%eax),%eax
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	53                   	push   %ebx
  801713:	50                   	push   %eax
  801714:	68 74 2c 80 00       	push   $0x802c74
  801719:	e8 97 ea ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801726:	eb da                	jmp    801702 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801728:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80172d:	eb d3                	jmp    801702 <ftruncate+0x52>

0080172f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	53                   	push   %ebx
  801733:	83 ec 1c             	sub    $0x1c,%esp
  801736:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801739:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173c:	50                   	push   %eax
  80173d:	ff 75 08             	pushl  0x8(%ebp)
  801740:	e8 84 fb ff ff       	call   8012c9 <fd_lookup>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 4b                	js     801797 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	ff 30                	pushl  (%eax)
  801758:	e8 bc fb ff ff       	call   801319 <dev_lookup>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	85 c0                	test   %eax,%eax
  801762:	78 33                	js     801797 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80176b:	74 2f                	je     80179c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80176d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801770:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801777:	00 00 00 
	stat->st_isdir = 0;
  80177a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801781:	00 00 00 
	stat->st_dev = dev;
  801784:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	53                   	push   %ebx
  80178e:	ff 75 f0             	pushl  -0x10(%ebp)
  801791:	ff 50 14             	call   *0x14(%eax)
  801794:	83 c4 10             	add    $0x10,%esp
}
  801797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    
		return -E_NOT_SUPP;
  80179c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a1:	eb f4                	jmp    801797 <fstat+0x68>

008017a3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017a8:	83 ec 08             	sub    $0x8,%esp
  8017ab:	6a 00                	push   $0x0
  8017ad:	ff 75 08             	pushl  0x8(%ebp)
  8017b0:	e8 2f 02 00 00       	call   8019e4 <open>
  8017b5:	89 c3                	mov    %eax,%ebx
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	78 1b                	js     8017d9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017be:	83 ec 08             	sub    $0x8,%esp
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	50                   	push   %eax
  8017c5:	e8 65 ff ff ff       	call   80172f <fstat>
  8017ca:	89 c6                	mov    %eax,%esi
	close(fd);
  8017cc:	89 1c 24             	mov    %ebx,(%esp)
  8017cf:	e8 27 fc ff ff       	call   8013fb <close>
	return r;
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	89 f3                	mov    %esi,%ebx
}
  8017d9:	89 d8                	mov    %ebx,%eax
  8017db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017de:	5b                   	pop    %ebx
  8017df:	5e                   	pop    %esi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
  8017e7:	89 c6                	mov    %eax,%esi
  8017e9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017eb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017f2:	74 27                	je     80181b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017f4:	6a 07                	push   $0x7
  8017f6:	68 00 50 80 00       	push   $0x805000
  8017fb:	56                   	push   %esi
  8017fc:	ff 35 00 40 80 00    	pushl  0x804000
  801802:	e8 a4 f9 ff ff       	call   8011ab <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801807:	83 c4 0c             	add    $0xc,%esp
  80180a:	6a 00                	push   $0x0
  80180c:	53                   	push   %ebx
  80180d:	6a 00                	push   $0x0
  80180f:	e8 24 f9 ff ff       	call   801138 <ipc_recv>
}
  801814:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	6a 01                	push   $0x1
  801820:	e8 f2 f9 ff ff       	call   801217 <ipc_find_env>
  801825:	a3 00 40 80 00       	mov    %eax,0x804000
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	eb c5                	jmp    8017f4 <fsipc+0x12>

0080182f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8b 40 0c             	mov    0xc(%eax),%eax
  80183b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
  80184d:	b8 02 00 00 00       	mov    $0x2,%eax
  801852:	e8 8b ff ff ff       	call   8017e2 <fsipc>
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <devfile_flush>:
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8b 40 0c             	mov    0xc(%eax),%eax
  801865:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80186a:	ba 00 00 00 00       	mov    $0x0,%edx
  80186f:	b8 06 00 00 00       	mov    $0x6,%eax
  801874:	e8 69 ff ff ff       	call   8017e2 <fsipc>
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <devfile_stat>:
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	53                   	push   %ebx
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8b 40 0c             	mov    0xc(%eax),%eax
  80188b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	b8 05 00 00 00       	mov    $0x5,%eax
  80189a:	e8 43 ff ff ff       	call   8017e2 <fsipc>
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 2c                	js     8018cf <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	68 00 50 80 00       	push   $0x805000
  8018ab:	53                   	push   %ebx
  8018ac:	e8 e0 ee ff ff       	call   800791 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018b1:	a1 80 50 80 00       	mov    0x805080,%eax
  8018b6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018bc:	a1 84 50 80 00       	mov    0x805084,%eax
  8018c1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <devfile_write>:
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8018de:	85 db                	test   %ebx,%ebx
  8018e0:	75 07                	jne    8018e9 <devfile_write+0x15>
	return n_all;
  8018e2:	89 d8                	mov    %ebx,%eax
}
  8018e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ef:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8018f4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	53                   	push   %ebx
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	68 08 50 80 00       	push   $0x805008
  801906:	e8 14 f0 ff ff       	call   80091f <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	b8 04 00 00 00       	mov    $0x4,%eax
  801915:	e8 c8 fe ff ff       	call   8017e2 <fsipc>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 c3                	js     8018e4 <devfile_write+0x10>
	  assert(r <= n_left);
  801921:	39 d8                	cmp    %ebx,%eax
  801923:	77 0b                	ja     801930 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801925:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80192a:	7f 1d                	jg     801949 <devfile_write+0x75>
    n_all += r;
  80192c:	89 c3                	mov    %eax,%ebx
  80192e:	eb b2                	jmp    8018e2 <devfile_write+0xe>
	  assert(r <= n_left);
  801930:	68 e4 2c 80 00       	push   $0x802ce4
  801935:	68 f0 2c 80 00       	push   $0x802cf0
  80193a:	68 9f 00 00 00       	push   $0x9f
  80193f:	68 05 2d 80 00       	push   $0x802d05
  801944:	e8 6a 0a 00 00       	call   8023b3 <_panic>
	  assert(r <= PGSIZE);
  801949:	68 10 2d 80 00       	push   $0x802d10
  80194e:	68 f0 2c 80 00       	push   $0x802cf0
  801953:	68 a0 00 00 00       	push   $0xa0
  801958:	68 05 2d 80 00       	push   $0x802d05
  80195d:	e8 51 0a 00 00       	call   8023b3 <_panic>

00801962 <devfile_read>:
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	56                   	push   %esi
  801966:	53                   	push   %ebx
  801967:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	8b 40 0c             	mov    0xc(%eax),%eax
  801970:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801975:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80197b:	ba 00 00 00 00       	mov    $0x0,%edx
  801980:	b8 03 00 00 00       	mov    $0x3,%eax
  801985:	e8 58 fe ff ff       	call   8017e2 <fsipc>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 1f                	js     8019af <devfile_read+0x4d>
	assert(r <= n);
  801990:	39 f0                	cmp    %esi,%eax
  801992:	77 24                	ja     8019b8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801994:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801999:	7f 33                	jg     8019ce <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	50                   	push   %eax
  80199f:	68 00 50 80 00       	push   $0x805000
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	e8 73 ef ff ff       	call   80091f <memmove>
	return r;
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    
	assert(r <= n);
  8019b8:	68 1c 2d 80 00       	push   $0x802d1c
  8019bd:	68 f0 2c 80 00       	push   $0x802cf0
  8019c2:	6a 7c                	push   $0x7c
  8019c4:	68 05 2d 80 00       	push   $0x802d05
  8019c9:	e8 e5 09 00 00       	call   8023b3 <_panic>
	assert(r <= PGSIZE);
  8019ce:	68 10 2d 80 00       	push   $0x802d10
  8019d3:	68 f0 2c 80 00       	push   $0x802cf0
  8019d8:	6a 7d                	push   $0x7d
  8019da:	68 05 2d 80 00       	push   $0x802d05
  8019df:	e8 cf 09 00 00       	call   8023b3 <_panic>

008019e4 <open>:
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	56                   	push   %esi
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 1c             	sub    $0x1c,%esp
  8019ec:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019ef:	56                   	push   %esi
  8019f0:	e8 63 ed ff ff       	call   800758 <strlen>
  8019f5:	83 c4 10             	add    $0x10,%esp
  8019f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019fd:	7f 6c                	jg     801a6b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a05:	50                   	push   %eax
  801a06:	e8 6c f8 ff ff       	call   801277 <fd_alloc>
  801a0b:	89 c3                	mov    %eax,%ebx
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 3c                	js     801a50 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a14:	83 ec 08             	sub    $0x8,%esp
  801a17:	56                   	push   %esi
  801a18:	68 00 50 80 00       	push   $0x805000
  801a1d:	e8 6f ed ff ff       	call   800791 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a32:	e8 ab fd ff ff       	call   8017e2 <fsipc>
  801a37:	89 c3                	mov    %eax,%ebx
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 19                	js     801a59 <open+0x75>
	return fd2num(fd);
  801a40:	83 ec 0c             	sub    $0xc,%esp
  801a43:	ff 75 f4             	pushl  -0xc(%ebp)
  801a46:	e8 05 f8 ff ff       	call   801250 <fd2num>
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	83 c4 10             	add    $0x10,%esp
}
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    
		fd_close(fd, 0);
  801a59:	83 ec 08             	sub    $0x8,%esp
  801a5c:	6a 00                	push   $0x0
  801a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a61:	e8 0e f9 ff ff       	call   801374 <fd_close>
		return r;
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	eb e5                	jmp    801a50 <open+0x6c>
		return -E_BAD_PATH;
  801a6b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a70:	eb de                	jmp    801a50 <open+0x6c>

00801a72 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a78:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7d:	b8 08 00 00 00       	mov    $0x8,%eax
  801a82:	e8 5b fd ff ff       	call   8017e2 <fsipc>
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	56                   	push   %esi
  801a8d:	53                   	push   %ebx
  801a8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	e8 c4 f7 ff ff       	call   801260 <fd2data>
  801a9c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a9e:	83 c4 08             	add    $0x8,%esp
  801aa1:	68 23 2d 80 00       	push   $0x802d23
  801aa6:	53                   	push   %ebx
  801aa7:	e8 e5 ec ff ff       	call   800791 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aac:	8b 46 04             	mov    0x4(%esi),%eax
  801aaf:	2b 06                	sub    (%esi),%eax
  801ab1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ab7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abe:	00 00 00 
	stat->st_dev = &devpipe;
  801ac1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ac8:	30 80 00 
	return 0;
}
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	53                   	push   %ebx
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ae1:	53                   	push   %ebx
  801ae2:	6a 00                	push   $0x0
  801ae4:	e8 1f f1 ff ff       	call   800c08 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ae9:	89 1c 24             	mov    %ebx,(%esp)
  801aec:	e8 6f f7 ff ff       	call   801260 <fd2data>
  801af1:	83 c4 08             	add    $0x8,%esp
  801af4:	50                   	push   %eax
  801af5:	6a 00                	push   $0x0
  801af7:	e8 0c f1 ff ff       	call   800c08 <sys_page_unmap>
}
  801afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <_pipeisclosed>:
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	57                   	push   %edi
  801b05:	56                   	push   %esi
  801b06:	53                   	push   %ebx
  801b07:	83 ec 1c             	sub    $0x1c,%esp
  801b0a:	89 c7                	mov    %eax,%edi
  801b0c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b0e:	a1 08 40 80 00       	mov    0x804008,%eax
  801b13:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b16:	83 ec 0c             	sub    $0xc,%esp
  801b19:	57                   	push   %edi
  801b1a:	e8 77 09 00 00       	call   802496 <pageref>
  801b1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b22:	89 34 24             	mov    %esi,(%esp)
  801b25:	e8 6c 09 00 00       	call   802496 <pageref>
		nn = thisenv->env_runs;
  801b2a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b30:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	39 cb                	cmp    %ecx,%ebx
  801b38:	74 1b                	je     801b55 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b3a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b3d:	75 cf                	jne    801b0e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b3f:	8b 42 58             	mov    0x58(%edx),%eax
  801b42:	6a 01                	push   $0x1
  801b44:	50                   	push   %eax
  801b45:	53                   	push   %ebx
  801b46:	68 2a 2d 80 00       	push   $0x802d2a
  801b4b:	e8 65 e6 ff ff       	call   8001b5 <cprintf>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	eb b9                	jmp    801b0e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b58:	0f 94 c0             	sete   %al
  801b5b:	0f b6 c0             	movzbl %al,%eax
}
  801b5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b61:	5b                   	pop    %ebx
  801b62:	5e                   	pop    %esi
  801b63:	5f                   	pop    %edi
  801b64:	5d                   	pop    %ebp
  801b65:	c3                   	ret    

00801b66 <devpipe_write>:
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	57                   	push   %edi
  801b6a:	56                   	push   %esi
  801b6b:	53                   	push   %ebx
  801b6c:	83 ec 28             	sub    $0x28,%esp
  801b6f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b72:	56                   	push   %esi
  801b73:	e8 e8 f6 ff ff       	call   801260 <fd2data>
  801b78:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b7a:	83 c4 10             	add    $0x10,%esp
  801b7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801b82:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b85:	74 4f                	je     801bd6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b87:	8b 43 04             	mov    0x4(%ebx),%eax
  801b8a:	8b 0b                	mov    (%ebx),%ecx
  801b8c:	8d 51 20             	lea    0x20(%ecx),%edx
  801b8f:	39 d0                	cmp    %edx,%eax
  801b91:	72 14                	jb     801ba7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b93:	89 da                	mov    %ebx,%edx
  801b95:	89 f0                	mov    %esi,%eax
  801b97:	e8 65 ff ff ff       	call   801b01 <_pipeisclosed>
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	75 3b                	jne    801bdb <devpipe_write+0x75>
			sys_yield();
  801ba0:	e8 bf ef ff ff       	call   800b64 <sys_yield>
  801ba5:	eb e0                	jmp    801b87 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801baa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bb1:	89 c2                	mov    %eax,%edx
  801bb3:	c1 fa 1f             	sar    $0x1f,%edx
  801bb6:	89 d1                	mov    %edx,%ecx
  801bb8:	c1 e9 1b             	shr    $0x1b,%ecx
  801bbb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bbe:	83 e2 1f             	and    $0x1f,%edx
  801bc1:	29 ca                	sub    %ecx,%edx
  801bc3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bc7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bcb:	83 c0 01             	add    $0x1,%eax
  801bce:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bd1:	83 c7 01             	add    $0x1,%edi
  801bd4:	eb ac                	jmp    801b82 <devpipe_write+0x1c>
	return i;
  801bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd9:	eb 05                	jmp    801be0 <devpipe_write+0x7a>
				return 0;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5f                   	pop    %edi
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    

00801be8 <devpipe_read>:
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	57                   	push   %edi
  801bec:	56                   	push   %esi
  801bed:	53                   	push   %ebx
  801bee:	83 ec 18             	sub    $0x18,%esp
  801bf1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bf4:	57                   	push   %edi
  801bf5:	e8 66 f6 ff ff       	call   801260 <fd2data>
  801bfa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	be 00 00 00 00       	mov    $0x0,%esi
  801c04:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c07:	75 14                	jne    801c1d <devpipe_read+0x35>
	return i;
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	eb 02                	jmp    801c10 <devpipe_read+0x28>
				return i;
  801c0e:	89 f0                	mov    %esi,%eax
}
  801c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
			sys_yield();
  801c18:	e8 47 ef ff ff       	call   800b64 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c1d:	8b 03                	mov    (%ebx),%eax
  801c1f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c22:	75 18                	jne    801c3c <devpipe_read+0x54>
			if (i > 0)
  801c24:	85 f6                	test   %esi,%esi
  801c26:	75 e6                	jne    801c0e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c28:	89 da                	mov    %ebx,%edx
  801c2a:	89 f8                	mov    %edi,%eax
  801c2c:	e8 d0 fe ff ff       	call   801b01 <_pipeisclosed>
  801c31:	85 c0                	test   %eax,%eax
  801c33:	74 e3                	je     801c18 <devpipe_read+0x30>
				return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3a:	eb d4                	jmp    801c10 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c3c:	99                   	cltd   
  801c3d:	c1 ea 1b             	shr    $0x1b,%edx
  801c40:	01 d0                	add    %edx,%eax
  801c42:	83 e0 1f             	and    $0x1f,%eax
  801c45:	29 d0                	sub    %edx,%eax
  801c47:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c4f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c52:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c55:	83 c6 01             	add    $0x1,%esi
  801c58:	eb aa                	jmp    801c04 <devpipe_read+0x1c>

00801c5a <pipe>:
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	56                   	push   %esi
  801c5e:	53                   	push   %ebx
  801c5f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c65:	50                   	push   %eax
  801c66:	e8 0c f6 ff ff       	call   801277 <fd_alloc>
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	85 c0                	test   %eax,%eax
  801c72:	0f 88 23 01 00 00    	js     801d9b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	68 07 04 00 00       	push   $0x407
  801c80:	ff 75 f4             	pushl  -0xc(%ebp)
  801c83:	6a 00                	push   $0x0
  801c85:	e8 f9 ee ff ff       	call   800b83 <sys_page_alloc>
  801c8a:	89 c3                	mov    %eax,%ebx
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	0f 88 04 01 00 00    	js     801d9b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c9d:	50                   	push   %eax
  801c9e:	e8 d4 f5 ff ff       	call   801277 <fd_alloc>
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	0f 88 db 00 00 00    	js     801d8b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	68 07 04 00 00       	push   $0x407
  801cb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbb:	6a 00                	push   $0x0
  801cbd:	e8 c1 ee ff ff       	call   800b83 <sys_page_alloc>
  801cc2:	89 c3                	mov    %eax,%ebx
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	0f 88 bc 00 00 00    	js     801d8b <pipe+0x131>
	va = fd2data(fd0);
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd5:	e8 86 f5 ff ff       	call   801260 <fd2data>
  801cda:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cdc:	83 c4 0c             	add    $0xc,%esp
  801cdf:	68 07 04 00 00       	push   $0x407
  801ce4:	50                   	push   %eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	e8 97 ee ff ff       	call   800b83 <sys_page_alloc>
  801cec:	89 c3                	mov    %eax,%ebx
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	0f 88 82 00 00 00    	js     801d7b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	ff 75 f0             	pushl  -0x10(%ebp)
  801cff:	e8 5c f5 ff ff       	call   801260 <fd2data>
  801d04:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d0b:	50                   	push   %eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	56                   	push   %esi
  801d0f:	6a 00                	push   $0x0
  801d11:	e8 b0 ee ff ff       	call   800bc6 <sys_page_map>
  801d16:	89 c3                	mov    %eax,%ebx
  801d18:	83 c4 20             	add    $0x20,%esp
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 4e                	js     801d6d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d1f:	a1 20 30 80 00       	mov    0x803020,%eax
  801d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d27:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d36:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	e8 03 f5 ff ff       	call   801250 <fd2num>
  801d4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d50:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d52:	83 c4 04             	add    $0x4,%esp
  801d55:	ff 75 f0             	pushl  -0x10(%ebp)
  801d58:	e8 f3 f4 ff ff       	call   801250 <fd2num>
  801d5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d60:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d6b:	eb 2e                	jmp    801d9b <pipe+0x141>
	sys_page_unmap(0, va);
  801d6d:	83 ec 08             	sub    $0x8,%esp
  801d70:	56                   	push   %esi
  801d71:	6a 00                	push   $0x0
  801d73:	e8 90 ee ff ff       	call   800c08 <sys_page_unmap>
  801d78:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d81:	6a 00                	push   $0x0
  801d83:	e8 80 ee ff ff       	call   800c08 <sys_page_unmap>
  801d88:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d8b:	83 ec 08             	sub    $0x8,%esp
  801d8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d91:	6a 00                	push   $0x0
  801d93:	e8 70 ee ff ff       	call   800c08 <sys_page_unmap>
  801d98:	83 c4 10             	add    $0x10,%esp
}
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <pipeisclosed>:
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801daa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dad:	50                   	push   %eax
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	e8 13 f5 ff ff       	call   8012c9 <fd_lookup>
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	78 18                	js     801dd5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dbd:	83 ec 0c             	sub    $0xc,%esp
  801dc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc3:	e8 98 f4 ff ff       	call   801260 <fd2data>
	return _pipeisclosed(fd, p);
  801dc8:	89 c2                	mov    %eax,%edx
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcd:	e8 2f fd ff ff       	call   801b01 <_pipeisclosed>
  801dd2:	83 c4 10             	add    $0x10,%esp
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ddd:	68 42 2d 80 00       	push   $0x802d42
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	e8 a7 e9 ff ff       	call   800791 <strcpy>
	return 0;
}
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <devsock_close>:
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	53                   	push   %ebx
  801df5:	83 ec 10             	sub    $0x10,%esp
  801df8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dfb:	53                   	push   %ebx
  801dfc:	e8 95 06 00 00       	call   802496 <pageref>
  801e01:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e04:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e09:	83 f8 01             	cmp    $0x1,%eax
  801e0c:	74 07                	je     801e15 <devsock_close+0x24>
}
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	ff 73 0c             	pushl  0xc(%ebx)
  801e1b:	e8 b9 02 00 00       	call   8020d9 <nsipc_close>
  801e20:	89 c2                	mov    %eax,%edx
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	eb e7                	jmp    801e0e <devsock_close+0x1d>

00801e27 <devsock_write>:
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 10             	pushl  0x10(%ebp)
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	ff 70 0c             	pushl  0xc(%eax)
  801e3b:	e8 76 03 00 00       	call   8021b6 <nsipc_send>
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <devsock_read>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 10             	pushl  0x10(%ebp)
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	ff 70 0c             	pushl  0xc(%eax)
  801e56:	e8 ef 02 00 00       	call   80214a <nsipc_recv>
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <fd2sockid>:
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e63:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	e8 5c f4 ff ff       	call   8012c9 <fd_lookup>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 10                	js     801e84 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801e7d:	39 08                	cmp    %ecx,(%eax)
  801e7f:	75 05                	jne    801e86 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e81:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    
		return -E_NOT_SUPP;
  801e86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e8b:	eb f7                	jmp    801e84 <fd2sockid+0x27>

00801e8d <alloc_sockfd>:
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	83 ec 1c             	sub    $0x1c,%esp
  801e95:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9a:	50                   	push   %eax
  801e9b:	e8 d7 f3 ff ff       	call   801277 <fd_alloc>
  801ea0:	89 c3                	mov    %eax,%ebx
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 43                	js     801eec <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	68 07 04 00 00       	push   $0x407
  801eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb4:	6a 00                	push   $0x0
  801eb6:	e8 c8 ec ff ff       	call   800b83 <sys_page_alloc>
  801ebb:	89 c3                	mov    %eax,%ebx
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 28                	js     801eec <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ecd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ed9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	50                   	push   %eax
  801ee0:	e8 6b f3 ff ff       	call   801250 <fd2num>
  801ee5:	89 c3                	mov    %eax,%ebx
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	eb 0c                	jmp    801ef8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	56                   	push   %esi
  801ef0:	e8 e4 01 00 00       	call   8020d9 <nsipc_close>
		return r;
  801ef5:	83 c4 10             	add    $0x10,%esp
}
  801ef8:	89 d8                	mov    %ebx,%eax
  801efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <accept>:
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	e8 4e ff ff ff       	call   801e5d <fd2sockid>
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 1b                	js     801f2e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	ff 75 10             	pushl  0x10(%ebp)
  801f19:	ff 75 0c             	pushl  0xc(%ebp)
  801f1c:	50                   	push   %eax
  801f1d:	e8 0e 01 00 00       	call   802030 <nsipc_accept>
  801f22:	83 c4 10             	add    $0x10,%esp
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 05                	js     801f2e <accept+0x2d>
	return alloc_sockfd(r);
  801f29:	e8 5f ff ff ff       	call   801e8d <alloc_sockfd>
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <bind>:
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	e8 1f ff ff ff       	call   801e5d <fd2sockid>
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 12                	js     801f54 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	ff 75 10             	pushl  0x10(%ebp)
  801f48:	ff 75 0c             	pushl  0xc(%ebp)
  801f4b:	50                   	push   %eax
  801f4c:	e8 31 01 00 00       	call   802082 <nsipc_bind>
  801f51:	83 c4 10             	add    $0x10,%esp
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <shutdown>:
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	e8 f9 fe ff ff       	call   801e5d <fd2sockid>
  801f64:	85 c0                	test   %eax,%eax
  801f66:	78 0f                	js     801f77 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	ff 75 0c             	pushl  0xc(%ebp)
  801f6e:	50                   	push   %eax
  801f6f:	e8 43 01 00 00       	call   8020b7 <nsipc_shutdown>
  801f74:	83 c4 10             	add    $0x10,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <connect>:
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	e8 d6 fe ff ff       	call   801e5d <fd2sockid>
  801f87:	85 c0                	test   %eax,%eax
  801f89:	78 12                	js     801f9d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	ff 75 10             	pushl  0x10(%ebp)
  801f91:	ff 75 0c             	pushl  0xc(%ebp)
  801f94:	50                   	push   %eax
  801f95:	e8 59 01 00 00       	call   8020f3 <nsipc_connect>
  801f9a:	83 c4 10             	add    $0x10,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <listen>:
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	e8 b0 fe ff ff       	call   801e5d <fd2sockid>
  801fad:	85 c0                	test   %eax,%eax
  801faf:	78 0f                	js     801fc0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fb1:	83 ec 08             	sub    $0x8,%esp
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	50                   	push   %eax
  801fb8:	e8 6b 01 00 00       	call   802128 <nsipc_listen>
  801fbd:	83 c4 10             	add    $0x10,%esp
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fc8:	ff 75 10             	pushl  0x10(%ebp)
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	ff 75 08             	pushl  0x8(%ebp)
  801fd1:	e8 3e 02 00 00       	call   802214 <nsipc_socket>
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	78 05                	js     801fe2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fdd:	e8 ab fe ff ff       	call   801e8d <alloc_sockfd>
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	53                   	push   %ebx
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fed:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ff4:	74 26                	je     80201c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ff6:	6a 07                	push   $0x7
  801ff8:	68 00 60 80 00       	push   $0x806000
  801ffd:	53                   	push   %ebx
  801ffe:	ff 35 04 40 80 00    	pushl  0x804004
  802004:	e8 a2 f1 ff ff       	call   8011ab <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802009:	83 c4 0c             	add    $0xc,%esp
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	e8 21 f1 ff ff       	call   801138 <ipc_recv>
}
  802017:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	6a 02                	push   $0x2
  802021:	e8 f1 f1 ff ff       	call   801217 <ipc_find_env>
  802026:	a3 04 40 80 00       	mov    %eax,0x804004
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	eb c6                	jmp    801ff6 <nsipc+0x12>

00802030 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	56                   	push   %esi
  802034:	53                   	push   %ebx
  802035:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802040:	8b 06                	mov    (%esi),%eax
  802042:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802047:	b8 01 00 00 00       	mov    $0x1,%eax
  80204c:	e8 93 ff ff ff       	call   801fe4 <nsipc>
  802051:	89 c3                	mov    %eax,%ebx
  802053:	85 c0                	test   %eax,%eax
  802055:	79 09                	jns    802060 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802057:	89 d8                	mov    %ebx,%eax
  802059:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5d                   	pop    %ebp
  80205f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	ff 35 10 60 80 00    	pushl  0x806010
  802069:	68 00 60 80 00       	push   $0x806000
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	e8 a9 e8 ff ff       	call   80091f <memmove>
		*addrlen = ret->ret_addrlen;
  802076:	a1 10 60 80 00       	mov    0x806010,%eax
  80207b:	89 06                	mov    %eax,(%esi)
  80207d:	83 c4 10             	add    $0x10,%esp
	return r;
  802080:	eb d5                	jmp    802057 <nsipc_accept+0x27>

00802082 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	53                   	push   %ebx
  802086:	83 ec 08             	sub    $0x8,%esp
  802089:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802094:	53                   	push   %ebx
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	68 04 60 80 00       	push   $0x806004
  80209d:	e8 7d e8 ff ff       	call   80091f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020a2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8020a8:	b8 02 00 00 00       	mov    $0x2,%eax
  8020ad:	e8 32 ff ff ff       	call   801fe4 <nsipc>
}
  8020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8020d2:	e8 0d ff ff ff       	call   801fe4 <nsipc>
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <nsipc_close>:

int
nsipc_close(int s)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8020e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8020ec:	e8 f3 fe ff ff       	call   801fe4 <nsipc>
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	53                   	push   %ebx
  8020f7:	83 ec 08             	sub    $0x8,%esp
  8020fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802105:	53                   	push   %ebx
  802106:	ff 75 0c             	pushl  0xc(%ebp)
  802109:	68 04 60 80 00       	push   $0x806004
  80210e:	e8 0c e8 ff ff       	call   80091f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802113:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802119:	b8 05 00 00 00       	mov    $0x5,%eax
  80211e:	e8 c1 fe ff ff       	call   801fe4 <nsipc>
}
  802123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802136:	8b 45 0c             	mov    0xc(%ebp),%eax
  802139:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80213e:	b8 06 00 00 00       	mov    $0x6,%eax
  802143:	e8 9c fe ff ff       	call   801fe4 <nsipc>
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	56                   	push   %esi
  80214e:	53                   	push   %ebx
  80214f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80215a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802160:	8b 45 14             	mov    0x14(%ebp),%eax
  802163:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802168:	b8 07 00 00 00       	mov    $0x7,%eax
  80216d:	e8 72 fe ff ff       	call   801fe4 <nsipc>
  802172:	89 c3                	mov    %eax,%ebx
  802174:	85 c0                	test   %eax,%eax
  802176:	78 1f                	js     802197 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802178:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80217d:	7f 21                	jg     8021a0 <nsipc_recv+0x56>
  80217f:	39 c6                	cmp    %eax,%esi
  802181:	7c 1d                	jl     8021a0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	50                   	push   %eax
  802187:	68 00 60 80 00       	push   $0x806000
  80218c:	ff 75 0c             	pushl  0xc(%ebp)
  80218f:	e8 8b e7 ff ff       	call   80091f <memmove>
  802194:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802197:	89 d8                	mov    %ebx,%eax
  802199:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219c:	5b                   	pop    %ebx
  80219d:	5e                   	pop    %esi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021a0:	68 4e 2d 80 00       	push   $0x802d4e
  8021a5:	68 f0 2c 80 00       	push   $0x802cf0
  8021aa:	6a 62                	push   $0x62
  8021ac:	68 63 2d 80 00       	push   $0x802d63
  8021b1:	e8 fd 01 00 00       	call   8023b3 <_panic>

008021b6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	53                   	push   %ebx
  8021ba:	83 ec 04             	sub    $0x4,%esp
  8021bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021c8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021ce:	7f 2e                	jg     8021fe <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	53                   	push   %ebx
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	68 0c 60 80 00       	push   $0x80600c
  8021dc:	e8 3e e7 ff ff       	call   80091f <memmove>
	nsipcbuf.send.req_size = size;
  8021e1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ea:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8021ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8021f4:	e8 eb fd ff ff       	call   801fe4 <nsipc>
}
  8021f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    
	assert(size < 1600);
  8021fe:	68 6f 2d 80 00       	push   $0x802d6f
  802203:	68 f0 2c 80 00       	push   $0x802cf0
  802208:	6a 6d                	push   $0x6d
  80220a:	68 63 2d 80 00       	push   $0x802d63
  80220f:	e8 9f 01 00 00       	call   8023b3 <_panic>

00802214 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80222a:	8b 45 10             	mov    0x10(%ebp),%eax
  80222d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802232:	b8 09 00 00 00       	mov    $0x9,%eax
  802237:	e8 a8 fd ff ff       	call   801fe4 <nsipc>
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	c3                   	ret    

00802244 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80224a:	68 7b 2d 80 00       	push   $0x802d7b
  80224f:	ff 75 0c             	pushl  0xc(%ebp)
  802252:	e8 3a e5 ff ff       	call   800791 <strcpy>
	return 0;
}
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <devcons_write>:
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	57                   	push   %edi
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80226a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80226f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802275:	3b 75 10             	cmp    0x10(%ebp),%esi
  802278:	73 31                	jae    8022ab <devcons_write+0x4d>
		m = n - tot;
  80227a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80227d:	29 f3                	sub    %esi,%ebx
  80227f:	83 fb 7f             	cmp    $0x7f,%ebx
  802282:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802287:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	53                   	push   %ebx
  80228e:	89 f0                	mov    %esi,%eax
  802290:	03 45 0c             	add    0xc(%ebp),%eax
  802293:	50                   	push   %eax
  802294:	57                   	push   %edi
  802295:	e8 85 e6 ff ff       	call   80091f <memmove>
		sys_cputs(buf, m);
  80229a:	83 c4 08             	add    $0x8,%esp
  80229d:	53                   	push   %ebx
  80229e:	57                   	push   %edi
  80229f:	e8 23 e8 ff ff       	call   800ac7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022a4:	01 de                	add    %ebx,%esi
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	eb ca                	jmp    802275 <devcons_write+0x17>
}
  8022ab:	89 f0                	mov    %esi,%eax
  8022ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    

008022b5 <devcons_read>:
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 08             	sub    $0x8,%esp
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022c4:	74 21                	je     8022e7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022c6:	e8 1a e8 ff ff       	call   800ae5 <sys_cgetc>
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 07                	jne    8022d6 <devcons_read+0x21>
		sys_yield();
  8022cf:	e8 90 e8 ff ff       	call   800b64 <sys_yield>
  8022d4:	eb f0                	jmp    8022c6 <devcons_read+0x11>
	if (c < 0)
  8022d6:	78 0f                	js     8022e7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8022d8:	83 f8 04             	cmp    $0x4,%eax
  8022db:	74 0c                	je     8022e9 <devcons_read+0x34>
	*(char*)vbuf = c;
  8022dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e0:	88 02                	mov    %al,(%edx)
	return 1;
  8022e2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    
		return 0;
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ee:	eb f7                	jmp    8022e7 <devcons_read+0x32>

008022f0 <cputchar>:
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022fc:	6a 01                	push   $0x1
  8022fe:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802301:	50                   	push   %eax
  802302:	e8 c0 e7 ff ff       	call   800ac7 <sys_cputs>
}
  802307:	83 c4 10             	add    $0x10,%esp
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <getchar>:
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802312:	6a 01                	push   $0x1
  802314:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802317:	50                   	push   %eax
  802318:	6a 00                	push   $0x0
  80231a:	e8 1a f2 ff ff       	call   801539 <read>
	if (r < 0)
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	85 c0                	test   %eax,%eax
  802324:	78 06                	js     80232c <getchar+0x20>
	if (r < 1)
  802326:	74 06                	je     80232e <getchar+0x22>
	return c;
  802328:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    
		return -E_EOF;
  80232e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802333:	eb f7                	jmp    80232c <getchar+0x20>

00802335 <iscons>:
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80233b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233e:	50                   	push   %eax
  80233f:	ff 75 08             	pushl  0x8(%ebp)
  802342:	e8 82 ef ff ff       	call   8012c9 <fd_lookup>
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	85 c0                	test   %eax,%eax
  80234c:	78 11                	js     80235f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802357:	39 10                	cmp    %edx,(%eax)
  802359:	0f 94 c0             	sete   %al
  80235c:	0f b6 c0             	movzbl %al,%eax
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <opencons>:
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802367:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236a:	50                   	push   %eax
  80236b:	e8 07 ef ff ff       	call   801277 <fd_alloc>
  802370:	83 c4 10             	add    $0x10,%esp
  802373:	85 c0                	test   %eax,%eax
  802375:	78 3a                	js     8023b1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	68 07 04 00 00       	push   $0x407
  80237f:	ff 75 f4             	pushl  -0xc(%ebp)
  802382:	6a 00                	push   $0x0
  802384:	e8 fa e7 ff ff       	call   800b83 <sys_page_alloc>
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	85 c0                	test   %eax,%eax
  80238e:	78 21                	js     8023b1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802399:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023a5:	83 ec 0c             	sub    $0xc,%esp
  8023a8:	50                   	push   %eax
  8023a9:	e8 a2 ee ff ff       	call   801250 <fd2num>
  8023ae:	83 c4 10             	add    $0x10,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	56                   	push   %esi
  8023b7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023b8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023bb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023c1:	e8 7f e7 ff ff       	call   800b45 <sys_getenvid>
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	ff 75 0c             	pushl  0xc(%ebp)
  8023cc:	ff 75 08             	pushl  0x8(%ebp)
  8023cf:	56                   	push   %esi
  8023d0:	50                   	push   %eax
  8023d1:	68 88 2d 80 00       	push   $0x802d88
  8023d6:	e8 da dd ff ff       	call   8001b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023db:	83 c4 18             	add    $0x18,%esp
  8023de:	53                   	push   %ebx
  8023df:	ff 75 10             	pushl  0x10(%ebp)
  8023e2:	e8 7d dd ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  8023e7:	c7 04 24 3b 2d 80 00 	movl   $0x802d3b,(%esp)
  8023ee:	e8 c2 dd ff ff       	call   8001b5 <cprintf>
  8023f3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023f6:	cc                   	int3   
  8023f7:	eb fd                	jmp    8023f6 <_panic+0x43>

008023f9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8023ff:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802406:	74 0a                	je     802412 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802412:	a1 08 40 80 00       	mov    0x804008,%eax
  802417:	8b 40 48             	mov    0x48(%eax),%eax
  80241a:	83 ec 04             	sub    $0x4,%esp
  80241d:	6a 07                	push   $0x7
  80241f:	68 00 f0 bf ee       	push   $0xeebff000
  802424:	50                   	push   %eax
  802425:	e8 59 e7 ff ff       	call   800b83 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80242a:	83 c4 10             	add    $0x10,%esp
  80242d:	85 c0                	test   %eax,%eax
  80242f:	78 2c                	js     80245d <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802431:	e8 0f e7 ff ff       	call   800b45 <sys_getenvid>
  802436:	83 ec 08             	sub    $0x8,%esp
  802439:	68 6f 24 80 00       	push   $0x80246f
  80243e:	50                   	push   %eax
  80243f:	e8 8a e8 ff ff       	call   800cce <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	85 c0                	test   %eax,%eax
  802449:	79 bd                	jns    802408 <set_pgfault_handler+0xf>
  80244b:	50                   	push   %eax
  80244c:	68 ac 2d 80 00       	push   $0x802dac
  802451:	6a 23                	push   $0x23
  802453:	68 c4 2d 80 00       	push   $0x802dc4
  802458:	e8 56 ff ff ff       	call   8023b3 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80245d:	50                   	push   %eax
  80245e:	68 ac 2d 80 00       	push   $0x802dac
  802463:	6a 21                	push   $0x21
  802465:	68 c4 2d 80 00       	push   $0x802dc4
  80246a:	e8 44 ff ff ff       	call   8023b3 <_panic>

0080246f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80246f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802470:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802475:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802477:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  80247a:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  80247e:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  802481:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802485:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802489:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80248c:	83 c4 08             	add    $0x8,%esp
	popal
  80248f:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802490:	83 c4 04             	add    $0x4,%esp
	popfl
  802493:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802494:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802495:	c3                   	ret    

00802496 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80249c:	89 d0                	mov    %edx,%eax
  80249e:	c1 e8 16             	shr    $0x16,%eax
  8024a1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024a8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024ad:	f6 c1 01             	test   $0x1,%cl
  8024b0:	74 1d                	je     8024cf <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024b2:	c1 ea 0c             	shr    $0xc,%edx
  8024b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024bc:	f6 c2 01             	test   $0x1,%dl
  8024bf:	74 0e                	je     8024cf <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024c1:	c1 ea 0c             	shr    $0xc,%edx
  8024c4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024cb:	ef 
  8024cc:	0f b7 c0             	movzwl %ax,%eax
}
  8024cf:	5d                   	pop    %ebp
  8024d0:	c3                   	ret    
  8024d1:	66 90                	xchg   %ax,%ax
  8024d3:	66 90                	xchg   %ax,%ax
  8024d5:	66 90                	xchg   %ax,%ax
  8024d7:	66 90                	xchg   %ax,%ax
  8024d9:	66 90                	xchg   %ax,%ax
  8024db:	66 90                	xchg   %ax,%ax
  8024dd:	66 90                	xchg   %ax,%ax
  8024df:	90                   	nop

008024e0 <__udivdi3>:
  8024e0:	f3 0f 1e fb          	endbr32 
  8024e4:	55                   	push   %ebp
  8024e5:	57                   	push   %edi
  8024e6:	56                   	push   %esi
  8024e7:	53                   	push   %ebx
  8024e8:	83 ec 1c             	sub    $0x1c,%esp
  8024eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024fb:	85 d2                	test   %edx,%edx
  8024fd:	75 49                	jne    802548 <__udivdi3+0x68>
  8024ff:	39 f3                	cmp    %esi,%ebx
  802501:	76 15                	jbe    802518 <__udivdi3+0x38>
  802503:	31 ff                	xor    %edi,%edi
  802505:	89 e8                	mov    %ebp,%eax
  802507:	89 f2                	mov    %esi,%edx
  802509:	f7 f3                	div    %ebx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	83 c4 1c             	add    $0x1c,%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	89 d9                	mov    %ebx,%ecx
  80251a:	85 db                	test   %ebx,%ebx
  80251c:	75 0b                	jne    802529 <__udivdi3+0x49>
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	f7 f3                	div    %ebx
  802527:	89 c1                	mov    %eax,%ecx
  802529:	31 d2                	xor    %edx,%edx
  80252b:	89 f0                	mov    %esi,%eax
  80252d:	f7 f1                	div    %ecx
  80252f:	89 c6                	mov    %eax,%esi
  802531:	89 e8                	mov    %ebp,%eax
  802533:	89 f7                	mov    %esi,%edi
  802535:	f7 f1                	div    %ecx
  802537:	89 fa                	mov    %edi,%edx
  802539:	83 c4 1c             	add    $0x1c,%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	39 f2                	cmp    %esi,%edx
  80254a:	77 1c                	ja     802568 <__udivdi3+0x88>
  80254c:	0f bd fa             	bsr    %edx,%edi
  80254f:	83 f7 1f             	xor    $0x1f,%edi
  802552:	75 2c                	jne    802580 <__udivdi3+0xa0>
  802554:	39 f2                	cmp    %esi,%edx
  802556:	72 06                	jb     80255e <__udivdi3+0x7e>
  802558:	31 c0                	xor    %eax,%eax
  80255a:	39 eb                	cmp    %ebp,%ebx
  80255c:	77 ad                	ja     80250b <__udivdi3+0x2b>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	eb a6                	jmp    80250b <__udivdi3+0x2b>
  802565:	8d 76 00             	lea    0x0(%esi),%esi
  802568:	31 ff                	xor    %edi,%edi
  80256a:	31 c0                	xor    %eax,%eax
  80256c:	89 fa                	mov    %edi,%edx
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 f9                	mov    %edi,%ecx
  802582:	b8 20 00 00 00       	mov    $0x20,%eax
  802587:	29 f8                	sub    %edi,%eax
  802589:	d3 e2                	shl    %cl,%edx
  80258b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80258f:	89 c1                	mov    %eax,%ecx
  802591:	89 da                	mov    %ebx,%edx
  802593:	d3 ea                	shr    %cl,%edx
  802595:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802599:	09 d1                	or     %edx,%ecx
  80259b:	89 f2                	mov    %esi,%edx
  80259d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a1:	89 f9                	mov    %edi,%ecx
  8025a3:	d3 e3                	shl    %cl,%ebx
  8025a5:	89 c1                	mov    %eax,%ecx
  8025a7:	d3 ea                	shr    %cl,%edx
  8025a9:	89 f9                	mov    %edi,%ecx
  8025ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025af:	89 eb                	mov    %ebp,%ebx
  8025b1:	d3 e6                	shl    %cl,%esi
  8025b3:	89 c1                	mov    %eax,%ecx
  8025b5:	d3 eb                	shr    %cl,%ebx
  8025b7:	09 de                	or     %ebx,%esi
  8025b9:	89 f0                	mov    %esi,%eax
  8025bb:	f7 74 24 08          	divl   0x8(%esp)
  8025bf:	89 d6                	mov    %edx,%esi
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	f7 64 24 0c          	mull   0xc(%esp)
  8025c7:	39 d6                	cmp    %edx,%esi
  8025c9:	72 15                	jb     8025e0 <__udivdi3+0x100>
  8025cb:	89 f9                	mov    %edi,%ecx
  8025cd:	d3 e5                	shl    %cl,%ebp
  8025cf:	39 c5                	cmp    %eax,%ebp
  8025d1:	73 04                	jae    8025d7 <__udivdi3+0xf7>
  8025d3:	39 d6                	cmp    %edx,%esi
  8025d5:	74 09                	je     8025e0 <__udivdi3+0x100>
  8025d7:	89 d8                	mov    %ebx,%eax
  8025d9:	31 ff                	xor    %edi,%edi
  8025db:	e9 2b ff ff ff       	jmp    80250b <__udivdi3+0x2b>
  8025e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025e3:	31 ff                	xor    %edi,%edi
  8025e5:	e9 21 ff ff ff       	jmp    80250b <__udivdi3+0x2b>
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <__umoddi3>:
  8025f0:	f3 0f 1e fb          	endbr32 
  8025f4:	55                   	push   %ebp
  8025f5:	57                   	push   %edi
  8025f6:	56                   	push   %esi
  8025f7:	53                   	push   %ebx
  8025f8:	83 ec 1c             	sub    $0x1c,%esp
  8025fb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802603:	8b 74 24 30          	mov    0x30(%esp),%esi
  802607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80260b:	89 da                	mov    %ebx,%edx
  80260d:	85 c0                	test   %eax,%eax
  80260f:	75 3f                	jne    802650 <__umoddi3+0x60>
  802611:	39 df                	cmp    %ebx,%edi
  802613:	76 13                	jbe    802628 <__umoddi3+0x38>
  802615:	89 f0                	mov    %esi,%eax
  802617:	f7 f7                	div    %edi
  802619:	89 d0                	mov    %edx,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	83 c4 1c             	add    $0x1c,%esp
  802620:	5b                   	pop    %ebx
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	89 fd                	mov    %edi,%ebp
  80262a:	85 ff                	test   %edi,%edi
  80262c:	75 0b                	jne    802639 <__umoddi3+0x49>
  80262e:	b8 01 00 00 00       	mov    $0x1,%eax
  802633:	31 d2                	xor    %edx,%edx
  802635:	f7 f7                	div    %edi
  802637:	89 c5                	mov    %eax,%ebp
  802639:	89 d8                	mov    %ebx,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	f7 f5                	div    %ebp
  80263f:	89 f0                	mov    %esi,%eax
  802641:	f7 f5                	div    %ebp
  802643:	89 d0                	mov    %edx,%eax
  802645:	eb d4                	jmp    80261b <__umoddi3+0x2b>
  802647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80264e:	66 90                	xchg   %ax,%ax
  802650:	89 f1                	mov    %esi,%ecx
  802652:	39 d8                	cmp    %ebx,%eax
  802654:	76 0a                	jbe    802660 <__umoddi3+0x70>
  802656:	89 f0                	mov    %esi,%eax
  802658:	83 c4 1c             	add    $0x1c,%esp
  80265b:	5b                   	pop    %ebx
  80265c:	5e                   	pop    %esi
  80265d:	5f                   	pop    %edi
  80265e:	5d                   	pop    %ebp
  80265f:	c3                   	ret    
  802660:	0f bd e8             	bsr    %eax,%ebp
  802663:	83 f5 1f             	xor    $0x1f,%ebp
  802666:	75 20                	jne    802688 <__umoddi3+0x98>
  802668:	39 d8                	cmp    %ebx,%eax
  80266a:	0f 82 b0 00 00 00    	jb     802720 <__umoddi3+0x130>
  802670:	39 f7                	cmp    %esi,%edi
  802672:	0f 86 a8 00 00 00    	jbe    802720 <__umoddi3+0x130>
  802678:	89 c8                	mov    %ecx,%eax
  80267a:	83 c4 1c             	add    $0x1c,%esp
  80267d:	5b                   	pop    %ebx
  80267e:	5e                   	pop    %esi
  80267f:	5f                   	pop    %edi
  802680:	5d                   	pop    %ebp
  802681:	c3                   	ret    
  802682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802688:	89 e9                	mov    %ebp,%ecx
  80268a:	ba 20 00 00 00       	mov    $0x20,%edx
  80268f:	29 ea                	sub    %ebp,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 44 24 08          	mov    %eax,0x8(%esp)
  802697:	89 d1                	mov    %edx,%ecx
  802699:	89 f8                	mov    %edi,%eax
  80269b:	d3 e8                	shr    %cl,%eax
  80269d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026a9:	09 c1                	or     %eax,%ecx
  8026ab:	89 d8                	mov    %ebx,%eax
  8026ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b1:	89 e9                	mov    %ebp,%ecx
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 d1                	mov    %edx,%ecx
  8026b7:	d3 e8                	shr    %cl,%eax
  8026b9:	89 e9                	mov    %ebp,%ecx
  8026bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026bf:	d3 e3                	shl    %cl,%ebx
  8026c1:	89 c7                	mov    %eax,%edi
  8026c3:	89 d1                	mov    %edx,%ecx
  8026c5:	89 f0                	mov    %esi,%eax
  8026c7:	d3 e8                	shr    %cl,%eax
  8026c9:	89 e9                	mov    %ebp,%ecx
  8026cb:	89 fa                	mov    %edi,%edx
  8026cd:	d3 e6                	shl    %cl,%esi
  8026cf:	09 d8                	or     %ebx,%eax
  8026d1:	f7 74 24 08          	divl   0x8(%esp)
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	89 f3                	mov    %esi,%ebx
  8026d9:	f7 64 24 0c          	mull   0xc(%esp)
  8026dd:	89 c6                	mov    %eax,%esi
  8026df:	89 d7                	mov    %edx,%edi
  8026e1:	39 d1                	cmp    %edx,%ecx
  8026e3:	72 06                	jb     8026eb <__umoddi3+0xfb>
  8026e5:	75 10                	jne    8026f7 <__umoddi3+0x107>
  8026e7:	39 c3                	cmp    %eax,%ebx
  8026e9:	73 0c                	jae    8026f7 <__umoddi3+0x107>
  8026eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026f3:	89 d7                	mov    %edx,%edi
  8026f5:	89 c6                	mov    %eax,%esi
  8026f7:	89 ca                	mov    %ecx,%edx
  8026f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fe:	29 f3                	sub    %esi,%ebx
  802700:	19 fa                	sbb    %edi,%edx
  802702:	89 d0                	mov    %edx,%eax
  802704:	d3 e0                	shl    %cl,%eax
  802706:	89 e9                	mov    %ebp,%ecx
  802708:	d3 eb                	shr    %cl,%ebx
  80270a:	d3 ea                	shr    %cl,%edx
  80270c:	09 d8                	or     %ebx,%eax
  80270e:	83 c4 1c             	add    $0x1c,%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    
  802716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80271d:	8d 76 00             	lea    0x0(%esi),%esi
  802720:	89 da                	mov    %ebx,%edx
  802722:	29 fe                	sub    %edi,%esi
  802724:	19 c2                	sbb    %eax,%edx
  802726:	89 f1                	mov    %esi,%ecx
  802728:	89 c8                	mov    %ecx,%eax
  80272a:	e9 4b ff ff ff       	jmp    80267a <__umoddi3+0x8a>
