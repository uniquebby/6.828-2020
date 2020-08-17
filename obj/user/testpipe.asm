
obj/user/testpipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 a1 02 00 00       	call   8002d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 a0 	movl   $0x8029a0,0x804004
  800042:	29 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 4c 1d 00 00       	call   801d9a <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 02 11 00 00       	call   801162 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 1e 01 00 00    	js     800188 <umain+0x155>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	0f 85 56 01 00 00    	jne    8001c6 <umain+0x193>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800070:	a1 08 50 80 00       	mov    0x805008,%eax
  800075:	8b 40 48             	mov    0x48(%eax),%eax
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	ff 75 90             	pushl  -0x70(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 ce 29 80 00       	push   $0x8029ce
  800084:	e8 84 03 00 00       	call   80040d <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 a7 14 00 00       	call   80153b <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 eb 29 80 00       	push   $0x8029eb
  8000a8:	e8 60 03 00 00       	call   80040d <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 42 16 00 00       	call   801700 <readn>
  8000be:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	0f 88 cf 00 00 00    	js     80019a <umain+0x167>
			panic("read: %e", i);
		buf[i] = 0;
  8000cb:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 35 00 40 80 00    	pushl  0x804000
  8000d9:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 b2 09 00 00       	call   800a94 <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 11 2a 80 00       	push   $0x802a11
  8000f5:	e8 13 03 00 00       	call   80040d <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 16 02 00 00       	call   800318 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 0c 1e 00 00       	call   801f17 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 67 	movl   $0x802a67,0x804004
  800112:	2a 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 7a 1c 00 00       	call   801d9a <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 30 10 00 00       	call   801162 <fork>
  800132:	89 c3                	mov    %eax,%ebx
  800134:	85 c0                	test   %eax,%eax
  800136:	0f 88 35 01 00 00    	js     800271 <umain+0x23e>
		panic("fork: %e", i);

	if (pid == 0) {
  80013c:	0f 84 41 01 00 00    	je     800283 <umain+0x250>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 8c             	pushl  -0x74(%ebp)
  800148:	e8 ee 13 00 00       	call   80153b <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 e3 13 00 00       	call   80153b <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 b7 1d 00 00       	call   801f17 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 95 2a 80 00 	movl   $0x802a95,(%esp)
  800167:	e8 a1 02 00 00       	call   80040d <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 ac 29 80 00       	push   $0x8029ac
  80017c:	6a 0e                	push   $0xe
  80017e:	68 b5 29 80 00       	push   $0x8029b5
  800183:	e8 aa 01 00 00       	call   800332 <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 c5 29 80 00       	push   $0x8029c5
  80018e:	6a 11                	push   $0x11
  800190:	68 b5 29 80 00       	push   $0x8029b5
  800195:	e8 98 01 00 00       	call   800332 <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 08 2a 80 00       	push   $0x802a08
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 b5 29 80 00       	push   $0x8029b5
  8001a7:	e8 86 01 00 00       	call   800332 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 2d 2a 80 00       	push   $0x802a2d
  8001b9:	e8 4f 02 00 00       	call   80040d <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 ce 29 80 00       	push   $0x8029ce
  8001da:	e8 2e 02 00 00       	call   80040d <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 51 13 00 00       	call   80153b <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 40 2a 80 00       	push   $0x802a40
  8001fe:	e8 0a 02 00 00       	call   80040d <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 9f 07 00 00       	call   8009b0 <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 22 15 00 00       	call   801745 <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 40 80 00    	pushl  0x804000
  80022e:	e8 7d 07 00 00       	call   8009b0 <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 f6 12 00 00       	call   80153b <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 5d 2a 80 00       	push   $0x802a5d
  800253:	6a 25                	push   $0x25
  800255:	68 b5 29 80 00       	push   $0x8029b5
  80025a:	e8 d3 00 00 00       	call   800332 <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 ac 29 80 00       	push   $0x8029ac
  800265:	6a 2c                	push   $0x2c
  800267:	68 b5 29 80 00       	push   $0x8029b5
  80026c:	e8 c1 00 00 00       	call   800332 <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 c5 29 80 00       	push   $0x8029c5
  800277:	6a 2f                	push   $0x2f
  800279:	68 b5 29 80 00       	push   $0x8029b5
  80027e:	e8 af 00 00 00       	call   800332 <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 ad 12 00 00       	call   80153b <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 74 2a 80 00       	push   $0x802a74
  800299:	e8 6f 01 00 00       	call   80040d <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 76 2a 80 00       	push   $0x802a76
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 95 14 00 00       	call   801745 <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 78 2a 80 00       	push   $0x802a78
  8002c0:	e8 48 01 00 00       	call   80040d <cprintf>
		exit();
  8002c5:	e8 4e 00 00 00       	call   800318 <exit>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	e9 70 fe ff ff       	jmp    800142 <umain+0x10f>

008002d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002dd:	e8 bb 0a 00 00       	call   800d9d <sys_getenvid>
  8002e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ef:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f4:	85 db                	test   %ebx,%ebx
  8002f6:	7e 07                	jle    8002ff <libmain+0x2d>
		binaryname = argv[0];
  8002f8:	8b 06                	mov    (%esi),%eax
  8002fa:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	e8 2a fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800309:	e8 0a 00 00 00       	call   800318 <exit>
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80031e:	e8 45 12 00 00       	call   801568 <close_all>
	sys_env_destroy(0);
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	6a 00                	push   $0x0
  800328:	e8 2f 0a 00 00       	call   800d5c <sys_env_destroy>
}
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800337:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80033a:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800340:	e8 58 0a 00 00       	call   800d9d <sys_getenvid>
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	56                   	push   %esi
  80034f:	50                   	push   %eax
  800350:	68 f8 2a 80 00       	push   $0x802af8
  800355:	e8 b3 00 00 00       	call   80040d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035a:	83 c4 18             	add    $0x18,%esp
  80035d:	53                   	push   %ebx
  80035e:	ff 75 10             	pushl  0x10(%ebp)
  800361:	e8 56 00 00 00       	call   8003bc <vcprintf>
	cprintf("\n");
  800366:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80036d:	e8 9b 00 00 00       	call   80040d <cprintf>
  800372:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800375:	cc                   	int3   
  800376:	eb fd                	jmp    800375 <_panic+0x43>

00800378 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	53                   	push   %ebx
  80037c:	83 ec 04             	sub    $0x4,%esp
  80037f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800382:	8b 13                	mov    (%ebx),%edx
  800384:	8d 42 01             	lea    0x1(%edx),%eax
  800387:	89 03                	mov    %eax,(%ebx)
  800389:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80038c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800390:	3d ff 00 00 00       	cmp    $0xff,%eax
  800395:	74 09                	je     8003a0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800397:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80039b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	68 ff 00 00 00       	push   $0xff
  8003a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ab:	50                   	push   %eax
  8003ac:	e8 6e 09 00 00       	call   800d1f <sys_cputs>
		b->idx = 0;
  8003b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	eb db                	jmp    800397 <putch+0x1f>

008003bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003cc:	00 00 00 
	b.cnt = 0;
  8003cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d9:	ff 75 0c             	pushl  0xc(%ebp)
  8003dc:	ff 75 08             	pushl  0x8(%ebp)
  8003df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e5:	50                   	push   %eax
  8003e6:	68 78 03 80 00       	push   $0x800378
  8003eb:	e8 19 01 00 00       	call   800509 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f0:	83 c4 08             	add    $0x8,%esp
  8003f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ff:	50                   	push   %eax
  800400:	e8 1a 09 00 00       	call   800d1f <sys_cputs>

	return b.cnt;
}
  800405:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800413:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800416:	50                   	push   %eax
  800417:	ff 75 08             	pushl  0x8(%ebp)
  80041a:	e8 9d ff ff ff       	call   8003bc <vcprintf>
	va_end(ap);

	return cnt;
}
  80041f:	c9                   	leave  
  800420:	c3                   	ret    

00800421 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	57                   	push   %edi
  800425:	56                   	push   %esi
  800426:	53                   	push   %ebx
  800427:	83 ec 1c             	sub    $0x1c,%esp
  80042a:	89 c7                	mov    %eax,%edi
  80042c:	89 d6                	mov    %edx,%esi
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8b 55 0c             	mov    0xc(%ebp),%edx
  800434:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800437:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80043d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800442:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800445:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800448:	3b 45 10             	cmp    0x10(%ebp),%eax
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800450:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800453:	73 15                	jae    80046a <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800455:	83 eb 01             	sub    $0x1,%ebx
  800458:	85 db                	test   %ebx,%ebx
  80045a:	7e 43                	jle    80049f <printnum+0x7e>
			putch(padc, putdat);
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	56                   	push   %esi
  800460:	ff 75 18             	pushl  0x18(%ebp)
  800463:	ff d7                	call   *%edi
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	eb eb                	jmp    800455 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046a:	83 ec 0c             	sub    $0xc,%esp
  80046d:	ff 75 18             	pushl  0x18(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800476:	53                   	push   %ebx
  800477:	ff 75 10             	pushl  0x10(%ebp)
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800480:	ff 75 e0             	pushl  -0x20(%ebp)
  800483:	ff 75 dc             	pushl  -0x24(%ebp)
  800486:	ff 75 d8             	pushl  -0x28(%ebp)
  800489:	e8 b2 22 00 00       	call   802740 <__udivdi3>
  80048e:	83 c4 18             	add    $0x18,%esp
  800491:	52                   	push   %edx
  800492:	50                   	push   %eax
  800493:	89 f2                	mov    %esi,%edx
  800495:	89 f8                	mov    %edi,%eax
  800497:	e8 85 ff ff ff       	call   800421 <printnum>
  80049c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	56                   	push   %esi
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8004af:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b2:	e8 99 23 00 00       	call   802850 <__umoddi3>
  8004b7:	83 c4 14             	add    $0x14,%esp
  8004ba:	0f be 80 1b 2b 80 00 	movsbl 0x802b1b(%eax),%eax
  8004c1:	50                   	push   %eax
  8004c2:	ff d7                	call   *%edi
}
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ca:	5b                   	pop    %ebx
  8004cb:	5e                   	pop    %esi
  8004cc:	5f                   	pop    %edi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d9:	8b 10                	mov    (%eax),%edx
  8004db:	3b 50 04             	cmp    0x4(%eax),%edx
  8004de:	73 0a                	jae    8004ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e3:	89 08                	mov    %ecx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	88 02                	mov    %al,(%edx)
}
  8004ea:	5d                   	pop    %ebp
  8004eb:	c3                   	ret    

008004ec <printfmt>:
{
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
  8004ef:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004f5:	50                   	push   %eax
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 0c             	pushl  0xc(%ebp)
  8004fc:	ff 75 08             	pushl  0x8(%ebp)
  8004ff:	e8 05 00 00 00       	call   800509 <vprintfmt>
}
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	c9                   	leave  
  800508:	c3                   	ret    

