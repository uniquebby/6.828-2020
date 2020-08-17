
obj/user/primespipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 00 02 00 00       	call   800231 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800045:	eb 5e                	jmp    8000a5 <primeproc+0x72>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800047:	83 ec 0c             	sub    $0xc,%esp
  80004a:	85 c0                	test   %eax,%eax
  80004c:	ba 00 00 00 00       	mov    $0x0,%edx
  800051:	0f 4e d0             	cmovle %eax,%edx
  800054:	52                   	push   %edx
  800055:	50                   	push   %eax
  800056:	68 a0 28 80 00       	push   $0x8028a0
  80005b:	6a 15                	push   $0x15
  80005d:	68 cf 28 80 00       	push   $0x8028cf
  800062:	e8 2a 02 00 00       	call   800291 <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 e5 28 80 00       	push   $0x8028e5
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 cf 28 80 00       	push   $0x8028cf
  800074:	e8 18 02 00 00       	call   800291 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 ee 28 80 00       	push   $0x8028ee
  80007f:	6a 1d                	push   $0x1d
  800081:	68 cf 28 80 00       	push   $0x8028cf
  800086:	e8 06 02 00 00       	call   800291 <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 06 14 00 00       	call   80149a <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 fb 13 00 00       	call   80149a <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 ae 15 00 00       	call   80165f <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 e1 28 80 00       	push   $0x8028e1
  8000c4:	e8 a3 02 00 00       	call   80036c <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 28 1c 00 00       	call   801cf9 <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 e1 0f 00 00       	call   8010c1 <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 a9 13 00 00       	call   80149a <close>
	wfd = pfd[1];
  8000f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f4:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f7:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	e8 59 15 00 00       	call   80165f <readn>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	83 f8 04             	cmp    $0x4,%eax
  80010c:	75 42                	jne    800150 <primeproc+0x11d>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d e0             	idivl  -0x20(%ebp)
  800115:	85 d2                	test   %edx,%edx
  800117:	74 e1                	je     8000fa <primeproc+0xc7>
			if ((r=write(wfd, &i, 4)) != 4)
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	6a 04                	push   $0x4
  80011e:	56                   	push   %esi
  80011f:	57                   	push   %edi
  800120:	e8 7f 15 00 00       	call   8016a4 <write>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	83 f8 04             	cmp    $0x4,%eax
  80012b:	74 cd                	je     8000fa <primeproc+0xc7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	85 c0                	test   %eax,%eax
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	0f 4e d0             	cmovle %eax,%edx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	ff 75 e0             	pushl  -0x20(%ebp)
  80013f:	68 13 29 80 00       	push   $0x802913
  800144:	6a 2e                	push   $0x2e
  800146:	68 cf 28 80 00       	push   $0x8028cf
  80014b:	e8 41 01 00 00       	call   800291 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 f7 28 80 00       	push   $0x8028f7
  800168:	6a 2b                	push   $0x2b
  80016a:	68 cf 28 80 00       	push   $0x8028cf
  80016f:	e8 1d 01 00 00       	call   800291 <_panic>

00800174 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017b:	c7 05 00 30 80 00 2d 	movl   $0x80292d,0x803000
  800182:	29 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 6b 1b 00 00       	call   801cf9 <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 24 0f 00 00       	call   8010c1 <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 ec 12 00 00       	call   80149a <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 e5 28 80 00       	push   $0x8028e5
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 cf 28 80 00       	push   $0x8028cf
  8001c6:	e8 c6 00 00 00       	call   800291 <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 ee 28 80 00       	push   $0x8028ee
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 cf 28 80 00       	push   $0x8028cf
  8001d8:	e8 b4 00 00 00       	call   800291 <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 b2 12 00 00       	call   80149a <close>

	// feed all the integers through
	for (i=2;; i++)
  8001e8:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001ef:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 04                	push   $0x4
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8001fe:	e8 a1 14 00 00       	call   8016a4 <write>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	83 f8 04             	cmp    $0x4,%eax
  800209:	75 06                	jne    800211 <umain+0x9d>
	for (i=2;; i++)
  80020b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80020f:	eb e4                	jmp    8001f5 <umain+0x81>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	85 c0                	test   %eax,%eax
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	0f 4e d0             	cmovle %eax,%edx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 38 29 80 00       	push   $0x802938
  800225:	6a 4a                	push   $0x4a
  800227:	68 cf 28 80 00       	push   $0x8028cf
  80022c:	e8 60 00 00 00       	call   800291 <_panic>

00800231 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800239:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80023c:	e8 bb 0a 00 00       	call   800cfc <sys_getenvid>
  800241:	25 ff 03 00 00       	and    $0x3ff,%eax
  800246:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800249:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80024e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800253:	85 db                	test   %ebx,%ebx
  800255:	7e 07                	jle    80025e <libmain+0x2d>
		binaryname = argv[0];
  800257:	8b 06                	mov    (%esi),%eax
  800259:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	e8 0c ff ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  800268:	e8 0a 00 00 00       	call   800277 <exit>
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5d                   	pop    %ebp
  800276:	c3                   	ret    

00800277 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80027d:	e8 45 12 00 00       	call   8014c7 <close_all>
	sys_env_destroy(0);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	6a 00                	push   $0x0
  800287:	e8 2f 0a 00 00       	call   800cbb <sys_env_destroy>
}
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800296:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800299:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80029f:	e8 58 0a 00 00       	call   800cfc <sys_getenvid>
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	56                   	push   %esi
  8002ae:	50                   	push   %eax
  8002af:	68 5c 29 80 00       	push   $0x80295c
  8002b4:	e8 b3 00 00 00       	call   80036c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b9:	83 c4 18             	add    $0x18,%esp
  8002bc:	53                   	push   %ebx
  8002bd:	ff 75 10             	pushl  0x10(%ebp)
  8002c0:	e8 56 00 00 00       	call   80031b <vcprintf>
	cprintf("\n");
  8002c5:	c7 04 24 e3 28 80 00 	movl   $0x8028e3,(%esp)
  8002cc:	e8 9b 00 00 00       	call   80036c <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d4:	cc                   	int3   
  8002d5:	eb fd                	jmp    8002d4 <_panic+0x43>

008002d7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	53                   	push   %ebx
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e1:	8b 13                	mov    (%ebx),%edx
  8002e3:	8d 42 01             	lea    0x1(%edx),%eax
  8002e6:	89 03                	mov    %eax,(%ebx)
  8002e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002eb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f4:	74 09                	je     8002ff <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	68 ff 00 00 00       	push   $0xff
  800307:	8d 43 08             	lea    0x8(%ebx),%eax
  80030a:	50                   	push   %eax
  80030b:	e8 6e 09 00 00       	call   800c7e <sys_cputs>
		b->idx = 0;
  800310:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb db                	jmp    8002f6 <putch+0x1f>

0080031b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800324:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032b:	00 00 00 
	b.cnt = 0;
  80032e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800335:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800344:	50                   	push   %eax
  800345:	68 d7 02 80 00       	push   $0x8002d7
  80034a:	e8 19 01 00 00       	call   800468 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80034f:	83 c4 08             	add    $0x8,%esp
  800352:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800358:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80035e:	50                   	push   %eax
  80035f:	e8 1a 09 00 00       	call   800c7e <sys_cputs>

	return b.cnt;
}
  800364:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800372:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800375:	50                   	push   %eax
  800376:	ff 75 08             	pushl  0x8(%ebp)
  800379:	e8 9d ff ff ff       	call   80031b <vcprintf>
	va_end(ap);

	return cnt;
}
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	57                   	push   %edi
  800384:	56                   	push   %esi
  800385:	53                   	push   %ebx
  800386:	83 ec 1c             	sub    $0x1c,%esp
  800389:	89 c7                	mov    %eax,%edi
  80038b:	89 d6                	mov    %edx,%esi
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	8b 55 0c             	mov    0xc(%ebp),%edx
  800393:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800396:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800399:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80039c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8003aa:	89 d0                	mov    %edx,%eax
  8003ac:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8003af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003b2:	73 15                	jae    8003c9 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b4:	83 eb 01             	sub    $0x1,%ebx
  8003b7:	85 db                	test   %ebx,%ebx
  8003b9:	7e 43                	jle    8003fe <printnum+0x7e>
			putch(padc, putdat);
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	56                   	push   %esi
  8003bf:	ff 75 18             	pushl  0x18(%ebp)
  8003c2:	ff d7                	call   *%edi
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	eb eb                	jmp    8003b4 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c9:	83 ec 0c             	sub    $0xc,%esp
  8003cc:	ff 75 18             	pushl  0x18(%ebp)
  8003cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	53                   	push   %ebx
  8003d6:	ff 75 10             	pushl  0x10(%ebp)
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003df:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e8:	e8 63 22 00 00       	call   802650 <__udivdi3>
  8003ed:	83 c4 18             	add    $0x18,%esp
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	89 f2                	mov    %esi,%edx
  8003f4:	89 f8                	mov    %edi,%eax
  8003f6:	e8 85 ff ff ff       	call   800380 <printnum>
  8003fb:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	56                   	push   %esi
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	ff 75 e4             	pushl  -0x1c(%ebp)
  800408:	ff 75 e0             	pushl  -0x20(%ebp)
  80040b:	ff 75 dc             	pushl  -0x24(%ebp)
  80040e:	ff 75 d8             	pushl  -0x28(%ebp)
  800411:	e8 4a 23 00 00       	call   802760 <__umoddi3>
  800416:	83 c4 14             	add    $0x14,%esp
  800419:	0f be 80 7f 29 80 00 	movsbl 0x80297f(%eax),%eax
  800420:	50                   	push   %eax
  800421:	ff d7                	call   *%edi
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800429:	5b                   	pop    %ebx
  80042a:	5e                   	pop    %esi
  80042b:	5f                   	pop    %edi
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    

0080042e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800434:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800438:	8b 10                	mov    (%eax),%edx
  80043a:	3b 50 04             	cmp    0x4(%eax),%edx
  80043d:	73 0a                	jae    800449 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800442:	89 08                	mov    %ecx,(%eax)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	88 02                	mov    %al,(%edx)
}
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    