00800509 <vprintfmt>:
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	57                   	push   %edi
  80050d:	56                   	push   %esi
  80050e:	53                   	push   %ebx
  80050f:	83 ec 3c             	sub    $0x3c,%esp
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	8b 7d 10             	mov    0x10(%ebp),%edi
  80051b:	eb 0a                	jmp    800527 <vprintfmt+0x1e>
			putch(ch, putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	50                   	push   %eax
  800522:	ff d6                	call   *%esi
  800524:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800527:	83 c7 01             	add    $0x1,%edi
  80052a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80052e:	83 f8 25             	cmp    $0x25,%eax
  800531:	74 0c                	je     80053f <vprintfmt+0x36>
			if (ch == '\0')
  800533:	85 c0                	test   %eax,%eax
  800535:	75 e6                	jne    80051d <vprintfmt+0x14>
}
  800537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80053a:	5b                   	pop    %ebx
  80053b:	5e                   	pop    %esi
  80053c:	5f                   	pop    %edi
  80053d:	5d                   	pop    %ebp
  80053e:	c3                   	ret    
		padc = ' ';
  80053f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800543:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80054a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800551:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800558:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	8d 47 01             	lea    0x1(%edi),%eax
  800560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800563:	0f b6 17             	movzbl (%edi),%edx
  800566:	8d 42 dd             	lea    -0x23(%edx),%eax
  800569:	3c 55                	cmp    $0x55,%al
  80056b:	0f 87 ba 03 00 00    	ja     80092b <vprintfmt+0x422>
  800571:	0f b6 c0             	movzbl %al,%eax
  800574:	ff 24 85 60 2c 80 00 	jmp    *0x802c60(,%eax,4)
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800582:	eb d9                	jmp    80055d <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800584:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800587:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80058b:	eb d0                	jmp    80055d <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80058d:	0f b6 d2             	movzbl %dl,%edx
  800590:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800593:	b8 00 00 00 00       	mov    $0x0,%eax
  800598:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80059b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005a8:	83 f9 09             	cmp    $0x9,%ecx
  8005ab:	77 55                	ja     800602 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b0:	eb e9                	jmp    80059b <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ca:	79 91                	jns    80055d <vprintfmt+0x54>
				width = precision, precision = -1;
  8005cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005d9:	eb 82                	jmp    80055d <vprintfmt+0x54>
  8005db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	0f 49 d0             	cmovns %eax,%edx
  8005e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ee:	e9 6a ff ff ff       	jmp    80055d <vprintfmt+0x54>
  8005f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005fd:	e9 5b ff ff ff       	jmp    80055d <vprintfmt+0x54>
  800602:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	eb bc                	jmp    8005c6 <vprintfmt+0xbd>
			lflag++;
  80060a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800610:	e9 48 ff ff ff       	jmp    80055d <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 78 04             	lea    0x4(%eax),%edi
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	ff 30                	pushl  (%eax)
  800621:	ff d6                	call   *%esi
			break;
  800623:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800626:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800629:	e9 9c 02 00 00       	jmp    8008ca <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 78 04             	lea    0x4(%eax),%edi
  800634:	8b 00                	mov    (%eax),%eax
  800636:	99                   	cltd   
  800637:	31 d0                	xor    %edx,%eax
  800639:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063b:	83 f8 0f             	cmp    $0xf,%eax
  80063e:	7f 23                	jg     800663 <vprintfmt+0x15a>
  800640:	8b 14 85 c0 2d 80 00 	mov    0x802dc0(,%eax,4),%edx
  800647:	85 d2                	test   %edx,%edx
  800649:	74 18                	je     800663 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80064b:	52                   	push   %edx
  80064c:	68 5e 30 80 00       	push   $0x80305e
  800651:	53                   	push   %ebx
  800652:	56                   	push   %esi
  800653:	e8 94 fe ff ff       	call   8004ec <printfmt>
  800658:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80065e:	e9 67 02 00 00       	jmp    8008ca <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800663:	50                   	push   %eax
  800664:	68 33 2b 80 00       	push   $0x802b33
  800669:	53                   	push   %ebx
  80066a:	56                   	push   %esi
  80066b:	e8 7c fe ff ff       	call   8004ec <printfmt>
  800670:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800673:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800676:	e9 4f 02 00 00       	jmp    8008ca <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	83 c0 04             	add    $0x4,%eax
  800681:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800689:	85 d2                	test   %edx,%edx
  80068b:	b8 2c 2b 80 00       	mov    $0x802b2c,%eax
  800690:	0f 45 c2             	cmovne %edx,%eax
  800693:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800696:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069a:	7e 06                	jle    8006a2 <vprintfmt+0x199>
  80069c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a0:	75 0d                	jne    8006af <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006a5:	89 c7                	mov    %eax,%edi
  8006a7:	03 45 e0             	add    -0x20(%ebp),%eax
  8006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ad:	eb 3f                	jmp    8006ee <vprintfmt+0x1e5>
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b5:	50                   	push   %eax
  8006b6:	e8 0d 03 00 00       	call   8009c8 <strnlen>
  8006bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006be:	29 c2                	sub    %eax,%edx
  8006c0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006c8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	85 ff                	test   %edi,%edi
  8006d1:	7e 58                	jle    80072b <vprintfmt+0x222>
					putch(padc, putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dc:	83 ef 01             	sub    $0x1,%edi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	eb eb                	jmp    8006cf <vprintfmt+0x1c6>
					putch(ch, putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	52                   	push   %edx
  8006e9:	ff d6                	call   *%esi
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006f1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	83 c7 01             	add    $0x1,%edi
  8006f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006fa:	0f be d0             	movsbl %al,%edx
  8006fd:	85 d2                	test   %edx,%edx
  8006ff:	74 45                	je     800746 <vprintfmt+0x23d>
  800701:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800705:	78 06                	js     80070d <vprintfmt+0x204>
  800707:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80070b:	78 35                	js     800742 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80070d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800711:	74 d1                	je     8006e4 <vprintfmt+0x1db>
  800713:	0f be c0             	movsbl %al,%eax
  800716:	83 e8 20             	sub    $0x20,%eax
  800719:	83 f8 5e             	cmp    $0x5e,%eax
  80071c:	76 c6                	jbe    8006e4 <vprintfmt+0x1db>
					putch('?', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 3f                	push   $0x3f
  800724:	ff d6                	call   *%esi
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	eb c3                	jmp    8006ee <vprintfmt+0x1e5>
  80072b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80072e:	85 d2                	test   %edx,%edx
  800730:	b8 00 00 00 00       	mov    $0x0,%eax
  800735:	0f 49 c2             	cmovns %edx,%eax
  800738:	29 c2                	sub    %eax,%edx
  80073a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80073d:	e9 60 ff ff ff       	jmp    8006a2 <vprintfmt+0x199>
  800742:	89 cf                	mov    %ecx,%edi
  800744:	eb 02                	jmp    800748 <vprintfmt+0x23f>
  800746:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800748:	85 ff                	test   %edi,%edi
  80074a:	7e 10                	jle    80075c <vprintfmt+0x253>
				putch(' ', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	53                   	push   %ebx
  800750:	6a 20                	push   $0x20
  800752:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800754:	83 ef 01             	sub    $0x1,%edi
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb ec                	jmp    800748 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80075c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	e9 63 01 00 00       	jmp    8008ca <vprintfmt+0x3c1>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7f 1b                	jg     800787 <vprintfmt+0x27e>
	else if (lflag)
  80076c:	85 c9                	test   %ecx,%ecx
  80076e:	74 63                	je     8007d3 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	99                   	cltd   
  800779:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
  800785:	eb 17                	jmp    80079e <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 50 04             	mov    0x4(%eax),%edx
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 08             	lea    0x8(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80079e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a9:	85 c9                	test   %ecx,%ecx
  8007ab:	0f 89 ff 00 00 00    	jns    8008b0 <vprintfmt+0x3a7>
				putch('-', putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	6a 2d                	push   $0x2d
  8007b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007bf:	f7 da                	neg    %edx
  8007c1:	83 d1 00             	adc    $0x0,%ecx
  8007c4:	f7 d9                	neg    %ecx
  8007c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ce:	e9 dd 00 00 00       	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007db:	99                   	cltd   
  8007dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e8:	eb b4                	jmp    80079e <vprintfmt+0x295>
	if (lflag >= 2)
  8007ea:	83 f9 01             	cmp    $0x1,%ecx
  8007ed:	7f 1e                	jg     80080d <vprintfmt+0x304>
	else if (lflag)
  8007ef:	85 c9                	test   %ecx,%ecx
  8007f1:	74 32                	je     800825 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 10                	mov    (%eax),%edx
  8007f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800803:	b8 0a 00 00 00       	mov    $0xa,%eax
  800808:	e9 a3 00 00 00       	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	8b 48 04             	mov    0x4(%eax),%ecx
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800820:	e9 8b 00 00 00       	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 10                	mov    (%eax),%edx
  80082a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082f:	8d 40 04             	lea    0x4(%eax),%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800835:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083a:	eb 74                	jmp    8008b0 <vprintfmt+0x3a7>
	if (lflag >= 2)
  80083c:	83 f9 01             	cmp    $0x1,%ecx
  80083f:	7f 1b                	jg     80085c <vprintfmt+0x353>
	else if (lflag)
  800841:	85 c9                	test   %ecx,%ecx
  800843:	74 2c                	je     800871 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8b 10                	mov    (%eax),%edx
  80084a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084f:	8d 40 04             	lea    0x4(%eax),%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800855:	b8 08 00 00 00       	mov    $0x8,%eax
  80085a:	eb 54                	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8b 10                	mov    (%eax),%edx
  800861:	8b 48 04             	mov    0x4(%eax),%ecx
  800864:	8d 40 08             	lea    0x8(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086a:	b8 08 00 00 00       	mov    $0x8,%eax
  80086f:	eb 3f                	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 10                	mov    (%eax),%edx
  800876:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087b:	8d 40 04             	lea    0x4(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800881:	b8 08 00 00 00       	mov    $0x8,%eax
  800886:	eb 28                	jmp    8008b0 <vprintfmt+0x3a7>
			putch('0', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	6a 30                	push   $0x30
  80088e:	ff d6                	call   *%esi
			putch('x', putdat);
  800890:	83 c4 08             	add    $0x8,%esp
  800893:	53                   	push   %ebx
  800894:	6a 78                	push   $0x78
  800896:	ff d6                	call   *%esi
			num = (unsigned long long)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8b 10                	mov    (%eax),%edx
  80089d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a5:	8d 40 04             	lea    0x4(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008b7:	57                   	push   %edi
  8008b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bb:	50                   	push   %eax
  8008bc:	51                   	push   %ecx
  8008bd:	52                   	push   %edx
  8008be:	89 da                	mov    %ebx,%edx
  8008c0:	89 f0                	mov    %esi,%eax
  8008c2:	e8 5a fb ff ff       	call   800421 <printnum>
			break;
  8008c7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cd:	e9 55 fc ff ff       	jmp    800527 <vprintfmt+0x1e>
	if (lflag >= 2)
  8008d2:	83 f9 01             	cmp    $0x1,%ecx
  8008d5:	7f 1b                	jg     8008f2 <vprintfmt+0x3e9>
	else if (lflag)
  8008d7:	85 c9                	test   %ecx,%ecx
  8008d9:	74 2c                	je     800907 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8b 10                	mov    (%eax),%edx
  8008e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008e5:	8d 40 04             	lea    0x4(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f0:	eb be                	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 10                	mov    (%eax),%edx
  8008f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8008fa:	8d 40 08             	lea    0x8(%eax),%eax
  8008fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800900:	b8 10 00 00 00       	mov    $0x10,%eax
  800905:	eb a9                	jmp    8008b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8b 10                	mov    (%eax),%edx
  80090c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800911:	8d 40 04             	lea    0x4(%eax),%eax
  800914:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800917:	b8 10 00 00 00       	mov    $0x10,%eax
  80091c:	eb 92                	jmp    8008b0 <vprintfmt+0x3a7>
			putch(ch, putdat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	53                   	push   %ebx
  800922:	6a 25                	push   $0x25
  800924:	ff d6                	call   *%esi
			break;
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	eb 9f                	jmp    8008ca <vprintfmt+0x3c1>
			putch('%', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	53                   	push   %ebx
  80092f:	6a 25                	push   $0x25
  800931:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800933:	83 c4 10             	add    $0x10,%esp
  800936:	89 f8                	mov    %edi,%eax
  800938:	eb 03                	jmp    80093d <vprintfmt+0x434>
  80093a:	83 e8 01             	sub    $0x1,%eax
  80093d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800941:	75 f7                	jne    80093a <vprintfmt+0x431>
  800943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800946:	eb 82                	jmp    8008ca <vprintfmt+0x3c1>

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800954:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800957:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80095b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80095e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800965:	85 c0                	test   %eax,%eax
  800967:	74 26                	je     80098f <vsnprintf+0x47>
  800969:	85 d2                	test   %edx,%edx
  80096b:	7e 22                	jle    80098f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096d:	ff 75 14             	pushl  0x14(%ebp)
  800970:	ff 75 10             	pushl  0x10(%ebp)
  800973:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	68 cf 04 80 00       	push   $0x8004cf
  80097c:	e8 88 fb ff ff       	call   800509 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800984:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098a:	83 c4 10             	add    $0x10,%esp
}
  80098d:	c9                   	leave  
  80098e:	c3                   	ret    
		return -E_INVAL;
  80098f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800994:	eb f7                	jmp    80098d <vsnprintf+0x45>

00800996 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099f:	50                   	push   %eax
  8009a0:	ff 75 10             	pushl  0x10(%ebp)
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	ff 75 08             	pushl  0x8(%ebp)
  8009a9:	e8 9a ff ff ff       	call   800948 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009bf:	74 05                	je     8009c6 <strlen+0x16>
		n++;
  8009c1:	83 c0 01             	add    $0x1,%eax
  8009c4:	eb f5                	jmp    8009bb <strlen+0xb>
	return n;
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d6:	39 c2                	cmp    %eax,%edx
  8009d8:	74 0d                	je     8009e7 <strnlen+0x1f>
  8009da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009de:	74 05                	je     8009e5 <strnlen+0x1d>
		n++;
  8009e0:	83 c2 01             	add    $0x1,%edx
  8009e3:	eb f1                	jmp    8009d6 <strnlen+0xe>
  8009e5:	89 d0                	mov    %edx,%eax
	return n;
}
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	53                   	push   %ebx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009ff:	83 c2 01             	add    $0x1,%edx
  800a02:	84 c9                	test   %cl,%cl
  800a04:	75 f2                	jne    8009f8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a06:	5b                   	pop    %ebx
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	53                   	push   %ebx
  800a0d:	83 ec 10             	sub    $0x10,%esp
  800a10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a13:	53                   	push   %ebx
  800a14:	e8 97 ff ff ff       	call   8009b0 <strlen>
  800a19:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	01 d8                	add    %ebx,%eax
  800a21:	50                   	push   %eax
  800a22:	e8 c2 ff ff ff       	call   8009e9 <strcpy>
	return dst;
}
  800a27:	89 d8                	mov    %ebx,%eax
  800a29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	56                   	push   %esi
  800a32:	53                   	push   %ebx
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a39:	89 c6                	mov    %eax,%esi
  800a3b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	39 f2                	cmp    %esi,%edx
  800a42:	74 11                	je     800a55 <strncpy+0x27>
		*dst++ = *src;
  800a44:	83 c2 01             	add    $0x1,%edx
  800a47:	0f b6 19             	movzbl (%ecx),%ebx
  800a4a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4d:	80 fb 01             	cmp    $0x1,%bl
  800a50:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a53:	eb eb                	jmp    800a40 <strncpy+0x12>
	}
	return ret;
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	56                   	push   %esi
  800a5d:	53                   	push   %ebx
  800a5e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a64:	8b 55 10             	mov    0x10(%ebp),%edx
  800a67:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a69:	85 d2                	test   %edx,%edx
  800a6b:	74 21                	je     800a8e <strlcpy+0x35>
  800a6d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a71:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a73:	39 c2                	cmp    %eax,%edx
  800a75:	74 14                	je     800a8b <strlcpy+0x32>
  800a77:	0f b6 19             	movzbl (%ecx),%ebx
  800a7a:	84 db                	test   %bl,%bl
  800a7c:	74 0b                	je     800a89 <strlcpy+0x30>
			*dst++ = *src++;
  800a7e:	83 c1 01             	add    $0x1,%ecx
  800a81:	83 c2 01             	add    $0x1,%edx
  800a84:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a87:	eb ea                	jmp    800a73 <strlcpy+0x1a>
  800a89:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a8b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8e:	29 f0                	sub    %esi,%eax
}
  800a90:	5b                   	pop    %ebx
  800a91:	5e                   	pop    %esi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a9d:	0f b6 01             	movzbl (%ecx),%eax
  800aa0:	84 c0                	test   %al,%al
  800aa2:	74 0c                	je     800ab0 <strcmp+0x1c>
  800aa4:	3a 02                	cmp    (%edx),%al
  800aa6:	75 08                	jne    800ab0 <strcmp+0x1c>
		p++, q++;
  800aa8:	83 c1 01             	add    $0x1,%ecx
  800aab:	83 c2 01             	add    $0x1,%edx
  800aae:	eb ed                	jmp    800a9d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab0:	0f b6 c0             	movzbl %al,%eax
  800ab3:	0f b6 12             	movzbl (%edx),%edx
  800ab6:	29 d0                	sub    %edx,%eax
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac4:	89 c3                	mov    %eax,%ebx
  800ac6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac9:	eb 06                	jmp    800ad1 <strncmp+0x17>
		n--, p++, q++;
  800acb:	83 c0 01             	add    $0x1,%eax
  800ace:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ad1:	39 d8                	cmp    %ebx,%eax
  800ad3:	74 16                	je     800aeb <strncmp+0x31>
  800ad5:	0f b6 08             	movzbl (%eax),%ecx
  800ad8:	84 c9                	test   %cl,%cl
  800ada:	74 04                	je     800ae0 <strncmp+0x26>
  800adc:	3a 0a                	cmp    (%edx),%cl
  800ade:	74 eb                	je     800acb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae0:	0f b6 00             	movzbl (%eax),%eax
  800ae3:	0f b6 12             	movzbl (%edx),%edx
  800ae6:	29 d0                	sub    %edx,%eax
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    
		return 0;
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  800af0:	eb f6                	jmp    800ae8 <strncmp+0x2e>

00800af2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afc:	0f b6 10             	movzbl (%eax),%edx
  800aff:	84 d2                	test   %dl,%dl
  800b01:	74 09                	je     800b0c <strchr+0x1a>
		if (*s == c)
  800b03:	38 ca                	cmp    %cl,%dl
  800b05:	74 0a                	je     800b11 <strchr+0x1f>
	for (; *s; s++)
  800b07:	83 c0 01             	add    $0x1,%eax
  800b0a:	eb f0                	jmp    800afc <strchr+0xa>
			return (char *) s;
	return 0;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b20:	38 ca                	cmp    %cl,%dl
  800b22:	74 09                	je     800b2d <strfind+0x1a>
  800b24:	84 d2                	test   %dl,%dl
  800b26:	74 05                	je     800b2d <strfind+0x1a>
	for (; *s; s++)
  800b28:	83 c0 01             	add    $0x1,%eax
  800b2b:	eb f0                	jmp    800b1d <strfind+0xa>
			break;
	return (char *) s;
}
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b3b:	85 c9                	test   %ecx,%ecx
  800b3d:	74 31                	je     800b70 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3f:	89 f8                	mov    %edi,%eax
  800b41:	09 c8                	or     %ecx,%eax
  800b43:	a8 03                	test   $0x3,%al
  800b45:	75 23                	jne    800b6a <memset+0x3b>
		c &= 0xFF;
  800b47:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b4b:	89 d3                	mov    %edx,%ebx
  800b4d:	c1 e3 08             	shl    $0x8,%ebx
  800b50:	89 d0                	mov    %edx,%eax
  800b52:	c1 e0 18             	shl    $0x18,%eax
  800b55:	89 d6                	mov    %edx,%esi
  800b57:	c1 e6 10             	shl    $0x10,%esi
  800b5a:	09 f0                	or     %esi,%eax
  800b5c:	09 c2                	or     %eax,%edx
  800b5e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b60:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	fc                   	cld    
  800b66:	f3 ab                	rep stos %eax,%es:(%edi)
  800b68:	eb 06                	jmp    800b70 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	fc                   	cld    
  800b6e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b70:	89 f8                	mov    %edi,%eax
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5f                   	pop    %edi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	57                   	push   %edi
  800b7b:	56                   	push   %esi
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b85:	39 c6                	cmp    %eax,%esi
  800b87:	73 32                	jae    800bbb <memmove+0x44>
  800b89:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b8c:	39 c2                	cmp    %eax,%edx
  800b8e:	76 2b                	jbe    800bbb <memmove+0x44>
		s += n;
		d += n;
  800b90:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b93:	89 fe                	mov    %edi,%esi
  800b95:	09 ce                	or     %ecx,%esi
  800b97:	09 d6                	or     %edx,%esi
  800b99:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9f:	75 0e                	jne    800baf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ba1:	83 ef 04             	sub    $0x4,%edi
  800ba4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800baa:	fd                   	std    
  800bab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bad:	eb 09                	jmp    800bb8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800baf:	83 ef 01             	sub    $0x1,%edi
  800bb2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb5:	fd                   	std    
  800bb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb8:	fc                   	cld    
  800bb9:	eb 1a                	jmp    800bd5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	09 ca                	or     %ecx,%edx
  800bbf:	09 f2                	or     %esi,%edx
  800bc1:	f6 c2 03             	test   $0x3,%dl
  800bc4:	75 0a                	jne    800bd0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	fc                   	cld    
  800bcc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bce:	eb 05                	jmp    800bd5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bd0:	89 c7                	mov    %eax,%edi
  800bd2:	fc                   	cld    
  800bd3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bdf:	ff 75 10             	pushl  0x10(%ebp)
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	ff 75 08             	pushl  0x8(%ebp)
  800be8:	e8 8a ff ff ff       	call   800b77 <memmove>
}
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfa:	89 c6                	mov    %eax,%esi
  800bfc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bff:	39 f0                	cmp    %esi,%eax
  800c01:	74 1c                	je     800c1f <memcmp+0x30>
		if (*s1 != *s2)
  800c03:	0f b6 08             	movzbl (%eax),%ecx
  800c06:	0f b6 1a             	movzbl (%edx),%ebx
  800c09:	38 d9                	cmp    %bl,%cl
  800c0b:	75 08                	jne    800c15 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c0d:	83 c0 01             	add    $0x1,%eax
  800c10:	83 c2 01             	add    $0x1,%edx
  800c13:	eb ea                	jmp    800bff <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c15:	0f b6 c1             	movzbl %cl,%eax
  800c18:	0f b6 db             	movzbl %bl,%ebx
  800c1b:	29 d8                	sub    %ebx,%eax
  800c1d:	eb 05                	jmp    800c24 <memcmp+0x35>
	}

	return 0;
  800c1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c31:	89 c2                	mov    %eax,%edx
  800c33:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c36:	39 d0                	cmp    %edx,%eax
  800c38:	73 09                	jae    800c43 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c3a:	38 08                	cmp    %cl,(%eax)
  800c3c:	74 05                	je     800c43 <memfind+0x1b>
	for (; s < ends; s++)
  800c3e:	83 c0 01             	add    $0x1,%eax
  800c41:	eb f3                	jmp    800c36 <memfind+0xe>
			break;
	return (void *) s;
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
  800c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c51:	eb 03                	jmp    800c56 <strtol+0x11>
		s++;
  800c53:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c56:	0f b6 01             	movzbl (%ecx),%eax
  800c59:	3c 20                	cmp    $0x20,%al
  800c5b:	74 f6                	je     800c53 <strtol+0xe>
  800c5d:	3c 09                	cmp    $0x9,%al
  800c5f:	74 f2                	je     800c53 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c61:	3c 2b                	cmp    $0x2b,%al
  800c63:	74 2a                	je     800c8f <strtol+0x4a>
	int neg = 0;
  800c65:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c6a:	3c 2d                	cmp    $0x2d,%al
  800c6c:	74 2b                	je     800c99 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c74:	75 0f                	jne    800c85 <strtol+0x40>
  800c76:	80 39 30             	cmpb   $0x30,(%ecx)
  800c79:	74 28                	je     800ca3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c7b:	85 db                	test   %ebx,%ebx
  800c7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c82:	0f 44 d8             	cmove  %eax,%ebx
  800c85:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c8d:	eb 50                	jmp    800cdf <strtol+0x9a>
		s++;
  800c8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c92:	bf 00 00 00 00       	mov    $0x0,%edi
  800c97:	eb d5                	jmp    800c6e <strtol+0x29>
		s++, neg = 1;
  800c99:	83 c1 01             	add    $0x1,%ecx
  800c9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800ca1:	eb cb                	jmp    800c6e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ca7:	74 0e                	je     800cb7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca9:	85 db                	test   %ebx,%ebx
  800cab:	75 d8                	jne    800c85 <strtol+0x40>
		s++, base = 8;
  800cad:	83 c1 01             	add    $0x1,%ecx
  800cb0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb5:	eb ce                	jmp    800c85 <strtol+0x40>
		s += 2, base = 16;
  800cb7:	83 c1 02             	add    $0x2,%ecx
  800cba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cbf:	eb c4                	jmp    800c85 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cc1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cc4:	89 f3                	mov    %esi,%ebx
  800cc6:	80 fb 19             	cmp    $0x19,%bl
  800cc9:	77 29                	ja     800cf4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ccb:	0f be d2             	movsbl %dl,%edx
  800cce:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cd1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cd4:	7d 30                	jge    800d06 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd6:	83 c1 01             	add    $0x1,%ecx
  800cd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cdd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cdf:	0f b6 11             	movzbl (%ecx),%edx
  800ce2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce5:	89 f3                	mov    %esi,%ebx
  800ce7:	80 fb 09             	cmp    $0x9,%bl
  800cea:	77 d5                	ja     800cc1 <strtol+0x7c>
			dig = *s - '0';
  800cec:	0f be d2             	movsbl %dl,%edx
  800cef:	83 ea 30             	sub    $0x30,%edx
  800cf2:	eb dd                	jmp    800cd1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cf4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cf7:	89 f3                	mov    %esi,%ebx
  800cf9:	80 fb 19             	cmp    $0x19,%bl
  800cfc:	77 08                	ja     800d06 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cfe:	0f be d2             	movsbl %dl,%edx
  800d01:	83 ea 37             	sub    $0x37,%edx
  800d04:	eb cb                	jmp    800cd1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0a:	74 05                	je     800d11 <strtol+0xcc>
		*endptr = (char *) s;
  800d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d11:	89 c2                	mov    %eax,%edx
  800d13:	f7 da                	neg    %edx
  800d15:	85 ff                	test   %edi,%edi
  800d17:	0f 45 c2             	cmovne %edx,%eax
}
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d30:	89 c3                	mov    %eax,%ebx
  800d32:	89 c7                	mov    %eax,%edi
  800d34:	89 c6                	mov    %eax,%esi
  800d36:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_cgetc>:

int
sys_cgetc(void)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d43:	ba 00 00 00 00       	mov    $0x0,%edx
  800d48:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4d:	89 d1                	mov    %edx,%ecx
  800d4f:	89 d3                	mov    %edx,%ebx
  800d51:	89 d7                	mov    %edx,%edi
  800d53:	89 d6                	mov    %edx,%esi
  800d55:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	b8 03 00 00 00       	mov    $0x3,%eax
  800d72:	89 cb                	mov    %ecx,%ebx
  800d74:	89 cf                	mov    %ecx,%edi
  800d76:	89 ce                	mov    %ecx,%esi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 03                	push   $0x3
  800d8c:	68 1f 2e 80 00       	push   $0x802e1f
  800d91:	6a 23                	push   $0x23
  800d93:	68 3c 2e 80 00       	push   $0x802e3c
  800d98:	e8 95 f5 ff ff       	call   800332 <_panic>

00800d9d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da3:	ba 00 00 00 00       	mov    $0x0,%edx
  800da8:	b8 02 00 00 00       	mov    $0x2,%eax
  800dad:	89 d1                	mov    %edx,%ecx
  800daf:	89 d3                	mov    %edx,%ebx
  800db1:	89 d7                	mov    %edx,%edi
  800db3:	89 d6                	mov    %edx,%esi
  800db5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <sys_yield>:

void
sys_yield(void)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	57                   	push   %edi
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dcc:	89 d1                	mov    %edx,%ecx
  800dce:	89 d3                	mov    %edx,%ebx
  800dd0:	89 d7                	mov    %edx,%edi
  800dd2:	89 d6                	mov    %edx,%esi
  800dd4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de4:	be 00 00 00 00       	mov    $0x0,%esi
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	b8 04 00 00 00       	mov    $0x4,%eax
  800df4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df7:	89 f7                	mov    %esi,%edi
  800df9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7f 08                	jg     800e07 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	50                   	push   %eax
  800e0b:	6a 04                	push   $0x4
  800e0d:	68 1f 2e 80 00       	push   $0x802e1f
  800e12:	6a 23                	push   $0x23
  800e14:	68 3c 2e 80 00       	push   $0x802e3c
  800e19:	e8 14 f5 ff ff       	call   800332 <_panic>

00800e1e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e38:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 05                	push   $0x5
  800e4f:	68 1f 2e 80 00       	push   $0x802e1f
  800e54:	6a 23                	push   $0x23
  800e56:	68 3c 2e 80 00       	push   $0x802e3c
  800e5b:	e8 d2 f4 ff ff       	call   800332 <_panic>

00800e60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	b8 06 00 00 00       	mov    $0x6,%eax
  800e79:	89 df                	mov    %ebx,%edi
  800e7b:	89 de                	mov    %ebx,%esi
  800e7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7f 08                	jg     800e8b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8b:	83 ec 0c             	sub    $0xc,%esp
  800e8e:	50                   	push   %eax
  800e8f:	6a 06                	push   $0x6
  800e91:	68 1f 2e 80 00       	push   $0x802e1f
  800e96:	6a 23                	push   $0x23
  800e98:	68 3c 2e 80 00       	push   $0x802e3c
  800e9d:	e8 90 f4 ff ff       	call   800332 <_panic>

00800ea2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	b8 08 00 00 00       	mov    $0x8,%eax
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	89 de                	mov    %ebx,%esi
  800ebf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7f 08                	jg     800ecd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	50                   	push   %eax
  800ed1:	6a 08                	push   $0x8
  800ed3:	68 1f 2e 80 00       	push   $0x802e1f
  800ed8:	6a 23                	push   $0x23
  800eda:	68 3c 2e 80 00       	push   $0x802e3c
  800edf:	e8 4e f4 ff ff       	call   800332 <_panic>

00800ee4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
  800eea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef8:	b8 09 00 00 00       	mov    $0x9,%eax
  800efd:	89 df                	mov    %ebx,%edi
  800eff:	89 de                	mov    %ebx,%esi
  800f01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	7f 08                	jg     800f0f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0a:	5b                   	pop    %ebx
  800f0b:	5e                   	pop    %esi
  800f0c:	5f                   	pop    %edi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0f:	83 ec 0c             	sub    $0xc,%esp
  800f12:	50                   	push   %eax
  800f13:	6a 09                	push   $0x9
  800f15:	68 1f 2e 80 00       	push   $0x802e1f
  800f1a:	6a 23                	push   $0x23
  800f1c:	68 3c 2e 80 00       	push   $0x802e3c
  800f21:	e8 0c f4 ff ff       	call   800332 <_panic>

00800f26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
  800f2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3f:	89 df                	mov    %ebx,%edi
  800f41:	89 de                	mov    %ebx,%esi
  800f43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f45:	85 c0                	test   %eax,%eax
  800f47:	7f 08                	jg     800f51 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f51:	83 ec 0c             	sub    $0xc,%esp
  800f54:	50                   	push   %eax
  800f55:	6a 0a                	push   $0xa
  800f57:	68 1f 2e 80 00       	push   $0x802e1f
  800f5c:	6a 23                	push   $0x23
  800f5e:	68 3c 2e 80 00       	push   $0x802e3c
  800f63:	e8 ca f3 ff ff       	call   800332 <_panic>

00800f68 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f79:	be 00 00 00 00       	mov    $0x0,%esi
  800f7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f84:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa1:	89 cb                	mov    %ecx,%ebx
  800fa3:	89 cf                	mov    %ecx,%edi
  800fa5:	89 ce                	mov    %ecx,%esi
  800fa7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7f 08                	jg     800fb5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb5:	83 ec 0c             	sub    $0xc,%esp
  800fb8:	50                   	push   %eax
  800fb9:	6a 0d                	push   $0xd
  800fbb:	68 1f 2e 80 00       	push   $0x802e1f
  800fc0:	6a 23                	push   $0x23
  800fc2:	68 3c 2e 80 00       	push   $0x802e3c
  800fc7:	e8 66 f3 ff ff       	call   800332 <_panic>

00800fcc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fdc:	89 d1                	mov    %edx,%ecx
  800fde:	89 d3                	mov    %edx,%ebx
  800fe0:	89 d7                	mov    %edx,%edi
  800fe2:	89 d6                	mov    %edx,%esi
  800fe4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 0c             	sub    $0xc,%esp
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ff7:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ff9:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800ffc:	89 d9                	mov    %ebx,%ecx
  800ffe:	c1 e9 16             	shr    $0x16,%ecx
  801001:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  801008:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  80100d:	f6 c1 01             	test   $0x1,%cl
  801010:	74 0c                	je     80101e <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  801012:	89 d9                	mov    %ebx,%ecx
  801014:	c1 e9 0c             	shr    $0xc,%ecx
  801017:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  80101e:	f6 c2 02             	test   $0x2,%dl
  801021:	0f 84 a3 00 00 00    	je     8010ca <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  801027:	89 da                	mov    %ebx,%edx
  801029:	c1 ea 0c             	shr    $0xc,%edx
  80102c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801033:	f6 c6 08             	test   $0x8,%dh
  801036:	0f 84 b7 00 00 00    	je     8010f3 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  80103c:	e8 5c fd ff ff       	call   800d9d <sys_getenvid>
  801041:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	6a 07                	push   $0x7
  801048:	68 00 f0 7f 00       	push   $0x7ff000
  80104d:	50                   	push   %eax
  80104e:	e8 88 fd ff ff       	call   800ddb <sys_page_alloc>
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	85 c0                	test   %eax,%eax
  801058:	0f 88 bc 00 00 00    	js     80111a <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  80105e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  801064:	83 ec 04             	sub    $0x4,%esp
  801067:	68 00 10 00 00       	push   $0x1000
  80106c:	53                   	push   %ebx
  80106d:	68 00 f0 7f 00       	push   $0x7ff000
  801072:	e8 00 fb ff ff       	call   800b77 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  801077:	83 c4 08             	add    $0x8,%esp
  80107a:	53                   	push   %ebx
  80107b:	56                   	push   %esi
  80107c:	e8 df fd ff ff       	call   800e60 <sys_page_unmap>
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	85 c0                	test   %eax,%eax
  801086:	0f 88 a0 00 00 00    	js     80112c <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	6a 07                	push   $0x7
  801091:	53                   	push   %ebx
  801092:	56                   	push   %esi
  801093:	68 00 f0 7f 00       	push   $0x7ff000
  801098:	56                   	push   %esi
  801099:	e8 80 fd ff ff       	call   800e1e <sys_page_map>
  80109e:	83 c4 20             	add    $0x20,%esp
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	0f 88 95 00 00 00    	js     80113e <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	68 00 f0 7f 00       	push   $0x7ff000
  8010b1:	56                   	push   %esi
  8010b2:	e8 a9 fd ff ff       	call   800e60 <sys_page_unmap>
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	0f 88 8e 00 00 00    	js     801150 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  8010c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  8010ca:	8b 70 28             	mov    0x28(%eax),%esi
  8010cd:	e8 cb fc ff ff       	call   800d9d <sys_getenvid>
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	50                   	push   %eax
  8010d5:	68 4c 2e 80 00       	push   $0x802e4c
  8010da:	e8 2e f3 ff ff       	call   80040d <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  8010df:	83 c4 0c             	add    $0xc,%esp
  8010e2:	68 70 2e 80 00       	push   $0x802e70
  8010e7:	6a 27                	push   $0x27
  8010e9:	68 44 2f 80 00       	push   $0x802f44
  8010ee:	e8 3f f2 ff ff       	call   800332 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  8010f3:	8b 78 28             	mov    0x28(%eax),%edi
  8010f6:	e8 a2 fc ff ff       	call   800d9d <sys_getenvid>
  8010fb:	57                   	push   %edi
  8010fc:	53                   	push   %ebx
  8010fd:	50                   	push   %eax
  8010fe:	68 4c 2e 80 00       	push   $0x802e4c
  801103:	e8 05 f3 ff ff       	call   80040d <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801108:	56                   	push   %esi
  801109:	68 a4 2e 80 00       	push   $0x802ea4
  80110e:	6a 2b                	push   $0x2b
  801110:	68 44 2f 80 00       	push   $0x802f44
  801115:	e8 18 f2 ff ff       	call   800332 <_panic>
      panic("pgfault: page allocation failed %e", r);
  80111a:	50                   	push   %eax
  80111b:	68 dc 2e 80 00       	push   $0x802edc
  801120:	6a 39                	push   $0x39
  801122:	68 44 2f 80 00       	push   $0x802f44
  801127:	e8 06 f2 ff ff       	call   800332 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  80112c:	50                   	push   %eax
  80112d:	68 00 2f 80 00       	push   $0x802f00
  801132:	6a 3e                	push   $0x3e
  801134:	68 44 2f 80 00       	push   $0x802f44
  801139:	e8 f4 f1 ff ff       	call   800332 <_panic>
      panic("pgfault: page map failed (%e)", r);
  80113e:	50                   	push   %eax
  80113f:	68 4f 2f 80 00       	push   $0x802f4f
  801144:	6a 40                	push   $0x40
  801146:	68 44 2f 80 00       	push   $0x802f44
  80114b:	e8 e2 f1 ff ff       	call   800332 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801150:	50                   	push   %eax
  801151:	68 00 2f 80 00       	push   $0x802f00
  801156:	6a 42                	push   $0x42
  801158:	68 44 2f 80 00       	push   $0x802f44
  80115d:	e8 d0 f1 ff ff       	call   800332 <_panic>

00801162 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	57                   	push   %edi
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
  801168:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  80116b:	68 eb 0f 80 00       	push   $0x800feb
  801170:	e8 cd 13 00 00       	call   802542 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801175:	b8 07 00 00 00       	mov    $0x7,%eax
  80117a:	cd 30                	int    $0x30
  80117c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	78 2d                	js     8011b3 <fork+0x51>
  801186:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801188:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  80118d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801191:	0f 85 a6 00 00 00    	jne    80123d <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  801197:	e8 01 fc ff ff       	call   800d9d <sys_getenvid>
  80119c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011a9:	a3 08 50 80 00       	mov    %eax,0x805008
      return 0;
  8011ae:	e9 79 01 00 00       	jmp    80132c <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  8011b3:	50                   	push   %eax
  8011b4:	68 c5 29 80 00       	push   $0x8029c5
  8011b9:	68 aa 00 00 00       	push   $0xaa
  8011be:	68 44 2f 80 00       	push   $0x802f44
  8011c3:	e8 6a f1 ff ff       	call   800332 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	6a 05                	push   $0x5
  8011cd:	53                   	push   %ebx
  8011ce:	57                   	push   %edi
  8011cf:	53                   	push   %ebx
  8011d0:	6a 00                	push   $0x0
  8011d2:	e8 47 fc ff ff       	call   800e1e <sys_page_map>
  8011d7:	83 c4 20             	add    $0x20,%esp
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	79 4d                	jns    80122b <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8011de:	50                   	push   %eax
  8011df:	68 6d 2f 80 00       	push   $0x802f6d
  8011e4:	6a 61                	push   $0x61
  8011e6:	68 44 2f 80 00       	push   $0x802f44
  8011eb:	e8 42 f1 ff ff       	call   800332 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	68 05 08 00 00       	push   $0x805
  8011f8:	53                   	push   %ebx
  8011f9:	57                   	push   %edi
  8011fa:	53                   	push   %ebx
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 1c fc ff ff       	call   800e1e <sys_page_map>
  801202:	83 c4 20             	add    $0x20,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	0f 88 b7 00 00 00    	js     8012c4 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80120d:	83 ec 0c             	sub    $0xc,%esp
  801210:	68 05 08 00 00       	push   $0x805
  801215:	53                   	push   %ebx
  801216:	6a 00                	push   $0x0
  801218:	53                   	push   %ebx
  801219:	6a 00                	push   $0x0
  80121b:	e8 fe fb ff ff       	call   800e1e <sys_page_map>
  801220:	83 c4 20             	add    $0x20,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	0f 88 ab 00 00 00    	js     8012d6 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80122b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801231:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801237:	0f 84 ab 00 00 00    	je     8012e8 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  80123d:	89 d8                	mov    %ebx,%eax
  80123f:	c1 e8 16             	shr    $0x16,%eax
  801242:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801249:	a8 01                	test   $0x1,%al
  80124b:	74 de                	je     80122b <fork+0xc9>
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	c1 e8 0c             	shr    $0xc,%eax
  801252:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801259:	f6 c2 01             	test   $0x1,%dl
  80125c:	74 cd                	je     80122b <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  80125e:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801261:	89 c2                	mov    %eax,%edx
  801263:	c1 ea 16             	shr    $0x16,%edx
  801266:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80126d:	f6 c2 01             	test   $0x1,%dl
  801270:	74 b9                	je     80122b <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801272:	c1 e8 0c             	shr    $0xc,%eax
  801275:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  80127c:	a8 01                	test   $0x1,%al
  80127e:	74 ab                	je     80122b <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801280:	a9 02 08 00 00       	test   $0x802,%eax
  801285:	0f 84 3d ff ff ff    	je     8011c8 <fork+0x66>
	else if(pte & PTE_SHARE)
  80128b:	f6 c4 04             	test   $0x4,%ah
  80128e:	0f 84 5c ff ff ff    	je     8011f0 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	25 07 0e 00 00       	and    $0xe07,%eax
  80129c:	50                   	push   %eax
  80129d:	53                   	push   %ebx
  80129e:	57                   	push   %edi
  80129f:	53                   	push   %ebx
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 77 fb ff ff       	call   800e1e <sys_page_map>
  8012a7:	83 c4 20             	add    $0x20,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	0f 89 79 ff ff ff    	jns    80122b <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8012b2:	50                   	push   %eax
  8012b3:	68 6d 2f 80 00       	push   $0x802f6d
  8012b8:	6a 67                	push   $0x67
  8012ba:	68 44 2f 80 00       	push   $0x802f44
  8012bf:	e8 6e f0 ff ff       	call   800332 <_panic>
			panic("Page Map Failed: %e", error_code);
  8012c4:	50                   	push   %eax
  8012c5:	68 6d 2f 80 00       	push   $0x802f6d
  8012ca:	6a 6d                	push   $0x6d
  8012cc:	68 44 2f 80 00       	push   $0x802f44
  8012d1:	e8 5c f0 ff ff       	call   800332 <_panic>
			panic("Page Map Failed: %e", error_code);
  8012d6:	50                   	push   %eax
  8012d7:	68 6d 2f 80 00       	push   $0x802f6d
  8012dc:	6a 70                	push   $0x70
  8012de:	68 44 2f 80 00       	push   $0x802f44
  8012e3:	e8 4a f0 ff ff       	call   800332 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	6a 07                	push   $0x7
  8012ed:	68 00 f0 bf ee       	push   $0xeebff000
  8012f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f5:	e8 e1 fa ff ff       	call   800ddb <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 36                	js     801337 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	68 b8 25 80 00       	push   $0x8025b8
  801309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80130c:	e8 15 fc ff ff       	call   800f26 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 34                	js     80134c <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	6a 02                	push   $0x2
  80131d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801320:	e8 7d fb ff ff       	call   800ea2 <sys_env_set_status>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 35                	js     801361 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  80132c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5f                   	pop    %edi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801337:	50                   	push   %eax
  801338:	68 c5 29 80 00       	push   $0x8029c5
  80133d:	68 ba 00 00 00       	push   $0xba
  801342:	68 44 2f 80 00       	push   $0x802f44
  801347:	e8 e6 ef ff ff       	call   800332 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80134c:	50                   	push   %eax
  80134d:	68 20 2f 80 00       	push   $0x802f20
  801352:	68 bf 00 00 00       	push   $0xbf
  801357:	68 44 2f 80 00       	push   $0x802f44
  80135c:	e8 d1 ef ff ff       	call   800332 <_panic>
      panic("sys_env_set_status: %e", r);
  801361:	50                   	push   %eax
  801362:	68 81 2f 80 00       	push   $0x802f81
  801367:	68 c3 00 00 00       	push   $0xc3
  80136c:	68 44 2f 80 00       	push   $0x802f44
  801371:	e8 bc ef ff ff       	call   800332 <_panic>

00801376 <sfork>:

// Challenge!
int
sfork(void)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80137c:	68 98 2f 80 00       	push   $0x802f98
  801381:	68 cc 00 00 00       	push   $0xcc
  801386:	68 44 2f 80 00       	push   $0x802f44
  80138b:	e8 a2 ef ff ff       	call   800332 <_panic>

00801390 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	05 00 00 00 30       	add    $0x30000000,%eax
  80139b:	c1 e8 0c             	shr    $0xc,%eax
}
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	c1 ea 16             	shr    $0x16,%edx
  8013c4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013cb:	f6 c2 01             	test   $0x1,%dl
  8013ce:	74 2d                	je     8013fd <fd_alloc+0x46>
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 0c             	shr    $0xc,%edx
  8013d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013dc:	f6 c2 01             	test   $0x1,%dl
  8013df:	74 1c                	je     8013fd <fd_alloc+0x46>
  8013e1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013e6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013eb:	75 d2                	jne    8013bf <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013f6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013fb:	eb 0a                	jmp    801407 <fd_alloc+0x50>
			*fd_store = fd;
  8013fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801400:	89 01                	mov    %eax,(%ecx)
			return 0;
  801402:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801407:	5d                   	pop    %ebp
  801408:	c3                   	ret    

00801409 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80140f:	83 f8 1f             	cmp    $0x1f,%eax
  801412:	77 30                	ja     801444 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801414:	c1 e0 0c             	shl    $0xc,%eax
  801417:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80141c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801422:	f6 c2 01             	test   $0x1,%dl
  801425:	74 24                	je     80144b <fd_lookup+0x42>
  801427:	89 c2                	mov    %eax,%edx
  801429:	c1 ea 0c             	shr    $0xc,%edx
  80142c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801433:	f6 c2 01             	test   $0x1,%dl
  801436:	74 1a                	je     801452 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	89 02                	mov    %eax,(%edx)
	return 0;
  80143d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    
		return -E_INVAL;
  801444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801449:	eb f7                	jmp    801442 <fd_lookup+0x39>
		return -E_INVAL;
  80144b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801450:	eb f0                	jmp    801442 <fd_lookup+0x39>
  801452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801457:	eb e9                	jmp    801442 <fd_lookup+0x39>

00801459 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801462:	ba 00 00 00 00       	mov    $0x0,%edx
  801467:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80146c:	39 08                	cmp    %ecx,(%eax)
  80146e:	74 38                	je     8014a8 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801470:	83 c2 01             	add    $0x1,%edx
  801473:	8b 04 95 2c 30 80 00 	mov    0x80302c(,%edx,4),%eax
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 ee                	jne    80146c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80147e:	a1 08 50 80 00       	mov    0x805008,%eax
  801483:	8b 40 48             	mov    0x48(%eax),%eax
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	51                   	push   %ecx
  80148a:	50                   	push   %eax
  80148b:	68 b0 2f 80 00       	push   $0x802fb0
  801490:	e8 78 ef ff ff       	call   80040d <cprintf>
	*dev = 0;
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    
			*dev = devtab[i];
  8014a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ab:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	eb f2                	jmp    8014a6 <dev_lookup+0x4d>

008014b4 <fd_close>:
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	57                   	push   %edi
  8014b8:	56                   	push   %esi
  8014b9:	53                   	push   %ebx
  8014ba:	83 ec 24             	sub    $0x24,%esp
  8014bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8014c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014cd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d0:	50                   	push   %eax
  8014d1:	e8 33 ff ff ff       	call   801409 <fd_lookup>
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 05                	js     8014e4 <fd_close+0x30>
	    || fd != fd2)
  8014df:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014e2:	74 16                	je     8014fa <fd_close+0x46>
		return (must_exist ? r : 0);
  8014e4:	89 f8                	mov    %edi,%eax
  8014e6:	84 c0                	test   %al,%al
  8014e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ed:	0f 44 d8             	cmove  %eax,%ebx
}
  8014f0:	89 d8                	mov    %ebx,%eax
  8014f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5f                   	pop    %edi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801500:	50                   	push   %eax
  801501:	ff 36                	pushl  (%esi)
  801503:	e8 51 ff ff ff       	call   801459 <dev_lookup>
  801508:	89 c3                	mov    %eax,%ebx
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 1a                	js     80152b <fd_close+0x77>
		if (dev->dev_close)
  801511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801514:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801517:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80151c:	85 c0                	test   %eax,%eax
  80151e:	74 0b                	je     80152b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801520:	83 ec 0c             	sub    $0xc,%esp
  801523:	56                   	push   %esi
  801524:	ff d0                	call   *%eax
  801526:	89 c3                	mov    %eax,%ebx
  801528:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	56                   	push   %esi
  80152f:	6a 00                	push   $0x0
  801531:	e8 2a f9 ff ff       	call   800e60 <sys_page_unmap>
	return r;
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	eb b5                	jmp    8014f0 <fd_close+0x3c>

0080153b <close>:

int
close(int fdnum)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	ff 75 08             	pushl  0x8(%ebp)
  801548:	e8 bc fe ff ff       	call   801409 <fd_lookup>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	79 02                	jns    801556 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    
		return fd_close(fd, 1);
  801556:	83 ec 08             	sub    $0x8,%esp
  801559:	6a 01                	push   $0x1
  80155b:	ff 75 f4             	pushl  -0xc(%ebp)
  80155e:	e8 51 ff ff ff       	call   8014b4 <fd_close>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	eb ec                	jmp    801554 <close+0x19>

00801568 <close_all>:

void
close_all(void)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	53                   	push   %ebx
  80156c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80156f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	53                   	push   %ebx
  801578:	e8 be ff ff ff       	call   80153b <close>
	for (i = 0; i < MAXFD; i++)
  80157d:	83 c3 01             	add    $0x1,%ebx
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	83 fb 20             	cmp    $0x20,%ebx
  801586:	75 ec                	jne    801574 <close_all+0xc>
}
  801588:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	57                   	push   %edi
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801596:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	e8 67 fe ff ff       	call   801409 <fd_lookup>
  8015a2:	89 c3                	mov    %eax,%ebx
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	0f 88 81 00 00 00    	js     801630 <dup+0xa3>
		return r;
	close(newfdnum);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 0c             	pushl  0xc(%ebp)
  8015b5:	e8 81 ff ff ff       	call   80153b <close>

	newfd = INDEX2FD(newfdnum);
  8015ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015bd:	c1 e6 0c             	shl    $0xc,%esi
  8015c0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015c6:	83 c4 04             	add    $0x4,%esp
  8015c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cc:	e8 cf fd ff ff       	call   8013a0 <fd2data>
  8015d1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015d3:	89 34 24             	mov    %esi,(%esp)
  8015d6:	e8 c5 fd ff ff       	call   8013a0 <fd2data>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	c1 e8 16             	shr    $0x16,%eax
  8015e5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ec:	a8 01                	test   $0x1,%al
  8015ee:	74 11                	je     801601 <dup+0x74>
  8015f0:	89 d8                	mov    %ebx,%eax
  8015f2:	c1 e8 0c             	shr    $0xc,%eax
  8015f5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015fc:	f6 c2 01             	test   $0x1,%dl
  8015ff:	75 39                	jne    80163a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801601:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801604:	89 d0                	mov    %edx,%eax
  801606:	c1 e8 0c             	shr    $0xc,%eax
  801609:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	25 07 0e 00 00       	and    $0xe07,%eax
  801618:	50                   	push   %eax
  801619:	56                   	push   %esi
  80161a:	6a 00                	push   $0x0
  80161c:	52                   	push   %edx
  80161d:	6a 00                	push   $0x0
  80161f:	e8 fa f7 ff ff       	call   800e1e <sys_page_map>
  801624:	89 c3                	mov    %eax,%ebx
  801626:	83 c4 20             	add    $0x20,%esp
  801629:	85 c0                	test   %eax,%eax
  80162b:	78 31                	js     80165e <dup+0xd1>
		goto err;

	return newfdnum;
  80162d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801630:	89 d8                	mov    %ebx,%eax
  801632:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801635:	5b                   	pop    %ebx
  801636:	5e                   	pop    %esi
  801637:	5f                   	pop    %edi
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80163a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	25 07 0e 00 00       	and    $0xe07,%eax
  801649:	50                   	push   %eax
  80164a:	57                   	push   %edi
  80164b:	6a 00                	push   $0x0
  80164d:	53                   	push   %ebx
  80164e:	6a 00                	push   $0x0
  801650:	e8 c9 f7 ff ff       	call   800e1e <sys_page_map>
  801655:	89 c3                	mov    %eax,%ebx
  801657:	83 c4 20             	add    $0x20,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	79 a3                	jns    801601 <dup+0x74>
	sys_page_unmap(0, newfd);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	56                   	push   %esi
  801662:	6a 00                	push   $0x0
  801664:	e8 f7 f7 ff ff       	call   800e60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801669:	83 c4 08             	add    $0x8,%esp
  80166c:	57                   	push   %edi
  80166d:	6a 00                	push   $0x0
  80166f:	e8 ec f7 ff ff       	call   800e60 <sys_page_unmap>
	return r;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	eb b7                	jmp    801630 <dup+0xa3>