0080044b <printfmt>:
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800451:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800454:	50                   	push   %eax
  800455:	ff 75 10             	pushl  0x10(%ebp)
  800458:	ff 75 0c             	pushl  0xc(%ebp)
  80045b:	ff 75 08             	pushl  0x8(%ebp)
  80045e:	e8 05 00 00 00       	call   800468 <vprintfmt>
}
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <vprintfmt>:
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	57                   	push   %edi
  80046c:	56                   	push   %esi
  80046d:	53                   	push   %ebx
  80046e:	83 ec 3c             	sub    $0x3c,%esp
  800471:	8b 75 08             	mov    0x8(%ebp),%esi
  800474:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800477:	8b 7d 10             	mov    0x10(%ebp),%edi
  80047a:	eb 0a                	jmp    800486 <vprintfmt+0x1e>
			putch(ch, putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	50                   	push   %eax
  800481:	ff d6                	call   *%esi
  800483:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800486:	83 c7 01             	add    $0x1,%edi
  800489:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80048d:	83 f8 25             	cmp    $0x25,%eax
  800490:	74 0c                	je     80049e <vprintfmt+0x36>
			if (ch == '\0')
  800492:	85 c0                	test   %eax,%eax
  800494:	75 e6                	jne    80047c <vprintfmt+0x14>
}
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    
		padc = ' ';
  80049e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004a2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004a9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004b7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8d 47 01             	lea    0x1(%edi),%eax
  8004bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004c2:	0f b6 17             	movzbl (%edi),%edx
  8004c5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004c8:	3c 55                	cmp    $0x55,%al
  8004ca:	0f 87 ba 03 00 00    	ja     80088a <vprintfmt+0x422>
  8004d0:	0f b6 c0             	movzbl %al,%eax
  8004d3:	ff 24 85 c0 2a 80 00 	jmp    *0x802ac0(,%eax,4)
  8004da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004dd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004e1:	eb d9                	jmp    8004bc <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004e6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004ea:	eb d0                	jmp    8004bc <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	0f b6 d2             	movzbl %dl,%edx
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004fa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004fd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800501:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800504:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800507:	83 f9 09             	cmp    $0x9,%ecx
  80050a:	77 55                	ja     800561 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80050c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80050f:	eb e9                	jmp    8004fa <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800525:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800529:	79 91                	jns    8004bc <vprintfmt+0x54>
				width = precision, precision = -1;
  80052b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80052e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800531:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800538:	eb 82                	jmp    8004bc <vprintfmt+0x54>
  80053a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	ba 00 00 00 00       	mov    $0x0,%edx
  800544:	0f 49 d0             	cmovns %eax,%edx
  800547:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054d:	e9 6a ff ff ff       	jmp    8004bc <vprintfmt+0x54>
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800555:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80055c:	e9 5b ff ff ff       	jmp    8004bc <vprintfmt+0x54>
  800561:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800564:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800567:	eb bc                	jmp    800525 <vprintfmt+0xbd>
			lflag++;
  800569:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80056f:	e9 48 ff ff ff       	jmp    8004bc <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 78 04             	lea    0x4(%eax),%edi
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	53                   	push   %ebx
  80057e:	ff 30                	pushl  (%eax)
  800580:	ff d6                	call   *%esi
			break;
  800582:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800585:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800588:	e9 9c 02 00 00       	jmp    800829 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 78 04             	lea    0x4(%eax),%edi
  800593:	8b 00                	mov    (%eax),%eax
  800595:	99                   	cltd   
  800596:	31 d0                	xor    %edx,%eax
  800598:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80059a:	83 f8 0f             	cmp    $0xf,%eax
  80059d:	7f 23                	jg     8005c2 <vprintfmt+0x15a>
  80059f:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  8005a6:	85 d2                	test   %edx,%edx
  8005a8:	74 18                	je     8005c2 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8005aa:	52                   	push   %edx
  8005ab:	68 be 2e 80 00       	push   $0x802ebe
  8005b0:	53                   	push   %ebx
  8005b1:	56                   	push   %esi
  8005b2:	e8 94 fe ff ff       	call   80044b <printfmt>
  8005b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ba:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005bd:	e9 67 02 00 00       	jmp    800829 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8005c2:	50                   	push   %eax
  8005c3:	68 97 29 80 00       	push   $0x802997
  8005c8:	53                   	push   %ebx
  8005c9:	56                   	push   %esi
  8005ca:	e8 7c fe ff ff       	call   80044b <printfmt>
  8005cf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005d2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005d5:	e9 4f 02 00 00       	jmp    800829 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	83 c0 04             	add    $0x4,%eax
  8005e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005e8:	85 d2                	test   %edx,%edx
  8005ea:	b8 90 29 80 00       	mov    $0x802990,%eax
  8005ef:	0f 45 c2             	cmovne %edx,%eax
  8005f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f9:	7e 06                	jle    800601 <vprintfmt+0x199>
  8005fb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005ff:	75 0d                	jne    80060e <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800604:	89 c7                	mov    %eax,%edi
  800606:	03 45 e0             	add    -0x20(%ebp),%eax
  800609:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060c:	eb 3f                	jmp    80064d <vprintfmt+0x1e5>
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 d8             	pushl  -0x28(%ebp)
  800614:	50                   	push   %eax
  800615:	e8 0d 03 00 00       	call   800927 <strnlen>
  80061a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061d:	29 c2                	sub    %eax,%edx
  80061f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800627:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80062b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80062e:	85 ff                	test   %edi,%edi
  800630:	7e 58                	jle    80068a <vprintfmt+0x222>
					putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	53                   	push   %ebx
  800636:	ff 75 e0             	pushl  -0x20(%ebp)
  800639:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80063b:	83 ef 01             	sub    $0x1,%edi
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	eb eb                	jmp    80062e <vprintfmt+0x1c6>
					putch(ch, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	53                   	push   %ebx
  800647:	52                   	push   %edx
  800648:	ff d6                	call   *%esi
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800650:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800652:	83 c7 01             	add    $0x1,%edi
  800655:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800659:	0f be d0             	movsbl %al,%edx
  80065c:	85 d2                	test   %edx,%edx
  80065e:	74 45                	je     8006a5 <vprintfmt+0x23d>
  800660:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800664:	78 06                	js     80066c <vprintfmt+0x204>
  800666:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80066a:	78 35                	js     8006a1 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80066c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800670:	74 d1                	je     800643 <vprintfmt+0x1db>
  800672:	0f be c0             	movsbl %al,%eax
  800675:	83 e8 20             	sub    $0x20,%eax
  800678:	83 f8 5e             	cmp    $0x5e,%eax
  80067b:	76 c6                	jbe    800643 <vprintfmt+0x1db>
					putch('?', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 3f                	push   $0x3f
  800683:	ff d6                	call   *%esi
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	eb c3                	jmp    80064d <vprintfmt+0x1e5>
  80068a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	b8 00 00 00 00       	mov    $0x0,%eax
  800694:	0f 49 c2             	cmovns %edx,%eax
  800697:	29 c2                	sub    %eax,%edx
  800699:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80069c:	e9 60 ff ff ff       	jmp    800601 <vprintfmt+0x199>
  8006a1:	89 cf                	mov    %ecx,%edi
  8006a3:	eb 02                	jmp    8006a7 <vprintfmt+0x23f>
  8006a5:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8006a7:	85 ff                	test   %edi,%edi
  8006a9:	7e 10                	jle    8006bb <vprintfmt+0x253>
				putch(' ', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 20                	push   $0x20
  8006b1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b3:	83 ef 01             	sub    $0x1,%edi
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	eb ec                	jmp    8006a7 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c1:	e9 63 01 00 00       	jmp    800829 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8006c6:	83 f9 01             	cmp    $0x1,%ecx
  8006c9:	7f 1b                	jg     8006e6 <vprintfmt+0x27e>
	else if (lflag)
  8006cb:	85 c9                	test   %ecx,%ecx
  8006cd:	74 63                	je     800732 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	99                   	cltd   
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	eb 17                	jmp    8006fd <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8b 50 04             	mov    0x4(%eax),%edx
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 08             	lea    0x8(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800700:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800703:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800708:	85 c9                	test   %ecx,%ecx
  80070a:	0f 89 ff 00 00 00    	jns    80080f <vprintfmt+0x3a7>
				putch('-', putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	6a 2d                	push   $0x2d
  800716:	ff d6                	call   *%esi
				num = -(long long) num;
  800718:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80071b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80071e:	f7 da                	neg    %edx
  800720:	83 d1 00             	adc    $0x0,%ecx
  800723:	f7 d9                	neg    %ecx
  800725:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800728:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072d:	e9 dd 00 00 00       	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	99                   	cltd   
  80073b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
  800747:	eb b4                	jmp    8006fd <vprintfmt+0x295>
	if (lflag >= 2)
  800749:	83 f9 01             	cmp    $0x1,%ecx
  80074c:	7f 1e                	jg     80076c <vprintfmt+0x304>
	else if (lflag)
  80074e:	85 c9                	test   %ecx,%ecx
  800750:	74 32                	je     800784 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800762:	b8 0a 00 00 00       	mov    $0xa,%eax
  800767:	e9 a3 00 00 00       	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 10                	mov    (%eax),%edx
  800771:	8b 48 04             	mov    0x4(%eax),%ecx
  800774:	8d 40 08             	lea    0x8(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80077a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077f:	e9 8b 00 00 00       	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 10                	mov    (%eax),%edx
  800789:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800794:	b8 0a 00 00 00       	mov    $0xa,%eax
  800799:	eb 74                	jmp    80080f <vprintfmt+0x3a7>
	if (lflag >= 2)
  80079b:	83 f9 01             	cmp    $0x1,%ecx
  80079e:	7f 1b                	jg     8007bb <vprintfmt+0x353>
	else if (lflag)
  8007a0:	85 c9                	test   %ecx,%ecx
  8007a2:	74 2c                	je     8007d0 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 10                	mov    (%eax),%edx
  8007a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b9:	eb 54                	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 10                	mov    (%eax),%edx
  8007c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c3:	8d 40 08             	lea    0x8(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c9:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ce:	eb 3f                	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 10                	mov    (%eax),%edx
  8007d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007da:	8d 40 04             	lea    0x4(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e5:	eb 28                	jmp    80080f <vprintfmt+0x3a7>
			putch('0', putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	6a 30                	push   $0x30
  8007ed:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ef:	83 c4 08             	add    $0x8,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	6a 78                	push   $0x78
  8007f5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800801:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800804:	8d 40 04             	lea    0x4(%eax),%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80080f:	83 ec 0c             	sub    $0xc,%esp
  800812:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800816:	57                   	push   %edi
  800817:	ff 75 e0             	pushl  -0x20(%ebp)
  80081a:	50                   	push   %eax
  80081b:	51                   	push   %ecx
  80081c:	52                   	push   %edx
  80081d:	89 da                	mov    %ebx,%edx
  80081f:	89 f0                	mov    %esi,%eax
  800821:	e8 5a fb ff ff       	call   800380 <printnum>
			break;
  800826:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800829:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082c:	e9 55 fc ff ff       	jmp    800486 <vprintfmt+0x1e>
	if (lflag >= 2)
  800831:	83 f9 01             	cmp    $0x1,%ecx
  800834:	7f 1b                	jg     800851 <vprintfmt+0x3e9>
	else if (lflag)
  800836:	85 c9                	test   %ecx,%ecx
  800838:	74 2c                	je     800866 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 10                	mov    (%eax),%edx
  80083f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084a:	b8 10 00 00 00       	mov    $0x10,%eax
  80084f:	eb be                	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 10                	mov    (%eax),%edx
  800856:	8b 48 04             	mov    0x4(%eax),%ecx
  800859:	8d 40 08             	lea    0x8(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085f:	b8 10 00 00 00       	mov    $0x10,%eax
  800864:	eb a9                	jmp    80080f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 10                	mov    (%eax),%edx
  80086b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800870:	8d 40 04             	lea    0x4(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800876:	b8 10 00 00 00       	mov    $0x10,%eax
  80087b:	eb 92                	jmp    80080f <vprintfmt+0x3a7>
			putch(ch, putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	53                   	push   %ebx
  800881:	6a 25                	push   $0x25
  800883:	ff d6                	call   *%esi
			break;
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	eb 9f                	jmp    800829 <vprintfmt+0x3c1>
			putch('%', putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	6a 25                	push   $0x25
  800890:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	89 f8                	mov    %edi,%eax
  800897:	eb 03                	jmp    80089c <vprintfmt+0x434>
  800899:	83 e8 01             	sub    $0x1,%eax
  80089c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a0:	75 f7                	jne    800899 <vprintfmt+0x431>
  8008a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a5:	eb 82                	jmp    800829 <vprintfmt+0x3c1>

008008a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	74 26                	je     8008ee <vsnprintf+0x47>
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	7e 22                	jle    8008ee <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cc:	ff 75 14             	pushl  0x14(%ebp)
  8008cf:	ff 75 10             	pushl  0x10(%ebp)
  8008d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d5:	50                   	push   %eax
  8008d6:	68 2e 04 80 00       	push   $0x80042e
  8008db:	e8 88 fb ff ff       	call   800468 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
}
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    
		return -E_INVAL;
  8008ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f3:	eb f7                	jmp    8008ec <vsnprintf+0x45>

008008f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008fe:	50                   	push   %eax
  8008ff:	ff 75 10             	pushl  0x10(%ebp)
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	e8 9a ff ff ff       	call   8008a7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80090d:	c9                   	leave  
  80090e:	c3                   	ret    

0080090f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800915:	b8 00 00 00 00       	mov    $0x0,%eax
  80091a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80091e:	74 05                	je     800925 <strlen+0x16>
		n++;
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	eb f5                	jmp    80091a <strlen+0xb>
	return n;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800930:	ba 00 00 00 00       	mov    $0x0,%edx
  800935:	39 c2                	cmp    %eax,%edx
  800937:	74 0d                	je     800946 <strnlen+0x1f>
  800939:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80093d:	74 05                	je     800944 <strnlen+0x1d>
		n++;
  80093f:	83 c2 01             	add    $0x1,%edx
  800942:	eb f1                	jmp    800935 <strnlen+0xe>
  800944:	89 d0                	mov    %edx,%eax
	return n;
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80095e:	83 c2 01             	add    $0x1,%edx
  800961:	84 c9                	test   %cl,%cl
  800963:	75 f2                	jne    800957 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800965:	5b                   	pop    %ebx
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	53                   	push   %ebx
  80096c:	83 ec 10             	sub    $0x10,%esp
  80096f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800972:	53                   	push   %ebx
  800973:	e8 97 ff ff ff       	call   80090f <strlen>
  800978:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	01 d8                	add    %ebx,%eax
  800980:	50                   	push   %eax
  800981:	e8 c2 ff ff ff       	call   800948 <strcpy>
	return dst;
}
  800986:	89 d8                	mov    %ebx,%eax
  800988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800998:	89 c6                	mov    %eax,%esi
  80099a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099d:	89 c2                	mov    %eax,%edx
  80099f:	39 f2                	cmp    %esi,%edx
  8009a1:	74 11                	je     8009b4 <strncpy+0x27>
		*dst++ = *src;
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	0f b6 19             	movzbl (%ecx),%ebx
  8009a9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ac:	80 fb 01             	cmp    $0x1,%bl
  8009af:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b2:	eb eb                	jmp    80099f <strncpy+0x12>
	}
	return ret;
}
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c8:	85 d2                	test   %edx,%edx
  8009ca:	74 21                	je     8009ed <strlcpy+0x35>
  8009cc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d2:	39 c2                	cmp    %eax,%edx
  8009d4:	74 14                	je     8009ea <strlcpy+0x32>
  8009d6:	0f b6 19             	movzbl (%ecx),%ebx
  8009d9:	84 db                	test   %bl,%bl
  8009db:	74 0b                	je     8009e8 <strlcpy+0x30>
			*dst++ = *src++;
  8009dd:	83 c1 01             	add    $0x1,%ecx
  8009e0:	83 c2 01             	add    $0x1,%edx
  8009e3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e6:	eb ea                	jmp    8009d2 <strlcpy+0x1a>
  8009e8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ed:	29 f0                	sub    %esi,%eax
}
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009fc:	0f b6 01             	movzbl (%ecx),%eax
  8009ff:	84 c0                	test   %al,%al
  800a01:	74 0c                	je     800a0f <strcmp+0x1c>
  800a03:	3a 02                	cmp    (%edx),%al
  800a05:	75 08                	jne    800a0f <strcmp+0x1c>
		p++, q++;
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
  800a0d:	eb ed                	jmp    8009fc <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0f:	0f b6 c0             	movzbl %al,%eax
  800a12:	0f b6 12             	movzbl (%edx),%edx
  800a15:	29 d0                	sub    %edx,%eax
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a23:	89 c3                	mov    %eax,%ebx
  800a25:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a28:	eb 06                	jmp    800a30 <strncmp+0x17>
		n--, p++, q++;
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a30:	39 d8                	cmp    %ebx,%eax
  800a32:	74 16                	je     800a4a <strncmp+0x31>
  800a34:	0f b6 08             	movzbl (%eax),%ecx
  800a37:	84 c9                	test   %cl,%cl
  800a39:	74 04                	je     800a3f <strncmp+0x26>
  800a3b:	3a 0a                	cmp    (%edx),%cl
  800a3d:	74 eb                	je     800a2a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3f:	0f b6 00             	movzbl (%eax),%eax
  800a42:	0f b6 12             	movzbl (%edx),%edx
  800a45:	29 d0                	sub    %edx,%eax
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    
		return 0;
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4f:	eb f6                	jmp    800a47 <strncmp+0x2e>

00800a51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5b:	0f b6 10             	movzbl (%eax),%edx
  800a5e:	84 d2                	test   %dl,%dl
  800a60:	74 09                	je     800a6b <strchr+0x1a>
		if (*s == c)
  800a62:	38 ca                	cmp    %cl,%dl
  800a64:	74 0a                	je     800a70 <strchr+0x1f>
	for (; *s; s++)
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	eb f0                	jmp    800a5b <strchr+0xa>
			return (char *) s;
	return 0;
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a7f:	38 ca                	cmp    %cl,%dl
  800a81:	74 09                	je     800a8c <strfind+0x1a>
  800a83:	84 d2                	test   %dl,%dl
  800a85:	74 05                	je     800a8c <strfind+0x1a>
	for (; *s; s++)
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	eb f0                	jmp    800a7c <strfind+0xa>
			break;
	return (char *) s;
}
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	57                   	push   %edi
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9a:	85 c9                	test   %ecx,%ecx
  800a9c:	74 31                	je     800acf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a9e:	89 f8                	mov    %edi,%eax
  800aa0:	09 c8                	or     %ecx,%eax
  800aa2:	a8 03                	test   $0x3,%al
  800aa4:	75 23                	jne    800ac9 <memset+0x3b>
		c &= 0xFF;
  800aa6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aaa:	89 d3                	mov    %edx,%ebx
  800aac:	c1 e3 08             	shl    $0x8,%ebx
  800aaf:	89 d0                	mov    %edx,%eax
  800ab1:	c1 e0 18             	shl    $0x18,%eax
  800ab4:	89 d6                	mov    %edx,%esi
  800ab6:	c1 e6 10             	shl    $0x10,%esi
  800ab9:	09 f0                	or     %esi,%eax
  800abb:	09 c2                	or     %eax,%edx
  800abd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800abf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	fc                   	cld    
  800ac5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac7:	eb 06                	jmp    800acf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	fc                   	cld    
  800acd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acf:	89 f8                	mov    %edi,%eax
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae4:	39 c6                	cmp    %eax,%esi
  800ae6:	73 32                	jae    800b1a <memmove+0x44>
  800ae8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aeb:	39 c2                	cmp    %eax,%edx
  800aed:	76 2b                	jbe    800b1a <memmove+0x44>
		s += n;
		d += n;
  800aef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af2:	89 fe                	mov    %edi,%esi
  800af4:	09 ce                	or     %ecx,%esi
  800af6:	09 d6                	or     %edx,%esi
  800af8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afe:	75 0e                	jne    800b0e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b00:	83 ef 04             	sub    $0x4,%edi
  800b03:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b09:	fd                   	std    
  800b0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0c:	eb 09                	jmp    800b17 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0e:	83 ef 01             	sub    $0x1,%edi
  800b11:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b14:	fd                   	std    
  800b15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b17:	fc                   	cld    
  800b18:	eb 1a                	jmp    800b34 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1a:	89 c2                	mov    %eax,%edx
  800b1c:	09 ca                	or     %ecx,%edx
  800b1e:	09 f2                	or     %esi,%edx
  800b20:	f6 c2 03             	test   $0x3,%dl
  800b23:	75 0a                	jne    800b2f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	fc                   	cld    
  800b2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2d:	eb 05                	jmp    800b34 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	fc                   	cld    
  800b32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b3e:	ff 75 10             	pushl  0x10(%ebp)
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	ff 75 08             	pushl  0x8(%ebp)
  800b47:	e8 8a ff ff ff       	call   800ad6 <memmove>
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b59:	89 c6                	mov    %eax,%esi
  800b5b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5e:	39 f0                	cmp    %esi,%eax
  800b60:	74 1c                	je     800b7e <memcmp+0x30>
		if (*s1 != *s2)
  800b62:	0f b6 08             	movzbl (%eax),%ecx
  800b65:	0f b6 1a             	movzbl (%edx),%ebx
  800b68:	38 d9                	cmp    %bl,%cl
  800b6a:	75 08                	jne    800b74 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b6c:	83 c0 01             	add    $0x1,%eax
  800b6f:	83 c2 01             	add    $0x1,%edx
  800b72:	eb ea                	jmp    800b5e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b74:	0f b6 c1             	movzbl %cl,%eax
  800b77:	0f b6 db             	movzbl %bl,%ebx
  800b7a:	29 d8                	sub    %ebx,%eax
  800b7c:	eb 05                	jmp    800b83 <memcmp+0x35>
	}

	return 0;
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b95:	39 d0                	cmp    %edx,%eax
  800b97:	73 09                	jae    800ba2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b99:	38 08                	cmp    %cl,(%eax)
  800b9b:	74 05                	je     800ba2 <memfind+0x1b>
	for (; s < ends; s++)
  800b9d:	83 c0 01             	add    $0x1,%eax
  800ba0:	eb f3                	jmp    800b95 <memfind+0xe>
			break;
	return (void *) s;
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
  800baa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb0:	eb 03                	jmp    800bb5 <strtol+0x11>
		s++;
  800bb2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb5:	0f b6 01             	movzbl (%ecx),%eax
  800bb8:	3c 20                	cmp    $0x20,%al
  800bba:	74 f6                	je     800bb2 <strtol+0xe>
  800bbc:	3c 09                	cmp    $0x9,%al
  800bbe:	74 f2                	je     800bb2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc0:	3c 2b                	cmp    $0x2b,%al
  800bc2:	74 2a                	je     800bee <strtol+0x4a>
	int neg = 0;
  800bc4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bc9:	3c 2d                	cmp    $0x2d,%al
  800bcb:	74 2b                	je     800bf8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd3:	75 0f                	jne    800be4 <strtol+0x40>
  800bd5:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd8:	74 28                	je     800c02 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bda:	85 db                	test   %ebx,%ebx
  800bdc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be1:	0f 44 d8             	cmove  %eax,%ebx
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bec:	eb 50                	jmp    800c3e <strtol+0x9a>
		s++;
  800bee:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf1:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf6:	eb d5                	jmp    800bcd <strtol+0x29>
		s++, neg = 1;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	bf 01 00 00 00       	mov    $0x1,%edi
  800c00:	eb cb                	jmp    800bcd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c02:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c06:	74 0e                	je     800c16 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c08:	85 db                	test   %ebx,%ebx
  800c0a:	75 d8                	jne    800be4 <strtol+0x40>
		s++, base = 8;
  800c0c:	83 c1 01             	add    $0x1,%ecx
  800c0f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c14:	eb ce                	jmp    800be4 <strtol+0x40>
		s += 2, base = 16;
  800c16:	83 c1 02             	add    $0x2,%ecx
  800c19:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c1e:	eb c4                	jmp    800be4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c20:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 19             	cmp    $0x19,%bl
  800c28:	77 29                	ja     800c53 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2a:	0f be d2             	movsbl %dl,%edx
  800c2d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c33:	7d 30                	jge    800c65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c35:	83 c1 01             	add    $0x1,%ecx
  800c38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c3e:	0f b6 11             	movzbl (%ecx),%edx
  800c41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c44:	89 f3                	mov    %esi,%ebx
  800c46:	80 fb 09             	cmp    $0x9,%bl
  800c49:	77 d5                	ja     800c20 <strtol+0x7c>
			dig = *s - '0';
  800c4b:	0f be d2             	movsbl %dl,%edx
  800c4e:	83 ea 30             	sub    $0x30,%edx
  800c51:	eb dd                	jmp    800c30 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c53:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c56:	89 f3                	mov    %esi,%ebx
  800c58:	80 fb 19             	cmp    $0x19,%bl
  800c5b:	77 08                	ja     800c65 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c5d:	0f be d2             	movsbl %dl,%edx
  800c60:	83 ea 37             	sub    $0x37,%edx
  800c63:	eb cb                	jmp    800c30 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c69:	74 05                	je     800c70 <strtol+0xcc>
		*endptr = (char *) s;
  800c6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c70:	89 c2                	mov    %eax,%edx
  800c72:	f7 da                	neg    %edx
  800c74:	85 ff                	test   %edi,%edi
  800c76:	0f 45 c2             	cmovne %edx,%eax
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8f:	89 c3                	mov    %eax,%ebx
  800c91:	89 c7                	mov    %eax,%edi
  800c93:	89 c6                	mov    %eax,%esi
  800c95:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cac:	89 d1                	mov    %edx,%ecx
  800cae:	89 d3                	mov    %edx,%ebx
  800cb0:	89 d7                	mov    %edx,%edi
  800cb2:	89 d6                	mov    %edx,%esi
  800cb4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
  800cc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd1:	89 cb                	mov    %ecx,%ebx
  800cd3:	89 cf                	mov    %ecx,%edi
  800cd5:	89 ce                	mov    %ecx,%esi
  800cd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7f 08                	jg     800ce5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	83 ec 0c             	sub    $0xc,%esp
  800ce8:	50                   	push   %eax
  800ce9:	6a 03                	push   $0x3
  800ceb:	68 7f 2c 80 00       	push   $0x802c7f
  800cf0:	6a 23                	push   $0x23
  800cf2:	68 9c 2c 80 00       	push   $0x802c9c
  800cf7:	e8 95 f5 ff ff       	call   800291 <_panic>

00800cfc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d02:	ba 00 00 00 00       	mov    $0x0,%edx
  800d07:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0c:	89 d1                	mov    %edx,%ecx
  800d0e:	89 d3                	mov    %edx,%ebx
  800d10:	89 d7                	mov    %edx,%edi
  800d12:	89 d6                	mov    %edx,%esi
  800d14:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <sys_yield>:

void
sys_yield(void)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d21:	ba 00 00 00 00       	mov    $0x0,%edx
  800d26:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2b:	89 d1                	mov    %edx,%ecx
  800d2d:	89 d3                	mov    %edx,%ebx
  800d2f:	89 d7                	mov    %edx,%edi
  800d31:	89 d6                	mov    %edx,%esi
  800d33:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d43:	be 00 00 00 00       	mov    $0x0,%esi
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d56:	89 f7                	mov    %esi,%edi
  800d58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5a:	85 c0                	test   %eax,%eax
  800d5c:	7f 08                	jg     800d66 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d66:	83 ec 0c             	sub    $0xc,%esp
  800d69:	50                   	push   %eax
  800d6a:	6a 04                	push   $0x4
  800d6c:	68 7f 2c 80 00       	push   $0x802c7f
  800d71:	6a 23                	push   $0x23
  800d73:	68 9c 2c 80 00       	push   $0x802c9c
  800d78:	e8 14 f5 ff ff       	call   800291 <_panic>

00800d7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d94:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d97:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7f 08                	jg     800da8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	50                   	push   %eax
  800dac:	6a 05                	push   $0x5
  800dae:	68 7f 2c 80 00       	push   $0x802c7f
  800db3:	6a 23                	push   $0x23
  800db5:	68 9c 2c 80 00       	push   $0x802c9c
  800dba:	e8 d2 f4 ff ff       	call   800291 <_panic>

00800dbf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	b8 06 00 00 00       	mov    $0x6,%eax
  800dd8:	89 df                	mov    %ebx,%edi
  800dda:	89 de                	mov    %ebx,%esi
  800ddc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	7f 08                	jg     800dea <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	50                   	push   %eax
  800dee:	6a 06                	push   $0x6
  800df0:	68 7f 2c 80 00       	push   $0x802c7f
  800df5:	6a 23                	push   $0x23
  800df7:	68 9c 2c 80 00       	push   $0x802c9c
  800dfc:	e8 90 f4 ff ff       	call   800291 <_panic>

00800e01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e15:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1a:	89 df                	mov    %ebx,%edi
  800e1c:	89 de                	mov    %ebx,%esi
  800e1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e20:	85 c0                	test   %eax,%eax
  800e22:	7f 08                	jg     800e2c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	50                   	push   %eax
  800e30:	6a 08                	push   $0x8
  800e32:	68 7f 2c 80 00       	push   $0x802c7f
  800e37:	6a 23                	push   $0x23
  800e39:	68 9c 2c 80 00       	push   $0x802c9c
  800e3e:	e8 4e f4 ff ff       	call   800291 <_panic>

00800e43 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e57:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5c:	89 df                	mov    %ebx,%edi
  800e5e:	89 de                	mov    %ebx,%esi
  800e60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7f 08                	jg     800e6e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	50                   	push   %eax
  800e72:	6a 09                	push   $0x9
  800e74:	68 7f 2c 80 00       	push   $0x802c7f
  800e79:	6a 23                	push   $0x23
  800e7b:	68 9c 2c 80 00       	push   $0x802c9c
  800e80:	e8 0c f4 ff ff       	call   800291 <_panic>

00800e85 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e9e:	89 df                	mov    %ebx,%edi
  800ea0:	89 de                	mov    %ebx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 0a                	push   $0xa
  800eb6:	68 7f 2c 80 00       	push   $0x802c7f
  800ebb:	6a 23                	push   $0x23
  800ebd:	68 9c 2c 80 00       	push   $0x802c9c
  800ec2:	e8 ca f3 ff ff       	call   800291 <_panic>

00800ec7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed8:	be 00 00 00 00       	mov    $0x0,%esi
  800edd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
  800ef0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f00:	89 cb                	mov    %ecx,%ebx
  800f02:	89 cf                	mov    %ecx,%edi
  800f04:	89 ce                	mov    %ecx,%esi
  800f06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	7f 08                	jg     800f14 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	50                   	push   %eax
  800f18:	6a 0d                	push   $0xd
  800f1a:	68 7f 2c 80 00       	push   $0x802c7f
  800f1f:	6a 23                	push   $0x23
  800f21:	68 9c 2c 80 00       	push   $0x802c9c
  800f26:	e8 66 f3 ff ff       	call   800291 <_panic>

00800f2b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f31:	ba 00 00 00 00       	mov    $0x0,%edx
  800f36:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f3b:	89 d1                	mov    %edx,%ecx
  800f3d:	89 d3                	mov    %edx,%ebx
  800f3f:	89 d7                	mov    %edx,%edi
  800f41:	89 d6                	mov    %edx,%esi
  800f43:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f56:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800f58:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f5b:	89 d9                	mov    %ebx,%ecx
  800f5d:	c1 e9 16             	shr    $0x16,%ecx
  800f60:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800f67:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f6c:	f6 c1 01             	test   $0x1,%cl
  800f6f:	74 0c                	je     800f7d <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800f71:	89 d9                	mov    %ebx,%ecx
  800f73:	c1 e9 0c             	shr    $0xc,%ecx
  800f76:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800f7d:	f6 c2 02             	test   $0x2,%dl
  800f80:	0f 84 a3 00 00 00    	je     801029 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800f86:	89 da                	mov    %ebx,%edx
  800f88:	c1 ea 0c             	shr    $0xc,%edx
  800f8b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f92:	f6 c6 08             	test   $0x8,%dh
  800f95:	0f 84 b7 00 00 00    	je     801052 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800f9b:	e8 5c fd ff ff       	call   800cfc <sys_getenvid>
  800fa0:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	6a 07                	push   $0x7
  800fa7:	68 00 f0 7f 00       	push   $0x7ff000
  800fac:	50                   	push   %eax
  800fad:	e8 88 fd ff ff       	call   800d3a <sys_page_alloc>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	0f 88 bc 00 00 00    	js     801079 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800fbd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800fc3:	83 ec 04             	sub    $0x4,%esp
  800fc6:	68 00 10 00 00       	push   $0x1000
  800fcb:	53                   	push   %ebx
  800fcc:	68 00 f0 7f 00       	push   $0x7ff000
  800fd1:	e8 00 fb ff ff       	call   800ad6 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800fd6:	83 c4 08             	add    $0x8,%esp
  800fd9:	53                   	push   %ebx
  800fda:	56                   	push   %esi
  800fdb:	e8 df fd ff ff       	call   800dbf <sys_page_unmap>
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	0f 88 a0 00 00 00    	js     80108b <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800feb:	83 ec 0c             	sub    $0xc,%esp
  800fee:	6a 07                	push   $0x7
  800ff0:	53                   	push   %ebx
  800ff1:	56                   	push   %esi
  800ff2:	68 00 f0 7f 00       	push   $0x7ff000
  800ff7:	56                   	push   %esi
  800ff8:	e8 80 fd ff ff       	call   800d7d <sys_page_map>
  800ffd:	83 c4 20             	add    $0x20,%esp
  801000:	85 c0                	test   %eax,%eax
  801002:	0f 88 95 00 00 00    	js     80109d <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801008:	83 ec 08             	sub    $0x8,%esp
  80100b:	68 00 f0 7f 00       	push   $0x7ff000
  801010:	56                   	push   %esi
  801011:	e8 a9 fd ff ff       	call   800dbf <sys_page_unmap>
  801016:	83 c4 10             	add    $0x10,%esp
  801019:	85 c0                	test   %eax,%eax
  80101b:	0f 88 8e 00 00 00    	js     8010af <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  801021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  801029:	8b 70 28             	mov    0x28(%eax),%esi
  80102c:	e8 cb fc ff ff       	call   800cfc <sys_getenvid>
  801031:	56                   	push   %esi
  801032:	53                   	push   %ebx
  801033:	50                   	push   %eax
  801034:	68 ac 2c 80 00       	push   $0x802cac
  801039:	e8 2e f3 ff ff       	call   80036c <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  80103e:	83 c4 0c             	add    $0xc,%esp
  801041:	68 d0 2c 80 00       	push   $0x802cd0
  801046:	6a 27                	push   $0x27
  801048:	68 a4 2d 80 00       	push   $0x802da4
  80104d:	e8 3f f2 ff ff       	call   800291 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  801052:	8b 78 28             	mov    0x28(%eax),%edi
  801055:	e8 a2 fc ff ff       	call   800cfc <sys_getenvid>
  80105a:	57                   	push   %edi
  80105b:	53                   	push   %ebx
  80105c:	50                   	push   %eax
  80105d:	68 ac 2c 80 00       	push   $0x802cac
  801062:	e8 05 f3 ff ff       	call   80036c <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801067:	56                   	push   %esi
  801068:	68 04 2d 80 00       	push   $0x802d04
  80106d:	6a 2b                	push   $0x2b
  80106f:	68 a4 2d 80 00       	push   $0x802da4
  801074:	e8 18 f2 ff ff       	call   800291 <_panic>
      panic("pgfault: page allocation failed %e", r);
  801079:	50                   	push   %eax
  80107a:	68 3c 2d 80 00       	push   $0x802d3c
  80107f:	6a 39                	push   $0x39
  801081:	68 a4 2d 80 00       	push   $0x802da4
  801086:	e8 06 f2 ff ff       	call   800291 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  80108b:	50                   	push   %eax
  80108c:	68 60 2d 80 00       	push   $0x802d60
  801091:	6a 3e                	push   $0x3e
  801093:	68 a4 2d 80 00       	push   $0x802da4
  801098:	e8 f4 f1 ff ff       	call   800291 <_panic>
      panic("pgfault: page map failed (%e)", r);
  80109d:	50                   	push   %eax
  80109e:	68 af 2d 80 00       	push   $0x802daf
  8010a3:	6a 40                	push   $0x40
  8010a5:	68 a4 2d 80 00       	push   $0x802da4
  8010aa:	e8 e2 f1 ff ff       	call   800291 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  8010af:	50                   	push   %eax
  8010b0:	68 60 2d 80 00       	push   $0x802d60
  8010b5:	6a 42                	push   $0x42
  8010b7:	68 a4 2d 80 00       	push   $0x802da4
  8010bc:	e8 d0 f1 ff ff       	call   800291 <_panic>

008010c1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	57                   	push   %edi
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
  8010c7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  8010ca:	68 4a 0f 80 00       	push   $0x800f4a
  8010cf:	e8 7e 13 00 00       	call   802452 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010d4:	b8 07 00 00 00       	mov    $0x7,%eax
  8010d9:	cd 30                	int    $0x30
  8010db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  8010de:	83 c4 10             	add    $0x10,%esp
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	78 2d                	js     801112 <fork+0x51>
  8010e5:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  8010ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010f0:	0f 85 a6 00 00 00    	jne    80119c <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  8010f6:	e8 01 fc ff ff       	call   800cfc <sys_getenvid>
  8010fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801108:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  80110d:	e9 79 01 00 00       	jmp    80128b <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  801112:	50                   	push   %eax
  801113:	68 ee 28 80 00       	push   $0x8028ee
  801118:	68 aa 00 00 00       	push   $0xaa
  80111d:	68 a4 2d 80 00       	push   $0x802da4
  801122:	e8 6a f1 ff ff       	call   800291 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  801127:	83 ec 0c             	sub    $0xc,%esp
  80112a:	6a 05                	push   $0x5
  80112c:	53                   	push   %ebx
  80112d:	57                   	push   %edi
  80112e:	53                   	push   %ebx
  80112f:	6a 00                	push   $0x0
  801131:	e8 47 fc ff ff       	call   800d7d <sys_page_map>
  801136:	83 c4 20             	add    $0x20,%esp
  801139:	85 c0                	test   %eax,%eax
  80113b:	79 4d                	jns    80118a <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80113d:	50                   	push   %eax
  80113e:	68 cd 2d 80 00       	push   $0x802dcd
  801143:	6a 61                	push   $0x61
  801145:	68 a4 2d 80 00       	push   $0x802da4
  80114a:	e8 42 f1 ff ff       	call   800291 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80114f:	83 ec 0c             	sub    $0xc,%esp
  801152:	68 05 08 00 00       	push   $0x805
  801157:	53                   	push   %ebx
  801158:	57                   	push   %edi
  801159:	53                   	push   %ebx
  80115a:	6a 00                	push   $0x0
  80115c:	e8 1c fc ff ff       	call   800d7d <sys_page_map>
  801161:	83 c4 20             	add    $0x20,%esp
  801164:	85 c0                	test   %eax,%eax
  801166:	0f 88 b7 00 00 00    	js     801223 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	68 05 08 00 00       	push   $0x805
  801174:	53                   	push   %ebx
  801175:	6a 00                	push   $0x0
  801177:	53                   	push   %ebx
  801178:	6a 00                	push   $0x0
  80117a:	e8 fe fb ff ff       	call   800d7d <sys_page_map>
  80117f:	83 c4 20             	add    $0x20,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	0f 88 ab 00 00 00    	js     801235 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80118a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801190:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801196:	0f 84 ab 00 00 00    	je     801247 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  80119c:	89 d8                	mov    %ebx,%eax
  80119e:	c1 e8 16             	shr    $0x16,%eax
  8011a1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011a8:	a8 01                	test   $0x1,%al
  8011aa:	74 de                	je     80118a <fork+0xc9>
  8011ac:	89 d8                	mov    %ebx,%eax
  8011ae:	c1 e8 0c             	shr    $0xc,%eax
  8011b1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011b8:	f6 c2 01             	test   $0x1,%dl
  8011bb:	74 cd                	je     80118a <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  8011bd:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	c1 ea 16             	shr    $0x16,%edx
  8011c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011cc:	f6 c2 01             	test   $0x1,%dl
  8011cf:	74 b9                	je     80118a <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  8011d1:	c1 e8 0c             	shr    $0xc,%eax
  8011d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  8011db:	a8 01                	test   $0x1,%al
  8011dd:	74 ab                	je     80118a <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  8011df:	a9 02 08 00 00       	test   $0x802,%eax
  8011e4:	0f 84 3d ff ff ff    	je     801127 <fork+0x66>
	else if(pte & PTE_SHARE)
  8011ea:	f6 c4 04             	test   $0x4,%ah
  8011ed:	0f 84 5c ff ff ff    	je     80114f <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8011fb:	50                   	push   %eax
  8011fc:	53                   	push   %ebx
  8011fd:	57                   	push   %edi
  8011fe:	53                   	push   %ebx
  8011ff:	6a 00                	push   $0x0
  801201:	e8 77 fb ff ff       	call   800d7d <sys_page_map>
  801206:	83 c4 20             	add    $0x20,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	0f 89 79 ff ff ff    	jns    80118a <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801211:	50                   	push   %eax
  801212:	68 cd 2d 80 00       	push   $0x802dcd
  801217:	6a 67                	push   $0x67
  801219:	68 a4 2d 80 00       	push   $0x802da4
  80121e:	e8 6e f0 ff ff       	call   800291 <_panic>
			panic("Page Map Failed: %e", error_code);
  801223:	50                   	push   %eax
  801224:	68 cd 2d 80 00       	push   $0x802dcd
  801229:	6a 6d                	push   $0x6d
  80122b:	68 a4 2d 80 00       	push   $0x802da4
  801230:	e8 5c f0 ff ff       	call   800291 <_panic>
			panic("Page Map Failed: %e", error_code);
  801235:	50                   	push   %eax
  801236:	68 cd 2d 80 00       	push   $0x802dcd
  80123b:	6a 70                	push   $0x70
  80123d:	68 a4 2d 80 00       	push   $0x802da4
  801242:	e8 4a f0 ff ff       	call   800291 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801247:	83 ec 04             	sub    $0x4,%esp
  80124a:	6a 07                	push   $0x7
  80124c:	68 00 f0 bf ee       	push   $0xeebff000
  801251:	ff 75 e4             	pushl  -0x1c(%ebp)
  801254:	e8 e1 fa ff ff       	call   800d3a <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 36                	js     801296 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	68 c8 24 80 00       	push   $0x8024c8
  801268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126b:	e8 15 fc ff ff       	call   800e85 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 34                	js     8012ab <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	6a 02                	push   $0x2
  80127c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80127f:	e8 7d fb ff ff       	call   800e01 <sys_env_set_status>
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 35                	js     8012c0 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  80128b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801296:	50                   	push   %eax
  801297:	68 ee 28 80 00       	push   $0x8028ee
  80129c:	68 ba 00 00 00       	push   $0xba
  8012a1:	68 a4 2d 80 00       	push   $0x802da4
  8012a6:	e8 e6 ef ff ff       	call   800291 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8012ab:	50                   	push   %eax
  8012ac:	68 80 2d 80 00       	push   $0x802d80
  8012b1:	68 bf 00 00 00       	push   $0xbf
  8012b6:	68 a4 2d 80 00       	push   $0x802da4
  8012bb:	e8 d1 ef ff ff       	call   800291 <_panic>
      panic("sys_env_set_status: %e", r);
  8012c0:	50                   	push   %eax
  8012c1:	68 e1 2d 80 00       	push   $0x802de1
  8012c6:	68 c3 00 00 00       	push   $0xc3
  8012cb:	68 a4 2d 80 00       	push   $0x802da4
  8012d0:	e8 bc ef ff ff       	call   800291 <_panic>

008012d5 <sfork>:

// Challenge!
int
sfork(void)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012db:	68 f8 2d 80 00       	push   $0x802df8
  8012e0:	68 cc 00 00 00       	push   $0xcc
  8012e5:	68 a4 2d 80 00       	push   $0x802da4
  8012ea:	e8 a2 ef ff ff       	call   800291 <_panic>

008012ef <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	05 00 00 00 30       	add    $0x30000000,%eax
  8012fa:	c1 e8 0c             	shr    $0xc,%eax
}
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80130a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80130f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80131e:	89 c2                	mov    %eax,%edx
  801320:	c1 ea 16             	shr    $0x16,%edx
  801323:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80132a:	f6 c2 01             	test   $0x1,%dl
  80132d:	74 2d                	je     80135c <fd_alloc+0x46>
  80132f:	89 c2                	mov    %eax,%edx
  801331:	c1 ea 0c             	shr    $0xc,%edx
  801334:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80133b:	f6 c2 01             	test   $0x1,%dl
  80133e:	74 1c                	je     80135c <fd_alloc+0x46>
  801340:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801345:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80134a:	75 d2                	jne    80131e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801355:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80135a:	eb 0a                	jmp    801366 <fd_alloc+0x50>
			*fd_store = fd;
  80135c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801361:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80136e:	83 f8 1f             	cmp    $0x1f,%eax
  801371:	77 30                	ja     8013a3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801373:	c1 e0 0c             	shl    $0xc,%eax
  801376:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80137b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801381:	f6 c2 01             	test   $0x1,%dl
  801384:	74 24                	je     8013aa <fd_lookup+0x42>
  801386:	89 c2                	mov    %eax,%edx
  801388:	c1 ea 0c             	shr    $0xc,%edx
  80138b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801392:	f6 c2 01             	test   $0x1,%dl
  801395:	74 1a                	je     8013b1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	89 02                	mov    %eax,(%edx)
	return 0;
  80139c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    
		return -E_INVAL;
  8013a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a8:	eb f7                	jmp    8013a1 <fd_lookup+0x39>
		return -E_INVAL;
  8013aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013af:	eb f0                	jmp    8013a1 <fd_lookup+0x39>
  8013b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b6:	eb e9                	jmp    8013a1 <fd_lookup+0x39>

008013b8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013cb:	39 08                	cmp    %ecx,(%eax)
  8013cd:	74 38                	je     801407 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8013cf:	83 c2 01             	add    $0x1,%edx
  8013d2:	8b 04 95 8c 2e 80 00 	mov    0x802e8c(,%edx,4),%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	75 ee                	jne    8013cb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8013e2:	8b 40 48             	mov    0x48(%eax),%eax
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	51                   	push   %ecx
  8013e9:	50                   	push   %eax
  8013ea:	68 10 2e 80 00       	push   $0x802e10
  8013ef:	e8 78 ef ff ff       	call   80036c <cprintf>
	*dev = 0;
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    
			*dev = devtab[i];
  801407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	eb f2                	jmp    801405 <dev_lookup+0x4d>

00801413 <fd_close>:
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	57                   	push   %edi
  801417:	56                   	push   %esi
  801418:	53                   	push   %ebx
  801419:	83 ec 24             	sub    $0x24,%esp
  80141c:	8b 75 08             	mov    0x8(%ebp),%esi
  80141f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801422:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801425:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801426:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80142c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80142f:	50                   	push   %eax
  801430:	e8 33 ff ff ff       	call   801368 <fd_lookup>
  801435:	89 c3                	mov    %eax,%ebx
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 05                	js     801443 <fd_close+0x30>
	    || fd != fd2)
  80143e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801441:	74 16                	je     801459 <fd_close+0x46>
		return (must_exist ? r : 0);
  801443:	89 f8                	mov    %edi,%eax
  801445:	84 c0                	test   %al,%al
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
  80144c:	0f 44 d8             	cmove  %eax,%ebx
}
  80144f:	89 d8                	mov    %ebx,%eax
  801451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801454:	5b                   	pop    %ebx
  801455:	5e                   	pop    %esi
  801456:	5f                   	pop    %edi
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80145f:	50                   	push   %eax
  801460:	ff 36                	pushl  (%esi)
  801462:	e8 51 ff ff ff       	call   8013b8 <dev_lookup>
  801467:	89 c3                	mov    %eax,%ebx
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 1a                	js     80148a <fd_close+0x77>
		if (dev->dev_close)
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801476:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80147b:	85 c0                	test   %eax,%eax
  80147d:	74 0b                	je     80148a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	56                   	push   %esi
  801483:	ff d0                	call   *%eax
  801485:	89 c3                	mov    %eax,%ebx
  801487:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	56                   	push   %esi
  80148e:	6a 00                	push   $0x0
  801490:	e8 2a f9 ff ff       	call   800dbf <sys_page_unmap>
	return r;
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	eb b5                	jmp    80144f <fd_close+0x3c>

0080149a <close>:

int
close(int fdnum)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 bc fe ff ff       	call   801368 <fd_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	79 02                	jns    8014b5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    
		return fd_close(fd, 1);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	6a 01                	push   $0x1
  8014ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8014bd:	e8 51 ff ff ff       	call   801413 <fd_close>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	eb ec                	jmp    8014b3 <close+0x19>

008014c7 <close_all>:

void
close_all(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ce:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	53                   	push   %ebx
  8014d7:	e8 be ff ff ff       	call   80149a <close>
	for (i = 0; i < MAXFD; i++)
  8014dc:	83 c3 01             	add    $0x1,%ebx
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	83 fb 20             	cmp    $0x20,%ebx
  8014e5:	75 ec                	jne    8014d3 <close_all+0xc>
}
  8014e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	57                   	push   %edi
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f8:	50                   	push   %eax
  8014f9:	ff 75 08             	pushl  0x8(%ebp)
  8014fc:	e8 67 fe ff ff       	call   801368 <fd_lookup>
  801501:	89 c3                	mov    %eax,%ebx
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	0f 88 81 00 00 00    	js     80158f <dup+0xa3>
		return r;
	close(newfdnum);
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	e8 81 ff ff ff       	call   80149a <close>

	newfd = INDEX2FD(newfdnum);
  801519:	8b 75 0c             	mov    0xc(%ebp),%esi
  80151c:	c1 e6 0c             	shl    $0xc,%esi
  80151f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801525:	83 c4 04             	add    $0x4,%esp
  801528:	ff 75 e4             	pushl  -0x1c(%ebp)
  80152b:	e8 cf fd ff ff       	call   8012ff <fd2data>
  801530:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801532:	89 34 24             	mov    %esi,(%esp)
  801535:	e8 c5 fd ff ff       	call   8012ff <fd2data>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80153f:	89 d8                	mov    %ebx,%eax
  801541:	c1 e8 16             	shr    $0x16,%eax
  801544:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80154b:	a8 01                	test   $0x1,%al
  80154d:	74 11                	je     801560 <dup+0x74>
  80154f:	89 d8                	mov    %ebx,%eax
  801551:	c1 e8 0c             	shr    $0xc,%eax
  801554:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80155b:	f6 c2 01             	test   $0x1,%dl
  80155e:	75 39                	jne    801599 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801563:	89 d0                	mov    %edx,%eax
  801565:	c1 e8 0c             	shr    $0xc,%eax
  801568:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80156f:	83 ec 0c             	sub    $0xc,%esp
  801572:	25 07 0e 00 00       	and    $0xe07,%eax
  801577:	50                   	push   %eax
  801578:	56                   	push   %esi
  801579:	6a 00                	push   $0x0
  80157b:	52                   	push   %edx
  80157c:	6a 00                	push   $0x0
  80157e:	e8 fa f7 ff ff       	call   800d7d <sys_page_map>
  801583:	89 c3                	mov    %eax,%ebx
  801585:	83 c4 20             	add    $0x20,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 31                	js     8015bd <dup+0xd1>
		goto err;

	return newfdnum;
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80158f:	89 d8                	mov    %ebx,%eax
  801591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801594:	5b                   	pop    %ebx
  801595:	5e                   	pop    %esi
  801596:	5f                   	pop    %edi
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801599:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a8:	50                   	push   %eax
  8015a9:	57                   	push   %edi
  8015aa:	6a 00                	push   $0x0
  8015ac:	53                   	push   %ebx
  8015ad:	6a 00                	push   $0x0
  8015af:	e8 c9 f7 ff ff       	call   800d7d <sys_page_map>
  8015b4:	89 c3                	mov    %eax,%ebx
  8015b6:	83 c4 20             	add    $0x20,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	79 a3                	jns    801560 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	56                   	push   %esi
  8015c1:	6a 00                	push   $0x0
  8015c3:	e8 f7 f7 ff ff       	call   800dbf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015c8:	83 c4 08             	add    $0x8,%esp
  8015cb:	57                   	push   %edi
  8015cc:	6a 00                	push   $0x0
  8015ce:	e8 ec f7 ff ff       	call   800dbf <sys_page_unmap>
	return r;
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	eb b7                	jmp    80158f <dup+0xa3>

008015d8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 1c             	sub    $0x1c,%esp
  8015df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e5:	50                   	push   %eax
  8015e6:	53                   	push   %ebx
  8015e7:	e8 7c fd ff ff       	call   801368 <fd_lookup>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 3f                	js     801632 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	ff 30                	pushl  (%eax)
  8015ff:	e8 b4 fd ff ff       	call   8013b8 <dev_lookup>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 27                	js     801632 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80160b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160e:	8b 42 08             	mov    0x8(%edx),%eax
  801611:	83 e0 03             	and    $0x3,%eax
  801614:	83 f8 01             	cmp    $0x1,%eax
  801617:	74 1e                	je     801637 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	8b 40 08             	mov    0x8(%eax),%eax
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 35                	je     801658 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	ff 75 10             	pushl  0x10(%ebp)
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	52                   	push   %edx
  80162d:	ff d0                	call   *%eax
  80162f:	83 c4 10             	add    $0x10,%esp
}
  801632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801635:	c9                   	leave  
  801636:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801637:	a1 08 40 80 00       	mov    0x804008,%eax
  80163c:	8b 40 48             	mov    0x48(%eax),%eax
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	53                   	push   %ebx
  801643:	50                   	push   %eax
  801644:	68 51 2e 80 00       	push   $0x802e51
  801649:	e8 1e ed ff ff       	call   80036c <cprintf>
		return -E_INVAL;
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801656:	eb da                	jmp    801632 <read+0x5a>
		return -E_NOT_SUPP;
  801658:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165d:	eb d3                	jmp    801632 <read+0x5a>

0080165f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	57                   	push   %edi
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	8b 7d 08             	mov    0x8(%ebp),%edi
  80166b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801673:	39 f3                	cmp    %esi,%ebx
  801675:	73 23                	jae    80169a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	89 f0                	mov    %esi,%eax
  80167c:	29 d8                	sub    %ebx,%eax
  80167e:	50                   	push   %eax
  80167f:	89 d8                	mov    %ebx,%eax
  801681:	03 45 0c             	add    0xc(%ebp),%eax
  801684:	50                   	push   %eax
  801685:	57                   	push   %edi
  801686:	e8 4d ff ff ff       	call   8015d8 <read>
		if (m < 0)
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 06                	js     801698 <readn+0x39>
			return m;
		if (m == 0)
  801692:	74 06                	je     80169a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801694:	01 c3                	add    %eax,%ebx
  801696:	eb db                	jmp    801673 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801698:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80169a:	89 d8                	mov    %ebx,%eax
  80169c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5f                   	pop    %edi
  8016a2:	5d                   	pop    %ebp
  8016a3:	c3                   	ret    

008016a4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 1c             	sub    $0x1c,%esp
  8016ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	53                   	push   %ebx
  8016b3:	e8 b0 fc ff ff       	call   801368 <fd_lookup>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 3a                	js     8016f9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c5:	50                   	push   %eax
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	ff 30                	pushl  (%eax)
  8016cb:	e8 e8 fc ff ff       	call   8013b8 <dev_lookup>
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 22                	js     8016f9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016de:	74 1e                	je     8016fe <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e3:	8b 52 0c             	mov    0xc(%edx),%edx
  8016e6:	85 d2                	test   %edx,%edx
  8016e8:	74 35                	je     80171f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	ff 75 10             	pushl  0x10(%ebp)
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	50                   	push   %eax
  8016f4:	ff d2                	call   *%edx
  8016f6:	83 c4 10             	add    $0x10,%esp
}
  8016f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016fe:	a1 08 40 80 00       	mov    0x804008,%eax
  801703:	8b 40 48             	mov    0x48(%eax),%eax
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	53                   	push   %ebx
  80170a:	50                   	push   %eax
  80170b:	68 6d 2e 80 00       	push   $0x802e6d
  801710:	e8 57 ec ff ff       	call   80036c <cprintf>
		return -E_INVAL;
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171d:	eb da                	jmp    8016f9 <write+0x55>
		return -E_NOT_SUPP;
  80171f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801724:	eb d3                	jmp    8016f9 <write+0x55>

00801726 <seek>:

int
seek(int fdnum, off_t offset)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80172c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172f:	50                   	push   %eax
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	e8 30 fc ff ff       	call   801368 <fd_lookup>
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 0e                	js     80174d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	53                   	push   %ebx
  801753:	83 ec 1c             	sub    $0x1c,%esp
  801756:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801759:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80175c:	50                   	push   %eax
  80175d:	53                   	push   %ebx
  80175e:	e8 05 fc ff ff       	call   801368 <fd_lookup>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	78 37                	js     8017a1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176a:	83 ec 08             	sub    $0x8,%esp
  80176d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801770:	50                   	push   %eax
  801771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801774:	ff 30                	pushl  (%eax)
  801776:	e8 3d fc ff ff       	call   8013b8 <dev_lookup>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 1f                	js     8017a1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801789:	74 1b                	je     8017a6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80178b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178e:	8b 52 18             	mov    0x18(%edx),%edx
  801791:	85 d2                	test   %edx,%edx
  801793:	74 32                	je     8017c7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801795:	83 ec 08             	sub    $0x8,%esp
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	50                   	push   %eax
  80179c:	ff d2                	call   *%edx
  80179e:	83 c4 10             	add    $0x10,%esp
}
  8017a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017a6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017ab:	8b 40 48             	mov    0x48(%eax),%eax
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	53                   	push   %ebx
  8017b2:	50                   	push   %eax
  8017b3:	68 30 2e 80 00       	push   $0x802e30
  8017b8:	e8 af eb ff ff       	call   80036c <cprintf>
		return -E_INVAL;
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c5:	eb da                	jmp    8017a1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cc:	eb d3                	jmp    8017a1 <ftruncate+0x52>