00801679 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	53                   	push   %ebx
  80167d:	83 ec 1c             	sub    $0x1c,%esp
  801680:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801683:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801686:	50                   	push   %eax
  801687:	53                   	push   %ebx
  801688:	e8 7c fd ff ff       	call   801409 <fd_lookup>
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	85 c0                	test   %eax,%eax
  801692:	78 3f                	js     8016d3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169a:	50                   	push   %eax
  80169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169e:	ff 30                	pushl  (%eax)
  8016a0:	e8 b4 fd ff ff       	call   801459 <dev_lookup>
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	78 27                	js     8016d3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016af:	8b 42 08             	mov    0x8(%edx),%eax
  8016b2:	83 e0 03             	and    $0x3,%eax
  8016b5:	83 f8 01             	cmp    $0x1,%eax
  8016b8:	74 1e                	je     8016d8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	8b 40 08             	mov    0x8(%eax),%eax
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	74 35                	je     8016f9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	ff 75 10             	pushl  0x10(%ebp)
  8016ca:	ff 75 0c             	pushl  0xc(%ebp)
  8016cd:	52                   	push   %edx
  8016ce:	ff d0                	call   *%eax
  8016d0:	83 c4 10             	add    $0x10,%esp
}
  8016d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016d8:	a1 08 50 80 00       	mov    0x805008,%eax
  8016dd:	8b 40 48             	mov    0x48(%eax),%eax
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	53                   	push   %ebx
  8016e4:	50                   	push   %eax
  8016e5:	68 f1 2f 80 00       	push   $0x802ff1
  8016ea:	e8 1e ed ff ff       	call   80040d <cprintf>
		return -E_INVAL;
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f7:	eb da                	jmp    8016d3 <read+0x5a>
		return -E_NOT_SUPP;
  8016f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fe:	eb d3                	jmp    8016d3 <read+0x5a>