008017ce <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 1c             	sub    $0x1c,%esp
  8017d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017db:	50                   	push   %eax
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	e8 84 fb ff ff       	call   801368 <fd_lookup>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 4b                	js     801836 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f1:	50                   	push   %eax
  8017f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f5:	ff 30                	pushl  (%eax)
  8017f7:	e8 bc fb ff ff       	call   8013b8 <dev_lookup>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 33                	js     801836 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80180a:	74 2f                	je     80183b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80180c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80180f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801816:	00 00 00 
	stat->st_isdir = 0;
  801819:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801820:	00 00 00 
	stat->st_dev = dev;
  801823:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	53                   	push   %ebx
  80182d:	ff 75 f0             	pushl  -0x10(%ebp)
  801830:	ff 50 14             	call   *0x14(%eax)
  801833:	83 c4 10             	add    $0x10,%esp
}
  801836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801839:	c9                   	leave  
  80183a:	c3                   	ret    
		return -E_NOT_SUPP;
  80183b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801840:	eb f4                	jmp    801836 <fstat+0x68>

00801842 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	6a 00                	push   $0x0
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	e8 2f 02 00 00       	call   801a83 <open>
  801854:	89 c3                	mov    %eax,%ebx
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 1b                	js     801878 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	ff 75 0c             	pushl  0xc(%ebp)
  801863:	50                   	push   %eax
  801864:	e8 65 ff ff ff       	call   8017ce <fstat>
  801869:	89 c6                	mov    %eax,%esi
	close(fd);
  80186b:	89 1c 24             	mov    %ebx,(%esp)
  80186e:	e8 27 fc ff ff       	call   80149a <close>
	return r;
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	89 f3                	mov    %esi,%ebx
}
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5e                   	pop    %esi
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    

00801881 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
  801886:	89 c6                	mov    %eax,%esi
  801888:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80188a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801891:	74 27                	je     8018ba <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801893:	6a 07                	push   $0x7
  801895:	68 00 50 80 00       	push   $0x805000
  80189a:	56                   	push   %esi
  80189b:	ff 35 00 40 80 00    	pushl  0x804000
  8018a1:	e8 bc 0c 00 00       	call   802562 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a6:	83 c4 0c             	add    $0xc,%esp
  8018a9:	6a 00                	push   $0x0
  8018ab:	53                   	push   %ebx
  8018ac:	6a 00                	push   $0x0
  8018ae:	e8 3c 0c 00 00       	call   8024ef <ipc_recv>
}
  8018b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	6a 01                	push   $0x1
  8018bf:	e8 0a 0d 00 00       	call   8025ce <ipc_find_env>
  8018c4:	a3 00 40 80 00       	mov    %eax,0x804000
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	eb c5                	jmp    801893 <fsipc+0x12>

008018ce <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018da:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	b8 02 00 00 00       	mov    $0x2,%eax
  8018f1:	e8 8b ff ff ff       	call   801881 <fsipc>
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <devfile_flush>:
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8b 40 0c             	mov    0xc(%eax),%eax
  801904:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	b8 06 00 00 00       	mov    $0x6,%eax
  801913:	e8 69 ff ff ff       	call   801881 <fsipc>
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <devfile_stat>:
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	53                   	push   %ebx
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	8b 40 0c             	mov    0xc(%eax),%eax
  80192a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80192f:	ba 00 00 00 00       	mov    $0x0,%edx
  801934:	b8 05 00 00 00       	mov    $0x5,%eax
  801939:	e8 43 ff ff ff       	call   801881 <fsipc>
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 2c                	js     80196e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	68 00 50 80 00       	push   $0x805000
  80194a:	53                   	push   %ebx
  80194b:	e8 f8 ef ff ff       	call   800948 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801950:	a1 80 50 80 00       	mov    0x805080,%eax
  801955:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80195b:	a1 84 50 80 00       	mov    0x805084,%eax
  801960:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <devfile_write>:
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	53                   	push   %ebx
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80197d:	85 db                	test   %ebx,%ebx
  80197f:	75 07                	jne    801988 <devfile_write+0x15>
	return n_all;
  801981:	89 d8                	mov    %ebx,%eax
}
  801983:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801986:	c9                   	leave  
  801987:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8b 40 0c             	mov    0xc(%eax),%eax
  80198e:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801993:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	53                   	push   %ebx
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	68 08 50 80 00       	push   $0x805008
  8019a5:	e8 2c f1 ff ff       	call   800ad6 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 04 00 00 00       	mov    $0x4,%eax
  8019b4:	e8 c8 fe ff ff       	call   801881 <fsipc>
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 c3                	js     801983 <devfile_write+0x10>
	  assert(r <= n_left);
  8019c0:	39 d8                	cmp    %ebx,%eax
  8019c2:	77 0b                	ja     8019cf <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8019c4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019c9:	7f 1d                	jg     8019e8 <devfile_write+0x75>
    n_all += r;
  8019cb:	89 c3                	mov    %eax,%ebx
  8019cd:	eb b2                	jmp    801981 <devfile_write+0xe>
	  assert(r <= n_left);
  8019cf:	68 a0 2e 80 00       	push   $0x802ea0
  8019d4:	68 ac 2e 80 00       	push   $0x802eac
  8019d9:	68 9f 00 00 00       	push   $0x9f
  8019de:	68 c1 2e 80 00       	push   $0x802ec1
  8019e3:	e8 a9 e8 ff ff       	call   800291 <_panic>
	  assert(r <= PGSIZE);
  8019e8:	68 cc 2e 80 00       	push   $0x802ecc
  8019ed:	68 ac 2e 80 00       	push   $0x802eac
  8019f2:	68 a0 00 00 00       	push   $0xa0
  8019f7:	68 c1 2e 80 00       	push   $0x802ec1
  8019fc:	e8 90 e8 ff ff       	call   800291 <_panic>