00801700 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	57                   	push   %edi
  801704:	56                   	push   %esi
  801705:	53                   	push   %ebx
  801706:	83 ec 0c             	sub    $0xc,%esp
  801709:	8b 7d 08             	mov    0x8(%ebp),%edi
  80170c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80170f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801714:	39 f3                	cmp    %esi,%ebx
  801716:	73 23                	jae    80173b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	89 f0                	mov    %esi,%eax
  80171d:	29 d8                	sub    %ebx,%eax
  80171f:	50                   	push   %eax
  801720:	89 d8                	mov    %ebx,%eax
  801722:	03 45 0c             	add    0xc(%ebp),%eax
  801725:	50                   	push   %eax
  801726:	57                   	push   %edi
  801727:	e8 4d ff ff ff       	call   801679 <read>
		if (m < 0)
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 06                	js     801739 <readn+0x39>
			return m;
		if (m == 0)
  801733:	74 06                	je     80173b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801735:	01 c3                	add    %eax,%ebx
  801737:	eb db                	jmp    801714 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801739:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80173b:	89 d8                	mov    %ebx,%eax
  80173d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801740:	5b                   	pop    %ebx
  801741:	5e                   	pop    %esi
  801742:	5f                   	pop    %edi
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 1c             	sub    $0x1c,%esp
  80174c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	53                   	push   %ebx
  801754:	e8 b0 fc ff ff       	call   801409 <fd_lookup>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 3a                	js     80179a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	ff 30                	pushl  (%eax)
  80176c:	e8 e8 fc ff ff       	call   801459 <dev_lookup>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 22                	js     80179a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80177f:	74 1e                	je     80179f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801784:	8b 52 0c             	mov    0xc(%edx),%edx
  801787:	85 d2                	test   %edx,%edx
  801789:	74 35                	je     8017c0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	ff 75 10             	pushl  0x10(%ebp)
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	50                   	push   %eax
  801795:	ff d2                	call   *%edx
  801797:	83 c4 10             	add    $0x10,%esp
}
  80179a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80179f:	a1 08 50 80 00       	mov    0x805008,%eax
  8017a4:	8b 40 48             	mov    0x48(%eax),%eax
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	53                   	push   %ebx
  8017ab:	50                   	push   %eax
  8017ac:	68 0d 30 80 00       	push   $0x80300d
  8017b1:	e8 57 ec ff ff       	call   80040d <cprintf>
		return -E_INVAL;
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017be:	eb da                	jmp    80179a <write+0x55>
		return -E_NOT_SUPP;
  8017c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c5:	eb d3                	jmp    80179a <write+0x55>