00801a01 <devfile_read>:
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	56                   	push   %esi
  801a05:	53                   	push   %ebx
  801a06:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a14:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1f:	b8 03 00 00 00       	mov    $0x3,%eax
  801a24:	e8 58 fe ff ff       	call   801881 <fsipc>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 1f                	js     801a4e <devfile_read+0x4d>
	assert(r <= n);
  801a2f:	39 f0                	cmp    %esi,%eax
  801a31:	77 24                	ja     801a57 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a33:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a38:	7f 33                	jg     801a6d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	50                   	push   %eax
  801a3e:	68 00 50 80 00       	push   $0x805000
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	e8 8b f0 ff ff       	call   800ad6 <memmove>
	return r;
  801a4b:	83 c4 10             	add    $0x10,%esp
}
  801a4e:	89 d8                	mov    %ebx,%eax
  801a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    
	assert(r <= n);
  801a57:	68 d8 2e 80 00       	push   $0x802ed8
  801a5c:	68 ac 2e 80 00       	push   $0x802eac
  801a61:	6a 7c                	push   $0x7c
  801a63:	68 c1 2e 80 00       	push   $0x802ec1
  801a68:	e8 24 e8 ff ff       	call   800291 <_panic>
	assert(r <= PGSIZE);
  801a6d:	68 cc 2e 80 00       	push   $0x802ecc
  801a72:	68 ac 2e 80 00       	push   $0x802eac
  801a77:	6a 7d                	push   $0x7d
  801a79:	68 c1 2e 80 00       	push   $0x802ec1
  801a7e:	e8 0e e8 ff ff       	call   800291 <_panic>

00801a83 <open>:
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 1c             	sub    $0x1c,%esp
  801a8b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a8e:	56                   	push   %esi
  801a8f:	e8 7b ee ff ff       	call   80090f <strlen>
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a9c:	7f 6c                	jg     801b0a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a9e:	83 ec 0c             	sub    $0xc,%esp
  801aa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa4:	50                   	push   %eax
  801aa5:	e8 6c f8 ff ff       	call   801316 <fd_alloc>
  801aaa:	89 c3                	mov    %eax,%ebx
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 3c                	js     801aef <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	56                   	push   %esi
  801ab7:	68 00 50 80 00       	push   $0x805000
  801abc:	e8 87 ee ff ff       	call   800948 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801acc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad1:	e8 ab fd ff ff       	call   801881 <fsipc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 19                	js     801af8 <open+0x75>
	return fd2num(fd);
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae5:	e8 05 f8 ff ff       	call   8012ef <fd2num>
  801aea:	89 c3                	mov    %eax,%ebx
  801aec:	83 c4 10             	add    $0x10,%esp
}
  801aef:	89 d8                	mov    %ebx,%eax
  801af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
		fd_close(fd, 0);
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 f4             	pushl  -0xc(%ebp)
  801b00:	e8 0e f9 ff ff       	call   801413 <fd_close>
		return r;
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	eb e5                	jmp    801aef <open+0x6c>
		return -E_BAD_PATH;
  801b0a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b0f:	eb de                	jmp    801aef <open+0x6c>

00801b11 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b21:	e8 5b fd ff ff       	call   801881 <fsipc>
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b30:	83 ec 0c             	sub    $0xc,%esp
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	e8 c4 f7 ff ff       	call   8012ff <fd2data>
  801b3b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b3d:	83 c4 08             	add    $0x8,%esp
  801b40:	68 df 2e 80 00       	push   $0x802edf
  801b45:	53                   	push   %ebx
  801b46:	e8 fd ed ff ff       	call   800948 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b4b:	8b 46 04             	mov    0x4(%esi),%eax
  801b4e:	2b 06                	sub    (%esi),%eax
  801b50:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b5d:	00 00 00 
	stat->st_dev = &devpipe;
  801b60:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b67:	30 80 00 
	return 0;
}
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5d                   	pop    %ebp
  801b75:	c3                   	ret    

00801b76 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	53                   	push   %ebx
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b80:	53                   	push   %ebx
  801b81:	6a 00                	push   $0x0
  801b83:	e8 37 f2 ff ff       	call   800dbf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b88:	89 1c 24             	mov    %ebx,(%esp)
  801b8b:	e8 6f f7 ff ff       	call   8012ff <fd2data>
  801b90:	83 c4 08             	add    $0x8,%esp
  801b93:	50                   	push   %eax
  801b94:	6a 00                	push   $0x0
  801b96:	e8 24 f2 ff ff       	call   800dbf <sys_page_unmap>
}
  801b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <_pipeisclosed>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	57                   	push   %edi
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 1c             	sub    $0x1c,%esp
  801ba9:	89 c7                	mov    %eax,%edi
  801bab:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bad:	a1 08 40 80 00       	mov    0x804008,%eax
  801bb2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bb5:	83 ec 0c             	sub    $0xc,%esp
  801bb8:	57                   	push   %edi
  801bb9:	e8 49 0a 00 00       	call   802607 <pageref>
  801bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bc1:	89 34 24             	mov    %esi,(%esp)
  801bc4:	e8 3e 0a 00 00       	call   802607 <pageref>
		nn = thisenv->env_runs;
  801bc9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bcf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	39 cb                	cmp    %ecx,%ebx
  801bd7:	74 1b                	je     801bf4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bd9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bdc:	75 cf                	jne    801bad <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bde:	8b 42 58             	mov    0x58(%edx),%eax
  801be1:	6a 01                	push   $0x1
  801be3:	50                   	push   %eax
  801be4:	53                   	push   %ebx
  801be5:	68 e6 2e 80 00       	push   $0x802ee6
  801bea:	e8 7d e7 ff ff       	call   80036c <cprintf>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	eb b9                	jmp    801bad <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bf4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bf7:	0f 94 c0             	sete   %al
  801bfa:	0f b6 c0             	movzbl %al,%eax
}
  801bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <devpipe_write>:
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	57                   	push   %edi
  801c09:	56                   	push   %esi
  801c0a:	53                   	push   %ebx
  801c0b:	83 ec 28             	sub    $0x28,%esp
  801c0e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c11:	56                   	push   %esi
  801c12:	e8 e8 f6 ff ff       	call   8012ff <fd2data>
  801c17:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c21:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c24:	74 4f                	je     801c75 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c26:	8b 43 04             	mov    0x4(%ebx),%eax
  801c29:	8b 0b                	mov    (%ebx),%ecx
  801c2b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c2e:	39 d0                	cmp    %edx,%eax
  801c30:	72 14                	jb     801c46 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c32:	89 da                	mov    %ebx,%edx
  801c34:	89 f0                	mov    %esi,%eax
  801c36:	e8 65 ff ff ff       	call   801ba0 <_pipeisclosed>
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	75 3b                	jne    801c7a <devpipe_write+0x75>
			sys_yield();
  801c3f:	e8 d7 f0 ff ff       	call   800d1b <sys_yield>
  801c44:	eb e0                	jmp    801c26 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c49:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c4d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c50:	89 c2                	mov    %eax,%edx
  801c52:	c1 fa 1f             	sar    $0x1f,%edx
  801c55:	89 d1                	mov    %edx,%ecx
  801c57:	c1 e9 1b             	shr    $0x1b,%ecx
  801c5a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c5d:	83 e2 1f             	and    $0x1f,%edx
  801c60:	29 ca                	sub    %ecx,%edx
  801c62:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c66:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c6a:	83 c0 01             	add    $0x1,%eax
  801c6d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c70:	83 c7 01             	add    $0x1,%edi
  801c73:	eb ac                	jmp    801c21 <devpipe_write+0x1c>
	return i;
  801c75:	8b 45 10             	mov    0x10(%ebp),%eax
  801c78:	eb 05                	jmp    801c7f <devpipe_write+0x7a>
				return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c82:	5b                   	pop    %ebx
  801c83:	5e                   	pop    %esi
  801c84:	5f                   	pop    %edi
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <devpipe_read>:
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	57                   	push   %edi
  801c8b:	56                   	push   %esi
  801c8c:	53                   	push   %ebx
  801c8d:	83 ec 18             	sub    $0x18,%esp
  801c90:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c93:	57                   	push   %edi
  801c94:	e8 66 f6 ff ff       	call   8012ff <fd2data>
  801c99:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	be 00 00 00 00       	mov    $0x0,%esi
  801ca3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ca6:	75 14                	jne    801cbc <devpipe_read+0x35>
	return i;
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	eb 02                	jmp    801caf <devpipe_read+0x28>
				return i;
  801cad:	89 f0                	mov    %esi,%eax
}
  801caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
			sys_yield();
  801cb7:	e8 5f f0 ff ff       	call   800d1b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cbc:	8b 03                	mov    (%ebx),%eax
  801cbe:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cc1:	75 18                	jne    801cdb <devpipe_read+0x54>
			if (i > 0)
  801cc3:	85 f6                	test   %esi,%esi
  801cc5:	75 e6                	jne    801cad <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801cc7:	89 da                	mov    %ebx,%edx
  801cc9:	89 f8                	mov    %edi,%eax
  801ccb:	e8 d0 fe ff ff       	call   801ba0 <_pipeisclosed>
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 e3                	je     801cb7 <devpipe_read+0x30>
				return 0;
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd9:	eb d4                	jmp    801caf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cdb:	99                   	cltd   
  801cdc:	c1 ea 1b             	shr    $0x1b,%edx
  801cdf:	01 d0                	add    %edx,%eax
  801ce1:	83 e0 1f             	and    $0x1f,%eax
  801ce4:	29 d0                	sub    %edx,%eax
  801ce6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cee:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cf1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cf4:	83 c6 01             	add    $0x1,%esi
  801cf7:	eb aa                	jmp    801ca3 <devpipe_read+0x1c>

00801cf9 <pipe>:
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	56                   	push   %esi
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d04:	50                   	push   %eax
  801d05:	e8 0c f6 ff ff       	call   801316 <fd_alloc>
  801d0a:	89 c3                	mov    %eax,%ebx
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	0f 88 23 01 00 00    	js     801e3a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	68 07 04 00 00       	push   $0x407
  801d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d22:	6a 00                	push   $0x0
  801d24:	e8 11 f0 ff ff       	call   800d3a <sys_page_alloc>
  801d29:	89 c3                	mov    %eax,%ebx
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	0f 88 04 01 00 00    	js     801e3a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3c:	50                   	push   %eax
  801d3d:	e8 d4 f5 ff ff       	call   801316 <fd_alloc>
  801d42:	89 c3                	mov    %eax,%ebx
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	85 c0                	test   %eax,%eax
  801d49:	0f 88 db 00 00 00    	js     801e2a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d4f:	83 ec 04             	sub    $0x4,%esp
  801d52:	68 07 04 00 00       	push   $0x407
  801d57:	ff 75 f0             	pushl  -0x10(%ebp)
  801d5a:	6a 00                	push   $0x0
  801d5c:	e8 d9 ef ff ff       	call   800d3a <sys_page_alloc>
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	85 c0                	test   %eax,%eax
  801d68:	0f 88 bc 00 00 00    	js     801e2a <pipe+0x131>
	va = fd2data(fd0);
  801d6e:	83 ec 0c             	sub    $0xc,%esp
  801d71:	ff 75 f4             	pushl  -0xc(%ebp)
  801d74:	e8 86 f5 ff ff       	call   8012ff <fd2data>
  801d79:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7b:	83 c4 0c             	add    $0xc,%esp
  801d7e:	68 07 04 00 00       	push   $0x407
  801d83:	50                   	push   %eax
  801d84:	6a 00                	push   $0x0
  801d86:	e8 af ef ff ff       	call   800d3a <sys_page_alloc>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	85 c0                	test   %eax,%eax
  801d92:	0f 88 82 00 00 00    	js     801e1a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9e:	e8 5c f5 ff ff       	call   8012ff <fd2data>
  801da3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801daa:	50                   	push   %eax
  801dab:	6a 00                	push   $0x0
  801dad:	56                   	push   %esi
  801dae:	6a 00                	push   $0x0
  801db0:	e8 c8 ef ff ff       	call   800d7d <sys_page_map>
  801db5:	89 c3                	mov    %eax,%ebx
  801db7:	83 c4 20             	add    $0x20,%esp
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 4e                	js     801e0c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801dbe:	a1 20 30 80 00       	mov    0x803020,%eax
  801dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801de1:	83 ec 0c             	sub    $0xc,%esp
  801de4:	ff 75 f4             	pushl  -0xc(%ebp)
  801de7:	e8 03 f5 ff ff       	call   8012ef <fd2num>
  801dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801def:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801df1:	83 c4 04             	add    $0x4,%esp
  801df4:	ff 75 f0             	pushl  -0x10(%ebp)
  801df7:	e8 f3 f4 ff ff       	call   8012ef <fd2num>
  801dfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dff:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e0a:	eb 2e                	jmp    801e3a <pipe+0x141>
	sys_page_unmap(0, va);
  801e0c:	83 ec 08             	sub    $0x8,%esp
  801e0f:	56                   	push   %esi
  801e10:	6a 00                	push   $0x0
  801e12:	e8 a8 ef ff ff       	call   800dbf <sys_page_unmap>
  801e17:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e1a:	83 ec 08             	sub    $0x8,%esp
  801e1d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e20:	6a 00                	push   $0x0
  801e22:	e8 98 ef ff ff       	call   800dbf <sys_page_unmap>
  801e27:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e30:	6a 00                	push   $0x0
  801e32:	e8 88 ef ff ff       	call   800dbf <sys_page_unmap>
  801e37:	83 c4 10             	add    $0x10,%esp
}
  801e3a:	89 d8                	mov    %ebx,%eax
  801e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <pipeisclosed>:
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4c:	50                   	push   %eax
  801e4d:	ff 75 08             	pushl  0x8(%ebp)
  801e50:	e8 13 f5 ff ff       	call   801368 <fd_lookup>
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	78 18                	js     801e74 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e62:	e8 98 f4 ff ff       	call   8012ff <fd2data>
	return _pipeisclosed(fd, p);
  801e67:	89 c2                	mov    %eax,%edx
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	e8 2f fd ff ff       	call   801ba0 <_pipeisclosed>
  801e71:	83 c4 10             	add    $0x10,%esp
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e7c:	68 f9 2e 80 00       	push   $0x802ef9
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	e8 bf ea ff ff       	call   800948 <strcpy>
	return 0;
}
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <devsock_close>:
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	53                   	push   %ebx
  801e94:	83 ec 10             	sub    $0x10,%esp
  801e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e9a:	53                   	push   %ebx
  801e9b:	e8 67 07 00 00       	call   802607 <pageref>
  801ea0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ea3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ea8:	83 f8 01             	cmp    $0x1,%eax
  801eab:	74 07                	je     801eb4 <devsock_close+0x24>
}
  801ead:	89 d0                	mov    %edx,%eax
  801eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	ff 73 0c             	pushl  0xc(%ebx)
  801eba:	e8 b9 02 00 00       	call   802178 <nsipc_close>
  801ebf:	89 c2                	mov    %eax,%edx
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	eb e7                	jmp    801ead <devsock_close+0x1d>

00801ec6 <devsock_write>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 10             	pushl  0x10(%ebp)
  801ed1:	ff 75 0c             	pushl  0xc(%ebp)
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	ff 70 0c             	pushl  0xc(%eax)
  801eda:	e8 76 03 00 00       	call   802255 <nsipc_send>
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <devsock_read>:
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	ff 75 10             	pushl  0x10(%ebp)
  801eec:	ff 75 0c             	pushl  0xc(%ebp)
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	ff 70 0c             	pushl  0xc(%eax)
  801ef5:	e8 ef 02 00 00       	call   8021e9 <nsipc_recv>
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <fd2sockid>:
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f02:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f05:	52                   	push   %edx
  801f06:	50                   	push   %eax
  801f07:	e8 5c f4 ff ff       	call   801368 <fd_lookup>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 10                	js     801f23 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801f1c:	39 08                	cmp    %ecx,(%eax)
  801f1e:	75 05                	jne    801f25 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f20:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    
		return -E_NOT_SUPP;
  801f25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f2a:	eb f7                	jmp    801f23 <fd2sockid+0x27>