008017c7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	ff 75 08             	pushl  0x8(%ebp)
  8017d4:	e8 30 fc ff ff       	call   801409 <fd_lookup>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 0e                	js     8017ee <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 1c             	sub    $0x1c,%esp
  8017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fd:	50                   	push   %eax
  8017fe:	53                   	push   %ebx
  8017ff:	e8 05 fc ff ff       	call   801409 <fd_lookup>
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 37                	js     801842 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801811:	50                   	push   %eax
  801812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801815:	ff 30                	pushl  (%eax)
  801817:	e8 3d fc ff ff       	call   801459 <dev_lookup>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 1f                	js     801842 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801826:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80182a:	74 1b                	je     801847 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80182c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182f:	8b 52 18             	mov    0x18(%edx),%edx
  801832:	85 d2                	test   %edx,%edx
  801834:	74 32                	je     801868 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	50                   	push   %eax
  80183d:	ff d2                	call   *%edx
  80183f:	83 c4 10             	add    $0x10,%esp
}
  801842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801845:	c9                   	leave  
  801846:	c3                   	ret    
			thisenv->env_id, fdnum);
  801847:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80184c:	8b 40 48             	mov    0x48(%eax),%eax
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	53                   	push   %ebx
  801853:	50                   	push   %eax
  801854:	68 d0 2f 80 00       	push   $0x802fd0
  801859:	e8 af eb ff ff       	call   80040d <cprintf>
		return -E_INVAL;
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801866:	eb da                	jmp    801842 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801868:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186d:	eb d3                	jmp    801842 <ftruncate+0x52>

0080186f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	83 ec 1c             	sub    $0x1c,%esp
  801876:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801879:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187c:	50                   	push   %eax
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	e8 84 fb ff ff       	call   801409 <fd_lookup>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 4b                	js     8018d7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801892:	50                   	push   %eax
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	ff 30                	pushl  (%eax)
  801898:	e8 bc fb ff ff       	call   801459 <dev_lookup>
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 33                	js     8018d7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018ab:	74 2f                	je     8018dc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018ad:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018b0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018b7:	00 00 00 
	stat->st_isdir = 0;
  8018ba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018c1:	00 00 00 
	stat->st_dev = dev;
  8018c4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	53                   	push   %ebx
  8018ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d1:	ff 50 14             	call   *0x14(%eax)
  8018d4:	83 c4 10             	add    $0x10,%esp
}
  8018d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    
		return -E_NOT_SUPP;
  8018dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e1:	eb f4                	jmp    8018d7 <fstat+0x68>

008018e3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	6a 00                	push   $0x0
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	e8 2f 02 00 00       	call   801b24 <open>
  8018f5:	89 c3                	mov    %eax,%ebx
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 1b                	js     801919 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018fe:	83 ec 08             	sub    $0x8,%esp
  801901:	ff 75 0c             	pushl  0xc(%ebp)
  801904:	50                   	push   %eax
  801905:	e8 65 ff ff ff       	call   80186f <fstat>
  80190a:	89 c6                	mov    %eax,%esi
	close(fd);
  80190c:	89 1c 24             	mov    %ebx,(%esp)
  80190f:	e8 27 fc ff ff       	call   80153b <close>
	return r;
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	89 f3                	mov    %esi,%ebx
}
  801919:	89 d8                	mov    %ebx,%eax
  80191b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    

00801922 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
  801927:	89 c6                	mov    %eax,%esi
  801929:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80192b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801932:	74 27                	je     80195b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801934:	6a 07                	push   $0x7
  801936:	68 00 60 80 00       	push   $0x806000
  80193b:	56                   	push   %esi
  80193c:	ff 35 00 50 80 00    	pushl  0x805000
  801942:	e8 0b 0d 00 00       	call   802652 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801947:	83 c4 0c             	add    $0xc,%esp
  80194a:	6a 00                	push   $0x0
  80194c:	53                   	push   %ebx
  80194d:	6a 00                	push   $0x0
  80194f:	e8 8b 0c 00 00       	call   8025df <ipc_recv>
}
  801954:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80195b:	83 ec 0c             	sub    $0xc,%esp
  80195e:	6a 01                	push   $0x1
  801960:	e8 59 0d 00 00       	call   8026be <ipc_find_env>
  801965:	a3 00 50 80 00       	mov    %eax,0x805000
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	eb c5                	jmp    801934 <fsipc+0x12>

0080196f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8b 40 0c             	mov    0xc(%eax),%eax
  80197b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801988:	ba 00 00 00 00       	mov    $0x0,%edx
  80198d:	b8 02 00 00 00       	mov    $0x2,%eax
  801992:	e8 8b ff ff ff       	call   801922 <fsipc>
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <devfile_flush>:
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 06 00 00 00       	mov    $0x6,%eax
  8019b4:	e8 69 ff ff ff       	call   801922 <fsipc>
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <devfile_stat>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	53                   	push   %ebx
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cb:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d5:	b8 05 00 00 00       	mov    $0x5,%eax
  8019da:	e8 43 ff ff ff       	call   801922 <fsipc>
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 2c                	js     801a0f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	68 00 60 80 00       	push   $0x806000
  8019eb:	53                   	push   %ebx
  8019ec:	e8 f8 ef ff ff       	call   8009e9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019f1:	a1 80 60 80 00       	mov    0x806080,%eax
  8019f6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019fc:	a1 84 60 80 00       	mov    0x806084,%eax
  801a01:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <devfile_write>:
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	53                   	push   %ebx
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801a1e:	85 db                	test   %ebx,%ebx
  801a20:	75 07                	jne    801a29 <devfile_write+0x15>
	return n_all;
  801a22:	89 d8                	mov    %ebx,%eax
}
  801a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2f:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  801a34:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	53                   	push   %ebx
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	68 08 60 80 00       	push   $0x806008
  801a46:	e8 2c f1 ff ff       	call   800b77 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	b8 04 00 00 00       	mov    $0x4,%eax
  801a55:	e8 c8 fe ff ff       	call   801922 <fsipc>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 c3                	js     801a24 <devfile_write+0x10>
	  assert(r <= n_left);
  801a61:	39 d8                	cmp    %ebx,%eax
  801a63:	77 0b                	ja     801a70 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801a65:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6a:	7f 1d                	jg     801a89 <devfile_write+0x75>
    n_all += r;
  801a6c:	89 c3                	mov    %eax,%ebx
  801a6e:	eb b2                	jmp    801a22 <devfile_write+0xe>
	  assert(r <= n_left);
  801a70:	68 40 30 80 00       	push   $0x803040
  801a75:	68 4c 30 80 00       	push   $0x80304c
  801a7a:	68 9f 00 00 00       	push   $0x9f
  801a7f:	68 61 30 80 00       	push   $0x803061
  801a84:	e8 a9 e8 ff ff       	call   800332 <_panic>
	  assert(r <= PGSIZE);
  801a89:	68 6c 30 80 00       	push   $0x80306c
  801a8e:	68 4c 30 80 00       	push   $0x80304c
  801a93:	68 a0 00 00 00       	push   $0xa0
  801a98:	68 61 30 80 00       	push   $0x803061
  801a9d:	e8 90 e8 ff ff       	call   800332 <_panic>

00801aa2 <devfile_read>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ab5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801abb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac5:	e8 58 fe ff ff       	call   801922 <fsipc>
  801aca:	89 c3                	mov    %eax,%ebx
  801acc:	85 c0                	test   %eax,%eax
  801ace:	78 1f                	js     801aef <devfile_read+0x4d>
	assert(r <= n);
  801ad0:	39 f0                	cmp    %esi,%eax
  801ad2:	77 24                	ja     801af8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ad4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad9:	7f 33                	jg     801b0e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	50                   	push   %eax
  801adf:	68 00 60 80 00       	push   $0x806000
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	e8 8b f0 ff ff       	call   800b77 <memmove>
	return r;
  801aec:	83 c4 10             	add    $0x10,%esp
}
  801aef:	89 d8                	mov    %ebx,%eax
  801af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
	assert(r <= n);
  801af8:	68 78 30 80 00       	push   $0x803078
  801afd:	68 4c 30 80 00       	push   $0x80304c
  801b02:	6a 7c                	push   $0x7c
  801b04:	68 61 30 80 00       	push   $0x803061
  801b09:	e8 24 e8 ff ff       	call   800332 <_panic>
	assert(r <= PGSIZE);
  801b0e:	68 6c 30 80 00       	push   $0x80306c
  801b13:	68 4c 30 80 00       	push   $0x80304c
  801b18:	6a 7d                	push   $0x7d
  801b1a:	68 61 30 80 00       	push   $0x803061
  801b1f:	e8 0e e8 ff ff       	call   800332 <_panic>

00801b24 <open>:
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
  801b29:	83 ec 1c             	sub    $0x1c,%esp
  801b2c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b2f:	56                   	push   %esi
  801b30:	e8 7b ee ff ff       	call   8009b0 <strlen>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b3d:	7f 6c                	jg     801bab <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b45:	50                   	push   %eax
  801b46:	e8 6c f8 ff ff       	call   8013b7 <fd_alloc>
  801b4b:	89 c3                	mov    %eax,%ebx
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 3c                	js     801b90 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	56                   	push   %esi
  801b58:	68 00 60 80 00       	push   $0x806000
  801b5d:	e8 87 ee ff ff       	call   8009e9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b65:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	e8 ab fd ff ff       	call   801922 <fsipc>
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 19                	js     801b99 <open+0x75>
	return fd2num(fd);
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	ff 75 f4             	pushl  -0xc(%ebp)
  801b86:	e8 05 f8 ff ff       	call   801390 <fd2num>
  801b8b:	89 c3                	mov    %eax,%ebx
  801b8d:	83 c4 10             	add    $0x10,%esp
}
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b95:	5b                   	pop    %ebx
  801b96:	5e                   	pop    %esi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    
		fd_close(fd, 0);
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba1:	e8 0e f9 ff ff       	call   8014b4 <fd_close>
		return r;
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	eb e5                	jmp    801b90 <open+0x6c>
		return -E_BAD_PATH;
  801bab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bb0:	eb de                	jmp    801b90 <open+0x6c>

00801bb2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbd:	b8 08 00 00 00       	mov    $0x8,%eax
  801bc2:	e8 5b fd ff ff       	call   801922 <fsipc>
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
  801bce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	e8 c4 f7 ff ff       	call   8013a0 <fd2data>
  801bdc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bde:	83 c4 08             	add    $0x8,%esp
  801be1:	68 7f 30 80 00       	push   $0x80307f
  801be6:	53                   	push   %ebx
  801be7:	e8 fd ed ff ff       	call   8009e9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bec:	8b 46 04             	mov    0x4(%esi),%eax
  801bef:	2b 06                	sub    (%esi),%eax
  801bf1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bf7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bfe:	00 00 00 
	stat->st_dev = &devpipe;
  801c01:	c7 83 88 00 00 00 24 	movl   $0x804024,0x88(%ebx)
  801c08:	40 80 00 
	return 0;
}
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	53                   	push   %ebx
  801c1b:	83 ec 0c             	sub    $0xc,%esp
  801c1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c21:	53                   	push   %ebx
  801c22:	6a 00                	push   $0x0
  801c24:	e8 37 f2 ff ff       	call   800e60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c29:	89 1c 24             	mov    %ebx,(%esp)
  801c2c:	e8 6f f7 ff ff       	call   8013a0 <fd2data>
  801c31:	83 c4 08             	add    $0x8,%esp
  801c34:	50                   	push   %eax
  801c35:	6a 00                	push   $0x0
  801c37:	e8 24 f2 ff ff       	call   800e60 <sys_page_unmap>
}
  801c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <_pipeisclosed>:
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	57                   	push   %edi
  801c45:	56                   	push   %esi
  801c46:	53                   	push   %ebx
  801c47:	83 ec 1c             	sub    $0x1c,%esp
  801c4a:	89 c7                	mov    %eax,%edi
  801c4c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c4e:	a1 08 50 80 00       	mov    0x805008,%eax
  801c53:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	57                   	push   %edi
  801c5a:	e8 98 0a 00 00       	call   8026f7 <pageref>
  801c5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c62:	89 34 24             	mov    %esi,(%esp)
  801c65:	e8 8d 0a 00 00       	call   8026f7 <pageref>
		nn = thisenv->env_runs;
  801c6a:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801c70:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	39 cb                	cmp    %ecx,%ebx
  801c78:	74 1b                	je     801c95 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c7a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c7d:	75 cf                	jne    801c4e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c7f:	8b 42 58             	mov    0x58(%edx),%eax
  801c82:	6a 01                	push   $0x1
  801c84:	50                   	push   %eax
  801c85:	53                   	push   %ebx
  801c86:	68 86 30 80 00       	push   $0x803086
  801c8b:	e8 7d e7 ff ff       	call   80040d <cprintf>
  801c90:	83 c4 10             	add    $0x10,%esp
  801c93:	eb b9                	jmp    801c4e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c95:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c98:	0f 94 c0             	sete   %al
  801c9b:	0f b6 c0             	movzbl %al,%eax
}
  801c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <devpipe_write>:
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	57                   	push   %edi
  801caa:	56                   	push   %esi
  801cab:	53                   	push   %ebx
  801cac:	83 ec 28             	sub    $0x28,%esp
  801caf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cb2:	56                   	push   %esi
  801cb3:	e8 e8 f6 ff ff       	call   8013a0 <fd2data>
  801cb8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  801cc2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cc5:	74 4f                	je     801d16 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cc7:	8b 43 04             	mov    0x4(%ebx),%eax
  801cca:	8b 0b                	mov    (%ebx),%ecx
  801ccc:	8d 51 20             	lea    0x20(%ecx),%edx
  801ccf:	39 d0                	cmp    %edx,%eax
  801cd1:	72 14                	jb     801ce7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801cd3:	89 da                	mov    %ebx,%edx
  801cd5:	89 f0                	mov    %esi,%eax
  801cd7:	e8 65 ff ff ff       	call   801c41 <_pipeisclosed>
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	75 3b                	jne    801d1b <devpipe_write+0x75>
			sys_yield();
  801ce0:	e8 d7 f0 ff ff       	call   800dbc <sys_yield>
  801ce5:	eb e0                	jmp    801cc7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cf1:	89 c2                	mov    %eax,%edx
  801cf3:	c1 fa 1f             	sar    $0x1f,%edx
  801cf6:	89 d1                	mov    %edx,%ecx
  801cf8:	c1 e9 1b             	shr    $0x1b,%ecx
  801cfb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cfe:	83 e2 1f             	and    $0x1f,%edx
  801d01:	29 ca                	sub    %ecx,%edx
  801d03:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d07:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d0b:	83 c0 01             	add    $0x1,%eax
  801d0e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d11:	83 c7 01             	add    $0x1,%edi
  801d14:	eb ac                	jmp    801cc2 <devpipe_write+0x1c>
	return i;
  801d16:	8b 45 10             	mov    0x10(%ebp),%eax
  801d19:	eb 05                	jmp    801d20 <devpipe_write+0x7a>
				return 0;
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5f                   	pop    %edi
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    

00801d28 <devpipe_read>:
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	57                   	push   %edi
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 18             	sub    $0x18,%esp
  801d31:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d34:	57                   	push   %edi
  801d35:	e8 66 f6 ff ff       	call   8013a0 <fd2data>
  801d3a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	be 00 00 00 00       	mov    $0x0,%esi
  801d44:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d47:	75 14                	jne    801d5d <devpipe_read+0x35>
	return i;
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	eb 02                	jmp    801d50 <devpipe_read+0x28>
				return i;
  801d4e:	89 f0                	mov    %esi,%eax
}
  801d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
			sys_yield();
  801d58:	e8 5f f0 ff ff       	call   800dbc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d5d:	8b 03                	mov    (%ebx),%eax
  801d5f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d62:	75 18                	jne    801d7c <devpipe_read+0x54>
			if (i > 0)
  801d64:	85 f6                	test   %esi,%esi
  801d66:	75 e6                	jne    801d4e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d68:	89 da                	mov    %ebx,%edx
  801d6a:	89 f8                	mov    %edi,%eax
  801d6c:	e8 d0 fe ff ff       	call   801c41 <_pipeisclosed>
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 e3                	je     801d58 <devpipe_read+0x30>
				return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	eb d4                	jmp    801d50 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d7c:	99                   	cltd   
  801d7d:	c1 ea 1b             	shr    $0x1b,%edx
  801d80:	01 d0                	add    %edx,%eax
  801d82:	83 e0 1f             	and    $0x1f,%eax
  801d85:	29 d0                	sub    %edx,%eax
  801d87:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d92:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d95:	83 c6 01             	add    $0x1,%esi
  801d98:	eb aa                	jmp    801d44 <devpipe_read+0x1c>

00801d9a <pipe>:
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	56                   	push   %esi
  801d9e:	53                   	push   %ebx
  801d9f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801da2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da5:	50                   	push   %eax
  801da6:	e8 0c f6 ff ff       	call   8013b7 <fd_alloc>
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	85 c0                	test   %eax,%eax
  801db2:	0f 88 23 01 00 00    	js     801edb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	68 07 04 00 00       	push   $0x407
  801dc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc3:	6a 00                	push   $0x0
  801dc5:	e8 11 f0 ff ff       	call   800ddb <sys_page_alloc>
  801dca:	89 c3                	mov    %eax,%ebx
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	0f 88 04 01 00 00    	js     801edb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ddd:	50                   	push   %eax
  801dde:	e8 d4 f5 ff ff       	call   8013b7 <fd_alloc>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	0f 88 db 00 00 00    	js     801ecb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	68 07 04 00 00       	push   $0x407
  801df8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfb:	6a 00                	push   $0x0
  801dfd:	e8 d9 ef ff ff       	call   800ddb <sys_page_alloc>
  801e02:	89 c3                	mov    %eax,%ebx
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	85 c0                	test   %eax,%eax
  801e09:	0f 88 bc 00 00 00    	js     801ecb <pipe+0x131>
	va = fd2data(fd0);
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	ff 75 f4             	pushl  -0xc(%ebp)
  801e15:	e8 86 f5 ff ff       	call   8013a0 <fd2data>
  801e1a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1c:	83 c4 0c             	add    $0xc,%esp
  801e1f:	68 07 04 00 00       	push   $0x407
  801e24:	50                   	push   %eax
  801e25:	6a 00                	push   $0x0
  801e27:	e8 af ef ff ff       	call   800ddb <sys_page_alloc>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	85 c0                	test   %eax,%eax
  801e33:	0f 88 82 00 00 00    	js     801ebb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3f:	e8 5c f5 ff ff       	call   8013a0 <fd2data>
  801e44:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e4b:	50                   	push   %eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	56                   	push   %esi
  801e4f:	6a 00                	push   $0x0
  801e51:	e8 c8 ef ff ff       	call   800e1e <sys_page_map>
  801e56:	89 c3                	mov    %eax,%ebx
  801e58:	83 c4 20             	add    $0x20,%esp
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	78 4e                	js     801ead <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e5f:	a1 24 40 80 00       	mov    0x804024,%eax
  801e64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e67:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e76:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	ff 75 f4             	pushl  -0xc(%ebp)
  801e88:	e8 03 f5 ff ff       	call   801390 <fd2num>
  801e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e90:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e92:	83 c4 04             	add    $0x4,%esp
  801e95:	ff 75 f0             	pushl  -0x10(%ebp)
  801e98:	e8 f3 f4 ff ff       	call   801390 <fd2num>
  801e9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eab:	eb 2e                	jmp    801edb <pipe+0x141>
	sys_page_unmap(0, va);
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	56                   	push   %esi
  801eb1:	6a 00                	push   $0x0
  801eb3:	e8 a8 ef ff ff       	call   800e60 <sys_page_unmap>
  801eb8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ebb:	83 ec 08             	sub    $0x8,%esp
  801ebe:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec1:	6a 00                	push   $0x0
  801ec3:	e8 98 ef ff ff       	call   800e60 <sys_page_unmap>
  801ec8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ecb:	83 ec 08             	sub    $0x8,%esp
  801ece:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed1:	6a 00                	push   $0x0
  801ed3:	e8 88 ef ff ff       	call   800e60 <sys_page_unmap>
  801ed8:	83 c4 10             	add    $0x10,%esp
}
  801edb:	89 d8                	mov    %ebx,%eax
  801edd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <pipeisclosed>:
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eed:	50                   	push   %eax
  801eee:	ff 75 08             	pushl  0x8(%ebp)
  801ef1:	e8 13 f5 ff ff       	call   801409 <fd_lookup>
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	78 18                	js     801f15 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 f4             	pushl  -0xc(%ebp)
  801f03:	e8 98 f4 ff ff       	call   8013a0 <fd2data>
	return _pipeisclosed(fd, p);
  801f08:	89 c2                	mov    %eax,%edx
  801f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0d:	e8 2f fd ff ff       	call   801c41 <_pipeisclosed>
  801f12:	83 c4 10             	add    $0x10,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f1f:	85 f6                	test   %esi,%esi
  801f21:	74 13                	je     801f36 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801f23:	89 f3                	mov    %esi,%ebx
  801f25:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f2b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801f2e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f34:	eb 1b                	jmp    801f51 <wait+0x3a>
	assert(envid != 0);
  801f36:	68 9e 30 80 00       	push   $0x80309e
  801f3b:	68 4c 30 80 00       	push   $0x80304c
  801f40:	6a 09                	push   $0x9
  801f42:	68 a9 30 80 00       	push   $0x8030a9
  801f47:	e8 e6 e3 ff ff       	call   800332 <_panic>
		sys_yield();
  801f4c:	e8 6b ee ff ff       	call   800dbc <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f51:	8b 43 48             	mov    0x48(%ebx),%eax
  801f54:	39 f0                	cmp    %esi,%eax
  801f56:	75 07                	jne    801f5f <wait+0x48>
  801f58:	8b 43 54             	mov    0x54(%ebx),%eax
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	75 ed                	jne    801f4c <wait+0x35>
}
  801f5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f62:	5b                   	pop    %ebx
  801f63:	5e                   	pop    %esi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f6c:	68 b4 30 80 00       	push   $0x8030b4
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	e8 70 ea ff ff       	call   8009e9 <strcpy>
	return 0;
}
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <devsock_close>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	53                   	push   %ebx
  801f84:	83 ec 10             	sub    $0x10,%esp
  801f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f8a:	53                   	push   %ebx
  801f8b:	e8 67 07 00 00       	call   8026f7 <pageref>
  801f90:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f93:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f98:	83 f8 01             	cmp    $0x1,%eax
  801f9b:	74 07                	je     801fa4 <devsock_close+0x24>
}
  801f9d:	89 d0                	mov    %edx,%eax
  801f9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fa4:	83 ec 0c             	sub    $0xc,%esp
  801fa7:	ff 73 0c             	pushl  0xc(%ebx)
  801faa:	e8 b9 02 00 00       	call   802268 <nsipc_close>
  801faf:	89 c2                	mov    %eax,%edx
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	eb e7                	jmp    801f9d <devsock_close+0x1d>

00801fb6 <devsock_write>:
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	ff 75 10             	pushl  0x10(%ebp)
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	ff 70 0c             	pushl  0xc(%eax)
  801fca:	e8 76 03 00 00       	call   802345 <nsipc_send>
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <devsock_read>:
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	ff 75 10             	pushl  0x10(%ebp)
  801fdc:	ff 75 0c             	pushl  0xc(%ebp)
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	ff 70 0c             	pushl  0xc(%eax)
  801fe5:	e8 ef 02 00 00       	call   8022d9 <nsipc_recv>
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <fd2sockid>:
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ff2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ff5:	52                   	push   %edx
  801ff6:	50                   	push   %eax
  801ff7:	e8 0d f4 ff ff       	call   801409 <fd_lookup>
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 10                	js     802013 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  80200c:	39 08                	cmp    %ecx,(%eax)
  80200e:	75 05                	jne    802015 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802010:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    
		return -E_NOT_SUPP;
  802015:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80201a:	eb f7                	jmp    802013 <fd2sockid+0x27>

0080201c <alloc_sockfd>:
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	83 ec 1c             	sub    $0x1c,%esp
  802024:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802026:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802029:	50                   	push   %eax
  80202a:	e8 88 f3 ff ff       	call   8013b7 <fd_alloc>
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	78 43                	js     80207b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 07 04 00 00       	push   $0x407
  802040:	ff 75 f4             	pushl  -0xc(%ebp)
  802043:	6a 00                	push   $0x0
  802045:	e8 91 ed ff ff       	call   800ddb <sys_page_alloc>
  80204a:	89 c3                	mov    %eax,%ebx
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	85 c0                	test   %eax,%eax
  802051:	78 28                	js     80207b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80205c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802068:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	50                   	push   %eax
  80206f:	e8 1c f3 ff ff       	call   801390 <fd2num>
  802074:	89 c3                	mov    %eax,%ebx
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	eb 0c                	jmp    802087 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	56                   	push   %esi
  80207f:	e8 e4 01 00 00       	call   802268 <nsipc_close>
		return r;
  802084:	83 c4 10             	add    $0x10,%esp
}
  802087:	89 d8                	mov    %ebx,%eax
  802089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208c:	5b                   	pop    %ebx
  80208d:	5e                   	pop    %esi
  80208e:	5d                   	pop    %ebp
  80208f:	c3                   	ret    