00801f2c <alloc_sockfd>:
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	56                   	push   %esi
  801f30:	53                   	push   %ebx
  801f31:	83 ec 1c             	sub    $0x1c,%esp
  801f34:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f39:	50                   	push   %eax
  801f3a:	e8 d7 f3 ff ff       	call   801316 <fd_alloc>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 43                	js     801f8b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	68 07 04 00 00       	push   $0x407
  801f50:	ff 75 f4             	pushl  -0xc(%ebp)
  801f53:	6a 00                	push   $0x0
  801f55:	e8 e0 ed ff ff       	call   800d3a <sys_page_alloc>
  801f5a:	89 c3                	mov    %eax,%ebx
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 28                	js     801f8b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f78:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	50                   	push   %eax
  801f7f:	e8 6b f3 ff ff       	call   8012ef <fd2num>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	eb 0c                	jmp    801f97 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f8b:	83 ec 0c             	sub    $0xc,%esp
  801f8e:	56                   	push   %esi
  801f8f:	e8 e4 01 00 00       	call   802178 <nsipc_close>
		return r;
  801f94:	83 c4 10             	add    $0x10,%esp
}
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    

00801fa0 <accept>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	e8 4e ff ff ff       	call   801efc <fd2sockid>
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 1b                	js     801fcd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	ff 75 10             	pushl  0x10(%ebp)
  801fb8:	ff 75 0c             	pushl  0xc(%ebp)
  801fbb:	50                   	push   %eax
  801fbc:	e8 0e 01 00 00       	call   8020cf <nsipc_accept>
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	78 05                	js     801fcd <accept+0x2d>
	return alloc_sockfd(r);
  801fc8:	e8 5f ff ff ff       	call   801f2c <alloc_sockfd>
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <bind>:
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	e8 1f ff ff ff       	call   801efc <fd2sockid>
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 12                	js     801ff3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	ff 75 10             	pushl  0x10(%ebp)
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	50                   	push   %eax
  801feb:	e8 31 01 00 00       	call   802121 <nsipc_bind>
  801ff0:	83 c4 10             	add    $0x10,%esp
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <shutdown>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	e8 f9 fe ff ff       	call   801efc <fd2sockid>
  802003:	85 c0                	test   %eax,%eax
  802005:	78 0f                	js     802016 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	50                   	push   %eax
  80200e:	e8 43 01 00 00       	call   802156 <nsipc_shutdown>
  802013:	83 c4 10             	add    $0x10,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <connect>:
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	e8 d6 fe ff ff       	call   801efc <fd2sockid>
  802026:	85 c0                	test   %eax,%eax
  802028:	78 12                	js     80203c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	ff 75 10             	pushl  0x10(%ebp)
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	e8 59 01 00 00       	call   802192 <nsipc_connect>
  802039:	83 c4 10             	add    $0x10,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <listen>:
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	e8 b0 fe ff ff       	call   801efc <fd2sockid>
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 0f                	js     80205f <listen+0x21>
	return nsipc_listen(r, backlog);
  802050:	83 ec 08             	sub    $0x8,%esp
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	50                   	push   %eax
  802057:	e8 6b 01 00 00       	call   8021c7 <nsipc_listen>
  80205c:	83 c4 10             	add    $0x10,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <socket>:

int
socket(int domain, int type, int protocol)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802067:	ff 75 10             	pushl  0x10(%ebp)
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	e8 3e 02 00 00       	call   8022b3 <nsipc_socket>
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	85 c0                	test   %eax,%eax
  80207a:	78 05                	js     802081 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80207c:	e8 ab fe ff ff       	call   801f2c <alloc_sockfd>
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	53                   	push   %ebx
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80208c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  802093:	74 26                	je     8020bb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802095:	6a 07                	push   $0x7
  802097:	68 00 60 80 00       	push   $0x806000
  80209c:	53                   	push   %ebx
  80209d:	ff 35 04 40 80 00    	pushl  0x804004
  8020a3:	e8 ba 04 00 00       	call   802562 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020a8:	83 c4 0c             	add    $0xc,%esp
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	e8 39 04 00 00       	call   8024ef <ipc_recv>
}
  8020b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020bb:	83 ec 0c             	sub    $0xc,%esp
  8020be:	6a 02                	push   $0x2
  8020c0:	e8 09 05 00 00       	call   8025ce <ipc_find_env>
  8020c5:	a3 04 40 80 00       	mov    %eax,0x804004
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	eb c6                	jmp    802095 <nsipc+0x12>

008020cf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	56                   	push   %esi
  8020d3:	53                   	push   %ebx
  8020d4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020df:	8b 06                	mov    (%esi),%eax
  8020e1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020eb:	e8 93 ff ff ff       	call   802083 <nsipc>
  8020f0:	89 c3                	mov    %eax,%ebx
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	79 09                	jns    8020ff <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020f6:	89 d8                	mov    %ebx,%eax
  8020f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020ff:	83 ec 04             	sub    $0x4,%esp
  802102:	ff 35 10 60 80 00    	pushl  0x806010
  802108:	68 00 60 80 00       	push   $0x806000
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	e8 c1 e9 ff ff       	call   800ad6 <memmove>
		*addrlen = ret->ret_addrlen;
  802115:	a1 10 60 80 00       	mov    0x806010,%eax
  80211a:	89 06                	mov    %eax,(%esi)
  80211c:	83 c4 10             	add    $0x10,%esp
	return r;
  80211f:	eb d5                	jmp    8020f6 <nsipc_accept+0x27>

00802121 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	53                   	push   %ebx
  802125:	83 ec 08             	sub    $0x8,%esp
  802128:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802133:	53                   	push   %ebx
  802134:	ff 75 0c             	pushl  0xc(%ebp)
  802137:	68 04 60 80 00       	push   $0x806004
  80213c:	e8 95 e9 ff ff       	call   800ad6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802141:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802147:	b8 02 00 00 00       	mov    $0x2,%eax
  80214c:	e8 32 ff ff ff       	call   802083 <nsipc>
}
  802151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80216c:	b8 03 00 00 00       	mov    $0x3,%eax
  802171:	e8 0d ff ff ff       	call   802083 <nsipc>
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <nsipc_close>:

int
nsipc_close(int s)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802186:	b8 04 00 00 00       	mov    $0x4,%eax
  80218b:	e8 f3 fe ff ff       	call   802083 <nsipc>
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	53                   	push   %ebx
  802196:	83 ec 08             	sub    $0x8,%esp
  802199:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021a4:	53                   	push   %ebx
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	68 04 60 80 00       	push   $0x806004
  8021ad:	e8 24 e9 ff ff       	call   800ad6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021b2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8021b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8021bd:	e8 c1 fe ff ff       	call   802083 <nsipc>
}
  8021c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8021dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8021e2:	e8 9c fe ff ff       	call   802083 <nsipc>
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	56                   	push   %esi
  8021ed:	53                   	push   %ebx
  8021ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8021f9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8021ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802202:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802207:	b8 07 00 00 00       	mov    $0x7,%eax
  80220c:	e8 72 fe ff ff       	call   802083 <nsipc>
  802211:	89 c3                	mov    %eax,%ebx
  802213:	85 c0                	test   %eax,%eax
  802215:	78 1f                	js     802236 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802217:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80221c:	7f 21                	jg     80223f <nsipc_recv+0x56>
  80221e:	39 c6                	cmp    %eax,%esi
  802220:	7c 1d                	jl     80223f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	50                   	push   %eax
  802226:	68 00 60 80 00       	push   $0x806000
  80222b:	ff 75 0c             	pushl  0xc(%ebp)
  80222e:	e8 a3 e8 ff ff       	call   800ad6 <memmove>
  802233:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802236:	89 d8                	mov    %ebx,%eax
  802238:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5d                   	pop    %ebp
  80223e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80223f:	68 05 2f 80 00       	push   $0x802f05
  802244:	68 ac 2e 80 00       	push   $0x802eac
  802249:	6a 62                	push   $0x62
  80224b:	68 1a 2f 80 00       	push   $0x802f1a
  802250:	e8 3c e0 ff ff       	call   800291 <_panic>

00802255 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	53                   	push   %ebx
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802267:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80226d:	7f 2e                	jg     80229d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	53                   	push   %ebx
  802273:	ff 75 0c             	pushl  0xc(%ebp)
  802276:	68 0c 60 80 00       	push   $0x80600c
  80227b:	e8 56 e8 ff ff       	call   800ad6 <memmove>
	nsipcbuf.send.req_size = size;
  802280:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802286:	8b 45 14             	mov    0x14(%ebp),%eax
  802289:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80228e:	b8 08 00 00 00       	mov    $0x8,%eax
  802293:	e8 eb fd ff ff       	call   802083 <nsipc>
}
  802298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    
	assert(size < 1600);
  80229d:	68 26 2f 80 00       	push   $0x802f26
  8022a2:	68 ac 2e 80 00       	push   $0x802eac
  8022a7:	6a 6d                	push   $0x6d
  8022a9:	68 1a 2f 80 00       	push   $0x802f1a
  8022ae:	e8 de df ff ff       	call   800291 <_panic>

008022b3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022d1:	b8 09 00 00 00       	mov    $0x9,%eax
  8022d6:	e8 a8 fd ff ff       	call   802083 <nsipc>
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e2:	c3                   	ret    

008022e3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022e9:	68 32 2f 80 00       	push   $0x802f32
  8022ee:	ff 75 0c             	pushl  0xc(%ebp)
  8022f1:	e8 52 e6 ff ff       	call   800948 <strcpy>
	return 0;
}
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <devcons_write>:
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	57                   	push   %edi
  802301:	56                   	push   %esi
  802302:	53                   	push   %ebx
  802303:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802309:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80230e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802314:	3b 75 10             	cmp    0x10(%ebp),%esi
  802317:	73 31                	jae    80234a <devcons_write+0x4d>
		m = n - tot;
  802319:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80231c:	29 f3                	sub    %esi,%ebx
  80231e:	83 fb 7f             	cmp    $0x7f,%ebx
  802321:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802326:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	53                   	push   %ebx
  80232d:	89 f0                	mov    %esi,%eax
  80232f:	03 45 0c             	add    0xc(%ebp),%eax
  802332:	50                   	push   %eax
  802333:	57                   	push   %edi
  802334:	e8 9d e7 ff ff       	call   800ad6 <memmove>
		sys_cputs(buf, m);
  802339:	83 c4 08             	add    $0x8,%esp
  80233c:	53                   	push   %ebx
  80233d:	57                   	push   %edi
  80233e:	e8 3b e9 ff ff       	call   800c7e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802343:	01 de                	add    %ebx,%esi
  802345:	83 c4 10             	add    $0x10,%esp
  802348:	eb ca                	jmp    802314 <devcons_write+0x17>
}
  80234a:	89 f0                	mov    %esi,%eax
  80234c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80234f:	5b                   	pop    %ebx
  802350:	5e                   	pop    %esi
  802351:	5f                   	pop    %edi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    

00802354 <devcons_read>:
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 08             	sub    $0x8,%esp
  80235a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80235f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802363:	74 21                	je     802386 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802365:	e8 32 e9 ff ff       	call   800c9c <sys_cgetc>
  80236a:	85 c0                	test   %eax,%eax
  80236c:	75 07                	jne    802375 <devcons_read+0x21>
		sys_yield();
  80236e:	e8 a8 e9 ff ff       	call   800d1b <sys_yield>
  802373:	eb f0                	jmp    802365 <devcons_read+0x11>
	if (c < 0)
  802375:	78 0f                	js     802386 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802377:	83 f8 04             	cmp    $0x4,%eax
  80237a:	74 0c                	je     802388 <devcons_read+0x34>
	*(char*)vbuf = c;
  80237c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237f:	88 02                	mov    %al,(%edx)
	return 1;
  802381:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    
		return 0;
  802388:	b8 00 00 00 00       	mov    $0x0,%eax
  80238d:	eb f7                	jmp    802386 <devcons_read+0x32>

0080238f <cputchar>:
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80239b:	6a 01                	push   $0x1
  80239d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a0:	50                   	push   %eax
  8023a1:	e8 d8 e8 ff ff       	call   800c7e <sys_cputs>
}
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <getchar>:
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023b1:	6a 01                	push   $0x1
  8023b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023b6:	50                   	push   %eax
  8023b7:	6a 00                	push   $0x0
  8023b9:	e8 1a f2 ff ff       	call   8015d8 <read>
	if (r < 0)
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	78 06                	js     8023cb <getchar+0x20>
	if (r < 1)
  8023c5:	74 06                	je     8023cd <getchar+0x22>
	return c;
  8023c7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
		return -E_EOF;
  8023cd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023d2:	eb f7                	jmp    8023cb <getchar+0x20>

008023d4 <iscons>:
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023dd:	50                   	push   %eax
  8023de:	ff 75 08             	pushl  0x8(%ebp)
  8023e1:	e8 82 ef ff ff       	call   801368 <fd_lookup>
  8023e6:	83 c4 10             	add    $0x10,%esp
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	78 11                	js     8023fe <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023f6:	39 10                	cmp    %edx,(%eax)
  8023f8:	0f 94 c0             	sete   %al
  8023fb:	0f b6 c0             	movzbl %al,%eax
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <opencons>:
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802406:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802409:	50                   	push   %eax
  80240a:	e8 07 ef ff ff       	call   801316 <fd_alloc>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	85 c0                	test   %eax,%eax
  802414:	78 3a                	js     802450 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802416:	83 ec 04             	sub    $0x4,%esp
  802419:	68 07 04 00 00       	push   $0x407
  80241e:	ff 75 f4             	pushl  -0xc(%ebp)
  802421:	6a 00                	push   $0x0
  802423:	e8 12 e9 ff ff       	call   800d3a <sys_page_alloc>
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	85 c0                	test   %eax,%eax
  80242d:	78 21                	js     802450 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802438:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	50                   	push   %eax
  802448:	e8 a2 ee ff ff       	call   8012ef <fd2num>
  80244d:	83 c4 10             	add    $0x10,%esp
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802458:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80245f:	74 0a                	je     80246b <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80246b:	a1 08 40 80 00       	mov    0x804008,%eax
  802470:	8b 40 48             	mov    0x48(%eax),%eax
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	6a 07                	push   $0x7
  802478:	68 00 f0 bf ee       	push   $0xeebff000
  80247d:	50                   	push   %eax
  80247e:	e8 b7 e8 ff ff       	call   800d3a <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	85 c0                	test   %eax,%eax
  802488:	78 2c                	js     8024b6 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80248a:	e8 6d e8 ff ff       	call   800cfc <sys_getenvid>
  80248f:	83 ec 08             	sub    $0x8,%esp
  802492:	68 c8 24 80 00       	push   $0x8024c8
  802497:	50                   	push   %eax
  802498:	e8 e8 e9 ff ff       	call   800e85 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80249d:	83 c4 10             	add    $0x10,%esp
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	79 bd                	jns    802461 <set_pgfault_handler+0xf>
  8024a4:	50                   	push   %eax
  8024a5:	68 3e 2f 80 00       	push   $0x802f3e
  8024aa:	6a 23                	push   $0x23
  8024ac:	68 56 2f 80 00       	push   $0x802f56
  8024b1:	e8 db dd ff ff       	call   800291 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8024b6:	50                   	push   %eax
  8024b7:	68 3e 2f 80 00       	push   $0x802f3e
  8024bc:	6a 21                	push   $0x21
  8024be:	68 56 2f 80 00       	push   $0x802f56
  8024c3:	e8 c9 dd ff ff       	call   800291 <_panic>