00802090 <accept>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	e8 4e ff ff ff       	call   801fec <fd2sockid>
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 1b                	js     8020bd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	ff 75 10             	pushl  0x10(%ebp)
  8020a8:	ff 75 0c             	pushl  0xc(%ebp)
  8020ab:	50                   	push   %eax
  8020ac:	e8 0e 01 00 00       	call   8021bf <nsipc_accept>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 05                	js     8020bd <accept+0x2d>
	return alloc_sockfd(r);
  8020b8:	e8 5f ff ff ff       	call   80201c <alloc_sockfd>
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <bind>:
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	e8 1f ff ff ff       	call   801fec <fd2sockid>
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 12                	js     8020e3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	ff 75 10             	pushl  0x10(%ebp)
  8020d7:	ff 75 0c             	pushl  0xc(%ebp)
  8020da:	50                   	push   %eax
  8020db:	e8 31 01 00 00       	call   802211 <nsipc_bind>
  8020e0:	83 c4 10             	add    $0x10,%esp
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <shutdown>:
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	e8 f9 fe ff ff       	call   801fec <fd2sockid>
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 0f                	js     802106 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020f7:	83 ec 08             	sub    $0x8,%esp
  8020fa:	ff 75 0c             	pushl  0xc(%ebp)
  8020fd:	50                   	push   %eax
  8020fe:	e8 43 01 00 00       	call   802246 <nsipc_shutdown>
  802103:	83 c4 10             	add    $0x10,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <connect>:
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	e8 d6 fe ff ff       	call   801fec <fd2sockid>
  802116:	85 c0                	test   %eax,%eax
  802118:	78 12                	js     80212c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80211a:	83 ec 04             	sub    $0x4,%esp
  80211d:	ff 75 10             	pushl  0x10(%ebp)
  802120:	ff 75 0c             	pushl  0xc(%ebp)
  802123:	50                   	push   %eax
  802124:	e8 59 01 00 00       	call   802282 <nsipc_connect>
  802129:	83 c4 10             	add    $0x10,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <listen>:
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	e8 b0 fe ff ff       	call   801fec <fd2sockid>
  80213c:	85 c0                	test   %eax,%eax
  80213e:	78 0f                	js     80214f <listen+0x21>
	return nsipc_listen(r, backlog);
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	50                   	push   %eax
  802147:	e8 6b 01 00 00       	call   8022b7 <nsipc_listen>
  80214c:	83 c4 10             	add    $0x10,%esp
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <socket>:

int
socket(int domain, int type, int protocol)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802157:	ff 75 10             	pushl  0x10(%ebp)
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	ff 75 08             	pushl  0x8(%ebp)
  802160:	e8 3e 02 00 00       	call   8023a3 <nsipc_socket>
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 05                	js     802171 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80216c:	e8 ab fe ff ff       	call   80201c <alloc_sockfd>
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	53                   	push   %ebx
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80217c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802183:	74 26                	je     8021ab <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802185:	6a 07                	push   $0x7
  802187:	68 00 70 80 00       	push   $0x807000
  80218c:	53                   	push   %ebx
  80218d:	ff 35 04 50 80 00    	pushl  0x805004
  802193:	e8 ba 04 00 00       	call   802652 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802198:	83 c4 0c             	add    $0xc,%esp
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	e8 39 04 00 00       	call   8025df <ipc_recv>
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021ab:	83 ec 0c             	sub    $0xc,%esp
  8021ae:	6a 02                	push   $0x2
  8021b0:	e8 09 05 00 00       	call   8026be <ipc_find_env>
  8021b5:	a3 04 50 80 00       	mov    %eax,0x805004
  8021ba:	83 c4 10             	add    $0x10,%esp
  8021bd:	eb c6                	jmp    802185 <nsipc+0x12>

008021bf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021cf:	8b 06                	mov    (%esi),%eax
  8021d1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021db:	e8 93 ff ff ff       	call   802173 <nsipc>
  8021e0:	89 c3                	mov    %eax,%ebx
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	79 09                	jns    8021ef <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021e6:	89 d8                	mov    %ebx,%eax
  8021e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021eb:	5b                   	pop    %ebx
  8021ec:	5e                   	pop    %esi
  8021ed:	5d                   	pop    %ebp
  8021ee:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	ff 35 10 70 80 00    	pushl  0x807010
  8021f8:	68 00 70 80 00       	push   $0x807000
  8021fd:	ff 75 0c             	pushl  0xc(%ebp)
  802200:	e8 72 e9 ff ff       	call   800b77 <memmove>
		*addrlen = ret->ret_addrlen;
  802205:	a1 10 70 80 00       	mov    0x807010,%eax
  80220a:	89 06                	mov    %eax,(%esi)
  80220c:	83 c4 10             	add    $0x10,%esp
	return r;
  80220f:	eb d5                	jmp    8021e6 <nsipc_accept+0x27>

00802211 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	53                   	push   %ebx
  802215:	83 ec 08             	sub    $0x8,%esp
  802218:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802223:	53                   	push   %ebx
  802224:	ff 75 0c             	pushl  0xc(%ebp)
  802227:	68 04 70 80 00       	push   $0x807004
  80222c:	e8 46 e9 ff ff       	call   800b77 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802231:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802237:	b8 02 00 00 00       	mov    $0x2,%eax
  80223c:	e8 32 ff ff ff       	call   802173 <nsipc>
}
  802241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802254:	8b 45 0c             	mov    0xc(%ebp),%eax
  802257:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80225c:	b8 03 00 00 00       	mov    $0x3,%eax
  802261:	e8 0d ff ff ff       	call   802173 <nsipc>
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <nsipc_close>:

int
nsipc_close(int s)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802276:	b8 04 00 00 00       	mov    $0x4,%eax
  80227b:	e8 f3 fe ff ff       	call   802173 <nsipc>
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	53                   	push   %ebx
  802286:	83 ec 08             	sub    $0x8,%esp
  802289:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802294:	53                   	push   %ebx
  802295:	ff 75 0c             	pushl  0xc(%ebp)
  802298:	68 04 70 80 00       	push   $0x807004
  80229d:	e8 d5 e8 ff ff       	call   800b77 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022a2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ad:	e8 c1 fe ff ff       	call   802173 <nsipc>
}
  8022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022cd:	b8 06 00 00 00       	mov    $0x6,%eax
  8022d2:	e8 9c fe ff ff       	call   802173 <nsipc>
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
  8022de:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022e9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022f7:	b8 07 00 00 00       	mov    $0x7,%eax
  8022fc:	e8 72 fe ff ff       	call   802173 <nsipc>
  802301:	89 c3                	mov    %eax,%ebx
  802303:	85 c0                	test   %eax,%eax
  802305:	78 1f                	js     802326 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802307:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80230c:	7f 21                	jg     80232f <nsipc_recv+0x56>
  80230e:	39 c6                	cmp    %eax,%esi
  802310:	7c 1d                	jl     80232f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	50                   	push   %eax
  802316:	68 00 70 80 00       	push   $0x807000
  80231b:	ff 75 0c             	pushl  0xc(%ebp)
  80231e:	e8 54 e8 ff ff       	call   800b77 <memmove>
  802323:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802326:	89 d8                	mov    %ebx,%eax
  802328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80232f:	68 c0 30 80 00       	push   $0x8030c0
  802334:	68 4c 30 80 00       	push   $0x80304c
  802339:	6a 62                	push   $0x62
  80233b:	68 d5 30 80 00       	push   $0x8030d5
  802340:	e8 ed df ff ff       	call   800332 <_panic>

00802345 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	53                   	push   %ebx
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802357:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80235d:	7f 2e                	jg     80238d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80235f:	83 ec 04             	sub    $0x4,%esp
  802362:	53                   	push   %ebx
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	68 0c 70 80 00       	push   $0x80700c
  80236b:	e8 07 e8 ff ff       	call   800b77 <memmove>
	nsipcbuf.send.req_size = size;
  802370:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802376:	8b 45 14             	mov    0x14(%ebp),%eax
  802379:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80237e:	b8 08 00 00 00       	mov    $0x8,%eax
  802383:	e8 eb fd ff ff       	call   802173 <nsipc>
}
  802388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    
	assert(size < 1600);
  80238d:	68 e1 30 80 00       	push   $0x8030e1
  802392:	68 4c 30 80 00       	push   $0x80304c
  802397:	6a 6d                	push   $0x6d
  802399:	68 d5 30 80 00       	push   $0x8030d5
  80239e:	e8 8f df ff ff       	call   800332 <_panic>

008023a3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023bc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023c1:	b8 09 00 00 00       	mov    $0x9,%eax
  8023c6:	e8 a8 fd ff ff       	call   802173 <nsipc>
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d2:	c3                   	ret    

008023d3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023d9:	68 ed 30 80 00       	push   $0x8030ed
  8023de:	ff 75 0c             	pushl  0xc(%ebp)
  8023e1:	e8 03 e6 ff ff       	call   8009e9 <strcpy>
	return 0;
}
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <devcons_write>:
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	57                   	push   %edi
  8023f1:	56                   	push   %esi
  8023f2:	53                   	push   %ebx
  8023f3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023f9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023fe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802404:	3b 75 10             	cmp    0x10(%ebp),%esi
  802407:	73 31                	jae    80243a <devcons_write+0x4d>
		m = n - tot;
  802409:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80240c:	29 f3                	sub    %esi,%ebx
  80240e:	83 fb 7f             	cmp    $0x7f,%ebx
  802411:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802416:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	53                   	push   %ebx
  80241d:	89 f0                	mov    %esi,%eax
  80241f:	03 45 0c             	add    0xc(%ebp),%eax
  802422:	50                   	push   %eax
  802423:	57                   	push   %edi
  802424:	e8 4e e7 ff ff       	call   800b77 <memmove>
		sys_cputs(buf, m);
  802429:	83 c4 08             	add    $0x8,%esp
  80242c:	53                   	push   %ebx
  80242d:	57                   	push   %edi
  80242e:	e8 ec e8 ff ff       	call   800d1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802433:	01 de                	add    %ebx,%esi
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	eb ca                	jmp    802404 <devcons_write+0x17>
}
  80243a:	89 f0                	mov    %esi,%eax
  80243c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80243f:	5b                   	pop    %ebx
  802440:	5e                   	pop    %esi
  802441:	5f                   	pop    %edi
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    

00802444 <devcons_read>:
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 08             	sub    $0x8,%esp
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80244f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802453:	74 21                	je     802476 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802455:	e8 e3 e8 ff ff       	call   800d3d <sys_cgetc>
  80245a:	85 c0                	test   %eax,%eax
  80245c:	75 07                	jne    802465 <devcons_read+0x21>
		sys_yield();
  80245e:	e8 59 e9 ff ff       	call   800dbc <sys_yield>
  802463:	eb f0                	jmp    802455 <devcons_read+0x11>
	if (c < 0)
  802465:	78 0f                	js     802476 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802467:	83 f8 04             	cmp    $0x4,%eax
  80246a:	74 0c                	je     802478 <devcons_read+0x34>
	*(char*)vbuf = c;
  80246c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246f:	88 02                	mov    %al,(%edx)
	return 1;
  802471:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    
		return 0;
  802478:	b8 00 00 00 00       	mov    $0x0,%eax
  80247d:	eb f7                	jmp    802476 <devcons_read+0x32>

0080247f <cputchar>:
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80248b:	6a 01                	push   $0x1
  80248d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802490:	50                   	push   %eax
  802491:	e8 89 e8 ff ff       	call   800d1f <sys_cputs>
}
  802496:	83 c4 10             	add    $0x10,%esp
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <getchar>:
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024a1:	6a 01                	push   $0x1
  8024a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024a6:	50                   	push   %eax
  8024a7:	6a 00                	push   $0x0
  8024a9:	e8 cb f1 ff ff       	call   801679 <read>
	if (r < 0)
  8024ae:	83 c4 10             	add    $0x10,%esp
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	78 06                	js     8024bb <getchar+0x20>
	if (r < 1)
  8024b5:	74 06                	je     8024bd <getchar+0x22>
	return c;
  8024b7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    
		return -E_EOF;
  8024bd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024c2:	eb f7                	jmp    8024bb <getchar+0x20>

008024c4 <iscons>:
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024cd:	50                   	push   %eax
  8024ce:	ff 75 08             	pushl  0x8(%ebp)
  8024d1:	e8 33 ef ff ff       	call   801409 <fd_lookup>
  8024d6:	83 c4 10             	add    $0x10,%esp
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	78 11                	js     8024ee <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8024e6:	39 10                	cmp    %edx,(%eax)
  8024e8:	0f 94 c0             	sete   %al
  8024eb:	0f b6 c0             	movzbl %al,%eax
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <opencons>:
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f9:	50                   	push   %eax
  8024fa:	e8 b8 ee ff ff       	call   8013b7 <fd_alloc>
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	85 c0                	test   %eax,%eax
  802504:	78 3a                	js     802540 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	68 07 04 00 00       	push   $0x407
  80250e:	ff 75 f4             	pushl  -0xc(%ebp)
  802511:	6a 00                	push   $0x0
  802513:	e8 c3 e8 ff ff       	call   800ddb <sys_page_alloc>
  802518:	83 c4 10             	add    $0x10,%esp
  80251b:	85 c0                	test   %eax,%eax
  80251d:	78 21                	js     802540 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802528:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802534:	83 ec 0c             	sub    $0xc,%esp
  802537:	50                   	push   %eax
  802538:	e8 53 ee ff ff       	call   801390 <fd2num>
  80253d:	83 c4 10             	add    $0x10,%esp
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802548:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80254f:	74 0a                	je     80255b <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80255b:	a1 08 50 80 00       	mov    0x805008,%eax
  802560:	8b 40 48             	mov    0x48(%eax),%eax
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	6a 07                	push   $0x7
  802568:	68 00 f0 bf ee       	push   $0xeebff000
  80256d:	50                   	push   %eax
  80256e:	e8 68 e8 ff ff       	call   800ddb <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802573:	83 c4 10             	add    $0x10,%esp
  802576:	85 c0                	test   %eax,%eax
  802578:	78 2c                	js     8025a6 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80257a:	e8 1e e8 ff ff       	call   800d9d <sys_getenvid>
  80257f:	83 ec 08             	sub    $0x8,%esp
  802582:	68 b8 25 80 00       	push   $0x8025b8
  802587:	50                   	push   %eax
  802588:	e8 99 e9 ff ff       	call   800f26 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	85 c0                	test   %eax,%eax
  802592:	79 bd                	jns    802551 <set_pgfault_handler+0xf>
  802594:	50                   	push   %eax
  802595:	68 f9 30 80 00       	push   $0x8030f9
  80259a:	6a 23                	push   $0x23
  80259c:	68 11 31 80 00       	push   $0x803111
  8025a1:	e8 8c dd ff ff       	call   800332 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8025a6:	50                   	push   %eax
  8025a7:	68 f9 30 80 00       	push   $0x8030f9
  8025ac:	6a 21                	push   $0x21
  8025ae:	68 11 31 80 00       	push   $0x803111
  8025b3:	e8 7a dd ff ff       	call   800332 <_panic>

008025b8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025b8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025b9:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8025be:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025c0:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8025c3:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8025c7:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8025ca:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8025ce:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8025d2:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8025d5:	83 c4 08             	add    $0x8,%esp
	popal
  8025d8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8025d9:	83 c4 04             	add    $0x4,%esp
	popfl
  8025dc:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8025dd:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8025de:	c3                   	ret    

008025df <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
  8025e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8025e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 4f                	je     802640 <ipc_recv+0x61>
  8025f1:	83 ec 0c             	sub    $0xc,%esp
  8025f4:	50                   	push   %eax
  8025f5:	e8 91 e9 ff ff       	call   800f8b <sys_ipc_recv>
  8025fa:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8025fd:	85 f6                	test   %esi,%esi
  8025ff:	74 14                	je     802615 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802601:	ba 00 00 00 00       	mov    $0x0,%edx
  802606:	85 c0                	test   %eax,%eax
  802608:	75 09                	jne    802613 <ipc_recv+0x34>
  80260a:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802610:	8b 52 74             	mov    0x74(%edx),%edx
  802613:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802615:	85 db                	test   %ebx,%ebx
  802617:	74 14                	je     80262d <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802619:	ba 00 00 00 00       	mov    $0x0,%edx
  80261e:	85 c0                	test   %eax,%eax
  802620:	75 09                	jne    80262b <ipc_recv+0x4c>
  802622:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802628:	8b 52 78             	mov    0x78(%edx),%edx
  80262b:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80262d:	85 c0                	test   %eax,%eax
  80262f:	75 08                	jne    802639 <ipc_recv+0x5a>
  802631:	a1 08 50 80 00       	mov    0x805008,%eax
  802636:	8b 40 70             	mov    0x70(%eax),%eax
}
  802639:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802640:	83 ec 0c             	sub    $0xc,%esp
  802643:	68 00 00 c0 ee       	push   $0xeec00000
  802648:	e8 3e e9 ff ff       	call   800f8b <sys_ipc_recv>
  80264d:	83 c4 10             	add    $0x10,%esp
  802650:	eb ab                	jmp    8025fd <ipc_recv+0x1e>

00802652 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 0c             	sub    $0xc,%esp
  80265b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80265e:	8b 75 10             	mov    0x10(%ebp),%esi
  802661:	eb 20                	jmp    802683 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802663:	6a 00                	push   $0x0
  802665:	68 00 00 c0 ee       	push   $0xeec00000
  80266a:	ff 75 0c             	pushl  0xc(%ebp)
  80266d:	57                   	push   %edi
  80266e:	e8 f5 e8 ff ff       	call   800f68 <sys_ipc_try_send>
  802673:	89 c3                	mov    %eax,%ebx
  802675:	83 c4 10             	add    $0x10,%esp
  802678:	eb 1f                	jmp    802699 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80267a:	e8 3d e7 ff ff       	call   800dbc <sys_yield>
	while(retval != 0) {
  80267f:	85 db                	test   %ebx,%ebx
  802681:	74 33                	je     8026b6 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802683:	85 f6                	test   %esi,%esi
  802685:	74 dc                	je     802663 <ipc_send+0x11>
  802687:	ff 75 14             	pushl  0x14(%ebp)
  80268a:	56                   	push   %esi
  80268b:	ff 75 0c             	pushl  0xc(%ebp)
  80268e:	57                   	push   %edi
  80268f:	e8 d4 e8 ff ff       	call   800f68 <sys_ipc_try_send>
  802694:	89 c3                	mov    %eax,%ebx
  802696:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802699:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80269c:	74 dc                	je     80267a <ipc_send+0x28>
  80269e:	85 db                	test   %ebx,%ebx
  8026a0:	74 d8                	je     80267a <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	68 20 31 80 00       	push   $0x803120
  8026aa:	6a 35                	push   $0x35
  8026ac:	68 50 31 80 00       	push   $0x803150
  8026b1:	e8 7c dc ff ff       	call   800332 <_panic>
	}
}
  8026b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b9:	5b                   	pop    %ebx
  8026ba:	5e                   	pop    %esi
  8026bb:	5f                   	pop    %edi
  8026bc:	5d                   	pop    %ebp
  8026bd:	c3                   	ret    

008026be <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026c9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026cc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026d2:	8b 52 50             	mov    0x50(%edx),%edx
  8026d5:	39 ca                	cmp    %ecx,%edx
  8026d7:	74 11                	je     8026ea <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8026d9:	83 c0 01             	add    $0x1,%eax
  8026dc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026e1:	75 e6                	jne    8026c9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	eb 0b                	jmp    8026f5 <ipc_find_env+0x37>
			return envs[i].env_id;
  8026ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026f2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026f5:	5d                   	pop    %ebp
  8026f6:	c3                   	ret    

008026f7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026fd:	89 d0                	mov    %edx,%eax
  8026ff:	c1 e8 16             	shr    $0x16,%eax
  802702:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80270e:	f6 c1 01             	test   $0x1,%cl
  802711:	74 1d                	je     802730 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802713:	c1 ea 0c             	shr    $0xc,%edx
  802716:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80271d:	f6 c2 01             	test   $0x1,%dl
  802720:	74 0e                	je     802730 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802722:	c1 ea 0c             	shr    $0xc,%edx
  802725:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80272c:	ef 
  80272d:	0f b7 c0             	movzwl %ax,%eax
}
  802730:	5d                   	pop    %ebp
  802731:	c3                   	ret    
  802732:	66 90                	xchg   %ax,%ax
  802734:	66 90                	xchg   %ax,%ax
  802736:	66 90                	xchg   %ax,%ax
  802738:	66 90                	xchg   %ax,%ax
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__udivdi3>:
  802740:	f3 0f 1e fb          	endbr32 
  802744:	55                   	push   %ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 1c             	sub    $0x1c,%esp
  80274b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80274f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802753:	8b 74 24 34          	mov    0x34(%esp),%esi
  802757:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80275b:	85 d2                	test   %edx,%edx
  80275d:	75 49                	jne    8027a8 <__udivdi3+0x68>
  80275f:	39 f3                	cmp    %esi,%ebx
  802761:	76 15                	jbe    802778 <__udivdi3+0x38>
  802763:	31 ff                	xor    %edi,%edi
  802765:	89 e8                	mov    %ebp,%eax
  802767:	89 f2                	mov    %esi,%edx
  802769:	f7 f3                	div    %ebx
  80276b:	89 fa                	mov    %edi,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	89 d9                	mov    %ebx,%ecx
  80277a:	85 db                	test   %ebx,%ebx
  80277c:	75 0b                	jne    802789 <__udivdi3+0x49>
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	31 d2                	xor    %edx,%edx
  802785:	f7 f3                	div    %ebx
  802787:	89 c1                	mov    %eax,%ecx
  802789:	31 d2                	xor    %edx,%edx
  80278b:	89 f0                	mov    %esi,%eax
  80278d:	f7 f1                	div    %ecx
  80278f:	89 c6                	mov    %eax,%esi
  802791:	89 e8                	mov    %ebp,%eax
  802793:	89 f7                	mov    %esi,%edi
  802795:	f7 f1                	div    %ecx
  802797:	89 fa                	mov    %edi,%edx
  802799:	83 c4 1c             	add    $0x1c,%esp
  80279c:	5b                   	pop    %ebx
  80279d:	5e                   	pop    %esi
  80279e:	5f                   	pop    %edi
  80279f:	5d                   	pop    %ebp
  8027a0:	c3                   	ret    
  8027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	39 f2                	cmp    %esi,%edx
  8027aa:	77 1c                	ja     8027c8 <__udivdi3+0x88>
  8027ac:	0f bd fa             	bsr    %edx,%edi
  8027af:	83 f7 1f             	xor    $0x1f,%edi
  8027b2:	75 2c                	jne    8027e0 <__udivdi3+0xa0>
  8027b4:	39 f2                	cmp    %esi,%edx
  8027b6:	72 06                	jb     8027be <__udivdi3+0x7e>
  8027b8:	31 c0                	xor    %eax,%eax
  8027ba:	39 eb                	cmp    %ebp,%ebx
  8027bc:	77 ad                	ja     80276b <__udivdi3+0x2b>
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	eb a6                	jmp    80276b <__udivdi3+0x2b>
  8027c5:	8d 76 00             	lea    0x0(%esi),%esi
  8027c8:	31 ff                	xor    %edi,%edi
  8027ca:	31 c0                	xor    %eax,%eax
  8027cc:	89 fa                	mov    %edi,%edx
  8027ce:	83 c4 1c             	add    $0x1c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    
  8027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027dd:	8d 76 00             	lea    0x0(%esi),%esi
  8027e0:	89 f9                	mov    %edi,%ecx
  8027e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027e7:	29 f8                	sub    %edi,%eax
  8027e9:	d3 e2                	shl    %cl,%edx
  8027eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 da                	mov    %ebx,%edx
  8027f3:	d3 ea                	shr    %cl,%edx
  8027f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f9:	09 d1                	or     %edx,%ecx
  8027fb:	89 f2                	mov    %esi,%edx
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 f9                	mov    %edi,%ecx
  802803:	d3 e3                	shl    %cl,%ebx
  802805:	89 c1                	mov    %eax,%ecx
  802807:	d3 ea                	shr    %cl,%edx
  802809:	89 f9                	mov    %edi,%ecx
  80280b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80280f:	89 eb                	mov    %ebp,%ebx
  802811:	d3 e6                	shl    %cl,%esi
  802813:	89 c1                	mov    %eax,%ecx
  802815:	d3 eb                	shr    %cl,%ebx
  802817:	09 de                	or     %ebx,%esi
  802819:	89 f0                	mov    %esi,%eax
  80281b:	f7 74 24 08          	divl   0x8(%esp)
  80281f:	89 d6                	mov    %edx,%esi
  802821:	89 c3                	mov    %eax,%ebx
  802823:	f7 64 24 0c          	mull   0xc(%esp)
  802827:	39 d6                	cmp    %edx,%esi
  802829:	72 15                	jb     802840 <__udivdi3+0x100>
  80282b:	89 f9                	mov    %edi,%ecx
  80282d:	d3 e5                	shl    %cl,%ebp
  80282f:	39 c5                	cmp    %eax,%ebp
  802831:	73 04                	jae    802837 <__udivdi3+0xf7>
  802833:	39 d6                	cmp    %edx,%esi
  802835:	74 09                	je     802840 <__udivdi3+0x100>
  802837:	89 d8                	mov    %ebx,%eax
  802839:	31 ff                	xor    %edi,%edi
  80283b:	e9 2b ff ff ff       	jmp    80276b <__udivdi3+0x2b>
  802840:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802843:	31 ff                	xor    %edi,%edi
  802845:	e9 21 ff ff ff       	jmp    80276b <__udivdi3+0x2b>
  80284a:	66 90                	xchg   %ax,%ax
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <__umoddi3>:
  802850:	f3 0f 1e fb          	endbr32 
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80285f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802863:	8b 74 24 30          	mov    0x30(%esp),%esi
  802867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80286b:	89 da                	mov    %ebx,%edx
  80286d:	85 c0                	test   %eax,%eax
  80286f:	75 3f                	jne    8028b0 <__umoddi3+0x60>
  802871:	39 df                	cmp    %ebx,%edi
  802873:	76 13                	jbe    802888 <__umoddi3+0x38>
  802875:	89 f0                	mov    %esi,%eax
  802877:	f7 f7                	div    %edi
  802879:	89 d0                	mov    %edx,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	83 c4 1c             	add    $0x1c,%esp
  802880:	5b                   	pop    %ebx
  802881:	5e                   	pop    %esi
  802882:	5f                   	pop    %edi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	89 fd                	mov    %edi,%ebp
  80288a:	85 ff                	test   %edi,%edi
  80288c:	75 0b                	jne    802899 <__umoddi3+0x49>
  80288e:	b8 01 00 00 00       	mov    $0x1,%eax
  802893:	31 d2                	xor    %edx,%edx
  802895:	f7 f7                	div    %edi
  802897:	89 c5                	mov    %eax,%ebp
  802899:	89 d8                	mov    %ebx,%eax
  80289b:	31 d2                	xor    %edx,%edx
  80289d:	f7 f5                	div    %ebp
  80289f:	89 f0                	mov    %esi,%eax
  8028a1:	f7 f5                	div    %ebp
  8028a3:	89 d0                	mov    %edx,%eax
  8028a5:	eb d4                	jmp    80287b <__umoddi3+0x2b>
  8028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ae:	66 90                	xchg   %ax,%ax
  8028b0:	89 f1                	mov    %esi,%ecx
  8028b2:	39 d8                	cmp    %ebx,%eax
  8028b4:	76 0a                	jbe    8028c0 <__umoddi3+0x70>
  8028b6:	89 f0                	mov    %esi,%eax
  8028b8:	83 c4 1c             	add    $0x1c,%esp
  8028bb:	5b                   	pop    %ebx
  8028bc:	5e                   	pop    %esi
  8028bd:	5f                   	pop    %edi
  8028be:	5d                   	pop    %ebp
  8028bf:	c3                   	ret    
  8028c0:	0f bd e8             	bsr    %eax,%ebp
  8028c3:	83 f5 1f             	xor    $0x1f,%ebp
  8028c6:	75 20                	jne    8028e8 <__umoddi3+0x98>
  8028c8:	39 d8                	cmp    %ebx,%eax
  8028ca:	0f 82 b0 00 00 00    	jb     802980 <__umoddi3+0x130>
  8028d0:	39 f7                	cmp    %esi,%edi
  8028d2:	0f 86 a8 00 00 00    	jbe    802980 <__umoddi3+0x130>
  8028d8:	89 c8                	mov    %ecx,%eax
  8028da:	83 c4 1c             	add    $0x1c,%esp
  8028dd:	5b                   	pop    %ebx
  8028de:	5e                   	pop    %esi
  8028df:	5f                   	pop    %edi
  8028e0:	5d                   	pop    %ebp
  8028e1:	c3                   	ret    
  8028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028e8:	89 e9                	mov    %ebp,%ecx
  8028ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8028ef:	29 ea                	sub    %ebp,%edx
  8028f1:	d3 e0                	shl    %cl,%eax
  8028f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028f7:	89 d1                	mov    %edx,%ecx
  8028f9:	89 f8                	mov    %edi,%eax
  8028fb:	d3 e8                	shr    %cl,%eax
  8028fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802901:	89 54 24 04          	mov    %edx,0x4(%esp)
  802905:	8b 54 24 04          	mov    0x4(%esp),%edx
  802909:	09 c1                	or     %eax,%ecx
  80290b:	89 d8                	mov    %ebx,%eax
  80290d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802911:	89 e9                	mov    %ebp,%ecx
  802913:	d3 e7                	shl    %cl,%edi
  802915:	89 d1                	mov    %edx,%ecx
  802917:	d3 e8                	shr    %cl,%eax
  802919:	89 e9                	mov    %ebp,%ecx
  80291b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80291f:	d3 e3                	shl    %cl,%ebx
  802921:	89 c7                	mov    %eax,%edi
  802923:	89 d1                	mov    %edx,%ecx
  802925:	89 f0                	mov    %esi,%eax
  802927:	d3 e8                	shr    %cl,%eax
  802929:	89 e9                	mov    %ebp,%ecx
  80292b:	89 fa                	mov    %edi,%edx
  80292d:	d3 e6                	shl    %cl,%esi
  80292f:	09 d8                	or     %ebx,%eax
  802931:	f7 74 24 08          	divl   0x8(%esp)
  802935:	89 d1                	mov    %edx,%ecx
  802937:	89 f3                	mov    %esi,%ebx
  802939:	f7 64 24 0c          	mull   0xc(%esp)
  80293d:	89 c6                	mov    %eax,%esi
  80293f:	89 d7                	mov    %edx,%edi
  802941:	39 d1                	cmp    %edx,%ecx
  802943:	72 06                	jb     80294b <__umoddi3+0xfb>
  802945:	75 10                	jne    802957 <__umoddi3+0x107>
  802947:	39 c3                	cmp    %eax,%ebx
  802949:	73 0c                	jae    802957 <__umoddi3+0x107>
  80294b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80294f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802953:	89 d7                	mov    %edx,%edi
  802955:	89 c6                	mov    %eax,%esi
  802957:	89 ca                	mov    %ecx,%edx
  802959:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80295e:	29 f3                	sub    %esi,%ebx
  802960:	19 fa                	sbb    %edi,%edx
  802962:	89 d0                	mov    %edx,%eax
  802964:	d3 e0                	shl    %cl,%eax
  802966:	89 e9                	mov    %ebp,%ecx
  802968:	d3 eb                	shr    %cl,%ebx
  80296a:	d3 ea                	shr    %cl,%edx
  80296c:	09 d8                	or     %ebx,%eax
  80296e:	83 c4 1c             	add    $0x1c,%esp
  802971:	5b                   	pop    %ebx
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
  802976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	89 da                	mov    %ebx,%edx
  802982:	29 fe                	sub    %edi,%esi
  802984:	19 c2                	sbb    %eax,%edx
  802986:	89 f1                	mov    %esi,%ecx
  802988:	89 c8                	mov    %ecx,%eax
  80298a:	e9 4b ff ff ff       	jmp    8028da <__umoddi3+0x8a>