008024c8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024c8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024c9:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024ce:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024d0:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8024d3:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8024d7:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8024da:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8024de:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8024e2:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8024e5:	83 c4 08             	add    $0x8,%esp
	popal
  8024e8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8024e9:	83 c4 04             	add    $0x4,%esp
	popfl
  8024ec:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8024ed:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8024ee:	c3                   	ret    

008024ef <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8024f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 4f                	je     802550 <ipc_recv+0x61>
  802501:	83 ec 0c             	sub    $0xc,%esp
  802504:	50                   	push   %eax
  802505:	e8 e0 e9 ff ff       	call   800eea <sys_ipc_recv>
  80250a:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  80250d:	85 f6                	test   %esi,%esi
  80250f:	74 14                	je     802525 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802511:	ba 00 00 00 00       	mov    $0x0,%edx
  802516:	85 c0                	test   %eax,%eax
  802518:	75 09                	jne    802523 <ipc_recv+0x34>
  80251a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802520:	8b 52 74             	mov    0x74(%edx),%edx
  802523:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802525:	85 db                	test   %ebx,%ebx
  802527:	74 14                	je     80253d <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802529:	ba 00 00 00 00       	mov    $0x0,%edx
  80252e:	85 c0                	test   %eax,%eax
  802530:	75 09                	jne    80253b <ipc_recv+0x4c>
  802532:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802538:	8b 52 78             	mov    0x78(%edx),%edx
  80253b:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80253d:	85 c0                	test   %eax,%eax
  80253f:	75 08                	jne    802549 <ipc_recv+0x5a>
  802541:	a1 08 40 80 00       	mov    0x804008,%eax
  802546:	8b 40 70             	mov    0x70(%eax),%eax
}
  802549:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802550:	83 ec 0c             	sub    $0xc,%esp
  802553:	68 00 00 c0 ee       	push   $0xeec00000
  802558:	e8 8d e9 ff ff       	call   800eea <sys_ipc_recv>
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	eb ab                	jmp    80250d <ipc_recv+0x1e>

00802562 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	57                   	push   %edi
  802566:	56                   	push   %esi
  802567:	53                   	push   %ebx
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80256e:	8b 75 10             	mov    0x10(%ebp),%esi
  802571:	eb 20                	jmp    802593 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802573:	6a 00                	push   $0x0
  802575:	68 00 00 c0 ee       	push   $0xeec00000
  80257a:	ff 75 0c             	pushl  0xc(%ebp)
  80257d:	57                   	push   %edi
  80257e:	e8 44 e9 ff ff       	call   800ec7 <sys_ipc_try_send>
  802583:	89 c3                	mov    %eax,%ebx
  802585:	83 c4 10             	add    $0x10,%esp
  802588:	eb 1f                	jmp    8025a9 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80258a:	e8 8c e7 ff ff       	call   800d1b <sys_yield>
	while(retval != 0) {
  80258f:	85 db                	test   %ebx,%ebx
  802591:	74 33                	je     8025c6 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802593:	85 f6                	test   %esi,%esi
  802595:	74 dc                	je     802573 <ipc_send+0x11>
  802597:	ff 75 14             	pushl  0x14(%ebp)
  80259a:	56                   	push   %esi
  80259b:	ff 75 0c             	pushl  0xc(%ebp)
  80259e:	57                   	push   %edi
  80259f:	e8 23 e9 ff ff       	call   800ec7 <sys_ipc_try_send>
  8025a4:	89 c3                	mov    %eax,%ebx
  8025a6:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8025a9:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8025ac:	74 dc                	je     80258a <ipc_send+0x28>
  8025ae:	85 db                	test   %ebx,%ebx
  8025b0:	74 d8                	je     80258a <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	68 64 2f 80 00       	push   $0x802f64
  8025ba:	6a 35                	push   $0x35
  8025bc:	68 94 2f 80 00       	push   $0x802f94
  8025c1:	e8 cb dc ff ff       	call   800291 <_panic>
	}
}
  8025c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c9:	5b                   	pop    %ebx
  8025ca:	5e                   	pop    %esi
  8025cb:	5f                   	pop    %edi
  8025cc:	5d                   	pop    %ebp
  8025cd:	c3                   	ret    

008025ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025d9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025dc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025e2:	8b 52 50             	mov    0x50(%edx),%edx
  8025e5:	39 ca                	cmp    %ecx,%edx
  8025e7:	74 11                	je     8025fa <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025e9:	83 c0 01             	add    $0x1,%eax
  8025ec:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025f1:	75 e6                	jne    8025d9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	eb 0b                	jmp    802605 <ipc_find_env+0x37>
			return envs[i].env_id;
  8025fa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025fd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802602:	8b 40 48             	mov    0x48(%eax),%eax
}
  802605:	5d                   	pop    %ebp
  802606:	c3                   	ret    

00802607 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802607:	55                   	push   %ebp
  802608:	89 e5                	mov    %esp,%ebp
  80260a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80260d:	89 d0                	mov    %edx,%eax
  80260f:	c1 e8 16             	shr    $0x16,%eax
  802612:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80261e:	f6 c1 01             	test   $0x1,%cl
  802621:	74 1d                	je     802640 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802623:	c1 ea 0c             	shr    $0xc,%edx
  802626:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80262d:	f6 c2 01             	test   $0x1,%dl
  802630:	74 0e                	je     802640 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802632:	c1 ea 0c             	shr    $0xc,%edx
  802635:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80263c:	ef 
  80263d:	0f b7 c0             	movzwl %ax,%eax
}
  802640:	5d                   	pop    %ebp
  802641:	c3                   	ret    
  802642:	66 90                	xchg   %ax,%ax
  802644:	66 90                	xchg   %ax,%ax
  802646:	66 90                	xchg   %ax,%ax
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__udivdi3>:
  802650:	f3 0f 1e fb          	endbr32 
  802654:	55                   	push   %ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 1c             	sub    $0x1c,%esp
  80265b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80265f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802663:	8b 74 24 34          	mov    0x34(%esp),%esi
  802667:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80266b:	85 d2                	test   %edx,%edx
  80266d:	75 49                	jne    8026b8 <__udivdi3+0x68>
  80266f:	39 f3                	cmp    %esi,%ebx
  802671:	76 15                	jbe    802688 <__udivdi3+0x38>
  802673:	31 ff                	xor    %edi,%edi
  802675:	89 e8                	mov    %ebp,%eax
  802677:	89 f2                	mov    %esi,%edx
  802679:	f7 f3                	div    %ebx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	89 d9                	mov    %ebx,%ecx
  80268a:	85 db                	test   %ebx,%ebx
  80268c:	75 0b                	jne    802699 <__udivdi3+0x49>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f3                	div    %ebx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	31 d2                	xor    %edx,%edx
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	f7 f1                	div    %ecx
  80269f:	89 c6                	mov    %eax,%esi
  8026a1:	89 e8                	mov    %ebp,%eax
  8026a3:	89 f7                	mov    %esi,%edi
  8026a5:	f7 f1                	div    %ecx
  8026a7:	89 fa                	mov    %edi,%edx
  8026a9:	83 c4 1c             	add    $0x1c,%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5f                   	pop    %edi
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    
  8026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	39 f2                	cmp    %esi,%edx
  8026ba:	77 1c                	ja     8026d8 <__udivdi3+0x88>
  8026bc:	0f bd fa             	bsr    %edx,%edi
  8026bf:	83 f7 1f             	xor    $0x1f,%edi
  8026c2:	75 2c                	jne    8026f0 <__udivdi3+0xa0>
  8026c4:	39 f2                	cmp    %esi,%edx
  8026c6:	72 06                	jb     8026ce <__udivdi3+0x7e>
  8026c8:	31 c0                	xor    %eax,%eax
  8026ca:	39 eb                	cmp    %ebp,%ebx
  8026cc:	77 ad                	ja     80267b <__udivdi3+0x2b>
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	eb a6                	jmp    80267b <__udivdi3+0x2b>
  8026d5:	8d 76 00             	lea    0x0(%esi),%esi
  8026d8:	31 ff                	xor    %edi,%edi
  8026da:	31 c0                	xor    %eax,%eax
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 f9                	mov    %edi,%ecx
  8026f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f7:	29 f8                	sub    %edi,%eax
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	89 da                	mov    %ebx,%edx
  802703:	d3 ea                	shr    %cl,%edx
  802705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802709:	09 d1                	or     %edx,%ecx
  80270b:	89 f2                	mov    %esi,%edx
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 f9                	mov    %edi,%ecx
  802713:	d3 e3                	shl    %cl,%ebx
  802715:	89 c1                	mov    %eax,%ecx
  802717:	d3 ea                	shr    %cl,%edx
  802719:	89 f9                	mov    %edi,%ecx
  80271b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80271f:	89 eb                	mov    %ebp,%ebx
  802721:	d3 e6                	shl    %cl,%esi
  802723:	89 c1                	mov    %eax,%ecx
  802725:	d3 eb                	shr    %cl,%ebx
  802727:	09 de                	or     %ebx,%esi
  802729:	89 f0                	mov    %esi,%eax
  80272b:	f7 74 24 08          	divl   0x8(%esp)
  80272f:	89 d6                	mov    %edx,%esi
  802731:	89 c3                	mov    %eax,%ebx
  802733:	f7 64 24 0c          	mull   0xc(%esp)
  802737:	39 d6                	cmp    %edx,%esi
  802739:	72 15                	jb     802750 <__udivdi3+0x100>
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e5                	shl    %cl,%ebp
  80273f:	39 c5                	cmp    %eax,%ebp
  802741:	73 04                	jae    802747 <__udivdi3+0xf7>
  802743:	39 d6                	cmp    %edx,%esi
  802745:	74 09                	je     802750 <__udivdi3+0x100>
  802747:	89 d8                	mov    %ebx,%eax
  802749:	31 ff                	xor    %edi,%edi
  80274b:	e9 2b ff ff ff       	jmp    80267b <__udivdi3+0x2b>
  802750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802753:	31 ff                	xor    %edi,%edi
  802755:	e9 21 ff ff ff       	jmp    80267b <__udivdi3+0x2b>
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	f3 0f 1e fb          	endbr32 
  802764:	55                   	push   %ebp
  802765:	57                   	push   %edi
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	83 ec 1c             	sub    $0x1c,%esp
  80276b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80276f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802773:	8b 74 24 30          	mov    0x30(%esp),%esi
  802777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80277b:	89 da                	mov    %ebx,%edx
  80277d:	85 c0                	test   %eax,%eax
  80277f:	75 3f                	jne    8027c0 <__umoddi3+0x60>
  802781:	39 df                	cmp    %ebx,%edi
  802783:	76 13                	jbe    802798 <__umoddi3+0x38>
  802785:	89 f0                	mov    %esi,%eax
  802787:	f7 f7                	div    %edi
  802789:	89 d0                	mov    %edx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	83 c4 1c             	add    $0x1c,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5f                   	pop    %edi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	89 fd                	mov    %edi,%ebp
  80279a:	85 ff                	test   %edi,%edi
  80279c:	75 0b                	jne    8027a9 <__umoddi3+0x49>
  80279e:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	f7 f7                	div    %edi
  8027a7:	89 c5                	mov    %eax,%ebp
  8027a9:	89 d8                	mov    %ebx,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f5                	div    %ebp
  8027af:	89 f0                	mov    %esi,%eax
  8027b1:	f7 f5                	div    %ebp
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	eb d4                	jmp    80278b <__umoddi3+0x2b>
  8027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	89 f1                	mov    %esi,%ecx
  8027c2:	39 d8                	cmp    %ebx,%eax
  8027c4:	76 0a                	jbe    8027d0 <__umoddi3+0x70>
  8027c6:	89 f0                	mov    %esi,%eax
  8027c8:	83 c4 1c             	add    $0x1c,%esp
  8027cb:	5b                   	pop    %ebx
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	0f bd e8             	bsr    %eax,%ebp
  8027d3:	83 f5 1f             	xor    $0x1f,%ebp
  8027d6:	75 20                	jne    8027f8 <__umoddi3+0x98>
  8027d8:	39 d8                	cmp    %ebx,%eax
  8027da:	0f 82 b0 00 00 00    	jb     802890 <__umoddi3+0x130>
  8027e0:	39 f7                	cmp    %esi,%edi
  8027e2:	0f 86 a8 00 00 00    	jbe    802890 <__umoddi3+0x130>
  8027e8:	89 c8                	mov    %ecx,%eax
  8027ea:	83 c4 1c             	add    $0x1c,%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5e                   	pop    %esi
  8027ef:	5f                   	pop    %edi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    
  8027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8027ff:	29 ea                	sub    %ebp,%edx
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 44 24 08          	mov    %eax,0x8(%esp)
  802807:	89 d1                	mov    %edx,%ecx
  802809:	89 f8                	mov    %edi,%eax
  80280b:	d3 e8                	shr    %cl,%eax
  80280d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802811:	89 54 24 04          	mov    %edx,0x4(%esp)
  802815:	8b 54 24 04          	mov    0x4(%esp),%edx
  802819:	09 c1                	or     %eax,%ecx
  80281b:	89 d8                	mov    %ebx,%eax
  80281d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e7                	shl    %cl,%edi
  802825:	89 d1                	mov    %edx,%ecx
  802827:	d3 e8                	shr    %cl,%eax
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80282f:	d3 e3                	shl    %cl,%ebx
  802831:	89 c7                	mov    %eax,%edi
  802833:	89 d1                	mov    %edx,%ecx
  802835:	89 f0                	mov    %esi,%eax
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 fa                	mov    %edi,%edx
  80283d:	d3 e6                	shl    %cl,%esi
  80283f:	09 d8                	or     %ebx,%eax
  802841:	f7 74 24 08          	divl   0x8(%esp)
  802845:	89 d1                	mov    %edx,%ecx
  802847:	89 f3                	mov    %esi,%ebx
  802849:	f7 64 24 0c          	mull   0xc(%esp)
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	89 d7                	mov    %edx,%edi
  802851:	39 d1                	cmp    %edx,%ecx
  802853:	72 06                	jb     80285b <__umoddi3+0xfb>
  802855:	75 10                	jne    802867 <__umoddi3+0x107>
  802857:	39 c3                	cmp    %eax,%ebx
  802859:	73 0c                	jae    802867 <__umoddi3+0x107>
  80285b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80285f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802863:	89 d7                	mov    %edx,%edi
  802865:	89 c6                	mov    %eax,%esi
  802867:	89 ca                	mov    %ecx,%edx
  802869:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80286e:	29 f3                	sub    %esi,%ebx
  802870:	19 fa                	sbb    %edi,%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	d3 e0                	shl    %cl,%eax
  802876:	89 e9                	mov    %ebp,%ecx
  802878:	d3 eb                	shr    %cl,%ebx
  80287a:	d3 ea                	shr    %cl,%edx
  80287c:	09 d8                	or     %ebx,%eax
  80287e:	83 c4 1c             	add    $0x1c,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
  802886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	89 da                	mov    %ebx,%edx
  802892:	29 fe                	sub    %edi,%esi
  802894:	19 c2                	sbb    %eax,%edx
  802896:	89 f1                	mov    %esi,%ecx
  802898:	89 c8                	mov    %ecx,%eax
  80289a:	e9 4b ff ff ff       	jmp    8027ea <__umoddi3+0x8a>
